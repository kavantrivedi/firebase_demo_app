import 'package:equatable/equatable.dart';

class FormEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();

}

class EmailChanged extends FormEvent {
  final String email;
  EmailChanged(this.email);
  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends FormEvent {
  final String password;
  PasswordChanged(this.password);
  @override
  List<Object?> get props => [password];
}

class AddressChanged extends FormEvent {
  final String address;
  AddressChanged(this.address);
  @override
  List<Object?> get props => [address];
}

class NameChanged extends FormEvent {
  final String name;
  NameChanged(this.name);
  @override
  List<Object?> get props => [name];
}

class FormSubmitted extends FormEvent {
  final bool isSignUp;
  final Function onSuccessCall;
  FormSubmitted(this.isSignUp, this.onSuccessCall);
  @override
  List<Object?> get props => [isSignUp,onSuccessCall];
}

class FormSubmittedSuccess extends FormEvent {

  FormSubmittedSuccess();
  @override
  List<Object?> get props => [];
}

