import 'package:flutter/material.dart';
import 'package:punch_it/screens/invite_user_screen.dart';
import 'package:punch_it/theme/app_theme.dart';
import 'package:punch_it/models/group.dart';

class GroupInfoScreen extends StatefulWidget {
  final Group group;

  const GroupInfoScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.group.name!,
                style: const TextStyle(fontSize: 50, fontFamily: 'FiraSans'),
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InviteUserScreen(
                      group: widget.group,
                    ),
                  ),
                ),
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
