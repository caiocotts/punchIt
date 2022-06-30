import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String newEmail = '', newPassword = '', retypedPassword = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: TextField(
                onChanged: (value) => newEmail = value,
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
                onChanged: (value) => newPassword = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
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
                onChanged: (value) => retypedPassword = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Re-enter Password",
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  final User? user = auth.currentUser;
                  if (retypedPassword != newPassword) {
                    SnackBar snackBar = const SnackBar(
                      content: Text("Passwords do not match"),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {});
                    return;
                  }
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: newEmail, password: newPassword);
                  } on FirebaseAuthException catch (e) {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
                      ),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {});
                    return;
                  }
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user?.email)
                      .set({
                    "uid": user?.uid,
                  }).catchError((e) {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
                      ),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {});
                    return;
                  });
                  if (user != null && !user.emailVerified) {
                    await user.sendEmailVerification();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {

                        return const LoginScreen();
                      },
                    ),
                  );
                },
                child: const Text("Sign Up"),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: Colors.grey,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
