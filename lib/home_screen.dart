import 'package:flutter/material.dart';
import 'package:punch_it/create_group_screen.dart';
import 'package:punch_it/joined_groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Builder(builder: (context) {
                  return TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateGroup(),
                      ),
                    ),
                    child: const Text("Create a Group"),
                  );
                }),
                // const TextButton(
                //   onPressed: null,
                //   child: Text("View Groups"),
                // ),
                Builder(builder: (context) {
                  return TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const JoinedGroups(),
                      ),
                    ),
                    child: const Text("Joined Groups"),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}
