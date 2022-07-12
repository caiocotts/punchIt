import 'package:firebase_auth/firebase_auth.dart';
import 'package:punch_it/Models/user.dart' as punch_it;
// import 'package:get_it/get_it.dart';

class UserRepository {
  static UserRepository? _instance;

  static getInstance() {
    _instance ??= UserRepository();
    return _instance;
  }

  Future<punch_it.User> authenticateUser(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
      (value) {
        punch_it.User u = punch_it.User();
        u.email = value.user?.email;
        u.uid = value.user?.uid;
        u.emailVerified = value.user?.emailVerified;
        return u;
      },
    );
  }
}
