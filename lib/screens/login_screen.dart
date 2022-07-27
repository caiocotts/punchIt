import 'package:flutter/material.dart';
import 'package:punch_it/screens/forgot_password_screen.dart';
import 'package:punch_it/screens/home_screen.dart';
import 'package:punch_it/screens/registration_screen.dart';
import 'package:punch_it/theme/app_theme.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/models/user.dart' as punch_it;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _password = '', _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppTheme.backgroundRed,
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: SafeArea(
            child: Column(children: [
              Image.asset(
                'assets/punchIt.png',
                height: 300,
                width: 300,
              ),
              const Text(
                'Punch It!',
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => _email = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      onChanged: (value) => _password = value,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    UserRepository userRepo = UserRepository.getInstance();
                    var user = punch_it.User();
                    try {
                      user = await userRepo.authenticateUser(_email, _password);
                    } on Exception catch (e) {
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

                    if (!user.emailVerified!) {
                      SnackBar snackBar = const SnackBar(
                        content: Text("Check email to verify account"),
                        backgroundColor: Colors.redAccent,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    'Login',
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(children: [
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
                                builder: (_) => const ForgotPasswordScreen(),
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
                    Column(children: [
                      Expanded(
                        child: Container(),
                      ),
                      Builder(builder: (context) {
                        return TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegistrationScreen(),
                            ),
                          ),
                          child: const Text("Sign Up"),
                          style: TextButton.styleFrom(
                            primary: Colors.black,
                          ),
                        );
                      }),
                    ])
                  ]),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
