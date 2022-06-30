import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/forgot_password_screen.dart';
import 'package:punch_it/registration_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String password = '', email = '';

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
                        'assets/punchIt.png',
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
                        onChanged: (value) => password = value,
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

                          try {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email, password: password);

                          } on FirebaseAuthException catch (e) {
                            SnackBar snackBar = SnackBar(
                              content: Text(
                                e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
                              ),
                              backgroundColor: Colors.redAccent,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {});
                            return;
                          }
                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null && !user.emailVerified) {
                            SnackBar snackBar = const SnackBar(
                              content: Text("Check email to verify account"),
                              backgroundColor: Colors.redAccent,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {});
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                  child: Container(),
                                ),
                                Builder(builder: (context) {
                                  return TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgotPasswordScreen(),
                                      ),
                                    ),
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
                                Builder(builder: (context) {
                                  return TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const RegistrationScreen(),
                                      ),
                                    ),
                                    child: const Text("Sign Up"),
                                    style: TextButton.styleFrom(
                                      primary: Colors.black,
                                    ),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
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
