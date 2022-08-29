import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:punch_it/models/user.dart' as punch_it;
import 'package:punch_it/repositories/punch_bag_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static UserRepository? _instance;
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

    _firestore.collection('users').doc(usr.email).set({'uid': usr.uid}).then(
        (_) => _firebase.currentUser?.sendEmailVerification());
    return usr;
  }

  Future<String?> updateHighScore() async {
    final prefs = await SharedPreferences.getInstance();

    String? strPressure =
        await PunchBagRepository.getInstance().getPressureReading();

    int iPressure = int.parse(strPressure!);

    if (prefs.getInt('highscore') == null ||
        iPressure > prefs.getInt('highscore')!) {
      prefs.setInt('highscore', iPressure);
    }

    punch_it.User usr = UserRepository.getInstance().getUser();

    _firestore
        .collection('users')
        .doc(usr.email)
        .update({'highscore': prefs.getInt('highscore')});

    return prefs.getInt('highscore').toString();
  }
}
