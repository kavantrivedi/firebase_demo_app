import 'package:equatable/equatable.dart';

class SignInState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInInitState extends SignInState {
  @override
  List<Object?> get props => [];
}

class SignInSuccessState extends SignInState {
  final String? displayName;

  SignInSuccessState({this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class SignInFailureState extends SignInState {
  final String message;

  SignInFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
