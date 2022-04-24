import 'package:flutter/material.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';

import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();
final AlertService _alertService = locator<AlertService>();

class EditJournalSortOrderScreen extends StatefulWidget {
  const EditJournalSortOrderScreen(this.journals);
  static String id = 'edit_journal_sort_order_screen';
  final List<Journal> journals;

  @override
  _EditJournalSortOrderScreenState createState() =>
      _EditJournalSortOrderScreenState();
}

class _EditJournalSortOrderScreenState
    extends State<EditJournalSortOrderScreen> {
  final Map<String, Widget> journalWidgets = {};
  final Map<String, JournalCheckObject> journalWidgetControl = {};
  List<Draggable> dragWidgets = [];
  List<DragTarget> dragTargetWidgets = [];
  bool isDone = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    createJournalMap();
    createDragWidgets();
  }

  //region Create Journal Map
  /// Need those Journal Maps to have a live Check on how the User maps the new sort order
  void createJournalMap() {
    for (var i = 0; i < widget.journals.length; i++) {
      journalWidgets[widget.journals[i].title] =
          DragJournal(journal: widget.journals[i]);
      journalWidgetControl[widget.journals[i].title] = JournalCheckObject(
          assigned: false,
          indexAssigned: 0,
          journalID: widget.journals[i].journalID);
    }
  }
  //endregion

  //region Create Drag Widgets
  void createDragWidgets() {
    for (var i = 0; i < widget.journals.length; i++) {
      dragWidgets.add(Draggable<String>(
          data: widget.journals[i].title,
          child: !journalWidgetControl[widget.journals[i].title].assigned
              ? DragJournal(
                  journal: widget.journals[i],
                  small: true,
                )
              : Container(
                  height: 60.0,
                  width: 150.0,
                ),
          feedback: DragJournal(
            journal: widget.journals[i],
            shading: true,
          ),
          childWhenDragging: Container(
            height: 60.0,
            width: 150.0,
          )));

      dragTargetWidgets.add(DragTarget<String>(
        builder: (BuildContext context, List<String> accepted,
            List<dynamic> rejected) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6.0),
                width: 20.0,
                child: Text(
                  '${i + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              updateDragTarget(i + 1),
              Container(
                padding: const EdgeInsets.all(6.0),
                width: 20.0,
              ),
            ],
          );
        },
        onWillAccept: (data) {
          bool isAvailable = true;
          journalWidgetControl.forEach((key, value) {
            if (value.assigned == true && value.indexAssigned == i + 1) {
              isAvailable = false;
            }
          });
          return isAvailable;
        },
        onAccept: (data) {
          setState(() {
            journalWidgetControl[data].assigned = true;
            journalWidgetControl[data].indexAssigned = i + 1;
            updateDragWidgets();
            checkIfDone();
          });
        },
        onLeave: (data) {},
      ));
    }
  }
  //endregion

  //region Update Drag Target
  Widget updateDragTarget(int index) {
    String indexedJournalTitle;
    journalWidgetControl.forEach((key, value) {
      if (value.indexAssigned == index) {
        indexedJournalTitle = key;
      }
    });
    if (indexedJournalTitle != null) {
      return journalWidgets[indexedJournalTitle];
    } else {
      return Container(
          width: 300,
          height: 60,
          child: Card(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )));
    }
  }
  //endregion

  //region Update Drag Widgets
  /// Drag Target constantly gets updated, whereas Draggable does not.
  /// This method re-instantiates the Draggable Widgets, can be better but works for now
  void updateDragWidgets() {
    dragWidgets.clear();
    for (var i = 0; i < widget.journals.length; i++) {
      dragWidgets.add(Draggable<String>(
          data: widget.journals[i].title,
          child: !journalWidgetControl[widget.journals[i].title].assigned
              ? DragJournal(
                  journal: widget.journals[i],
                  small: true,
                )
              : Container(
                  height: 60.0,
                  width: 150.0,
                ),
          feedback: DragJournal(
            journal: widget.journals[i],
            shading: true,
          ),
          childWhenDragging: Container(
            height: 60.0,
            width: 150.0,
          )));
    }
  }
  //endregion

  //region Check if User is done assigning
  void checkIfDone() {
    isDone = true;
    journalWidgetControl.forEach((key, value) {
      if (value.assigned == false) {
        isDone = false;
      }
    });
  }
  //endregion

  //region Reset Cards
  void reset() {
    journalWidgets.clear();
    journalWidgetControl.clear();
    dragWidgets.clear();
    dragTargetWidgets.clear();
    createJournalMap();
    createDragWidgets();
    isDone = false;
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(
            height: 10.0,
          ),
          Column(
            children: dragTargetWidgets,
          ),
          const Divider(
            height: 25.0,
            thickness: 3.0,
          ),
          Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dragWidgets.sublist(0, 2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: dragWidgets.length < 3
                    ? <Widget>[Container()]
                    : dragWidgets.length == 3
                        ? dragWidgets.sublist(2, 3)
                        : dragWidgets.sublist(2, 4),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: dragWidgets.length > 4
                    ? dragWidgets.sublist(4, 5)
                    : <Widget>[Container()],
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[500],
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 32.0,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      _navigationService.goBack();
                    },
                  ),
                ),
                const SizedBox(
                  width: 24.0,
                ),
                Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[700],
                    shape: const CircleBorder(),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      size: 32.0,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        reset();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: isDone,
                  child: Row(children: <Widget>[
                    const SizedBox(
                      width: 24.0,
                    ),
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.teal[700],
                        shape: const CircleBorder(),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.done),
                        color: Colors.white,
                        onPressed: () async {
                          if (!loading) {
                            loading = true;
                            await _dataAccessService
                                .updateJournalSortOrder(journalWidgetControl)
                                .then((_) async {
                              loading = false;
                              await _alertService.popUpSuccess(
                                  context, 'Sort Order Changed!');
                              _navigationService.navigateHome();
                            }).onError((error, stackTrace) async {
                              await _alertService.popUpError(context);
                            });
                          }
                        },
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

//region Drag Journal Widget
class DragJournal extends StatelessWidget {
  const DragJournal(
      {@required this.journal, this.shading = false, this.small = false});
  final Journal journal;
  final bool shading;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: shading
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [BoxShadow(blurRadius: 2.0)],
            )
          : null,
      width: small ? 150 : 300,
      height: 60,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: small
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: journal.icon,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 6.0),
                        width: 75.0,
                        child: Text(
                          journal.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                )
              : ListTile(
                  leading: journal.icon,
                  title: Text(
                    journal.title,
                  ),
                )),
    );
  }
}
//endregion

//region Journal Check Object
class JournalCheckObject {
  JournalCheckObject({this.assigned, this.indexAssigned, this.journalID});
  bool assigned;
  int indexAssigned;
  String journalID;
}
//endregion
