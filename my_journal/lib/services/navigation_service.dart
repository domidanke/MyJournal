import 'package:flutter/cupertino.dart';
import 'package:my_journal/screens/login/welcome_screen.dart';
import 'package:my_journal/screens/main/main_screen.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  //region Navigate To
  Future<dynamic> navigateTo(String routeName, {dynamic args = ''}) {
    if (args == '') {
      return navigatorKey.currentState.pushNamed(routeName);
    } else {
      return navigatorKey.currentState.pushNamed(routeName, arguments: args);
    }
  }
  //endregion

  //region Navigate Home
  Future<dynamic> navigateHome({dynamic args = ''}) {
    if (args == '') {
      return navigatorKey.currentState.pushNamedAndRemoveUntil(
        MainScreen.id,
        (route) => false,
      );
    } else {
      return navigatorKey.currentState.pushNamedAndRemoveUntil(
          MainScreen.id, (route) => false,
          arguments: args);
    }
  }
  //endregion

  //region Navigate Back To Welcome Screen
  Future<dynamic> signOut() {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
      WelcomeScreen.id,
      (route) => false,
    );
  }
  //endregion

  //region Go Back
  void goBack({int n = 1}) {
    for (int i = 0; i < n; i++) {
      navigatorKey.currentState.pop();
    }
  }
  //endregion
}
