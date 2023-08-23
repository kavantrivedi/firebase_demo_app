import 'package:firebasedemo/modules/home/home.dart';
import 'package:firebasedemo/modules/sign-in/bloc/auth_event.dart';
import 'package:firebasedemo/modules/sign-in/bloc/auth_state.dart';
import 'package:firebasedemo/modules/sign-in/bloc/sign_in_bloc.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_bloc.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_event.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_state.dart';
import 'package:firebasedemo/modules/sign-up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_service.dart';

class SignInWithEmail extends StatelessWidget {
  SignInWithEmail({super.key});

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormValidate>(listener: (context, state) {
          if (state.errorMessage.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                errorMessage: state.errorMessage,
              ),
            );
          } else if (state.isFormValid) {
            context.read<SignInBloc>().add(AuthStartedEvent());
          } else if (state.isFormValidateFailed) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Please fill the data correctly!')));
          }
        }),
        BlocListener<SignInBloc, AuthState>(listener: (context, state) {
          if (state is AuthSuccessState) {
            debugPrint('Navigate to Home screen');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }),
      ],
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraint) {
          final size = MediaQuery.of(context).size;
          if (constraint.maxWidth < 600) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  const Text('Sign-in'),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<FormBloc, FormValidate>(
                      builder: (context, state) {
                    final size = MediaQuery.of(context).size;
                    return Column(
                      children: [
                        SizedBox(
                          width: size.width * 0.5,
                          child: TextFormField(
                            onChanged: (value) {
                              context.read<FormBloc>().add(EmailChanged(value));
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              errorText: !state.isEmailValid
                                  ? 'Please ensure the email entered is valid'
                                  : null,
                              hintText: 'Email',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.5,
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              helperMaxLines: 2,
                              errorMaxLines: 2,
                              hintText: 'Password',
                              errorText: !state.isPasswordValid
                                  ? '''Password must be at least 8 characters and contain at least one letter and number'''
                                  : null,
                            ),
                            onChanged: (value) {
                              context
                                  .read<FormBloc>()
                                  .add(PasswordChanged(value));
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (state.isFormValid) {
                              context
                                  .read<FormBloc>()
                                  .add(FormSubmitted(false, () {
                                    context
                                        .read<SignInBloc>()
                                        .add(AuthSuccessEvent());
                                  }));
                            }
                          },
                          child: const Text(
                            'Sign in',
                          ),
                        ),
                      ],
                    );
                  }),

                  /*SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      controller: emailTextController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextFormField(
                      controller: passwordTextController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),*/
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpWithEmail(),
                          ),
                        );
                      },
                      child: const Text('Not register,Sign-up here'))
                ],
              ),
            );
          } else {
            return Row(
              children: [
                SizedBox(
                  height: constraint.maxHeight,
                  width: size.width * 0.5,
                  child: Image.asset(
                      '/Users/kavan/StudioProjects/firebasedemo/images/signinscreen.jpeg',
                      fit: BoxFit.fitHeight),
                ),
                SizedBox(width: size.width * 0.15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 45,
                    ),
                    const Text('Sign-in'),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<FormBloc, FormValidate>(
                        builder: (context, state) {
                      return Column(
                        children: [
                          SizedBox(
                            width: 220,
                            child: TextFormField(
                              onChanged: (value) {
                                context
                                    .read<FormBloc>()
                                    .add(EmailChanged(value));
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                errorText: !state.isEmailValid
                                    ? 'Please ensure the email entered is valid'
                                    : null,
                                hintText: 'Email',
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 10.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 220,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                hintText: 'Password',
                                errorText: !state.isPasswordValid
                                    ? '''Password must be at least 8 characters and contain at least one letter and number'''
                                    : null,
                              ),
                              onChanged: (value) {
                                context
                                    .read<FormBloc>()
                                    .add(PasswordChanged(value));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (state.isFormValid) {
                                context
                                    .read<FormBloc>()
                                    .add(FormSubmitted(false, () {
                                      context
                                          .read<SignInBloc>()
                                          .add(AuthSuccessEvent());
                                    }));
                              }
                            },
                            child: const Text(
                              'Sign in',
                            ),
                          ),
                          const SizedBox(height: 100,)
                        ],
                      );
                    }),

                    /*SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        controller: emailTextController,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        controller: passwordTextController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpWithEmail(),
                            ),
                          );
                        },
                        child: const Text('Not register,Sign-up here'))
                  ],
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  void onSignIn(BuildContext context) async {
    final message = await AuthService().login(
      email: emailTextController.text,
      password: passwordTextController.text,
    );
    if (message!.contains('Success')) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }
}

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;

  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
