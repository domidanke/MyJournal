import 'package:flutter/material.dart';
import 'package:my_journal/models/app_user.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/main/home_screen.dart';
import 'package:my_journal/screens/main/profile_screen.dart';
import 'package:my_journal/screens/main/settings-screen.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/theme_service.dart';

import '../../services/locator.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();
final ThemeService _themeService = locator<ThemeService>();

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future futureJournals;
  List<Journal> journals = [];
  AppUser appUser;
  List<Widget> _widgetOptions;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureJournals = getJournals();
  }

  Future<List<Journal>> getJournals() => _dataAccessService.getJournals();

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: futureJournals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            journals = snapshot.data;
            _widgetOptions = <Widget>[
              HomeScreen(
                journals: journals,
              ),
              ProfileScreen(journals: journals),
              SettingsScreen(
                journals: journals,
              ),
            ];
            return _widgetOptions.elementAt(_selectedIndex);
          }
        },
      ), //
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: const IconThemeData(size: 30.0),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.account_circle),
          ),
          BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(Icons.settings),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
