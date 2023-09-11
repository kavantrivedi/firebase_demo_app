import 'package:firebasedemo/modules/auth/bloc/auth_form_event.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_state.dart';
import 'package:firebasedemo/widgets/layouts/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_routes/app_routes.dart';
import '../../../config/app_routes/route_type.dart';
import '../../../widgets/error_dialog.dart';
import '../bloc/auth_form_bloc.dart';
import 'bloc/sign_up_bloc.dart';
import 'bloc/sign_up_state.dart';
import 'bloc/sing_up_event.dart';

class SignUpWithEmail extends StatelessWidget {
  SignUpWithEmail({super.key});

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController nameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthFormBloc, AuthFormState>(listener: (context, state) {
          if (state is AuthFormValid) {
            context.read<SignUpBloc>().add(
                  SignUpStartedEvent(
                    email: state.email,
                    password: state.password,
                    name: state.name ?? '',
                  ),
                );
          }

          if (state is AuthFormInValid) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.message,
              ),
            );
          }
        }),
        BlocListener<SignUpBloc, SignUpState>(listener: (context, state) {
          if (state is SignUpSuccessState) {
            AppRoutes.pushNamed(context, routeType: RouteType.roomsScreen);
          }

          if (state is SignUpFailureState) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.message,
              ),
            );
          }
        }),
      ],
      child: AuthLayout(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: BlocBuilder<AuthFormBloc, AuthFormState>(builder: (ctx, state) {
        return Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Text(
              'Create an account!!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: emailTextController,
                onChanged: (value) {
                  ctx.read<AuthFormBloc>().add(EmailChanged(value));
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: (state is AuthFormEmailChanged && !state.isValid)
                      ? 'Please ensure the email entered is valid'
                      : null,
                  hintText: 'Email',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: passwordTextController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  helperMaxLines: 2,
                  hintText: 'Password',
                  errorMaxLines: 2,
                  errorText: (state is AuthFormPasswordChanged &&
                          !state.isValid)
                      ? '''Password must be at least 8 characters and contain at least one letter and number'''
                      : null,
                ),
                onChanged: (value) {
                  ctx.read<AuthFormBloc>().add(PasswordChanged(value));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: nameTextController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  helperMaxLines: 2,
                  hintText: 'Name',
                  errorMaxLines: 2,
                  errorText: (state is AuthFormNameChanged && !state.isValid)
                      ? '''Name cannot be empty!'''
                      : null,
                ),
                onChanged: (value) {
                  ctx.read<AuthFormBloc>().add(NameChanged(value));
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, signInState) => signInState
                      is SignUpLoadingState
                  ? const LinearProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        ctx.read<AuthFormBloc>().add(
                              FormSubmitted(
                                isSignUp: true,
                                email: emailTextController.text.trim(),
                                password: passwordTextController.text.trim(),
                                name: nameTextController.text.trim(),
                              ),
                            );
                      },
                      child: const Text('Sign Up'),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                AppRoutes.pushNamed(context, routeType: RouteType.loginScreen);
              },
              child: const Text('Already have an account? sign-in here'),
            )
          ],
        );
      }),
    );
  }
}
