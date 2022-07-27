import 'package:flutter/material.dart';
import 'package:punch_it/repositories/group_repository.dart';
import 'package:punch_it/screens/home_screen.dart';
import 'package:punch_it/theme/app_theme.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
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
                onChanged: (value) => groupName = value,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Group Name',
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () async {
                  GroupRepository groupRepo = GroupRepository.getInstance();
                  try {
                    await groupRepo.createGroup(groupName);
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
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
                },
                child: const Text('Create'),
              );
            })
          ],
        ),
      ),
    );
  }
}
