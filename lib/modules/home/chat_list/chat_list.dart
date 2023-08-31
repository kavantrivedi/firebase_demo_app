import 'package:firebasedemo/config/app_themes.dart';
import 'package:flutter/material.dart';

import 'chat_list_view.dart';

enum SelectMode {
  normal,
  select,
}

enum PopupMenuAction {
  settings,
  invite,
  newGroup,
  newSpace,
  setStatus,
  archive,
}

enum ActiveFilter { groups, messages }

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  ChatListController createState() => ChatListController();
}

class ChatListController extends State<ChatListScreen>
    with TickerProviderStateMixin, RouteAware {
  bool get displayNavigationBar => !AppThemes.isColumnMode(context);

  String? activeSpaceId;

  int get selectedIndex {
    switch (activeFilter) {
      case ActiveFilter.messages:
        return 0;
      case ActiveFilter.groups:
        return 1;
    }
  }

  ActiveFilter getActiveFilterByDestination(int? i) {
    switch (i) {
      case 1:
        return ActiveFilter.groups;
      case 0:
      default:
        return ActiveFilter.messages;
    }
  }

  void onDestinationSelected(int? i) {
    setState(() {
      activeFilter = getActiveFilterByDestination(i);
    });
  }

  ActiveFilter activeFilter = ActiveFilter.messages;

  bool isTorBrowser = false;

  BoxConstraints? snappingSheetContainerSize;

  final ScrollController scrollController = ScrollController();
  final ValueNotifier<bool> scrolledToTop = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return const ChatListView();
  }
}

enum EditBundleAction { addToBundle, removeFromBundle }
