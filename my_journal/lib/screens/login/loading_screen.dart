import 'package:flutter/material.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/services/theme_service.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();
final ThemeService _themeService = locator<ThemeService>();
final NavigationService _navigationService = locator<NavigationService>();

class LoadingScreen extends StatefulWidget {
  static String id = 'loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final darkMode = await _dataAccessService.isDarkMode();
    _themeService.changeTheme(darkMode, context);
    _navigationService.navigateHome();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
