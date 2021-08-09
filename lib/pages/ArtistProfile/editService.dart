import 'dart:io';

import 'package:fazart_admin1/models/service.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/database.dart';
import 'package:image_picker/image_picker.dart';

class EditService extends StatefulWidget {
  final Service service;
  EditService(this.service);

  @override
  _EditServiceState createState() => _EditServiceState();
}

class _EditServiceState extends State<EditService> {
  final _formkey = GlobalKey<FormState>();
  bool imageAdded = true;
  File image;
  final picker = ImagePicker();
  bool isNewImage = false;
  String title, description;
  bool sale;
  bool loading = false;
  num price;
  bool isDataUpdated = false;

  Future getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
          imageAdded = true;
          isNewImage = true;
        } else {
          print('No image selected.');
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  List<Widget> imageList(List<dynamic> samples) {
    return samples.map((e) {
      return InkWell(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(e)),
          ),
          height: 50,
          width: 50,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Service"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getService(widget.service.id),
        builder: (context, snapshot) {
          if ((snapshot.hasData) & (!isDataUpdated)) {
            title = snapshot.data.name;
            description = snapshot.data.description;
            sale = snapshot.data.forSale;
            price = snapshot.data.price;

            isDataUpdated = true;
          }
          return snapshot.hasData
              ? Form(
                  key: _formkey,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (imageAdded) {
                                      print('more images cant be added');
                                      Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text(
                                              "Please delete the existing thumbnail before adding new one.")));
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: isNewImage
                                                ? FileImage(image)
                                                : NetworkImage(
                                                    snapshot.data.image)),
                                      ),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Samples',
                            style: h8,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ...imageList(snapshot.data.sampleImages),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        child: TextFormField(
                          initialValue: title,
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
                      Container(
                        height: 80,
                        child: TextFormField(
                          initialValue: description,
                          validator: (value) => value.isEmpty
                              ? "Enter a valid Description"
                              : null,
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
                      Row(
                        children: [
                          Text(
                            'For Sale',
                            style: h6color,
                          ),
                          Switch(
                              value: sale,
                              activeColor: Colors.redAccent,
                              onChanged: (value) {
                                setState(() {
                                  sale = value;
                                });
                              }),
                        ],
                      ),
                      sale
                          ? Column(
                              children: [
                                Container(
                                  height: 80,
                                  child: TextFormField(
                                    initialValue: price.toString(),
                                    validator: (value) => value.isEmpty
                                        ? "Enter a valid Price"
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        price = int.parse(value);
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    maxLength: 7,
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
                              ],
                            )
                          : Container(),
                      Container(
                        height: 60,
                        child: FlatButton(
                            color: Colors.redAccent,
                            onPressed: () async {
                              if (_formkey.currentState.validate() &&
                                  ((image != null) || !isNewImage)) {
                                try {
                                  setState(() {
                                    loading = true;
                                  });

                                  await modifyService(
                                    snapshot.data.id,
                                    isNewImage,
                                    snapshot.data.image,
                                    title,
                                    snapshot.data.artist,
                                    description,
                                    price,
                                    image,
                                    sale,
                                  );
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Successfully uploaded")));
                                  print("successfully uploaded");
                                  Navigator.pop(context, sale);
                                } catch (e) {
                                  setState(() {
                                    loading = false;
                                  });
                                  print('error not uploaded');
                                }
                              }
                            },
                            child: loading
                                ? Center(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        )))
                                : Text('Submit')),
                      )
                    ],
                  ),
                )
              : Container(child: Text("Data Loading"));
        },
      ),
    );
  }
}
