import 'package:equatable/equatable.dart';

class AuthFormEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EmailChanged extends AuthFormEvent {
  final String email;
  EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends AuthFormEvent {
  final String password;
  PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class NameChanged extends AuthFormEvent {
  final String name;
  NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class FormSubmitted extends AuthFormEvent {
  final bool isSignUp;
  final String email;
  final String password;
  final String? name;

  FormSubmitted({
    this.isSignUp = false,
    required this.email,
    required this.password,
    this.name,
  });
  @override
  List<Object?> get props => [
        isSignUp,
        email,
        password,
        name,
      ];
}
