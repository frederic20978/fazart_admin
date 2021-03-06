import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/models/painting.dart';
import 'package:fazart_admin1/models/query.dart';
import 'package:fazart_admin1/models/service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

CollectionReference users = FirebaseFirestore.instance.collection("users");
CollectionReference admin = FirebaseFirestore.instance.collection("admin");
CollectionReference paintings =
    FirebaseFirestore.instance.collection("paintings");
CollectionReference services =
    FirebaseFirestore.instance.collection("services");

FirebaseStorage storage = FirebaseStorage.instance;

Stream<CustomUser> getUser(String uid) {
  // DocumentSnapshot snapshot = await users.doc(uid).get();
  // CustomUser user = CustomUser(
  //     uid: uid,
  //     email: snapshot.get('email'),
  // image: snapshot.data().containsKey('url') ? snapshot.get('url') : null,
  // bio: snapshot.data().containsKey('bio') ? snapshot.get('bio') : null,
  // name: snapshot.get('name'),
  // hasBio: snapshot.data().containsKey('bio'),
  // isArtist: snapshot.get('isArtist'));
  // return user;
  return users.doc(uid).snapshots().map((user) => CustomUser(
        uid: uid,
        email: user.get('email'),
        image: user.data().containsKey('image') ? user.get('image') : null,
        bio: user.data().containsKey('bio') ? user.get('bio') : null,
        name: user.data().containsKey('name') ? user.get('name') : null,
        hasBio: user.data().containsKey('bio'),
        isArtist:
            user.data().containsKey('isArtist') ? user.get('isArtist') : false,
      ));
}

