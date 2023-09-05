import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/models/group_model.dart';
import 'package:firebasedemo/models/user_model.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:uuid/uuid.dart';

class CreateGroupRepo {
  List<UserModel>? _usersList;
  List<UserModel>? get usersList => [...?_usersList];

  final firestore = FirebaseFirestore.instance;

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  Future<String?> fetchUsersList() async {
    try {
      final users = await FireStoreRepository().fetchChatUser().first;
      _usersList = users;
      return null;
    } catch (error) {
      return error.toString();
    }
  }

  void updateUser(UserModel user, {bool isForSelect = false}) {
    final index = _usersList?.indexWhere((element) => element.uid == user.uid);
    if (index != null) {
      final selectedUser = _usersList?[index].copyWith(isSelected: isForSelect);
      if (selectedUser != null) {
        _usersList?[index] = selectedUser;
      }
    }
  }

  Future<GroupModel?> createGroup(
      {required String name, required List<UserModel> selectedUsers}) async {
    try {
      List<String> uids = selectedUsers.map((e) => e.uid ?? '').toList();
      var groupId = const Uuid().v1();
      GroupModel group = GroupModel(
        senderId: getCurrentUserId(),
        name: name,
        groupId: groupId,
        lastMessage: '',
        membersUid: [getCurrentUserId(), ...uids],
        timeSent: DateTime.now(),
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
      return group;
    } catch (e) {
      return null;
    }
  }
}
