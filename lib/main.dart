import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/modules/auth_service.dart';
import 'package:firebasedemo/modules/sign-in/bloc/auth_state.dart';
import 'package:firebasedemo/modules/sign-in/bloc/sign_in_bloc.dart';
import 'package:firebasedemo/modules/sign-in/sign_in_with_email.dart';
import 'package:firebasedemo/modules/sign-up/bloc/form_bloc.dart';
import 'package:firebasedemo/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'firebase_options.dart';
import 'modules/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => SignInBloc(AuthService()),
      ),
      BlocProvider(
        create: (context) => FormBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        splashColor: Colors.deepPurpleAccent.shade100.withOpacity(0.3),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (routesSettings) =>
          Routes.onGenerateRoute(routesSettings, const NavigateApp()),
      home: const NavigateApp(),
    );
  }
}

class NavigateApp extends StatelessWidget {
  const NavigateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isCurrentUserloggedIn = FirebaseAuth.instance.currentUser;
    return BlocBuilder<SignInBloc, AuthState>(builder: (context, state) {
      if (isCurrentUserloggedIn != null) {
        context.read<SignInBloc>().emit(AuthSuccessState());
        return const HomeScreen();
      }
      if (state is AuthSuccessState) {
        return const HomeScreen();
      } else {
        return SignInWithEmail();
      }
    });
  }
}
