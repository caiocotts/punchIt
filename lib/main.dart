import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/second.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const FirstScreen(),
  );
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late String email, password = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFD76446),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/PunchIt.png',
                        height: 300,
                        width: 300,
                      ),
                    ),
                    const Text(
                      "Punch It!",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'FiraSans',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextField(
                        onChanged: (value) => email = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextField(
                        obscureText: true,
                        onChanged: (value) => email = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Builder(builder: (context) {
                      return TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Second(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                        ),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: Colors.grey,
                        ),
                      );
                    }),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Builder(builder: (context) {
                                return TextButton(
                                  onPressed: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const Second(),
                                      ),
                                    );
                                  },
                                  child: const Text("Forgot Password?"),
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                );
                              }),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Column(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              TextButton(
                                onPressed: null,
                                child: const Text("Register"),
                                style: TextButton.styleFrom(
                                  primary: Colors.black,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Future logUser(String email, String pass) async {
//   try {
//     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
//   } on FirebaseAuthException catch(e) {
//     if (e.code == 'user-not-found') {
//       print('No user found for that email.');
//     } else if (e.code == 'wrong-password') {
//       print('Wrong password provided for that user.');
//     }
//   }
// }

// Future registerUser(String email, String pass) async {
//   try {
//     UserCredential userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: pass,
//     );
//   } on FirebaseAuthException catch (e) {
//     if (e.code == 'weak-password') {
//       print('The password provided is too weak.');
//     } else if (e.code == 'email-already-in-use') {
//       print('The account already exists for that email.');
//     }
//   } catch (e) {
//     print(e);
//   }
// }
