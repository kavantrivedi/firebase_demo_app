import 'package:firebasedemo/modules/auth/bloc/auth_form_event.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_state.dart';
import 'package:firebasedemo/resources/string_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFormBloc extends Bloc<AuthFormEvent, AuthFormState> {
  AuthFormBloc()
      : super(
          const AuthFormValid(
            email: '',
            password: '',
            name: '',
          ),
        ) {
    on<EmailChanged>(_emailChanged);
    on<PasswordChanged>(_passwordChanged);
    on<NameChanged>(_nameChanged);
    on<FormSubmitted>(_formSubmitted);
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return password.trim().length >= 6;
  }

  bool _isNameValid(String? displayName) {
    return (displayName?.trim().length ?? 0) >= 3;
  }

  void _emailChanged(EmailChanged event, Emitter<AuthFormState> emit) {
    emit(
      AuthFormEmailChanged(
        isValid: _isEmailValid(event.email),
      ),
    );
  }

  void _passwordChanged(PasswordChanged event, Emitter<AuthFormState> emit) {
    emit(
      AuthFormPasswordChanged(
        isValid: _isPasswordValid(event.password),
      ),
    );
  }

  void _nameChanged(NameChanged event, Emitter<AuthFormState> emit) {
    emit(
      AuthFormNameChanged(
        isValid: _isNameValid(event.name),
      ),
    );
  }

  void _formSubmitted(FormSubmitted event, Emitter<AuthFormState> emit) async {
    if (event.isSignUp) {
      _signUpformSubmitted(event, emit);
    } else {
      _signInformSubmitted(event, emit);
    }
  }

  void _signInformSubmitted(
      FormSubmitted event, Emitter<AuthFormState> emit) async {
    final isValidEmail = _isEmailValid(event.email);
    final isValidPassword = _isPasswordValid(event.password);

    if (isValidEmail && isValidPassword) {
      emit(AuthFormValid(email: event.email, password: event.password));
    } else {
      emit(AuthFormInValid(
        message: StringManager.fillDetailsCorrectly,
      ));
    }
  }

  void _signUpformSubmitted(
      FormSubmitted event, Emitter<AuthFormState> emit) async {
    final isValidEmail = _isEmailValid(event.email);
    final isValidPassword = _isPasswordValid(event.password);
    final isValidName = _isNameValid(event.name);

    if (isValidEmail && isValidPassword && isValidName) {
      emit(AuthFormValid(
        email: event.email,
        password: event.password,
        name: event.name,
      ));
    } else {
      emit(AuthFormInValid(
        message: StringManager.fillDetailsCorrectly,
      ));
    }
  }
}
