import 'dart:io';

import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fazart_admin1/database.dart';

class UpdateBio extends StatefulWidget {
  final CustomUser artist;

  UpdateBio({this.artist});
  @override
  _UpdateBioState createState() => _UpdateBioState();
}

class _UpdateBioState extends State<UpdateBio> {
  final _formkey = GlobalKey<FormState>();
  String name, bio;
  File _image;
  bool imageAdded = false;
  bool uploading = false;
  final picker = ImagePicker();

  Future<CustomUser> getBio(artist) {
    return Future(() => artist);
  }

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
          title: Text('Update Bio'),
        ),
        body: FutureBuilder(
          future: getBio(widget.artist),
          builder: (context, snapshot) {
            return Form(
              key: _formkey,
              child: ListView(children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  child: TextFormField(
                    initialValue: widget.artist.name,
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
                  height: 300,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Image:',
                        style: h6color,
                      ),
                      IconButton(
                        onPressed: () {
                          if (imageAdded) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Sorry, more images cannot be added"),
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
                                  // border: Border.all(width: .5)
                                ),
                                width: 200,
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
                  height: 80,
                  child: TextFormField(
                    initialValue: widget.artist.bio,
                    onChanged: (value) {
                      setState(() {
                        bio = value;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
                      color: Colors.red,
                      onPressed: () async {
                        try {
                          await updateArtist(
                              name: name ?? widget.artist.name,
                              userid: widget.artist.uid,
                              bio: bio ?? widget.artist.bio,
                              image: _image);
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Successfully uploaded")));
                          print("successfully uploaded");
                          Navigator.pushReplacementNamed(context, '/');
                        } catch (e) {
                          print('error not uploaded');
                        }
                      },
                      child: Text('Submit')),
                )
              ]),
            );
          },
        ));
  }
}
