import 'package:equatable/equatable.dart';

abstract class AuthFormState extends Equatable {
  const AuthFormState();
}

class InitialFormState extends AuthFormState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthFormEmailChanged extends AuthFormState {
  const AuthFormEmailChanged({
    required this.isValid,
  });

  final bool isValid;

  @override
  List<Object?> get props => [
        isValid,
      ];
}

class AuthFormPasswordChanged extends AuthFormState {
  const AuthFormPasswordChanged({
    required this.isValid,
  });

  final bool isValid;

  @override
  List<Object?> get props => [
        isValid,
      ];
}

class AuthFormNameChanged extends AuthFormState {
  const AuthFormNameChanged({
    required this.isValid,
  });

  final bool isValid;

  @override
  List<Object?> get props => [
        isValid,
      ];
}

class AuthFormValid extends AuthFormState {
  const AuthFormValid({
    required this.email,
    this.name,
    required this.password,
  });

  final String email;
  final String? name;
  final String password;

  @override
  List<Object?> get props => [
        email,
        name,
        password,
      ];
}

class AuthFormInValid extends AuthFormState {
  const AuthFormInValid({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// class AuthFormValidate extends FormState {
//   const AuthFormValidate({
//     required this.email,
//     this.name,
//     required this.password,
//     required this.isEmailValid,
//     required this.isPasswordValid,
//     required this.isNameValid,
//     required this.isInitial,
//     this.errorMsg,
//   });

//   final String email;
//   final String? name;
//   final String password;
//   final bool isEmailValid;
//   final bool isPasswordValid;
//   final bool isNameValid;
//   final String? errorMsg;
//   final bool isInitial;

//   AuthFormValidate copWith({
//     String? email,
//     String? password,
//     String? name,
//     bool? isEmailValid,
//     bool? isPasswordValid,
//     bool? isNameValid,
//     String? errorMsg,
//     bool? isInitial,
//     required AuthFormValidate existingState,
//   }) {
//     return AuthFormValidate(
//       email: email ?? existingState.email,
//       password: password ?? existingState.password,
//       isEmailValid: isEmailValid ?? existingState.isEmailValid,
//       isPasswordValid: isPasswordValid ?? existingState.isPasswordValid,
//       isNameValid: isNameValid ?? existingState.isNameValid,
//       name: name ?? existingState.name,
//       errorMsg: errorMsg ?? existingState.errorMsg,
//       isInitial: isInitial ?? existingState.isInitial,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         email,
//         name,
//         password,
//         isEmailValid,
//         isPasswordValid,
//         isNameValid,
//         errorMsg,
//         isInitial,
//       ];
// }
