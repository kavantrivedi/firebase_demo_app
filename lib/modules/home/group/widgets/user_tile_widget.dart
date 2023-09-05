import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user_model.dart';
import '../bloc/create_group_bloc.dart';

class UserTileWidget extends StatelessWidget {
  final UserModel userModel;
  const UserTileWidget({super.key, required this.userModel});

  void updateSelectedUsersList(BuildContext context) {
    if (userModel.isSelected ?? false) {
      context
          .read<CreateGroupBloc>()
          .add(UnSelectUserEvent(userModel: userModel));
    } else {
      context
          .read<CreateGroupBloc>()
          .add(SelectUserEvent(userModel: userModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.supervised_user_circle),
      title: Text(userModel.userName ?? ''),
      subtitle: Text(userModel.email ?? ''),
      trailing: Icon((userModel.isSelected ?? false)
          ? Icons.check_box_outlined
          : Icons.check_box_outline_blank),
      onTap: () => updateSelectedUsersList(context),
    );
  }
}
