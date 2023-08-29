import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/models/chat_model.dart';
import 'package:firebasedemo/models/user_model.dart';
import 'package:flutter/cupertino.dart';

import '../models/chat_meta_model.dart';

class FireStoreRepository {
  static final FireStoreRepository _fireStoreRepository =
  FireStoreRepository._internal();

  factory FireStoreRepository() {
    return _fireStoreRepository;
  }

  Stream<List<UserModel>> fetchChatUser() {
    final querySnapShots =
    FirebaseFirestore.instance.collection('users').snapshots();
    return querySnapShots.map((document) {
      final data = document.docs;
      return data.map((e) {
        final user = e.data();
        return UserModel.fromMap(user);
      }).toList();
    });
  }

  initializeChat({required String userId, required String secondUserId}) async {
    Map<String, dynamic> secondUser = {
      'secondUserId': secondUserId,
    };
    Map<String, dynamic> currentUser = {
      'secondUserId': userId,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(secondUserId)
        .set(secondUser);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(secondUserId)
        .collection('chats')
        .doc(userId)
        .set(currentUser);
  }

  void sendMessage(
      {required ChatModel message, required String secondUserId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(message.idFrom)
        .collection('chats')
        .doc(secondUserId)
        .collection('messages')
        .add(message.toMap());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(secondUserId)
        .collection('chats')
        .doc(message.idFrom)
        .collection('messages')
        .add(message.toMap());
  }

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  ChatModel getChatModel(String selectedUserId) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return ChatModel(
      timestamp: Timestamp.fromDate(DateTime.now()),
      idFrom: currentUser?.uid ?? '',
    );
  }

  Stream<List<ChatModel>> getMessages(ChatModel chatModel,
      String secondUserId) {
    debugPrint('get messages called');

    final users = FirebaseFirestore.instance
        .collection('users')
        .doc(chatModel.idFrom)
        .collection('chats')
        .doc(secondUserId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();

    return users.map((document) {
      final data = document.docs;
      return data.map((e) {
        final user = e.data();
        debugPrint(' data from stream ${user.toString()}');
        return ChatModel.fromMap(user);
      }).toList();
    });

    /* Stream<QuerySnapshot> mergedStream = StreamGroup.merge(combinedList);*/

/*
    mergedStream.map((event) {
      final data = event.docs;
      data.map((doc) {
        Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
        debugPrint("Message added ${messageMap.toString()}");
      }).toList();
    });
*/

/*
    return mergedStream.map((event) {
      final data = event.docs;
      return data.map((doc) {
        Map<String, dynamic> messageMap = doc.data() as Map<String, dynamic>;
        debugPrint("Message added ${messageMap.toString()}");
        return ChatModel.fromMap(messageMap);
      }).toList();
    });
*/
  }

  FireStoreRepository._internal();
}
