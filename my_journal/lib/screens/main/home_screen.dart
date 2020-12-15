import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/services/theme_service.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';
import 'package:my_journal/widgets/journal/journal_card.dart';
import 'package:my_journal/widgets/journal/mini_journal_card.dart';

import '../journal/create_journal_screen.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final AuthService _authService = locator<AuthService>();
final ThemeService _themeService = locator<ThemeService>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.journals});
  static String id = 'home_screen';
  final List<Journal> journals;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JournalCard> journalCards = [];
  List<Widget> miniJournalCards = [];
  Widget fab;
  Widget content;

  @override
  void initState() {
    super.initState();
    initWidgets();
  }

  //region Init Widgets
  void initWidgets() {
    getScrollWidget();
    getFab();
    createJournalCards();
    createMiniJournalCards();
  }
  //endregion

  //region Create Journal Cards
  void createJournalCards() {
    try {
      for (int i = 0; i < widget.journals.length; i++) {
        journalCards.add(JournalCard(
          journal: widget.journals[i],
        ));
      }
    } catch (e) {
      return;
    }
  }
  //endregion

  //region Create Mini Journal Cards
  void createMiniJournalCards() {
    try {
      for (final journal in widget.journals) {
        miniJournalCards.add(Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 12.0, right: 16.0, bottom: 12.0),
          child: MiniJournalCard(
            journal: journal,
            origin: 'Home',
          ),
        ));
      }
    } catch (e) {
      return;
    }
  }
  //endregion

  //region Get Floating Action Button Widget
  void getFab() {
    try {
      if (widget.journals.isEmpty) {
        fab = FloatingActionButton.extended(
          backgroundColor: Colors.teal[500],
          foregroundColor: Colors.white,
          onPressed: () {
            _navigationService.navigateTo(CreateJournalScreen.id);
          },
          icon: const Icon(Icons.add),
          label: const Text('Create First Journal'),
        );
      } else {
        fab = CustomFab(
          childButtons: [
            SpeedDialChild(
              child: const Icon(
                Icons.edit,
              ),
              backgroundColor: Colors.teal[700],
              label: 'Create Custom Journal',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                if (widget.journals.length >= 5) {
                  _alertService.maxJournals(context);
                } else {
                  _navigationService.navigateTo(CreateJournalScreen.id);
                }
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.add),
              backgroundColor: Colors.teal[900],
              label: 'Add Entry',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          height: (MediaQuery.of(context).size.height) * 2 / 5,
                          child: ListView(children: miniJournalCards));
                    });
              },
            ),
          ],
        );
      }
    } catch (e) {
      fab = FloatingActionButton.extended(
        backgroundColor: Colors.teal[500],
        foregroundColor: Colors.white,
        onPressed: () async {
          await _authService.signOut();
          _themeService.changeTheme(false, context);
          _navigationService.signOut();
        },
        icon: const Icon(Icons.lock_open),
        label: const Text('Sign Out'),
      );
    }
  }
  //endregion

  //region Get Main Content Widget
  void getScrollWidget() {
    try {
      if (widget.journals.isEmpty) {
        content = const Center(
          child: Text('No Journals yet!'),
        );
      } else {
        content = Column(
          children: <Widget>[
            Expanded(flex: 12, child: ListView(children: journalCards))
          ],
        );
      }
    } catch (e) {
      content = const Center(
        child: Text('Something went wrong'),
      );
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: fab,
      body: SafeArea(child: content),
    );
  }
}
