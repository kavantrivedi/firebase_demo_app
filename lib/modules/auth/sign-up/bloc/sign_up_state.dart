import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpInitState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object?> get props => [];
}

class SignUpSuccessState extends SignUpState {
  final String? displayName;

  SignUpSuccessState({this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class SignUpFailureState extends SignUpState {
  final String message;

  SignUpFailureState({required this.message});
  @override
  List<Object?> get props => [message];
}
