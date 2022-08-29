import 'package:flutter/material.dart';
import 'package:punch_it/screens/device_registration_screen.dart';
import 'package:punch_it/screens/forgot_password_screen.dart';
import 'package:punch_it/screens/home_screen.dart';
import 'package:punch_it/screens/registration_screen.dart';
import 'package:punch_it/theme/app_theme.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/models/user.dart' as punch_it;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '', _password = '';

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
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
                  height: 30.h,
                  width: 60.w,
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
                      final prefs = await SharedPreferences.getInstance();

                      UserRepository userRepo = UserRepository.getInstance();
                      var user = punch_it.User();
                      try {
                        user =
                            await userRepo.authenticateUser(_email, _password);
                      } on Exception catch (e) {
                        SnackBar snackBar = SnackBar(
                          content: Text(
                            e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
                          ),
                          backgroundColor: Colors.redAccent,
                        );
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {});
                        return;
                      }

                      if (!user.emailVerified!) {
                        SnackBar snackBar = const SnackBar(
                          content: Text("Check email to verify account"),
                          backgroundColor: Colors.redAccent,
                        );
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {});
                        return;
                      }
                      if (prefs.getString('device') == null) {
                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DeviceRegistrationScreen(),
                          ),
                        );
                        return;
                      }
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text(
                      'Login',
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
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: const Text("Forgot Password?"),
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
                            style: TextButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: const Text("Sign Up"),
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
    });
  }
}
