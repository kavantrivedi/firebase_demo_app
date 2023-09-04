import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';

class NewChatUserListView extends StatelessWidget {
  const NewChatUserListView({
    super.key,
    required this.userList,
  });

  final List<UserModel> userList;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => ListTile(
          leading: const Icon(Icons.supervised_user_circle),
          title: Text(userList[i].userName ?? ''),
          subtitle: Text(userList[i].email ?? ''),
          trailing: const Icon(Icons.chevron_right_outlined),
          onTap: () {
            AppRoutes.pushNamed(context,
                routeType: RouteType.chatDetailsScreen,
                pathParameters: {
                  'uid': userList[i].uid ?? ''
                },
                queryParameters: {
                  'name': userList[i].userName ?? '',
                  'isGroupChat': "0",
                });
          },
        ),
        childCount: userList.length,
      ),
    );
  }
}
