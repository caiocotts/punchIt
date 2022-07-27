import 'package:flutter/material.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/screens/login_screen.dart';
import 'package:punch_it/theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String _email = '', _password = '', _retypedPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              TextField(
                onChanged: (value) => _email = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) => _password = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
                textInputAction: TextInputAction.next,
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (value) => _retypedPassword = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Re-enter Password'),
                textInputAction: TextInputAction.next,
                obscureText: true,
              ),
              const SizedBox(
                height: 15,
              ),
              Builder(builder: (context) {
                return TextButton(
                  onPressed: () async {
                    if (_password != _retypedPassword) {
                      SnackBar snackBar = const SnackBar(
                        content: Text('Passwords do not match'),
                        backgroundColor: Colors.redAccent,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {});
                      return;
                    }
                    UserRepository userRepo = UserRepository.getInstance();
                    try {
                      await userRepo.registerUser(_email, _password);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return const LoginScreen();
                      }),
                    );
                  },
                  child: const Text('Sign Up'),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    backgroundColor: Colors.grey,
                  ),
                );
              })
            ]),
          )
        ]),
      ),
    );
  }
}
