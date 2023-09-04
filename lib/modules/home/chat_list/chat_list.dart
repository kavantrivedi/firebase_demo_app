import 'package:flutter/material.dart';
import 'chat_list_view.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> scrolledToTop = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return const ChatListView();
  }
}
