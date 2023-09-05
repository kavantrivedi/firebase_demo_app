// ignore_for_file: use_build_context_synchronously

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/config/app_themes.dart';
import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_bloc.dart';
import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_event.dart';
import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_state.dart';
import 'package:firebasedemo/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../../../config/app_routes/app_routes.dart';
import '../../../config/app_routes/route_type.dart';
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
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
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
                          isSelected: i ==
                              (state.chatTabType == ChatTabType.messages
                                  ? 0
                                  : 1),
                          onTap: () => {
                            context.read<ChatListBloc>().add(
                                  ChatListTabChangedEvent(
                                    chatTabType: i == 0
                                        ? ChatTabType.messages
                                        : ChatTabType.groups,
                                  ),
                                )
                          },
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
                  body: ChatListViewBody(chatTabType: state.chatTabType),
                  bottomNavigationBar: !AppThemes.isColumnMode(context)
                      ? NavigationBar(
                          height: 64,
                          selectedIndex:
                              (state.chatTabType == ChatTabType.messages
                                  ? 0
                                  : 1),
                          onDestinationSelected: (i) {
                            context.read<ChatListBloc>().add(
                                  ChatListTabChangedEvent(
                                    chatTabType: i == 0
                                        ? ChatTabType.messages
                                        : ChatTabType.groups,
                                  ),
                                );
                          },
                          destinations: getNavigationDestinations(context),
                        )
                      : null,
                  floatingActionButton: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedSize(
                        duration: AppThemes.animationDuration,
                        curve: AppThemes.animationCurve,
                        clipBehavior: Clip.none,
                        child: FloatingActionButton.extended(
                          heroTag: 'logout',
                          key: const ValueKey('logout'),
                          onPressed: () => logoutAction(context),
                          icon: const Icon(Icons.logout),
                          label: Text(
                            StringManager.logout,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      StartChatFloatingActionButton(
                        chatTabType: state.chatTabType,
                        roomsIsEmpty: false,
                        scrolledToTop: ValueNotifier(true),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void logoutAction(BuildContext context) async {
    if (await showOkCancelAlertDialog(
          useRootNavigator: false,
          context: context,
          title: StringManager.areYouSureYouWantToLogout,
          isDestructiveAction: false,
          okLabel: StringManager.logout,
          cancelLabel: StringManager.cancel,
        ) ==
        OkCancelResult.cancel) {
      return;
    }
    await showFutureLoadingDialog(
      context: context,
      future: () => FirebaseAuth.instance.signOut().then((value) {
        AppRoutes.pushNamed(context, routeType: RouteType.splashScreen);
      }),
    );
  }
}
