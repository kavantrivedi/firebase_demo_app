import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:firebasedemo/config/app_themes.dart';
import 'package:flutter/material.dart';
import 'bloc/chat_list_event.dart';

class StartChatFloatingActionButton extends StatelessWidget {
  final ChatTabType chatTabType;
  final ValueNotifier<bool> scrolledToTop;
  final bool roomsIsEmpty;

  const StartChatFloatingActionButton({
    Key? key,
    required this.chatTabType,
    required this.scrolledToTop,
    required this.roomsIsEmpty,
  }) : super(key: key);

  void _onPressed(BuildContext context) {
    switch (chatTabType) {
      case ChatTabType.messages:
        AppRoutes.pushNamed(context, routeType: RouteType.newChatScreen);
        break;
      case ChatTabType.groups:
        AppRoutes.pushNamed(context, routeType: RouteType.createGroupScreen);
        break;
    }
  }

  IconData get icon {
    switch (chatTabType) {
      case ChatTabType.messages:
        return Icons.add_outlined;
      case ChatTabType.groups:
        return Icons.group_add_outlined;
    }
  }

  String getLabel(BuildContext context) {
    switch (chatTabType) {
      case ChatTabType.messages:
        return 'New Chat';
      case ChatTabType.groups:
        return 'New Group';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: scrolledToTop,
      builder: (context, scrolledToTop, _) => AnimatedSize(
        duration: AppThemes.animationDuration,
        curve: AppThemes.animationCurve,
        clipBehavior: Clip.none,
        child: scrolledToTop
            ? FloatingActionButton.extended(
                onPressed: () => _onPressed(context),
                icon: Icon(icon),
                label: Text(
                  getLabel(context),
                  overflow: TextOverflow.fade,
                ),
              )
            : FloatingActionButton(
                onPressed: () => _onPressed(context),
                child: Icon(icon),
              ),
      ),
    );
  }
}
