import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigatorTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }
}
