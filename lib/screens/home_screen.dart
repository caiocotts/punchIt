import 'dart:async';
import 'package:flutter/material.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/screens/create_group_screen.dart';
import 'package:punch_it/screens/joined_groups_screen.dart';
import 'package:punch_it/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String punchPressure = '';

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(children: [
          Image.asset(
            'assets/punchingBag.png',
            height: 35.h,
            width: 60.w,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              "Sensor Reading",
              style: TextStyle(
                fontSize: 13.w,
                fontFamily: 'FiraSans',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                initialData: 'Loading...',
                future: UserRepository.getInstance().updateHighScore(),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> pressure) {
                  return Text(
                    pressure.data!,
                    style: TextStyle(
                      fontSize: 20.w,
                      fontFamily: 'FiraSans',
                    ),
                  );
                }),
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
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text("Create a Group"),
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
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text(
                    "Joined Groups",
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
