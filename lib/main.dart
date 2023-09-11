import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedemo/config/app_themes.dart';
import 'package:firebasedemo/modules/auth_service.dart';
import 'package:firebasedemo/modules/auth/sign-in/bloc/sign_in_bloc.dart';
import 'package:firebasedemo/modules/auth/bloc/auth_form_bloc.dart';
import 'package:firebasedemo/modules/home/chat_list/bloc/chat_list_bloc.dart';
import 'package:firebasedemo/modules/home/group/bloc/create_group_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_observer.dart';
import 'config/app_config.dart';
import 'config/app_routes/app_routes.dart';
import 'firebase_options.dart';
import 'modules/auth/sign-up/bloc/sign_up_bloc.dart';
import 'modules/home/group/bloc/create_group_bloc.dart';
import 'utils/custom_scroll_behaviour.dart';

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
        create: (context) => SignUpBloc(AuthService()),
      ),
      BlocProvider(
        create: (context) => ChatListBloc(),
      ),
      BlocProvider(
        create: (context) => AuthFormBloc(),
      ),
      BlocProvider(
        create: (context) => CreateGroupBloc(CreateGroupRepo()),
      ),
    ],
    child: const SimformChatApp(),
  ));
}

class SimformChatApp extends StatefulWidget {
  const SimformChatApp({super.key});
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<SimformChatApp> createState() => _SimformChatAppState();
}

class _SimformChatAppState extends State<SimformChatApp> {
  bool? columnMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isColumnMode =
            AppThemes.isColumnModeByWidth(constraints.maxWidth);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isColumnMode != columnMode) {
            setState(() {
              columnMode = isColumnMode;
              SimformChatApp.rootNavigatorKey = GlobalKey<NavigatorState>();
            });
          }
        });

        return MaterialApp.router(
          key: SimformChatApp.rootNavigatorKey,
          debugShowCheckedModeBanner: false,
          title: AppConfig.applicationName,
          themeMode: ThemeMode.dark,
          theme: AppThemes.buildTheme(
            Brightness.light,
            AppConfig.primaryColorLight,
          ),
          darkTheme: AppThemes.buildTheme(
            Brightness.dark,
            AppConfig.primaryColor,
          ),
          scrollBehavior: CustomScrollBehavior(),
          routerConfig: AppRoutes(columnMode: isColumnMode).getRoutes(),
        );
      },
    );
  }
}
