// import 'package:firebasedemo/modules/home/chat/chat_details_screen.dart';
// import 'package:firebasedemo/modules/home/home_screen.dart';
// import 'package:firebasedemo/modules/sign-in/sign_in_with_email.dart';
// import 'package:firebasedemo/routes/route_models/chat_details_model.dart';
// import 'package:firebasedemo/routes/route_models/routes_contants.dart';
// import 'package:flutter/material.dart';

// import '../modules/sign-up/sign_up_with_email.dart';

// class Routes {
//   static Route<dynamic> onGenerateRoute(
//       RouteSettings routeSettings, Widget root) {
//     switch (routeSettings.name) {
//       case RouteConstants.homeScreen:
//         return MaterialPageRoute(
//             builder: (_) => const HomeScreen(), settings: routeSettings);
//       case RouteConstants.chatDetailsScreen:
//         final data = routeSettings.arguments as ChatDetailModel;
//         return MaterialPageRoute(
//             builder: (_) => ChatDetailsScreen(
//                   isMobileView: data.isMobileView,
//                   chatModel: data.chatModel,
//                   userId: data.currentUser,
//                   secondUserId: data.secondUser,
//                 ),
//             settings: routeSettings);
//       case RouteConstants.signInEmail:
//         return MaterialPageRoute(
//             builder: (_) => SignInWithEmail(), settings: routeSettings);
//       case RouteConstants.signUpEmail:
//         return MaterialPageRoute(
//             builder: (_) => const SignUpWithEmail(), settings: routeSettings);
//       default:
//         return MaterialPageRoute(
//             builder: (_) => const HomeScreen(), settings: routeSettings);
//     }
//   }
// }
