import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JoinedGroups extends StatefulWidget {
  const JoinedGroups({Key? key}) : super(key: key);

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {
  List<String> documentNames = ["control", "group2", "test"];

  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: documentNames.length,
                itemBuilder: (context, index) {
                  getGroupNames();
                  return Text(documentNames[index]);
                }),
          ],
        ),
      ),
    );
  }

  Future getGroupNames() async {
    var id = FirebaseAuth.instance.currentUser?.uid;
    var docSnapshot = await FirebaseFirestore.instance
        .collection('users/$id/groups')
        .get();
    print(docSnapshot.docs.map((e) => e.data()));
  }
}
