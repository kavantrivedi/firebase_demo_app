import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../../../../repository/fire_store_repository.dart';
import 'my_message_card.dart';
import 'sender_message_card.dart';

class ChatList extends StatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
        stream: widget.isGroupChat
            ? FireStoreRepository().getGroupChatStream(widget.recieverUserId)
            : FireStoreRepository().getChatStream(widget.recieverUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen &&
                  messageData.recieverid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                FireStoreRepository().setChatMessageSeen(
                  context,
                  widget.recieverUserId,
                  messageData.messageId,
                );
              }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  isSeen: messageData.isSeen,
                );
              }
              return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
              );
            },
          );
        });
  }
}
