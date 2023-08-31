import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/modules/home/home_screen.dart';
import 'package:firebasedemo/modules/auth/sign-up/sign_up_with_email.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../modules/auth/sign-in/sign_in_with_email.dart';
import '../../modules/splash/splash_screen.dart';
import '../../widgets/error_view.dart';
import 'route_observer.dart';
import 'route_type.dart';

class AppRoutes {
  final bool columnMode;

  AppRoutes(this.columnMode);

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
        ..._mobileRoutes,
        //  if (columnMode) ..._tabletRoutes,
        // if (!columnMode) ..._mobileRoutes,
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
            child: const HomeScreen(),
            transitionsBuilder: _fadeTransition,
          ),
          //  builder: (context, state) => const HomeScreen(),
        ),

        // stackedRoutes: [
        //   VWidget(
        //     path: '/spaces/:roomid',
        //     widget: const ChatDetails(),
        //     stackedRoutes: _chatDetailsRoutes,
        //   ),
        //   VWidget(
        //     path: ':roomid',
        //     widget: const ChatPage(),
        //     stackedRoutes: [
        //       VWidget(
        //         path: 'details',
        //         widget: const ChatDetails(),
        //         stackedRoutes: _chatDetailsRoutes,
        //       ),
        //     ],
        //   ),

        //   // VWidget(
        //   //   path: '/newgroup',
        //   //   widget: const NewGroup(),
        //   // ),
        // ],
      ];

  // List<VRouteElement> get _tabletRoutes => [
  //       VNester(
  //         path: '/rooms',
  //         widgetBuilder: (child) => TwoColumnLayout(
  //           mainView: const ChatList(),
  //           sideView: child,
  //         ),
  //         buildTransition: _fadeTransition,
  //         nestedRoutes: [
  //           VWidget(
  //             path: '',
  //             widget: const EmptyPage(),
  //             buildTransition: _fadeTransition,
  //             stackedRoutes: [
  //               VWidget(
  //                 path: '/stories/create',
  //                 buildTransition: _fadeTransition,
  //                 widget: const AddStoryPage(),
  //               ),
  //               VWidget(
  //                 path: '/stories/:roomid',
  //                 buildTransition: _fadeTransition,
  //                 widget: const StoryPage(),
  //                 stackedRoutes: [
  //                   VWidget(
  //                     path: 'share',
  //                     widget: const AddStoryPage(),
  //                   ),
  //                 ],
  //               ),
  //               VWidget(
  //                 path: '/spaces/:roomid',
  //                 widget: const ChatDetails(),
  //                 buildTransition: _fadeTransition,
  //                 stackedRoutes: _chatDetailsRoutes,
  //               ),
  //               VWidget(
  //                 path: '/newprivatechat',
  //                 widget: const NewPrivateChat(),
  //                 buildTransition: _fadeTransition,
  //               ),
  //               VWidget(
  //                 path: '/newgroup',
  //                 widget: const NewGroup(),
  //                 buildTransition: _fadeTransition,
  //               ),
  //               VWidget(
  //                 path: '/newspace',
  //                 widget: const NewSpace(),
  //                 buildTransition: _fadeTransition,
  //               ),
  //               VNester(
  //                 path: ':roomid',
  //                 widgetBuilder: (child) => SideViewLayout(
  //                   mainView: const ChatPage(),
  //                   sideView: child,
  //                 ),
  //                 buildTransition: _fadeTransition,
  //                 nestedRoutes: [
  //                   VWidget(
  //                     path: '',
  //                     widget: const ChatPage(),
  //                     buildTransition: _fadeTransition,
  //                   ),
  //                   VWidget(
  //                     path: 'encryption',
  //                     widget: const ChatEncryptionSettings(),
  //                     buildTransition: _fadeTransition,
  //                   ),
  //                   VWidget(
  //                     path: 'details',
  //                     widget: const ChatDetails(),
  //                     buildTransition: _fadeTransition,
  //                     stackedRoutes: _chatDetailsRoutes,
  //                   ),
  //                   VWidget(
  //                     path: 'invite',
  //                     widget: const InvitationSelection(),
  //                     buildTransition: _fadeTransition,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //       VWidget(
  //         path: '/rooms',
  //         widget: const TwoColumnLayout(
  //           mainView: ChatList(),
  //           sideView: EmptyPage(),
  //         ),
  //         buildTransition: _fadeTransition,
  //         stackedRoutes: [
  //           VNester(
  //             path: '/settings',
  //             widgetBuilder: (child) => TwoColumnLayout(
  //               mainView: const Settings(),
  //               sideView: child,
  //             ),
  //             buildTransition: _dynamicTransition,
  //             nestedRoutes: [
  //               VWidget(
  //                 path: '',
  //                 widget: const EmptyPage(),
  //                 buildTransition: _dynamicTransition,
  //                 stackedRoutes: _settingsRoutes,
  //               ),
  //             ],
  //           ),
  //           VNester(
  //             path: '/archive',
  //             widgetBuilder: (child) => TwoColumnLayout(
  //               mainView: const Archive(),
  //               sideView: child,
  //             ),
  //             buildTransition: _fadeTransition,
  //             nestedRoutes: [
  //               VWidget(
  //                 path: '',
  //                 widget: const EmptyPage(),
  //                 buildTransition: _dynamicTransition,
  //               ),
  //               VWidget(
  //                 path: ':roomid',
  //                 widget: const ChatPage(),
  //                 buildTransition: _dynamicTransition,
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ];

  // List<VRouteElement> get _chatDetailsRoutes => [
  //       VWidget(
  //         path: 'permissions',
  //         widget: const ChatPermissionsSettings(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'invite',
  //         widget: const InvitationSelection(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'multiple_emotes',
  //         widget: const MultipleEmotesSettings(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'emotes',
  //         widget: const EmotesSettings(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'emotes/:state_key',
  //         widget: const EmotesSettings(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //     ];

  // List<VRouteElement> get _settingsRoutes => [
  //       VWidget(
  //         path: 'notifications',
  //         widget: const SettingsNotifications(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'style',
  //         widget: const SettingsStyle(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'devices',
  //         widget: const DevicesSettings(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //       VWidget(
  //         path: 'chat',
  //         widget: const SettingsChat(),
  //         buildTransition: _dynamicTransition,
  //         stackedRoutes: [
  //           VWidget(
  //             path: 'emotes',
  //             widget: const EmotesSettings(),
  //             buildTransition: _dynamicTransition,
  //           ),
  //         ],
  //       ),
  //       VWidget(
  //         path: 'addaccount',
  //         widget: const HomeserverPicker(),
  //         buildTransition: _fadeTransition,
  //         stackedRoutes: [
  //           VWidget(
  //             path: 'login',
  //             widget: const Login(),
  //             buildTransition: _fadeTransition,
  //           ),
  //         ],
  //       ),
  //       VWidget(
  //         path: 'security',
  //         widget: const SettingsSecurity(),
  //         buildTransition: _dynamicTransition,
  //         stackedRoutes: [
  //           VWidget(
  //             path: 'stories',
  //             widget: const SettingsStories(),
  //             buildTransition: _dynamicTransition,
  //           ),
  //           VWidget(
  //             path: 'ignorelist',
  //             widget: const SettingsIgnoreList(),
  //             buildTransition: _dynamicTransition,
  //           ),
  //           VWidget(
  //             path: '3pid',
  //             widget: const Settings3Pid(),
  //             buildTransition: _dynamicTransition,
  //           ),
  //         ],
  //       ),
  //       VWidget(
  //         path: 'logs',
  //         widget: const LogViewer(),
  //         buildTransition: _dynamicTransition,
  //       ),
  //     ];
}
