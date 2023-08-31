import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'chat_list.dart';

class ClientChooserButton extends StatelessWidget {
  final ChatListController controller;

  const ClientChooserButton(this.controller, {Key? key}) : super(key: key);

  List<PopupMenuEntry<Object>> _bundleMenuItems(BuildContext context) {
    return <PopupMenuEntry<Object>>[
      const PopupMenuItem(
        value: SettingsAction.newGroup,
        child: Row(
          children: [
            Icon(Icons.group_add_outlined),
            SizedBox(width: 18),
            Text('createNewGroup'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: SettingsAction.settings,
        child: Row(
          children: [
            Icon(Icons.settings_outlined),
            SizedBox(width: 18),
            Text('settings'),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // int clientCount = 0;

    return Container();

    // FutureBuilder<Profile>(
    //   future: matrix.client.fetchOwnProfile(),
    //   builder: (context, snapshot) => Stack(
    //     alignment: Alignment.center,
    //     children: [
    //       ...List.generate(
    //         clientCount,
    //         (index) => KeyBoardShortcuts(
    //           keysToPress: _buildKeyboardShortcut(index + 1),
    //           helpLabel: '',
    //           onKeysPressed: () => _handleKeyboardShortcut(
    //             matrix,
    //             index,
    //             context,
    //           ),
    //           child: const SizedBox.shrink(),
    //         ),
    //       ),
    //       KeyBoardShortcuts(
    //         keysToPress: {
    //           LogicalKeyboardKey.controlLeft,
    //           LogicalKeyboardKey.tab
    //         },
    //         helpLabel: 'nextAccount',
    //         onKeysPressed: () => {},
    //         child: const SizedBox.shrink(),
    //       ),
    //       KeyBoardShortcuts(
    //         keysToPress: {
    //           LogicalKeyboardKey.controlLeft,
    //           LogicalKeyboardKey.shiftLeft,
    //           LogicalKeyboardKey.tab
    //         },
    //         helpLabel: 'previousAccount',
    //         onKeysPressed: () => {},
    //         child: const SizedBox.shrink(),
    //       ),
    //       PopupMenuButton<Object>(
    //         onSelected: (o) => {},
    //         itemBuilder: _bundleMenuItems,
    //         child: Material(
    //           color: Colors.transparent,
    //           borderRadius: BorderRadius.circular(99),
    //           child: Avatar(
    //             mxContent: snapshot.data?.avatarUrl,
    //             name: snapshot.data?.displayName,
    //             size: 28,
    //             fontSize: 12,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Set<LogicalKeyboardKey>? _buildKeyboardShortcut(int index) {
    if (index > 0 && index < 10) {
      return {
        LogicalKeyboardKey.altLeft,
        LogicalKeyboardKey(0x00000000030 + index)
      };
    } else {
      return null;
    }
  }
}

enum SettingsAction {
  addAccount,
  newStory,
  newGroup,
  newSpace,
  invite,
  settings,
  archive,
}
