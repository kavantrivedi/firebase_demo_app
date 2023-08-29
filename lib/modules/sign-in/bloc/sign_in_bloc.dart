import 'package:bloc/bloc.dart' show Bloc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/auth_service.dart';
import 'package:firebasedemo/modules/sign-in/bloc/auth_event.dart';
import 'package:firebasedemo/modules/sign-in/bloc/auth_state.dart';

import '../../../models/user_model.dart';

class SignInBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService = AuthService();

  SignInBloc(this.authService) : super(AuthInitState()) {
    on<AuthEvent>((event, emit) {
      if (event is AuthStartedEvent) {
        User? user = FirebaseAuth.instance.currentUser;
        var loggedInUser = UserModel();
        if (user?.uid != null) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .get()
              .then((value) {
            loggedInUser = UserModel.fromMap(value.data());
          });
          emit(AuthSuccessState(displayName: loggedInUser.userName));
        } else {
          emit(AuthFailureState());
        }
      }
    });
    on<AuthSuccessEvent>((event, emit){
      User? user = FirebaseAuth.instance.currentUser;
      var loggedInUser = UserModel();
      if (user?.uid != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get()
            .then((value) {
          loggedInUser = UserModel.fromMap(value.data());
        });
        emit(AuthSuccessState(displayName: loggedInUser.userName));
      }
    });
  }
}
