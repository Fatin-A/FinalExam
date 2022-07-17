// ignore_for_file: unused_element, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_exam/note.dart';

class Service {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final String? uid;
  Service({this.uid});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final _auth = FirebaseAuth.instance;

  String errorMessage = "";

  Future<void> editProfile(String id, String title, String content) async {
    await _users.doc(id).update({
      'id': id,
      'email': title,
      'phonenum': content,
    });
  }

  Note? _userFromFirebaseUser(User? user) {
    return user != null
        ? Note(
            id: user.uid,
            title: '',
            content: '',
          )
        : null;
  }

  Future logIn(String email, String password) async {
    // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User? user = _auth.currentUser;

    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {});
      return 200;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Email address entered is invalid.";
          break;
        case "wrong-password":
          errorMessage =
              "The password entered is wrong. (Does not match with the registered email)";
          break;
        case "user-not-found":
          errorMessage = "Email address not found. Please register.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        default:
          errorMessage = "Undefined error.";
      }
      return errorMessage;
    }
  }
}
