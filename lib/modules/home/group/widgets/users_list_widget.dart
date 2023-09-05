import 'package:firebasedemo/modules/home/group/widgets/user_tile_widget.dart';
import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';

class UsersListWidget extends StatelessWidget {
  const UsersListWidget({
    super.key,
    required this.userList,
  });

  final List<UserModel> userList;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => UserTileWidget(
          userModel: userList[i],
        ),
        childCount: userList.length,
      ),
    );
  }
}
