import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/home_screen.dart';

class InviteUser extends StatefulWidget {
  // const InviteUser({Key? key}) : super(key: key);

  final String groupName;

  const InviteUser(this.groupName);

  @override
  State<InviteUser> createState() => _InviteUserState();
}

class _InviteUserState extends State<InviteUser> {
  late String userToInvite = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: TextField(
                onChanged: (value) => userToInvite = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Builder(
              builder: (context) {
                return TextButton(
                    onPressed: () async {
                      // QueryDocumentSnapshot queryDocumentSnapshot = await getGroupInfo(widget.groupName);
                      FirebaseFirestore.instance
                          .collection("junction_user_group")
                          .doc(userToInvite + widget.groupName)
                          .set({
                        "groupId": await getGroupInfo(widget.groupName),
                        "email": userToInvite,
                      }).then((_) {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      }).catchError((e) {
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
                    child: const Text("Invite"));
              },
            )
          ],
        ),
      ),
    );
  }

  Future<String> getGroupInfo(String groupName) async {
    var groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('name', isEqualTo: groupName)
        .get();
    // var groupList = Stream.fromFutures(
    //   groupSnapshot.docs.map((e) async {
    //     var groupId = e.data()['groupId'];
    //     DocumentSnapshot documentSnapshot =
    //     await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
    //     return documentSnapshot.id ;
    //   }),
    // ).toList();

    // print(groupSnapshot.docs[0].id);

    return groupSnapshot.docs[0].id;
  }
}
