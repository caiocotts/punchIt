import 'package:flutter/material.dart';
import 'package:punch_it/models/group.dart';
import 'package:punch_it/repositories/group_repository.dart';
import 'package:punch_it/screens/group_info_screen.dart';
import 'package:punch_it/theme/app_theme.dart';

class JoinedGroupsScreen extends StatefulWidget {
  final String userEmail;

  const JoinedGroupsScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  State<JoinedGroupsScreen> createState() => _JoinedGroupsScreenState();
}

class _JoinedGroupsScreenState extends State<JoinedGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundRed,
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                future: GroupRepository.getInstance()
                    .getGroupNames(widget.userEmail),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Group>> groups) {
                  if (groups.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: groups.data?.length,
                        itemBuilder: (context, index) {
                          return Builder(builder: (context) {
                            return TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) {
                                  return GroupInfoScreen(
                                    group: groups.data![index],
                                  );
                                }),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                              ),
                              child: Text(
                                groups.data![index].name as String,
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
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
}
