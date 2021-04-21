import 'package:flutter/material.dart';
import 'package:fazart_admin1/services/auth.dart';

class Login extends StatefulWidget {
  final VoidCallback changeLoginState;
  Login({this.changeLoginState});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  bool isLoggedIn = false;
  final _formkey = GlobalKey<FormState>();
  String emailAddress;
  String password;
  String error;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    // isSignedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formkey,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 200,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "enter a valid email" : null,
                      onChanged: (value) {
                        setState(() {
                          emailAddress = value;
                        });
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email",
                        icon: Icon(Icons.email),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) =>
                          value.isEmpty ? "enter a valid password" : null,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        icon: Icon(Icons.lock),
                      ),
                    ),
                  ),
                  error == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green,
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      emailAddress.trim(), password.trim());
                              if (result is String) {
                                setState(() {
                                  loading = false;
                                  error = result;
                                });
                              } else {
                                // Navigator.popAndPushNamed(context, '/');
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Text("Forgot Password"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont have an account ?  Click here to "),
                          InkWell(
                              onTap: () {
                                widget.changeLoginState();
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.red),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        loading == true
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
            : Container(),
      ],
    );
  }
}
