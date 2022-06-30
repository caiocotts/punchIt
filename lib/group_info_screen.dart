import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:punch_it/invite_user_screen.dart';

class GroupInfo extends StatefulWidget {
  final String groupName;

   const GroupInfo(this.groupName);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFD76446),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.groupName,
                  style: const TextStyle(
                    fontSize: 50,
                    fontFamily: 'FiraSans',
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: DataTable(columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Username',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Highscore',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              ], rows: const <DataRow>[
                DataRow(cells: <DataCell>[
                  DataCell(
                    Text('caio'),
                  ),
                  DataCell(
                    Text('42'),
                  )
                ])
              ]),
            ),
            Expanded(
              child: Container(),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) =>  InviteUser(widget.groupName))),
                child: const Text("Invite someone to group"),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
