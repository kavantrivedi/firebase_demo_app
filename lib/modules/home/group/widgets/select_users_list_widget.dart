import 'package:animations/animations.dart';
import 'package:firebasedemo/modules/home/group/bloc/create_group_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'users_list_widget.dart';

class SelectUsersListWidget extends StatelessWidget {
  const SelectUsersListWidget({Key? key}) : super(key: key);

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
            BlocBuilder<CreateGroupBloc, CreateGroupState>(
                builder: (ctx, state) {
              if ((state is LoadingState) || (state is CreateGroupInitial)) {
                return _buildLoadingList(context);
              }

              if (state is FailedState) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      state.message,
                    ),
                  ),
                );
              }

              if (state is LoadedState) {
                return UsersListWidget(
                  userList: state.usersList,
                );
              }

              return const SizedBox.shrink();
            }),
          ],
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
