import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasedemo/config/app_routes/app_routes.dart';
import 'package:firebasedemo/config/app_routes/route_type.dart';
import 'package:flutter/material.dart';
import '../../widgets/empty_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final isCurrentUserloggedIn = FirebaseAuth.instance.currentUser;
        if (isCurrentUserloggedIn != null) {
          AppRoutes.pushNamed(context, routeType: RouteType.roomsScreen);
        } else {
          AppRoutes.pushNamed(context, routeType: RouteType.loginScreen);
        }
      },
    );
    return const EmptyView(loading: true);
  }
}
