import 'package:firebasedemo/modules/sign-in/bloc/auth_event.dart';
import 'package:firebasedemo/modules/sign-in/bloc/sign_in_bloc.dart';
import 'package:firebasedemo/modules/sign-in/sign_in_with_email.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_event.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_state.dart';
import 'package:firebasedemo/routes/route_models/routes_contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/form_bloc.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({super.key});

  @override
  State<SignUpWithEmail> createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Text('Sign-Up'),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: const EmailTextField(),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: const _PasswordField(),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: const NameTextField()),
            const SizedBox(
              height: 20,
            ),
            const SignUpButton(),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                   RouteConstants.signInEmail
                  );
                },
                child: const Text('Already User, Sign-in here'))
          ],
        ),
      ),
    );
  }
}
class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              helperMaxLines: 2,
              hintText: 'Password',
              errorMaxLines: 2,
              errorText: !state.isPasswordValid
                  ? '''Password must be at least 8 characters and contain at least one letter and number'''
                  : null,
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(PasswordChanged(value));
            },
          ),
        );
      },
    );
  }
}

class NameTextField extends StatelessWidget {
  const NameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormValidate>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          helperMaxLines: 2,
          hintText: 'Name',
          errorMaxLines: 2,
          errorText: !state.isNameValid ? '''Name cannot be empty!''' : null,
        ),
        onChanged: (value){
          context.read<FormBloc>().add(NameChanged(value));
        },
      );
    });
  }
}

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormValidate>(
      builder: (context, state) {
        return TextFormField(
            onChanged: (value) {
              context.read<FormBloc>().add(EmailChanged(value));
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              errorText: !state.isEmailValid
                  ? 'Please ensure the email entered is valid'
                  : null,
              hintText: 'Email',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ));
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormValidate>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () => context.read<FormBloc>().add(FormSubmitted(true, () {
              context.read<SignInBloc>().add(AuthSuccessEvent());
            })),
        child: const Text(
          'Sign-up',
        ),
      );
    });
  }
}
