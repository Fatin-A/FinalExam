import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  // final LoginService _auth = locator<LoginService>();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> editProfile(String id, String title, String content) async {
    await _users.doc(id).update({
      'id': id,
      'email': title,
      'phonenum': content,
    });
  }

  static locator() {}
}
