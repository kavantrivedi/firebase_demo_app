import 'package:animations/animations.dart';
import 'package:firebasedemo/modules/home/new_chat/new_chat_user_list_view.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../repository/fire_store_repository.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text(
          'Select Contact',
        ),
      ),
      body: PageTransitionSwitcher(
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
              StreamBuilder<List<UserModel>>(
                  stream: FireStoreRepository().fetchChatUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingList(context);
                    }

                    if (snapshot.hasData) {
                      if (snapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return NewChatUserListView(userList: snapshot.data!);
                    }
                    return const SizedBox.shrink();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
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
