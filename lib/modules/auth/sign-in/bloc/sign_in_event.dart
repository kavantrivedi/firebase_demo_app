import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SignInStartedEvent extends SignInEvent {
  final String email;
  final String password;

  const SignInStartedEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
