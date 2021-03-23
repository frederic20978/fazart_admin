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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 25,
                    padding: EdgeInsets.all(2),
                    color: Color(0x7dc9c9c9),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.painting.name,
                              style: h8.copyWith(color: Colors.blue),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "INR${widget.painting.price}",
                            style: h8,
                          )
                        ]),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.painting.image))),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(3),
                    color: Color(0x7dc9c9c9),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("For Sale"),
                              Switch(
                                activeColor: Colors.blue,
                                value: switchValue,
                                onChanged: (newValue) async {
                                  await changeForSaleState(
                                      widget.painting, newValue);
                                  setState(() {
                                    switchValue = newValue;
                                  });
                                  widget.refresh();
                                },
                              ),
                            ],
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            child: IconButton(
                              onPressed: () {
                                showAlertDialog(context);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
