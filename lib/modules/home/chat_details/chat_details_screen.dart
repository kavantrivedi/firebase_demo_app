import 'package:flutter/material.dart';

import 'widgets/bottom_chat_field.dart';
import 'widgets/chat_list.dart';

class ChatDetailsScreen extends StatelessWidget {
  final String name;
  final String uid;
  final bool isGroupChat;

  const ChatDetailsScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          BottomChatField(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
