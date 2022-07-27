import 'package:flutter/material.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/screens/create_group_screen.dart';
import 'package:punch_it/screens/joined_groups_screen.dart';
import 'package:punch_it/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(children: [
          Image.asset(
            'assets/punchingBag.png',
            height: 256,
            width: 256,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Sensor Reading",
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'FiraSans',
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 160),
            child: Center(
              child: Text(
                "42",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'FiraSans',
                ),
              ),
            ),
          ),
          Row(children: [
            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(left: 25),
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateGroupScreen(),
                    ),
                  ),
                  child: const Text("Create a Group"),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
              );
            }),
            Expanded(
              child: Container(),
            ),
            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(right: 25),
                child: TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JoinedGroupsScreen(
                          userEmail:
                              UserRepository.getInstance().getUser().email!,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Joined Groups",
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                ),
              );
            })
          ])
        ]),
      ),
    );
  }
}
