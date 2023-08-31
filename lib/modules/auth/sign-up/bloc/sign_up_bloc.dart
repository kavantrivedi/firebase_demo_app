// import 'package:bloc/bloc.dart' show Bloc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/auth/sign-up/bloc/sign_up_state.dart';
import 'package:firebasedemo/modules/auth/sign-up/bloc/sing_up_event.dart';
import 'package:firebasedemo/modules/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user_model.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  AuthService authService = AuthService();

  SignUpBloc(this.authService) : super(SignUpInitState()) {
    on<SignUpStartedEvent>(_onSignUpStartedEvent);
  }

  void _onSignUpStartedEvent(event, emit) async {
    final userModel = UserModel(userName: event.name);
    final String? message = await authService.registration(
      email: event.email,
      password: event.password,
      userModel: userModel,
    );

    if (message?.contains("Success") ?? false) {
      User? user = FirebaseAuth.instance.currentUser;
      var loggedInUser = UserModel();
      if (user?.uid != null) {
        final value = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        loggedInUser = UserModel.fromMap(value.data());
        emit(SignUpSuccessState(displayName: loggedInUser.userName));
      } else {
        emit(SignUpFailureState(message: 'User doesn\'t exist'));
      }
    } else {
      emit(SignUpFailureState(message: message ?? ''));
    }
  }
}
