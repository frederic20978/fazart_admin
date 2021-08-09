import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/models/painting.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/database.dart';

class SinglePainting extends StatefulWidget {
  final Painting painting;
  final CustomUser artist;
  final Function refresh;
  SinglePainting(this.painting, this.artist, this.refresh);

  @override
  _SinglePaintingState createState() => _SinglePaintingState();
}

class _SinglePaintingState extends State<SinglePainting> {
  bool switchValue = false;

  @override
  void initState() {
    switchValue = widget.painting.forSale;
    // isSignedIn();
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () async {
        Navigator.of(context).pop();
        await deletePainting(widget.painting);
        widget.refresh();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text(
          "Would you like to premanently delete this work from your profile"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser>(
        stream: getArtist(widget.painting.artist),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              if (snapshot.hasData) {
                Navigator.pushNamed(context, '/pdetails', arguments: {
                  "painting": widget.painting,
                  "artist": snapshot.data
                });
              }
            },
            child: Card(
              margin: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.painting.name,
                            style: h8.copyWith(color: Color(0xFF2699FB)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: double.infinity,
                      child: Image.network(
                        widget.painting.image,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Center(
                      child: Text(
                        "INR${widget.painting.price}",
                        style: h6color,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.all(3),
                      color: Color(0x7dc9c9c9),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("For Sale"),
                                Switch(
                                  activeColor: Colors.blue,
                                  value: switchValue,
                                  onChanged: (newValue) async {
                                    try {
                                      if (widget.painting.price != null) {
                                        await changeForSaleState(
                                            widget.painting, newValue);
                                        setState(() {
                                          switchValue = newValue;
                                        });
                                      } else {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                                "please update the painting. Price, Height & Width are required for Selling")));
                                      }
                                    } catch (e) {
                                      print(e);
                                    }

                                    widget.refresh();
                                  },
                                ),
                                Container(
                                  width: 30,
                                  child: IconButton(
                                    onPressed: () async {
                                      var res = await Navigator.pushNamed(
                                          context, '/artisteditpainting',
                                          arguments: widget.painting);
                                      if (res != null) {
                                        setState(() {
                                          switchValue = res;
                                        });
                                      }
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              width: 30,
                              child: IconButton(
                                onPressed: () {
                                  showAlertDialog(context);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
