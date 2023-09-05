import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sign_in_state.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sign_in_bloc.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sing_in_event.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_bloc.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_event.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_state.dart';
import 'package:firebasedemo/widgets/layouts/auth_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/error_dialog.dart';

class SignInWithEmail extends StatelessWidget {
  SignInWithEmail({super.key});

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthFormBloc, AuthFormState>(listener: (context, state) {
          if (state is AuthFormValid) {
            context.read<SignInBloc>().add(
                  SignInStartedEvent(
                    email: state.email,
                    password: state.password,
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
        BlocListener<SignInBloc, SignInState>(listener: (context, state) {
          if (state is SignInSuccessState) {
            AppRoutes.pushNamed(context, routeType: RouteType.roomsScreen);
          }

          if (state is SignInFailureState) {
            ErrorDialog.show(context, errorMessage: state.message);
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
      child: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          const Text(
            'Welcome back!!',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          BlocBuilder<AuthFormBloc, AuthFormState>(builder: (ctx, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: emailTextController,
                    onChanged: (value) {
                      ctx.read<AuthFormBloc>().add(EmailChanged(value));
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorText:
                          (state is AuthFormEmailChanged && !state.isValid)
                              ? 'Please ensure the email entered is valid'
                              : null,
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 10.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      helperMaxLines: 2,
                      errorMaxLines: 2,
                      hintText: 'Password',
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => onSignInTapped(ctx, state: state),
                  child: const Text('Sign in'),
                ),
              ],
            );
          }),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              AppRoutes.pushNamed(context, routeType: RouteType.register);
            },
            child: const Text('Don\'t have an account? sign-up here'),
          )
        ],
      ),
    );
  }

  void onSignInTapped(BuildContext context, {required AuthFormState state}) {
    context.read<AuthFormBloc>().add(
          FormSubmitted(
            email: emailTextController.text.trim(),
            password: passwordTextController.text.trim(),
          ),
        );
  }
}
