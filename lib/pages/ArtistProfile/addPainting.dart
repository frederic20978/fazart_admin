import 'dart:io';

import 'package:fazart_admin1/database.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddPainting extends StatefulWidget {
  final CustomUser artist;
  AddPainting(this.artist);

  @override
  _AddPaintingState createState() => _AddPaintingState();
}

class _AddPaintingState extends State<AddPainting> {
  String title, description;
  num price, artScore;
  final _formkey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _image;
  bool imageAdded = false;
  bool uploading = false;
  bool loading = false;
  bool sale = false;
  num height, width;

  Future getImage(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          imageAdded = true;
        } else {
          print('No image selected.');
        }
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Painting'),
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
                    IconButton(
                      onPressed: () {
                        if (imageAdded) {
                          Scaffold.of(context1).showSnackBar(SnackBar(
                            content: Text("Sorry, more images cannot be added"),
                          ));
                        } else {
                          getImage(context);
                        }
                      },
                      icon: Icon(Icons.add_a_photo_outlined),
                    ),
                    imageAdded
                        ? InkWell(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: FileImage(_image)),
                              ),
                              height: 260,
                              width: 260,
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
              Container(
                height: 80,
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
                  ? Container(
                      height: 100,
                      child: TextFormField(
                        validator: (value) =>
                            value.isEmpty ? "Enter a valid price" : null,
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
                    )
                  : Container(),
              Divider(),
              Container(
                height: 80,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid Height" : null,
                  onChanged: (value) {
                    setState(() {
                      height = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "Height in cm",
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
                height: 80,
                child: TextFormField(
                  validator: (value) =>
                      value.isEmpty ? "Enter a valid Width" : null,
                  onChanged: (value) {
                    setState(() {
                      width = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: "Width in cm",
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
              // Divider(),
              // Container(
              //   height: 100,
              //   child: TextFormField(
              //     validator: (value) =>
              //         value.isEmpty ? "Enter a valid ArtScore" : null,
              //     onChanged: (value) {
              //       setState(() {
              //         artScore = int.parse(value);
              //       });
              //     },
              //     keyboardType: TextInputType.number,
              //     maxLength: 1,
              //     decoration: InputDecoration(
              //       labelText: "Art Score",
              //       fillColor: Colors.white,
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: Colors.blue,
              //         ),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           width: .5,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                height: 50,
                child: FlatButton(
                    color: Colors.purple[900],
                    onPressed: () async {
                      try {
                        if (_formkey.currentState.validate() &&
                            _image != null) {
                          setState(() {
                            loading = true;
                          });
                          await createPainting(title, widget.artist.uid,
                              description, price, _image, sale, height, width);
                          Scaffold.of(context1).showSnackBar(
                              SnackBar(content: Text("Successfully uploaded")));
                          print("successfully uploaded");
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() {
                          loading = false;
                        });
                        print('error not uploaded');
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
                        : Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          )),
              )
            ]),
          ),
        );
      }),
    );
  }
}
