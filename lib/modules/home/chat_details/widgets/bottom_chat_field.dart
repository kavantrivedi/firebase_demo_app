import 'package:firebasedemo/config/app_config.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:flutter/material.dart';

class BottomChatField extends StatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void sendTextMessage() async {
    FireStoreRepository().sendTextMessage(
      text: _messageController.text.trim(),
      recieverUserId: widget.recieverUserId,
      isGroupChat: widget.isGroupChat,
    );
    setState(() {
      _messageController.text = '';
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: _messageController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppConfig.chatBoxColor,
                    hintText: 'Type a message!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  right: 2,
                  left: 2,
                ),
                child: CircleAvatar(
                  backgroundColor: AppConfig.primaryColor,
                  radius: 25,
                  child: GestureDetector(
                    onTap: sendTextMessage,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
