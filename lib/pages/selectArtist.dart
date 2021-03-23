import 'package:fazart_admin1/database.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/models/customUser.dart';

class SelectArtist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Container(child: Text('fred'));
    return FutureBuilder<List<CustomUser>>(
      future: getArtists(),
      builder: (context, snapshot) {
        List<CustomUser> artists = snapshot.data;
        return snapshot.hasData
            ? Container(
                child: artists.length == 0
                    ? Container()
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(4),
                              itemCount: artists.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  contentPadding: EdgeInsets.all(4),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/artistprofile',
                                        arguments: artists[index]);
                                  },
                                  leading: Image.network(artists[index].image),
                                  title: Text(artists[index].name),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          FlatButton(
                              color: Colors.green,
                              onPressed: () {
                                Navigator.pushNamed(context, '/newArtist');
                              },
                              child: Text('Add new artist'))
                        ],
                      ),
              )
            : Container(
                child: Center(
                  child: Text('loading'),
                ),
              );
      },
    );
  }
}
