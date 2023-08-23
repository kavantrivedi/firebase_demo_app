import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => throw UnimplementedError();

}

class AuthStartedEvent extends AuthEvent
{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthSuccessEvent extends AuthEvent {
  @override
  List<Object?> get props =>[];
}

class AuthFailureEvent extends AuthEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}