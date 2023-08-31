import 'package:firebasedemo/config/app_themes.dart';
import 'package:firebasedemo/modules/home/chat_list/chat_list.dart';
import 'package:flutter/material.dart';
import 'chat_list_body.dart';
import 'navi_rail_item.dart';
import 'start_chat_fab.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  List<NavigationDestination> getNavigationDestinations(BuildContext context) {
    return [
      const NavigationDestination(
        icon: Icon(Icons.forum_outlined),
        selectedIcon: Icon(Icons.forum),
        label: 'Chats',
      ),
      const NavigationDestination(
        icon: Icon(Icons.group_outlined),
        selectedIcon: Icon(Icons.group),
        label: "Groups",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      builder: (_, __) {
        return Row(
          children: [
            if (AppThemes.isColumnMode(context) &&
                AppThemes.getDisplayNavigationRail(context)) ...[
              Builder(
                builder: (context) {
                  final destinations = getNavigationDestinations(context);

                  return SizedBox(
                    width: AppThemes.navRailWidth,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: destinations.length,
                      itemBuilder: (context, i) {
                        return NaviRailItem(
                          isSelected: i == 1,
                          onTap: () => {},
                          icon: destinations[i].icon,
                          selectedIcon: destinations[i].selectedIcon,
                          toolTip: destinations[i].label,
                        );
                      },
                    ),
                  );
                },
              ),
              Container(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ],
            Expanded(
              child: GestureDetector(
                onTap: FocusManager.instance.primaryFocus?.unfocus,
                excludeFromSemantics: true,
                behavior: HitTestBehavior.translucent,
                child: Scaffold(
                  body: const ChatListViewBody(),
                  bottomNavigationBar: !AppThemes.isColumnMode(context)
                      ? NavigationBar(
                          height: 64,
                          selectedIndex: 0,
                          onDestinationSelected: (index) {},
                          destinations: getNavigationDestinations(context),
                        )
                      : null,
                  floatingActionButton: StartChatFloatingActionButton(
                    activeFilter: ActiveFilter.messages,
                    roomsIsEmpty: false,
                    scrolledToTop: ValueNotifier(true),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
