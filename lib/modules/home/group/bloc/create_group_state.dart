part of 'create_group_bloc.dart';

sealed class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

final class CreateGroupInitial extends CreateGroupState {
  const CreateGroupInitial();
}

final class LoadingState extends CreateGroupState {
  const LoadingState();
}

final class LoadedState extends CreateGroupState {
  const LoadedState({
    this.validationMessage = '',
    required this.usersList,
    this.isGroupCreationInProgress = false,
    this.groupModel,
  });
  final String validationMessage;
  final List<UserModel> usersList;
  final bool isGroupCreationInProgress;
  final GroupModel? groupModel;

  @override
  List<Object> get props => [
        validationMessage,
        usersList,
        isGroupCreationInProgress,
      ];
}

final class FailedState extends CreateGroupState {
  final String message;

  const FailedState(this.message);

  @override
  List<Object> get props => [message];
}
