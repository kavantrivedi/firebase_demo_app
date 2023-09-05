import 'package:equatable/equatable.dart';
import 'package:firebasedemo/models/group_model.dart';
import 'package:firebasedemo/models/user_model.dart';
import 'package:firebasedemo/resources/string_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_group_repo.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  final CreateGroupRepo createGroupRepo;

  CreateGroupBloc(this.createGroupRepo) : super(const CreateGroupInitial()) {
    on<FetchUsersListEvent>(_onFetchUsersListEvent);
    on<SelectUserEvent>(_onSelectUserEvent);
    on<UnSelectUserEvent>(_onUnSelectUserEvent);
    on<ValidateAndCreateGroupEvent>(_onValidateAndCreateGroupEvent);
  }

  _onValidateAndCreateGroupEvent(
    ValidateAndCreateGroupEvent event,
    emit,
  ) async {
    if (event.name.length < 3) {
      emit(
        LoadedState(
          usersList: createGroupRepo.usersList ?? [],
          validationMessage: StringManager.groupNameValidationMessage,
        ),
      );
      return;
    }

    final selectedUsers = createGroupRepo.usersList
        ?.where((element) => element.isSelected ?? false)
        .toList();
    if ((selectedUsers?.length ?? 0) < 2) {
      emit(
        LoadedState(
          usersList: createGroupRepo.usersList ?? [],
          validationMessage:
              StringManager.groupSelectedUsersListValidationMessage,
        ),
      );
      return;
    }

    emit(
      LoadedState(
        usersList: createGroupRepo.usersList ?? [],
        isGroupCreationInProgress: true,
      ),
    );
    final group = await createGroupRepo.createGroup(
        name: event.name, selectedUsers: selectedUsers ?? []);

    if (group != null) {
      emit(
        LoadedState(
          usersList: createGroupRepo.usersList ?? [],
          isGroupCreationInProgress: false,
          groupModel: group,
        ),
      );
    } else {
      emit(
        LoadedState(
          usersList: createGroupRepo.usersList ?? [],
          isGroupCreationInProgress: false,
          validationMessage: 'Error while creating group.',
        ),
      );
    }
  }

  _onFetchUsersListEvent(FetchUsersListEvent event, emit) async {
    emit(const LoadingState());
    final message = await createGroupRepo.fetchUsersList();
    if (message?.isEmpty ?? true) {
      emit(LoadedState(usersList: createGroupRepo.usersList ?? []));
    } else {
      emit(FailedState(message ?? ''));
    }
  }

  _onSelectUserEvent(SelectUserEvent event, emit) {
    createGroupRepo.updateUser(event.userModel, isForSelect: true);
    emit(LoadedState(usersList: createGroupRepo.usersList ?? []));
  }

  _onUnSelectUserEvent(UnSelectUserEvent event, emit) {
    createGroupRepo.updateUser(event.userModel, isForSelect: false);
    emit(LoadedState(usersList: createGroupRepo.usersList ?? []));
  }
}
