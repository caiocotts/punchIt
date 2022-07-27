import 'package:flutter/material.dart';
import 'package:punch_it/models/group.dart';
import 'package:punch_it/theme/app_theme.dart';
import 'package:punch_it/repositories/group_repository.dart';
import 'package:punch_it/screens/home_screen.dart';

class InviteUserScreen extends StatefulWidget {
  final Group group;

  const InviteUserScreen({Key? key, required this.group}) : super(key: key);

  @override
  State<InviteUserScreen> createState() => _InviteUserScreenState();
}

class _InviteUserScreenState extends State<InviteUserScreen> {
  String userToInvite = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) => userToInvite = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  try {
                    await GroupRepository.getInstance()
                        .inviteUserToGroup(widget.group, userToInvite);
                  } on Exception catch (e) {
                    SnackBar snackBar = SnackBar(
                      content: Text(
                        e.toString().replaceAll(RegExp(r'\[.*\]'), ''),
                      ),
                      backgroundColor: Colors.redAccent,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState(() {});
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) {
                      return const HomeScreen();
                    }),
                  );
                },
                child: const Text("Invite"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
