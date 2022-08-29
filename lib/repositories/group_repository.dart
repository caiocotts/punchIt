import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:punch_it/repositories/user_repository.dart';
import 'package:punch_it/models/user.dart' as punch_it;

import 'package:punch_it/models/group.dart';

class GroupRepository {
  static GroupRepository? _instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static GroupRepository getInstance() {
    _instance ??= GroupRepository();
    return _instance!;
  }

  Future<Group> createGroup(String groupName) async {
    Group group = Group();
    await _firestore.collection('groups').add({
      'name': groupName,
    }).then((groupRef) async {
      group.name = groupName;
      group.id = groupRef.id;
      await inviteUserToGroup(
          group, UserRepository.getInstance().getUser().email!);
    });
    return group;
  }

  Future<Group> inviteUserToGroup(Group group, String userEmail) async {
    await _firestore
        .collection('junction_user_group')
        .doc(userEmail + group.id!)
        .set({
      'groupId': group.id,
      'email': userEmail,
    });
    return group;
  }

  Future<List<Group>> getGroupNames(String userEmail) async {
    var junctionSnapshot = await _firestore
        .collection('junction_user_group')
        .where('email', isEqualTo: userEmail)
        .get();

    return Stream.fromFutures(
      junctionSnapshot.docs.map(
        (e) async {
          Group group = Group();
          group.id = e.data()['groupId'];
          var documentSnapshot =
              await _firestore.collection('groups').doc(group.id).get();
          group.name = documentSnapshot['name'] as String;
          return group;
        },
      ),
    ).toList();
  }

  Future<List<punch_it.User>> getGroupMembers(Group group) async {
    var junctionSnapshot = await _firestore
        .collection('junction_user_group')
        .where('groupId', isEqualTo: group.id)
        .get();

    return Stream.fromFutures(
      junctionSnapshot.docs.map(
        (e) async {
          punch_it.User user = punch_it.User();
          user.email = e.data()['email'];
          var docSnapshot =
              await _firestore.collection('users').doc(user.email).get();
          user.uid = docSnapshot.data()!['uid'];

          if (docSnapshot.data()!['highscore'] == null) {
            user.highScore = 0;
          } else {
            user.highScore = docSnapshot.data()!['highscore'];
          }

          return user;
        },
      ),
    ).toList();
  }
}
