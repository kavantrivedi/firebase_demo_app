import 'package:flutter/material.dart';

import '../config/app_routes/app_routes.dart';
import '../config/app_routes/route_type.dart';
import 'app_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('404 Page Not Found!!'),
            const SizedBox(height: 20),
            AppButton(
              title: 'Go Back To Home',
              onPressed: () {
                AppRoutes.pushNamed(
                  context,
                  routeType: RouteType.splashScreen,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