Stream<CustomUser> getArtist(String id) {
  try {
    var snapshots = users.doc(id).snapshots();
    return snapshots.map((snapshot) => CustomUser(
        uid: snapshot.id,
        name: snapshot.get('name'),
        image: snapshot.get('image'),
        bio: snapshot.get('bio')));
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

Future<Service> getService(String id) async {
  try {
    DocumentSnapshot snapshot = await services.doc(id).get();
    return Service(
        artist: snapshot.data().containsKey('artist')
            ? snapshot.get('artist')
            : null,
        id: id,
        name: snapshot.data().containsKey('name') ? snapshot.get('name') : null,
        description: snapshot.data().containsKey('description')
            ? snapshot.get('description')
            : null,
        price:
            snapshot.data().containsKey('price') ? snapshot.get('price') : null,
        height: snapshot.data().containsKey('height')
            ? snapshot.get('height')
            : null,
        width:
            snapshot.data().containsKey('width') ? snapshot.get('width') : null,
        eta: snapshot.data().containsKey('eta') ? snapshot.get('eta') : null,
        image:
            snapshot.data().containsKey('image') ? snapshot.get('image') : null,
        forSale: snapshot.data().containsKey('onsale')
            ? snapshot.get('onsale')
            : null,
        sampleImages: snapshot.data().containsKey('sampleImages')
            ? snapshot.get('sampleImages')
            : null);
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

Future<Painting> getPainting(String id) async {
  try {
    DocumentSnapshot snapshot = await paintings.doc(id).get();
    return Painting(
        artist: snapshot.data().containsKey('artist')
            ? snapshot.get('artist')
            : null,
        id: id,
        name: snapshot.data().containsKey('name') ? snapshot.get('name') : null,
        description: snapshot.data().containsKey('description')
            ? snapshot.get('description')
            : null,
        price:
            snapshot.data().containsKey('price') ? snapshot.get('price') : null,
        height: snapshot.data().containsKey('height')
            ? snapshot.get('height')
            : null,
        width:
            snapshot.data().containsKey('width') ? snapshot.get('width') : null,
        image:
            snapshot.data().containsKey('image') ? snapshot.get('image') : null,
        forSale: snapshot.data().containsKey('onsale')
            ? snapshot.get('onsale')
            : null);
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

Future<List<CustomUser>> getArtists() async {
  try {
    QuerySnapshot snapshots =
        await users.where("isArtist", isEqualTo: true).limit(10).get();
    return snapshots.docs.map((snapshot) {
      return CustomUser(
        uid: snapshot.id,
        name: snapshot.get('name'),
        image: snapshot.get('image'),
        bio: snapshot.get('bio'),
      );
    }).toList();
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

Future<dynamic> getUrl() async {
  try {
    DocumentSnapshot metadata = await admin.doc("metadata").get();
    return metadata.get("url");
  } catch (e) {}
}

deletePainting(Painting painting) async {
  try {
    await paintings.doc(painting.id).delete();
    Reference ref = storage.refFromURL(painting.image);
    ref.delete();
  } catch (e) {
    print(e);
  }
}

changeForSaleState(Painting painting, bool state) async {
  try {
    await paintings.doc(painting.id).update({
      "onsale": state,
    });
  } catch (e) {
    print(e);
  }
}

deleteService(Service service) async {
  try {
    await services.doc(service.id).delete();
    Reference ref = storage.refFromURL(service.image);
    ref.delete();
    for (var image in service.sampleImages) {
      Reference ref = storage.refFromURL(image);
      ref.delete();
    }
  } catch (e) {
    print(e);
  }
}

changeForSaleStateService(Service service, bool state) async {
  try {
    await services.doc(service.id).update({
      "onsale": state,
    });
  } catch (e) {
    print(e);
  }
}

createArtist(String name, String bio, File image) async {
  List<String> searchArray = [];
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }

  var uid = Uuid();
  Reference ref = storage.ref(
      "PaintingImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
  TaskSnapshot taskSnapshot = await ref.putFile(image);
  var uri = await taskSnapshot.ref.getDownloadURL();
  String url = uri.toString();

  users.doc().set({
    "time": DateTime.now(),
    "name": name,
    "isArtist": true,
    "image": url,
    "bio": bio,
    "searchArray": searchArray,
  });
}

convertToArtist(String uid) async {
  await users.doc(uid).update({
    "isArtist": true,
  });
}

updateArtist({
  String name,
  String bio,
  File image,
  String userid,
}) async {
  List<String> searchArray = [];
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }

  try {
    var uid = Uuid();
    if (image != null) {
      Reference ref = storage.ref(
          "ArtistImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
      TaskSnapshot taskSnapshot = await ref.putFile(image);
      var uri = await taskSnapshot.ref.getDownloadURL();
      String url = uri.toString();
      await users.doc(userid).update({
        "time": DateTime.now(),
        "image": url,
      });
    }

    await users.doc(userid).update({
      "time": DateTime.now(),
      "name": name,
      "bio": bio,
      "searchArray": searchArray,
    });
  } catch (e) {
    print(e);
  }
}

createPainting(String name, String artist, String description, num price,
    File image, bool sale, num height, num width) async {
  List<String> searchArray = [];
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }

  var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  num photoheight = decodedImage.height;
  num photowidth = decodedImage.width;

  var uid = Uuid();
  Reference ref = storage.ref(
      "PaintingImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
  TaskSnapshot taskSnapshot = await ref.putFile(image);
  var uri = await taskSnapshot.ref.getDownloadURL();
  String url = uri.toString();

  paintings.doc().set({
    "artist": artist,
    "time": DateTime.now(),
    "description": description,
    "height": height,
    "width": width,
    "photoHeight": photoheight,
    "photoWidth": photowidth,
    "price": price,
    "image": url,
    "name": name,
    "relevance": 1,
    "artScore": 4,
    "onsale": sale,
    "type": ["op", "wc", "pd", "dm", "il"],
    "searchArray": searchArray,
  });
}

createService(String name, String artist, String description, num price,
    List<File> images, File image, bool sale) async {
  List<String> searchArray = [];
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }

  print(images);
  var uid = Uuid();
  List<String> sampleImages = [];
  if (images != null) {
    for (var image in images) {
      Reference ref = storage.ref(
          "SampleImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
      TaskSnapshot taskSnapshot = await ref.putFile(image);
      var uri = await taskSnapshot.ref.getDownloadURL();
      String url = uri.toString();
      sampleImages.add(url);
    }
  }

  Reference ref = storage.ref(
      "ServiceImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
  TaskSnapshot taskSnapshot = await ref.putFile(image);
  var uri = await taskSnapshot.ref.getDownloadURL();
  String serviceImage = uri.toString();

  services.doc().set({
    "artist": artist,
    "time": DateTime.now(),
    "description": description,
    "price": price,
    "eta": 8,
    "image": serviceImage,
    "sampleImages": sampleImages,
    "name": name,
    "relevance": 1,
    "artScore": 4,
    "onsale": sale,
    "type": ["op", "wc", "pd", "dm", "il"],
    "searchArray": searchArray,
  });
}

modifyService(
  String serviceId,
  bool isNewImage,
  String oldImage,
  String name,
  String artist,
  String description,
  num price,
  File image,
  bool sale,
) async {
  List<String> searchArray = [];
  String serviceImage;
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }

  var uid = Uuid();
  if (isNewImage) {
    Reference ref = storage.refFromURL(oldImage);
    await ref.delete();
    ref = storage.ref(
        "ServiceImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
    TaskSnapshot taskSnapshot = await ref.putFile(image);
    var uri = await taskSnapshot.ref.getDownloadURL();
    serviceImage = uri.toString();
    services.doc(serviceId).update({
      "description": description,
      "price": price,

      // "eta": 8,
      "image": serviceImage,
      "name": name,
      "onsale": sale,
      // "type": ["op", "wc", "pd", "dm", "il"],
      "searchArray": searchArray,
    });
  } else {
    services.doc(serviceId).update({
      "description": description,
      "price": price,

      // "eta": 8,
      "name": name,
      "onsale": sale,
      // "type": ["op", "wc", "pd", "dm", "il"],
      "searchArray": searchArray,
    });
  }
}

modifyPainting(
    String paintingId,
    bool isNewImage,
    String oldImage,
    String name,
    String artist,
    String description,
    num price,
    File image,
    bool sale,
    num height,
    num width) async {
  List<String> searchArray = [];
  String paintingImage;
  for (var i = 0; i < name.length; i++) {
    searchArray.add(name.substring(0, i + 1).toLowerCase());
  }
  print(paintingId);

  var uid = Uuid();
  if (isNewImage) {
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    num photoheight = decodedImage.height;
    num photowidth = decodedImage.width;

    Reference ref = storage.refFromURL(oldImage);
    await ref.delete();
    ref = storage.ref(
        "PaintingImages/${DateFormat("dd-MM-yy").format(DateTime.now())}/${uid.v1()}");
    TaskSnapshot taskSnapshot = await ref.putFile(image);
    var uri = await taskSnapshot.ref.getDownloadURL();
    paintingImage = uri.toString();
    paintings.doc(paintingId).update({
      "description": description,
      "price": price,
      "height": height,
      "width": width,
      "photoHeight": photoheight,
      "photoWidth": photowidth,
      // "eta": 8,
      "image": paintingImage,
      "name": name,
      "onsale": sale,
      // "type": ["op", "wc", "pd", "dm", "il"],
      "searchArray": searchArray,
    });
  } else {
    paintings.doc(paintingId).update({
      "description": description,
      "price": price,
      "height": height,
      "width": width,
      // "eta": 8,
      "name": name,
      "onsale": sale,
      // "type": ["op", "wc", "pd", "dm", "il"],
      "searchArray": searchArray,
    });
  }
}

Stream<List<Painting>> getPaintings(QueryModel q) {
  try {
    // QuerySnapshot snaps;
    // Query query = paintings;
    // query = query.where('artist', isEqualTo: q.artist);

    // snaps = await query.get();

    // var docs = snaps.docs;

    // var list = docs
    // .map((snapshot) => Painting(
    //       id: snapshot.id,
    //       name: snapshot.get('name'),
    //       artist: snapshot.get('artist'),
    //       image: snapshot.get('image'),
    //       price: snapshot.get('price'),
    //       description: snapshot.get('description'),
    //       relevance: snapshot.get('relevance'),
    //       forSale: snapshot.get('onsale'),
    //         ))
    //     .toList();
    // return list;
    //
    //
    return paintings
        .where('artist', isEqualTo: q.artist)
        .snapshots()
        .map((snapshot1) => snapshot1.docs
            .map((snapshot) => Painting(
                  id: snapshot.id,
                  name: snapshot.get('name'),
                  artist: snapshot.get('artist'),
                  image: snapshot.get('image'),
                  price: snapshot.get('price'),
                  description: snapshot.get('description'),
                  relevance: snapshot.get('relevance'),
                  forSale: snapshot.get('onsale'),
                ))
            .toList());
  } on Exception catch (e) {
    print(e);
    return null;
  }
}

Stream<List<Service>> getServices(QueryModel q) {
  try {
    // QuerySnapshot snaps;
    // Query query = services;
    // query = query.where('artist', isEqualTo: q.artist);

    // snaps = await query.get();
    // var docs = snaps.docs;
    // var list = docs
    // .map((snapshot) => Service(
    //       id: snapshot.id,
    //       forSale: snapshot.get('onsale'),
    //       name: snapshot.get('name'),
    //       artist: snapshot.get('artist'),
    //       price: snapshot.get('price'),
    //       image: snapshot.get('image'),
    //       sampleImages: snapshot.get('sampleImages'),
    //       description: snapshot.get('description'),
    //     ))
    //     .toList();
    // // if (q.sort['type'] == "relevance") {
    // //   list.sort((a, b) => a.relevance.compareTo(b.relevance));
    // // }
    // return list;
    return services
        .where('artist', isEqualTo: q.artist)
        .snapshots()
        .map((snapshot1) => snapshot1.docs
            .map((snapshot) => Service(
                  id: snapshot.id,
                  forSale: snapshot.get('onsale'),
                  name: snapshot.get('name'),
                  artist: snapshot.get('artist'),
                  price: snapshot.get('price'),
                  image: snapshot.get('image'),
                  sampleImages: snapshot.get('sampleImages'),
                  description: snapshot.get('description'),
                ))
            .toList());
  } on Exception catch (e) {
    print(e);
    return null;
  }
}
