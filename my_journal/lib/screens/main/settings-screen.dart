import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/journal/edit_journal_sort_order_screen.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/services/theme_service.dart';
import 'package:my_journal/widgets/journal/mini_journal_card.dart';

final NavigationService _navigationService = locator<NavigationService>();
final ThemeService _themeService = locator<ThemeService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();
final AlertService _alertService = locator<AlertService>();

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({this.journals});
  static String id = 'settings-screen';
  final List<Journal> journals;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<Widget> miniJournalCards = [];
  bool darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = _themeService.darkMode;
  }

  //region Create Mini Journal Cards
  void createMiniJournalCards({String origin}) {
    miniJournalCards.clear();
    for (final journal in widget.journals) {
      miniJournalCards.add(Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 12.0, right: 16.0, bottom: 12.0),
        child: MiniJournalCard(
          journal: journal,
          origin: 'Settings/$origin',
        ),
      ));
    }
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        Expanded(
          flex: 1,
          child: ListView(
            children: widget.journals.isNotEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.filter_1),
                          title: const Text('Change Journal Sort Order'),
                          onTap: () {
                            _navigationService.navigateTo(
                                EditJournalSortOrderScreen.id,
                                args: widget.journals);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit Journal'),
                          onTap: () {
                            createMiniJournalCards(origin: 'Edit-Journal');
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              2 /
                                              5,
                                      child:
                                          ListView(children: miniJournalCards));
                                });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          leading: const Icon(Icons.brush),
                          title: const Text('Edit Entries Color'),
                          onTap: () {
                            createMiniJournalCards(origin: 'Edit-Colors');
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      height:
                                          (MediaQuery.of(context).size.height) *
                                              2 /
                                              5,
                                      child:
                                          ListView(children: miniJournalCards));
                                });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          leading: darkMode
                              ? const Icon(Icons.nightlight_round)
                              : const Icon(Icons.wb_sunny),
                          title: darkMode
                              ? const Text('Night Mode')
                              : const Text('Day Mode'),
                          trailing: Switch(
                            activeColor: Colors.teal[500],
                            value: darkMode,
                            onChanged: (value) async {
                              setState(() {
                                darkMode = !darkMode;
                                _themeService.changeTheme(darkMode, context);
                              });
                              await _dataAccessService.toggleDarkMode(darkMode);
                            },
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 6.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          leading: darkMode
                              ? const Icon(Icons.nightlight_round)
                              : const Icon(Icons.wb_sunny),
                          title: darkMode
                              ? const Text('Night Mode')
                              : const Text('Day Mode'),
                          trailing: Switch(
                            activeColor: Colors.teal[500],
                            value: darkMode,
                            onChanged: (value) async {
                              setState(() {
                                darkMode = !darkMode;
                                _themeService.changeTheme(darkMode, context);
                              });
                              await _dataAccessService.toggleDarkMode(darkMode);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
          ),
        )
      ],
    )));
  }
}
