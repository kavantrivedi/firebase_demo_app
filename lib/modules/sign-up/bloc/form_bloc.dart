import 'package:firebasedemo/modules/sign-up/bloc/form_event.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../../auth_service.dart';

class FormBloc extends Bloc<FormEvent, FormValidate> {
  FormBloc()
      : super(const FormValidate(
            email: '',
            password: '',
            isEmailValid: true,
            isPasswordValid: true,
            isFormValid: true,
            isNameValid: true,
            isFormValidateFailed: false,
            isLoading: true,
            errorMessage: '',
            isFormSuccessful: false)) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<NameChanged>(_nameChanged);
    on<FormSubmitted>(_formSubmitted);
    on<FormSubmittedSuccess>(_formSubmittedSuccess);
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return true;
  }

  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }

  _emailChanged(EmailChanged event, Emitter<FormValidate> emit) {
    emit(state.copWith(
        isFormSuccessful: false,
        isFormValidateFailed: false,
        errorMessage: "",
        email: event.email,
        isEmailValid: _isEmailValid(event.email)));
  }

  _passwordChanged(PasswordChanged event, Emitter<FormValidate> emit) {
    emit(state.copWith(
        isFormSuccessful: false,
        isFormValidateFailed: false,
        errorMessage: "",
        password: event.password,
        isPasswordValid: _isPasswordValid(event.password)));
  }

  _nameChanged(NameChanged event, Emitter<FormValidate> emit) {
    emit(state.copWith(
        isFormSuccessful: false,
        isFormValidateFailed: false,
        errorMessage: "",
        displayName: event.name,
        isNameValid: _isNameValid(event.name)));
  }

  _formSubmitted(FormSubmitted event, Emitter<FormValidate> emit) async {
    if (state.isFormValid) {
      if (event.isSignUp) {
        emit(state.copWith(
            errorMessage: "",
            isFormValid: _isPasswordValid(state.password) &&
                _isEmailValid(state.email) &&
                _isNameValid(state.displayName),
            isLoading: true));

        final message = await AuthService().registration(
          email: state.email,
          password: state.password,
          userModel: UserModel(
            userAddress: state.address,
            userName: state.displayName,
          ),
        );
        if (message!.contains('Success')) {
          event.onSuccessCall.call();
        }else{
          emit(state.copWith(
              errorMessage: "Please enter valid Email and password",
              isFormValid: _isPasswordValid(state.password) &&
                  _isEmailValid(state.email),
              isLoading: true));
        }
      } else {
        final message = await AuthService()
            .login(email: state.email, password: state.password);
        if (message!.contains('Success')) {
          event.onSuccessCall.call();
        }else{
          emit(state.copWith(
              errorMessage: "Please enter valid Email and password",
              isFormValid: _isPasswordValid(state.password) &&
                  _isEmailValid(state.email) ,
              isLoading: true));

        }
        emit(
          state.copWith(
            isFormValid:
                _isEmailValid(state.email) && _isPasswordValid(state.password),
          ),
        );
      }
    } else {
      emit(state.copWith(
          isFormValid: false, isFormValidateFailed: true, isLoading: false));
    }
  }

  _formSubmittedSuccess(
      FormSubmittedSuccess event, Emitter<FormValidate> emit) {
    emit(state.copWith(isFormSuccessful: true));
  }
}
