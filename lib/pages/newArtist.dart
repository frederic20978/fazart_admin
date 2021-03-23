import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fazart_admin1/database.dart';

class AddNewArtist extends StatefulWidget {
  @override
  _AddNewArtistState createState() => _AddNewArtistState();
}

class _AddNewArtistState extends State<AddNewArtist> {
  String name, bio;
  final _formkey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _image;
  bool imageAdded = false;
  bool uploading = false;

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
        title: Text('Add Artist'),
        centerTitle: true,
      ),
      body: Builder(builder: (context1) {
        return Container(
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
                                  border: Border.all(width: .5)),
                              height: 300,
                              width: 280,
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
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: "Name",
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
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLength: 120,
                  decoration: InputDecoration(
                    labelText: "Bio",
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
                height: 50,
                child: FlatButton(
                    color: Colors.blue,
                    onPressed: () {
                      try {
                        createArtist(name, bio, _image);
                        Scaffold.of(context1).showSnackBar(
                            SnackBar(content: Text("Successfully uploaded")));
                        print("successfully uploaded");
                        Navigator.pop(context);
                      } catch (e) {
                        print('error not uploaded');
                      }
                    },
                    child: Text('Submit')),
              )
            ]),
          ),
        );
      }),
    );
  }
}
