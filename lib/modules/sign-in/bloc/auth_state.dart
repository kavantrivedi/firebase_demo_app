import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthInitState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AuthSuccessState extends AuthState {
  final String? displayName;

  AuthSuccessState({this.displayName});

  @override
  // TODO: implement props
  List<Object?> get props => [displayName];
}

class AuthFailureState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
