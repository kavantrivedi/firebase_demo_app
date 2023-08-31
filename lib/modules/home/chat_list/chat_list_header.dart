import 'package:firebasedemo/config/app_themes.dart';
import 'package:flutter/material.dart';

class ChatListHeader extends StatelessWidget implements PreferredSizeWidget {
  //final ChatListController controller;

  const ChatListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: AppThemes.isColumnMode(context),
      automaticallyImplyLeading: false,
      title: const Text(
        'Rooms',
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
