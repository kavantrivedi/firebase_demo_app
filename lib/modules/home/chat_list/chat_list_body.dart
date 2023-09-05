import 'package:animations/animations.dart';
import 'package:firebasedemo/models/group_model.dart';
import 'package:firebasedemo/repository/fire_store_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config/app_routes/app_routes.dart';
import '../../../config/app_routes/route_type.dart';
import '../../../models/chat_contact_model.dart';
import 'bloc/chat_list_event.dart';
import 'chat_list_header.dart';
import 'chat_list_item.dart';

class ChatListViewBody extends StatelessWidget {
  final ChatTabType chatTabType;

  const ChatListViewBody({
    Key? key,
    required this.chatTabType,
  }) : super(key: key);

  void onChatClick(BuildContext context,
      {required ChatContactModel chatContactModel}) {
    AppRoutes.pushNamed(context,
        routeType: RouteType.chatDetailsScreen,
        pathParameters: {
          'uid': chatContactModel.contactId
        },
        queryParameters: {
          'name': chatContactModel.name,
          'isGroupChat': "0",
        });
  }

  void onGroupClick(BuildContext context, {required GroupModel groupModel}) {
    AppRoutes.pushNamed(context,
        routeType: RouteType.chatDetailsScreen,
        pathParameters: {
          'uid': groupModel.groupId
        },
        queryParameters: {
          'name': groupModel.name,
          'isGroupChat': "1",
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        );
      },
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            ChatListHeader(
              chatTabType: chatTabType,
            ),
            chatTabType == ChatTabType.messages
                ? _build1to1MessageStream()
                : _buildGroupMessagesStream(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupMessagesStream() {
    return StreamBuilder<List<GroupModel>>(
      stream: FireStoreRepository().getAllGroupStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(context);
        }

        if (snapshot.hasData) {
          if ((snapshot.data?.length ?? 0) == 0) {
            return _buildEmptyView(context);
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int i) {
                final groupModel = snapshot.data![i];
                return ChatListItem(
                  groupModel: groupModel,
                  key: Key('chat_list_item_${groupModel.groupId}'),
                  selected: false,
                  onTap: () => onGroupClick(context, groupModel: groupModel),
                );
              },
              childCount: snapshot.data?.length ?? 0,
            ),
          );
        }

        return _buildEmptyView(context);
      },
    );
  }

  Widget _build1to1MessageStream() {
    return StreamBuilder<List<ChatContactModel>>(
      stream: FireStoreRepository().getChatContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(context);
        }

        if (snapshot.hasData) {
          if ((snapshot.data?.length ?? 0) == 0) {
            return _buildEmptyView(context);
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int i) {
                final chatContactModel = snapshot.data![i];
                return ChatListItem(
                  chatContactModel: chatContactModel,
                  key: Key('chat_list_item_${chatContactModel.contactId}'),
                  selected: false,
                  onTap: () =>
                      onChatClick(context, chatContactModel: chatContactModel),
                );
              },
              childCount: snapshot.data?.length ?? 0,
            ),
          );
        }

        return _buildEmptyView(context);
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Icon(
              chatTabType == ChatTabType.messages
                  ? CupertinoIcons.chat_bubble_2
                  : CupertinoIcons.group,
              size: 128,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    const dummyChatCount = 4;
    final titleColor =
        Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(100);
    final subtitleColor =
        Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(50);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => Opacity(
          opacity: (dummyChatCount - i) / dummyChatCount,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: titleColor,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: titleColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(width: 36),
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: subtitleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
            subtitle: Container(
              decoration: BoxDecoration(
                color: subtitleColor,
                borderRadius: BorderRadius.circular(3),
              ),
              height: 12,
              margin: const EdgeInsets.only(right: 22),
            ),
          ),
        ),
        childCount: dummyChatCount,
      ),
    );
  }
}
