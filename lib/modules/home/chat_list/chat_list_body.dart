import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../widgets/avatar_widget.dart';
import 'chat_list_header.dart';

class ChatListViewBody extends StatelessWidget {
  const ChatListViewBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const dummyChatCount = 4;
    final titleColor =
        Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(100);
    final subtitleColor =
        Theme.of(context).textTheme.bodyLarge!.color!.withAlpha(50);

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
      child: StreamBuilder(
        // key: ValueKey(
        //   client.userID.toString() +
        //       controller.activeFilter.toString() +
        //       controller.activeSpaceId.toString(),
        // ),
        // stream: client.onSync.stream
        //     .where((s) => s.hasRoomUpdate)
        //     .rateLimit(const Duration(seconds: 1)),
        builder: (context, _) {
          return SafeArea(
            child: CustomScrollView(
              //   controller: controller.scrollController,
              slivers: [
                const ChatListHeader(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Icon(
                          CupertinoIcons.chat_bubble_2,
                          size: 128,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverList(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SearchItem extends StatelessWidget {
  final String title;
  final Uri? avatar;
  final void Function() onPressed;

  const _SearchItem({
    required this.title,
    this.avatar,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 84,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Avatar(
                mxContent: avatar,
                name: title,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
