import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/home/chat_details/chat_details_screen.dart';
import 'package:firebasedemo/modules/home/chat_list/chat_list.dart';
import 'package:firebasedemo/modules/auth/sign-up/sign_up_with_email.dart';
import 'package:firebasedemo/modules/home/group/create_group_screen.dart';
import 'package:firebasedemo/widgets/empty_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/auth/sign-in/sign_in_with_email.dart';
import '../../modules/home/new_chat/new_chat_screen.dart';
import '../../modules/splash/splash_screen.dart';
import '../../widgets/error_view.dart';
import '../../widgets/layouts/two_column_layout.dart';
import 'route_observer.dart';
import 'route_type.dart';

class AppRoutes {
  final bool columnMode;

  AppRoutes(this.columnMode);

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static pushNamed(BuildContext context,
      {required RouteType routeType,
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Map<String, String> pathParameters = const <String, String>{}}) {
    context.goNamed(
      routeType.name,
      queryParameters: queryParameters,
      pathParameters: pathParameters,
    );
  }

  static pushByUrl(BuildContext context,
      {required String url,
      Map<String, dynamic> queryParameters = const <String, dynamic>{},
      Map<String, String> pathParameters = const <String, String>{}}) {
    context.goNamed(
      url,
      queryParameters: queryParameters,
      pathParameters: pathParameters,
    );
  }

  static FadeTransition _fadeTransition(_, animation1, __, child) =>
      FadeTransition(opacity: animation1, child: child);

  // static Function(dynamic, dynamic, dynamic)? get _dynamicTransition =>
  //     columnMode ? _fadeTransition : null;

  GoRouter getRoutes(String? initialRoute) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: initialRoute ?? RouteType.splashScreen.url,
      debugLogDiagnostics: true,
      observers: [AppNavigatorObserver()],
      redirect: (context, state) {
        final userDetails = FirebaseAuth.instance.currentUser;
        if (userDetails == null &&
            state.matchedLocation != RouteType.register.url) {
          return RouteType.loginScreen.url;
        }
        return null;
      },
      routes: [
        ..._authRoutes,
        if (columnMode) ..._tabletRoutes,
        if (!columnMode) ..._mobileRoutes,
      ],
      errorBuilder: (context, state) => const ErrorView(),
    );
  }

  List<GoRoute> get _authRoutes => [
        GoRoute(
          name: RouteType.splashScreen.name,
          path: RouteType.splashScreen.url,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          name: RouteType.loginScreen.name,
          path: RouteType.loginScreen.url,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: SignInWithEmail(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
        GoRoute(
          name: RouteType.register.name,
          path: RouteType.register.url,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: SignUpWithEmail(),
            transitionsBuilder: _fadeTransition,
          ),
        ),
      ];

  List<GoRoute> get _mobileRoutes => [
        GoRoute(
          name: RouteType.roomsScreen.name,
          path: RouteType.roomsScreen.url,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: ChatListScreen(),
            transitionsBuilder: _fadeTransition,
          ),
          routes: [
            GoRoute(
              name: RouteType.newChatScreen.name,
              path: RouteType.newChatScreen.url,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const NewChatScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),
            GoRoute(
              name: RouteType.createGroupScreen.name,
              path: RouteType.createGroupScreen.url,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const CreateGroupScreen(),
                transitionsBuilder: _fadeTransition,
              ),
            ),
            GoRoute(
              name: RouteType.chatDetailsScreen.name,
              path: RouteType.chatDetailsScreen.url,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: ChatDetailsScreen(
                  uid: state.pathParameters['uid'] ?? '',
                  name: state.uri.queryParameters['name'] ?? '',
                  isGroupChat: state.uri.queryParameters['isGroupChat'] == "1",
                ),
                transitionsBuilder: _fadeTransition,
              ),
            ),
          ],
        ),
      ];

  List<RouteBase> get _tabletRoutes => [
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state, child) => CustomTransitionPage(
            key: state.pageKey,
            child: TwoColumnLayout(
              mainView: ChatListScreen(),
              sideView: child,
            ),
            transitionsBuilder: _fadeTransition,
          ),
          routes: [
            GoRoute(
                path: RouteType.roomsScreen.url,
                name: RouteType.roomsScreen.name,
                pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const EmptyView(),
                      transitionsBuilder: _fadeTransition,
                    ),
                routes: [
                  GoRoute(
                    name: RouteType.newChatScreen.name,
                    path: RouteType.newChatScreen.url,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const NewChatScreen(),
                      transitionsBuilder: _fadeTransition,
                    ),
                  ),
                  GoRoute(
                    name: RouteType.createGroupScreen.name,
                    path: RouteType.createGroupScreen.url,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: const CreateGroupScreen(),
                      transitionsBuilder: _fadeTransition,
                    ),
                  ),
                  GoRoute(
                    name: RouteType.chatDetailsScreen.name,
                    path: RouteType.chatDetailsScreen.url,
                    pageBuilder: (context, state) => CustomTransitionPage(
                      key: state.pageKey,
                      child: ChatDetailsScreen(
                        uid: state.pathParameters['uid'] ?? '',
                        name: state.uri.queryParameters['name'] ?? '',
                        isGroupChat:
                            state.uri.queryParameters['isGroupChat'] == "1",
                      ),
                      transitionsBuilder: _fadeTransition,
                    ),
                  ),
                  // VWidget(
                  //   path: '/newgroup',
                  //   widget: const NewGroup(),
                  //   buildTransition: _fadeTransition,
                  // ),
                  // VNester(
                  //   path: ':roomid',
                  //   widgetBuilder: (child) => SideViewLayout(
                  //     mainView: const ChatPage(),
                  //     sideView: child,
                  //   ),
                  //   buildTransition: _fadeTransition,
                  //   nestedRoutes: [
                  //     VWidget(
                  //       path: '',
                  //       widget: const ChatPage(),
                  //       buildTransition: _fadeTransition,
                  //     ),
                  //     VWidget(
                  //       path: 'details',
                  //       widget: const ChatDetails(),
                  //       buildTransition: _fadeTransition,
                  //       stackedRoutes: _chatDetailsRoutes,
                  //     ),
                  //   ],
                  // ),
                ]),
          ],
        )
      ];
}
