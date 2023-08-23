import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.userName,
    required this.lastUserMessage,
  });

  final String userName;
  final String lastUserMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const titleTextStyle = TextStyle(
      color: Colors.deepPurpleAccent,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    var subtitleTextStyle = TextStyle(
      color: Colors.deepPurpleAccent.withOpacity(0.8),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(userName, style: titleTextStyle),
          const SizedBox(
            height: 8,
          ),
          Text(
            lastUserMessage,
            style: subtitleTextStyle,
          ),
        ],
      ),
    );
  }
}
