import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/home_screen.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String newGroupName = '', groupDescription = '';
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              onChanged: (value) => newGroupName = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Group Name",
              ),
              textInputAction: TextInputAction.next,
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  final User? user = auth.currentUser;
                  // print(newGroupName);
                  // print(uid);
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(user?.uid)
                      .collection("groups")
                      .add({
                        "groupName": newGroupName,
                      })
                      .then(
                        (_) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        ),
                      )
                      .catchError((e) {
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
                },
                child: const Text("Create"),
              );
            })
          ],
        ),
      ),
    );
  }
}
