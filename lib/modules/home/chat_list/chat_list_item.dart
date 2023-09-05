import 'package:firebasedemo/models/chat_contact_model.dart';
import 'package:firebasedemo/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_config.dart';
import '../../../config/app_themes.dart';
import '../../../widgets/avatar_widget.dart';

class ChatListItem extends StatelessWidget {
  final bool activeChat;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final ChatContactModel? chatContactModel;
  final GroupModel? groupModel;

  const ChatListItem({
    this.activeChat = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.chatContactModel,
    this.groupModel,
    Key? key,
  }) : super(key: key);

  void clickAction(BuildContext context) async {
    if (onTap != null) return onTap!();
    if (activeChat) return;
  }

  @override
  Widget build(BuildContext context) {
    const unreadBubbleSize = 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 1,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        clipBehavior: Clip.hardEdge,
        color: selected
            ? Theme.of(context).colorScheme.primaryContainer
            : activeChat
                ? Theme.of(context).colorScheme.secondaryContainer
                : Colors.transparent,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -0.5),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          onLongPress: onLongPress,
          leading: selected
              ? SizedBox(
                  width: Avatar.defaultSize,
                  height: Avatar.defaultSize,
                  child: Material(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Avatar.defaultSize),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                )
              : Avatar(
                  name: chatContactModel?.name ?? groupModel?.name ?? '',
                  onTap: onLongPress,
                ),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  chatContactModel?.name ?? groupModel?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  DateFormat.Hm().format(chatContactModel?.timeSent ??
                      groupModel?.timeSent ??
                      DateTime.now()),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Text(
                chatContactModel?.lastMessage ?? groupModel?.lastMessage ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                maxLines: 1,
                softWrap: false,
              )),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: AppThemes.animationDuration,
                curve: AppThemes.animationCurve,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                height: unreadBubbleSize,
                width: 9,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppConfig.borderRadius),
                ),
              ),
            ],
          ),
          onTap: () => clickAction(context),
        ),
      ),
    );
  }
}
