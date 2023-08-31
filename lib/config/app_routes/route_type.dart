enum RouteType {
  splashScreen,
  loginScreen,
  register,
  roomsScreen,
}

extension ExtRouteType on RouteType {
  String get url {
    switch (this) {
      case RouteType.splashScreen:
        return '/';
      case RouteType.loginScreen:
        return '/login';
      case RouteType.register:
        return '/register';
      case RouteType.roomsScreen:
        return '/rooms';
    }
  }

  String get name {
    switch (this) {
      case RouteType.splashScreen:
        return '/';
      case RouteType.loginScreen:
        return 'login';
      case RouteType.register:
        return 'register';
      case RouteType.roomsScreen:
        return 'rooms';
    }
  }
}
