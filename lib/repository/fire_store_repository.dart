import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/models/chat_model.dart';
import 'package:firebasedemo/models/message_model.dart';
import 'package:firebasedemo/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../models/chat_contact_model.dart';

class FireStoreRepository {
  static final FireStoreRepository _fireStoreRepository =
      FireStoreRepository._internal();

  final firestore = FirebaseFirestore.instance;

  factory FireStoreRepository() {
    return _fireStoreRepository;
  }

  String? getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Stream<List<UserModel>> fetchChatUser() {
    final querySnapShots = firestore
        .collection('users')
        .where('uid', isNotEqualTo: getCurrentUserId())
        .snapshots();
    return querySnapShots.map((document) {
      final data = document.docs;
      return data.map((e) {
        final user = e.data();
        return UserModel.fromMap(user);
      }).toList();
    });
  }

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(getCurrentUserId()).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<List<ChatContactModel>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(getCurrentUserId())
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContactModel.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContactModel(
            name: user.userName ?? '',
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(getCurrentUserId())
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  Stream<List<MessageModel>> getGroupChatStream(String groudId) {
    return firestore
        .collection('groups')
        .doc(groudId)
        .collection('chats')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }
      return messages;
    });
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(getCurrentUserId())
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(getCurrentUserId())
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void sendTextMessage({
    required String text,
    required String recieverUserId,
    required bool isGroupChat,
  }) async {
    final senderUser = await getCurrentUserData();
    try {
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      var messageId = const Uuid().v1();

      _saveDataToContactsSubcollection(
        senderUser!,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
        isGroupChat,
      );

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.userName ?? '',
        recieverUserName: recieverUserData?.userName,
        senderUsername: senderUser.userName ?? '',
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel? recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
    bool isGroupChat,
  ) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      // users -> reciever user id => chats -> current user id -> set data
      var recieverChatContact = ChatContactModel(
        name: senderUserData.userName ?? '',
        contactId: senderUserData.uid ?? '',
        timeSent: timeSent,
        lastMessage: text,
      );
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(getCurrentUserId())
          .set(
            recieverChatContact.toMap(),
          );
      // users -> current user id  => chats -> reciever user id -> set data
      var senderChatContact = ChatContactModel(
        name: recieverUserData?.userName ?? '',
        contactId: recieverUserData?.uid ?? '',
        timeSent: timeSent,
        lastMessage: text,
      );

      await firestore
          .collection('users')
          .doc(getCurrentUserId())
          .collection('chats')
          .doc(recieverUserId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required String senderUsername,
    required String? recieverUserName,
    required bool isGroupChat,
  }) async {
    final message = MessageModel(
      senderId: getCurrentUserId() ?? '',
      recieverid: recieverUserId,
      text: text,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    if (isGroupChat) {
      // groups -> group id -> chat -> message
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> sender id -> reciever id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(getCurrentUserId())
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
      // users -> eciever id  -> sender id -> messages -> message id -> store message
      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(getCurrentUserId())
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
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

  ChatModel getChatModel(String selectedUserId) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return ChatModel(
      timestamp: Timestamp.fromDate(DateTime.now()),
      idFrom: currentUser?.uid ?? '',
    );
  }

  Stream<List<ChatModel>> getMessages(
      ChatModel chatModel, String secondUserId) {
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
