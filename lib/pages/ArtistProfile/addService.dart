import 'dart:io';

import 'package:fazart_admin1/database.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddService extends StatefulWidget {
  final CustomUser artist;
  AddService(this.artist);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  String errorMessage;
  String title, description;
  num price, artScore;
  final _formkey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _image;
  bool uploading = false;
  List<Widget> imageList = [];
  List<File> images = [];
  File image;
  bool imageAdded = false;
  bool loading = false;

  Future getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
          imageAdded = true;
        } else {
          print('No image selected.');
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Future getSampleImages(BuildContext context1) async {
    if (imageList.length >= 5) {
      Scaffold.of(context1).showSnackBar(
          SnackBar(content: Text("Sorry, more images cannot be added")));
    } else {
      try {
        final pickedFile = await picker.getImage(
            source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
        setState(() {
          if (pickedFile != null) {
            _image = File(pickedFile.path);
            var img = InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(_image)),
                    border: Border.all(width: .5)),
                height: 50,
                width: 50,
              ),
            );
            images.add(_image);
            imageList.add(img);
          } else {
            print('No image selected.');
          }
        });
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Service'),
        centerTitle: true,
      ),
      body: Builder(builder: (context1) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Form(
            key: _formkey,
            child: ListView(children: [
              Container(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (imageAdded) {
                              print('more images cant be added');
                            } else {
                              getImage(context);
                            }
                          },
                          icon: Icon(Icons.add_a_photo_outlined),
                        ),
                        Text(
                          'Thumbnail',
                          style: h8,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    imageAdded
                        ? InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                  image:
                                      DecorationImage(image: FileImage(image)),
                                  border: Border.all(width: .5)),
                              height: 250,
                              width: 240,
                            ),
                          )
                        : Container(),
                    imageAdded
                        ? Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  imageAdded = false;
                                });
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Divider(),
              Container(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            getSampleImages(context1);
                          },
                          icon: Icon(Icons.add_a_photo_outlined),
                        ),
                        Text(
                          'Samples',
                          style: h8,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ...imageList,
                    imageList.length == 0
                        ? Container()
                        : Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  imageList.removeLast();
                                  images.removeLast();
                                });
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          )
                  ],
                ),
              ),
              Divider(),
              Container(
                height: 100,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid title" : null,
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Title",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 100,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid Description" : null,
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: "Description",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 100,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid Price" : null,
                  onChanged: (value) {
                    setState(() {
                      price = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "Price",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                height: 100,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid ArtScore" : null,
                  onChanged: (value) {
                    setState(() {
                      artScore = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                    labelText: "Art Score",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: .5,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              errorMessage == null
                  ? Container()
                  : Container(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
              Container(
                height: 60,
                child: FlatButton(
                    color: Colors.blue,
                    onPressed: () async {
                      if (_formkey.currentState.validate() && image != null) {
                        if (imageList.length > 2) {
                          try {
                            setState(() {
                              loading = true;
                            });
                            await createService(title, widget.artist.uid,
                                description, price, images, image);
                            Scaffold.of(context1).showSnackBar(SnackBar(
                                content: Text("Successfully uploaded")));
                            print("successfully uploaded");
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            print('error not uploaded');
                          }
                        }
                      } else {
                        errorMessage = 'Atleast 3 sample images required';
                      }
                    },
                    child: loading
                        ? Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: double.infinity,
                                height: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                )))
                        : Text('Submit')),
              )
            ]),
          ),
        );
      }),
    );
  }
}
