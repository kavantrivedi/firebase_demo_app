// import 'package:bloc/bloc.dart' show Bloc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/auth_service.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sing_in_event.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user_model.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  AuthService authService = AuthService();

  SignInBloc(this.authService) : super(SignInInitState()) {
    on<SignInStartedEvent>(_onSignInStartedEvent);
  }

  void _onSignInStartedEvent(event, emit) async {
    final String? message =
        await authService.login(email: event.email, password: event.password);

    if (message?.contains("Success") ?? false) {
      User? user = FirebaseAuth.instance.currentUser;
      var loggedInUser = UserModel();
      if (user?.uid != null) {
        final value = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        loggedInUser = UserModel.fromMap(value.data());
        emit(SignInSuccessState(displayName: loggedInUser.userName));
      } else {
        emit(SignInFailureState(message: 'User doesn\'t exist'));
      }
    } else {
      emit(SignInFailureState(message: message ?? ''));
    }
  }
}
