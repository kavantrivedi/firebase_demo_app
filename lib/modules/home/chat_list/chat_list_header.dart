import 'package:firebasedemo/config/app_themes.dart';
import 'package:flutter/material.dart';

import 'bloc/chat_list_event.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatTabType chatTabType;

  const ChatListHeader({
    Key? key,
    required this.chatTabType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: AppThemes.isColumnMode(context),
      automaticallyImplyLeading: false,
      title: Text(
        chatTabType.name.toUpperCase(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
