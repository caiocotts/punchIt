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
            Image.asset(
              'assets/pencil.png',
              height: 250,
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                onChanged: (value) => newGroupName = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Group Name",
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  DocumentReference docRef = await FirebaseFirestore.instance
                      .collection("groups")
                      .add({
                    "name": newGroupName,
                  });
                  String? email = auth.currentUser?.email;
                  FirebaseFirestore.instance
                      .collection("junction_user_group")
                      .doc(email! + docRef.id)
                      .set({
                    "groupId": docRef.id,
                    "email": email,
                  }).then(
                    (_) {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                  ).catchError((e) {
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
