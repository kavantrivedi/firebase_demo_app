part of 'create_group_bloc.dart';

sealed class CreateGroupEvent extends Equatable {
  const CreateGroupEvent();

  @override
  List<Object> get props => [];
}

class FetchUsersListEvent extends CreateGroupEvent {
  const FetchUsersListEvent();
  @override
  List<Object> get props => [];
}

class SelectUserEvent extends CreateGroupEvent {
  final UserModel userModel;
  const SelectUserEvent({required this.userModel});
  @override
  List<Object> get props => [userModel];
}

class UnSelectUserEvent extends CreateGroupEvent {
  final UserModel userModel;
  const UnSelectUserEvent({required this.userModel});
  @override
  List<Object> get props => [userModel];
}

class ValidateAndCreateGroupEvent extends CreateGroupEvent {
  final String name;
  const ValidateAndCreateGroupEvent({required this.name});
  @override
  List<Object> get props => [name];
}
