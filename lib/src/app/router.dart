import 'package:flutter/material.dart';

import '../features/add_feed/presentation/add_feed_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/my_feed/presentation/my_feed_screen.dart';
import '../features/auth/presentation/login_screen.dart';

class AppRouter {
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeAddFeed = '/add';
  static const String routeMyFeed = '/my';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case routeHome:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case routeAddFeed:
        return MaterialPageRoute(builder: (_) => const AddFeedScreen());
      case routeMyFeed:
        return MaterialPageRoute(builder: (_) => const MyFeedScreen());
    }
    return null;
  }
}
