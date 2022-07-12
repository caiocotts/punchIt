import 'package:flutter/material.dart';
import 'package:punch_it/Screens/home_screen.dart';
import 'package:punch_it/Theme/app_colors.dart';
import 'package:punch_it/Repositories/user_repository.dart';
import 'package:punch_it/Models/user.dart' as punch_it;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String password = '', email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColours.backgroundRed,
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: SafeArea(
            child: Column(children: [
              const Image(
                alignment: Alignment.topCenter,
                height: 300,
                width: 300,
                image: AssetImage(
                  'assets/punchIt.png',
                ),
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
                      onChanged: (value) => email = value,
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
                      onChanged: (value) => password = value,
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
                      user = await userRepo.authenticateUser(email, password);
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
                                builder: (_) => const HomeScreen(),
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
                              builder: (_) => const HomeScreen(),
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
