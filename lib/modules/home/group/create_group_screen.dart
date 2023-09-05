import 'package:firebasedemo/config/app_config.dart';
import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:firebasedemo/modules/home/group/bloc/create_group_bloc.dart';
import 'package:firebasedemo/resources/string_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import '../../../widgets/error_dialog.dart';
import 'widgets/select_users_list_widget.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreateGroupBloc>().add(const FetchUsersListEvent());
    });
  }

  void createGroup() {
    context.read<CreateGroupBloc>().add(
          ValidateAndCreateGroupEvent(
            name: groupNameController.text.trim(),
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.createGroup),
      ),
      body: BlocListener<CreateGroupBloc, CreateGroupState>(
        listener: (context, state) {
          if (state is LoadedState) {
            if (state.validationMessage.isNotEmpty) {
              ErrorDialog.show(context, errorMessage: state.validationMessage);
            }

            if (state.isGroupCreationInProgress) {
              showFutureLoadingDialog(
                context: context,
                future: () => Future.value(state.isGroupCreationInProgress),
              );
            }

            if (state.groupModel != null) {
              AppRoutes.pushNamed(
                context,
                routeType: RouteType.chatDetailsScreen,
                pathParameters: {'uid': state.groupModel?.groupId ?? ''},
                queryParameters: {
                  'name': state.groupModel?.name,
                  'isGroupChat': "1",
                },
              );
            }
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: groupNameController,
                    decoration: InputDecoration(
                      hintText: StringManager.enterGroupName,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    StringManager.selectMinUsersTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Expanded(
                  child: SelectUsersListWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: AppConfig.tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
