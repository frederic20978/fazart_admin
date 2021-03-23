import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fazart_admin1/models/customUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var users = FirebaseFirestore.instance.collection('users');

  // create User from firebaseUser
  // User _userFromFirebaseUser(User user) {
  //   return user != null ? User(uid: user.uid) : null;
  // }
  User currentUser() {
    return _auth.currentUser;
  }

  Stream<CustomUser> user() {
    return _auth.authStateChanges().map((user) {
      return user != null ? CustomUser(uid: user.uid, email: user.email) : null;
    });
  }

  // signin with email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      return e.message;
    }
  }

// register with email
  Future registerWithEmailAndPassword(String fullname, String email,
      String password, String mobileNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create user data in firestore
      await users.doc(user.uid).set({
        "email": user.email,
        "name": fullname,
        "mobileNumber": mobileNumber,
        "isArtist": true
      });

      return user;
    } catch (e) {
      print(e.message);

      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
