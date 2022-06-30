import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/group_info_screen.dart';

class JoinedGroups extends StatefulWidget {
  const JoinedGroups({Key? key}) : super(key: key);

  @override
  State<JoinedGroups> createState() => _JoinedGroupsState();
}

class _JoinedGroupsState extends State<JoinedGroups> {
  var db = FirebaseFirestore.instance;
  late Future<List<String>> documentNames;

  @override
  void initState() {
    super.initState();
    documentNames = getGroupNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: documentNames,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Builder(builder: (context) {
                            return TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return GroupInfo(snapshot.data[index]);
                                }),
                              ),
                              child: Text(
                                snapshot.data[index],
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                            );
                          });
                        });
                  } else {
                    return const Text("retrieving groups...");
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getGroupNames() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    var junctionSnapshot = await db
        .collection('junction_user_group')
        .where('email', isEqualTo: email)
        .get();

    return Stream.fromFutures(
      junctionSnapshot.docs.map((e) async {
        var groupId = e.data()['groupId'];
        DocumentSnapshot documentSnapshot =
            await db.collection('groups').doc(groupId).get();
        return documentSnapshot['name'] as String;
      }),
    ).toList();
  }
}
