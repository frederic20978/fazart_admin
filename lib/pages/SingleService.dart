import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/models/service.dart';
import 'package:fazart_admin1/database.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';

class SingleService extends StatefulWidget {
  final Service service;
  final Function refresh;
  SingleService(this.service, this.refresh);

  @override
  _SingleServiceState createState() => _SingleServiceState();
}

class _SingleServiceState extends State<SingleService> {
  bool switchValue;

  @override
  void initState() {
    switchValue = widget.service.forSale;
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
        await deleteService(widget.service);
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
        stream: getArtist(widget.service.artist),
        builder: (context, snapshot) {
          return InkWell(
            child: Card(
              margin: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.service.name,
                            style: h8.copyWith(color: Color(0xFF2699FB)),
                          ),
                          Text(
                            "INR${widget.service.price}",
                            style: h8,
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
                        widget.service.image,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
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
                                    try {
                                      await changeForSaleStateService(
                                          widget.service, newValue);
                                      setState(() {
                                        switchValue = newValue;
                                      });
                                    } catch (e) {
                                      print(e);
                                    }

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
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
