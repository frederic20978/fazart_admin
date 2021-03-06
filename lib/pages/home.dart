import 'package:fazart_admin1/pages/ArtistProfile/artistprofile.dart';
import 'package:fazart_admin1/pages/authentication/register.dart';
import 'package:fazart_admin1/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:fazart_admin1/services/auth.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:fazart_admin1/database.dart';
import 'package:fazart_admin1/pages/authentication/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<CustomUser> stream;
  bool isLogin = true;

  @override
  void initState() {
    stream = AuthService().user();
    super.initState();
  }

  void changeToRegister() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser>(
        stream: stream,
        builder: (context, snapshot1) {
          return snapshot1.data != null
              ? StreamBuilder<CustomUser>(
                  stream: getUser(snapshot1.data.uid),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return snapshot.data.isArtist
                          ? ArtistProfile(snapshot.data)
                          : Scaffold(
                              appBar: AppBar(
                                title: Text('login'),
                                centerTitle: true,
                              ),
                              body: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                    ),
                                    Text(
                                      "You have a Normal account. Do you wish to apply for artist account?",
                                      style: h6color,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        convertToArtist(snapshot.data.uid);
                                      },
                                      child: InkWell(
                                          child: Text(
                                        "Apply",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )
                                  ],
                                ),
                              ));
                    } else {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text('Fazart'),
                            centerTitle: true,
                          ),
                          body: Text('Content Loading'));
                    }
                  })
              : Scaffold(
                  appBar: AppBar(
                    title: Text('login'),
                    centerTitle: true,
                  ),
                  body: isLogin
                      ? Login(
                          changeLoginState: changeToRegister,
                        )
                      : Register(
                          changeLoginState: changeToRegister,
                        ),
                );
          // ProfilePage(snapshot.data)
          // : Consumer<AppState>(builder: (context, state, widget) {
          //     return _widgetOptions[state.accountIndex];
        });
  }
}
