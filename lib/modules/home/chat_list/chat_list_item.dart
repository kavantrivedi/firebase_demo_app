import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../config/app_themes.dart';
import '../../../widgets/avatar_widget.dart';

enum ArchivedRoomAction { delete, rejoin }

class ChatListItem extends StatelessWidget {
  //final Room room;
  final bool activeChat;
  final bool selected;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const ChatListItem({
    this.activeChat = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    Key? key,
  }) : super(key: key);

  void clickAction(BuildContext context) async {
    if (onTap != null) return onTap!();
    if (activeChat) return;
  }

  @override
  Widget build(BuildContext context) {
    const unreadBubbleSize = 0.0;
    const displayname = "Abc";
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
                  name: displayname,
                  onTap: onLongPress,
                ),
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  displayname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  'time create', // room.timeCreated.localizedTimeShort(context),
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
              // if (typingText.isEmpty &&
              //     ownMessage &&
              //     room.lastEvent!.status.isSending) ...[
              //   const SizedBox(
              //     width: 16,
              //     height: 16,
              //     child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              //   ),
              //   const SizedBox(width: 4),
              // ],
              AnimatedContainer(
                width: 18,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                duration: AppThemes.animationDuration,
                curve: AppThemes.animationCurve,
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.edit_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 14,
                ),
              ),
              Expanded(
                  child: Text(
                "typingText",
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
