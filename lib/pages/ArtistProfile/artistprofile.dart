import 'package:fazart_admin1/database.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/models/painting.dart';
import 'package:fazart_admin1/models/query.dart';
import 'package:fazart_admin1/models/service.dart';
import 'package:fazart_admin1/pages/ArtistProfile/updateBio.dart';
import 'package:fazart_admin1/pages/SinglePainting.dart';
import 'package:fazart_admin1/pages/SingleService.dart';
import 'package:fazart_admin1/services/auth.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share/share.dart';

class ArtistProfile extends StatefulWidget {
  final CustomUser artist;
  ArtistProfile(this.artist);
  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  Stream<List<Painting>> paintingFuture;
  Stream<List<Service>> serviceFuture;
  int currentTab = 0;
  String url;
  bool editBio = false;

  Widget grid(
      {int curreentTab, List<dynamic> paintings, List<dynamic> services}) {
    switch (currentTab) {
      case 0:
        return StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(top: 4, left: 4, right: 4),
          shrinkWrap: true,
          crossAxisCount: 2,
          itemCount: paintings.length,
          itemBuilder: (BuildContext context, int index) {
            try {
              return SinglePainting(paintings[index], widget.artist, () {
                setState(() {
                  getData();
                });
              });
            } on Exception catch (e) {
              print(e);
              return Container(
                child: Text("error"),
              );
            }
          },
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        );

      case 1:
        return StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(top: 4, left: 4, right: 4),
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          shrinkWrap: true,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          crossAxisCount: 2,
          itemCount: services.length,
          itemBuilder: (context, index) {
            return SingleService(services[index], () {
              setState(() {
                getData();
              });
            });
          },
        );
      default:
        return null;
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    url = await getUrl();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.artist.hasBio || editBio
        ? UpdateBio(artist: widget.artist)
        : Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
              centerTitle: true,
              actions: [
                FlatButton.icon(
                    onPressed: () {
                      AuthService().signOut();
                    },
                    icon: Icon(Icons.logout),
                    label: Text('logout')),
              ],
            ),
            body: StreamBuilder<List<dynamic>>(
                stream: currentTab == 0
                    ? getPaintings(QueryModel(
                        artist: widget.artist.uid,
                        sale: false,
                        sort: {"bool": false, "type": null, "desc": true},
                        filterArray: [],
                        priceRange: null,
                      ))
                    : getServices(QueryModel(
                        artist: widget.artist.uid,
                        sale: false,
                        sort: {"bool": false, "type": null, "desc": true},
                        filterArray: [],
                        priceRange: null,
                      )),
                builder: (context, snapshot) {
                  return DefaultTabController(
                    initialIndex: currentTab,
                    length: 2,
                    child: NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              toolbarHeight: 0,
                              leading: Container(),
                              bottom: TabBar(
                                labelColor: Colors.black,
                                onTap: (tab) {
                                  setState(() {
                                    currentTab = tab;
                                  });
                                },
                                indicatorColor: Colors.redAccent,
                                tabs: [
                                  Tab(
                                    text: "ARTWORKS",
                                  ),
                                  Tab(
                                    text: "SERVICES",
                                  ),
                                ],
                              ),
                              pinned: true,
                              backgroundColor: Colors.white,
                              expandedHeight: 280.0,
                              collapsedHeight: 1,
                              flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.pin,
                                background: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 15),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: NetworkImage(
                                                      widget.artist.image),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 1,
                                                      horizontal: 15),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              widget
                                                                  .artist.name,
                                                              style: h4,
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () async {
                                                              final cache = await DefaultCacheManager()
                                                                  .getSingleFile(
                                                                      widget
                                                                          .artist
                                                                          .image);
                                                              print(cache);
                                                              Share.shareFiles(
                                                                  [cache.path],
                                                                  text:
                                                                      'Check my profile on Fazart: ${widget.artist.name} $url/artist/${widget.artist.uid}');
                                                            },
                                                            child: Icon(
                                                              Icons.share,
                                                              size: 25,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        widget.artist.bio ??
                                                            'No bio',
                                                        style: h8,
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          FlatButton.icon(
                                                              onPressed: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/updatebio',
                                                                    arguments:
                                                                        widget
                                                                            .artist);
                                                              },
                                                              icon: Icon(
                                                                  Icons.edit),
                                                              label: Text(
                                                                  'Edit Bio'))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: FlatButton(
                                                        color:
                                                            Colors.purple[900],
                                                        onPressed: () async {
                                                          await Navigator.pushNamed(
                                                              context,
                                                              '/artistaddpainting',
                                                              arguments: widget
                                                                  .artist);
                                                          setState(() {
                                                            getData();
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add Painting',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ))),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Expanded(
                                                    child: FlatButton(
                                                        color: Colors.redAccent,
                                                        onPressed: () async {
                                                          await Navigator.pushNamed(
                                                              context,
                                                              '/artistaddservice',
                                                              arguments: widget
                                                                  .artist);
                                                          setState(() {
                                                            getData();
                                                          });
                                                        },
                                                        child: Text(
                                                            'Add Service'))),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ];
                        },
                        body: snapshot.hasData
                            ? ((snapshot.data.length == 0)
                                ? Container(child: Text("coming soon"))
                                : currentTab == 0 &&
                                        snapshot.data[0].runtimeType == Painting
                                    ? grid(
                                        curreentTab: currentTab,
                                        paintings: snapshot.data,
                                      )
                                    : currentTab == 1 &&
                                            snapshot.data[0].runtimeType ==
                                                Service
                                        ? grid(
                                            curreentTab: currentTab,
                                            services: snapshot.data,
                                          )
                                        : Container(child: Text("error")))
                            : Container(child: Text("loading"))),
                  );
                }),
          );
  }
}
