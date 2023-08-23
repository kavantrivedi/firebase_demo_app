import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable {
  const FormState();
}

class InitialFormState extends FormState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FormValidate extends FormState {
  const FormValidate({
    required this.email,
    this.displayName,
    this.address,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isFormValid,
    required this.isNameValid,
    required this.isFormValidateFailed,
    required this.isLoading,
    required this.errorMessage,
    required this.isFormSuccessful,
  });

  final String email;
  final String? displayName;
  final String password;
  final String? address;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  FormValidate copWith(
      {String? email,
      String? password,
      String? displayName,
      String? address,
      bool? isEmailValid,
      bool? isPasswordValid,
      bool? isFormValid,
      bool? isLoading,
      int? age,
      String? errorMessage,
      bool? isNameValid,
      bool? isAgeValid,
      bool? isFormValidateFailed,
      bool? isFormSuccessful}) {
    return FormValidate(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isFormValid: isFormValid ?? this.isFormValid,
      isNameValid: isNameValid ?? this.isNameValid,
      isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful,
      displayName: displayName ?? this.displayName,
      address: address ?? this.address,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        displayName,
        password,
        isEmailValid,
        isPasswordValid,
        isFormValid,
        isFormSuccessful,
        errorMessage,
        isLoading,
        isNameValid,
        isFormValidateFailed,
      ];
}
