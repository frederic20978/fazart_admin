import 'package:fazart_admin1/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function changeLoginState;
  Register({this.changeLoginState});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  bool isLoggedIn = false;
  final _formkey = GlobalKey<FormState>();
  String fullname;
  String emailAddress;
  String password;
  String error;
  String mobileNumber;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "enter a valid name" : null,
                    onChanged: (value) {
                      setState(() {
                        fullname = value;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    validator: (value) =>
                        value.isEmpty ? "enter a valid Phone number" : null,
                    onChanged: (value) {
                      setState(() {
                        mobileNumber = value;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Mobile",
                      icon: Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
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
                  padding: const EdgeInsets.all(8),
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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) =>
                        value != password ? "password mismatch" : null,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ),
                error == null
                    ? Container()
                    : Align(
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 0.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.blue,
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
                                await _auth.registerWithEmailAndPassword(
                                    fullname.trim(),
                                    emailAddress.trim(),
                                    password.trim(),
                                    mobileNumber.trim());

                            if (result is String) {
                              setState(() {
                                loading = false;
                                error = result;
                              });
                            }
                          }
                        },
                        child: Text(
                          "Register",
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
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ?  Click here to "),
                        InkWell(
                            onTap: () {
                              widget.changeLoginState();
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(color: Colors.red),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
