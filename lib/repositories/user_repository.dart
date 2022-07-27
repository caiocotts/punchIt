import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:punch_it/models/user.dart' as punch_it;

class UserRepository {
  static UserRepository? _instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  static UserRepository getInstance() {
    _instance ??= UserRepository();
    return _instance!;
  }

  punch_it.User getUser() {
    punch_it.User usr = punch_it.User();
    usr.uid = _firebase.currentUser?.uid;
    usr.email = _firebase.currentUser?.email;
    usr.emailVerified = _firebase.currentUser?.emailVerified;
    return usr;
  }

  Future<punch_it.User> authenticateUser(String email, String password) {
    return _firebase
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        punch_it.User usr = punch_it.User();
        usr.emailVerified = value.user?.emailVerified;
        return usr;
      },
    );
  }

  Future<punch_it.User> registerUser(String email, String password) async {
    punch_it.User usr = punch_it.User();
    usr = await _firebase
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      usr.email = value.user?.email;
      usr.uid = value.user?.uid;
      usr.emailVerified = value.user?.emailVerified;
      return usr;
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(usr.email)
        .set({'uid': usr.uid}).then(
      (_) => _firebase.currentUser?.sendEmailVerification(),
    );
    return usr;
  }
}
