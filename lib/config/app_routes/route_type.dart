enum RouteType {
  splashScreen,
  loginScreen,
  register,
  roomsScreen,
  newChatScreen,
  chatDetailsScreen,
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
      case RouteType.newChatScreen:
        return 'new-chat';
      case RouteType.chatDetailsScreen:
        return 'chat-details/:uid';
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
      case RouteType.newChatScreen:
        return 'new-chat';
      case RouteType.chatDetailsScreen:
        return 'chat-details';
    }
  }
}
