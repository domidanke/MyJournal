import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();

class EntryDetailScreen extends StatefulWidget {
  const EntryDetailScreen(this.entry);
  static String id = 'entry_detail_screen';
  final Entry entry;

  @override
  _EntryDetailScreenState createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  Icon specialDayIcon;
  bool editMode = false;
  String initialHeader;
  String initialContent;
  final TextEditingController headerController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    initTextControls();
  }

  //region Init Text Controls
  void initTextControls() {
    initialHeader = widget.entry.header;
    initialContent = widget.entry.content;
    headerController.text = widget.entry.header;
    contentController.text = widget.entry.content;
    headerController.addListener(() {
      widget.entry.header = headerController.text;
    });
    contentController.addListener(() {
      widget.entry.content = contentController.text;
    });
  }
  //endregion

  //region Cancel Edit
  void cancelEdit() {
    setState(() {
      editMode = false;
      headerController.text = initialHeader;
      contentController.text = initialContent;
      widget.entry.header = initialHeader;
      widget.entry.content = initialContent;
    });
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: editMode ? () => FocusScope.of(context).unfocus() : null,
      child: Scaffold(
        floatingActionButton: !editMode && !widget.entry.isMockEntry
            ? CustomFab(
                childButtons: [
                  SpeedDialChild(
                      child: const Icon(Icons.edit),
                      backgroundColor: Colors.teal[700],
                      label: 'Edit Entry',
                      labelStyle: const TextStyle(color: Colors.black),
                      onTap: () {
                        setState(() {
                          editMode = true;
                        });
                      }),
                  SpeedDialChild(
                      child: const Icon(Icons.delete),
                      backgroundColor: Colors.teal[900],
                      label: 'Delete Entry',
                      labelStyle: const TextStyle(color: Colors.black),
                      onTap: () =>
                          _alertService.deleteEntry(context, widget.entry)),
                ],
              )
            : null,
        body: SafeArea(
            child: !editMode
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(
                                    Icons.chevron_left,
                                    size: 32.0,
                                  ),
                                  onPressed: () {
                                    _navigationService.goBack();
                                  },
                                ),
                                Text(
                                  '${widget.entry.header}',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 32.0),
                                  child: widget.entry.journal.icon,
                                ),
                              ]),
                        ),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Card(
                                  color: widget.entry.journal.entriesColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  child: SingleChildScrollView(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8.0, right: 8.0),
                                      child: Text(
                                        '${widget.entry.content}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                  )),
                                )))
                      ])
                : Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: TextFormField(
                          key: const Key('editHeaderTextFieldKey'),
                          controller: headerController,
                          decoration: kTextFieldInputDecoration,
                          maxLength: 20,
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: Container(
                              height: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom ==
                                      0.0
                                  ? MediaQuery.of(context).size.height - 300.0
                                  : MediaQuery.of(context).size.height -
                                      250.0 -
                                      MediaQuery.of(context).viewInsets.bottom,
                              child: TextFormField(
                                key: const Key('editContentTextFieldKey'),
                                controller: contentController,
                                style: const TextStyle(
                                  height: 1.5,
                                ),
                                decoration: kTextFieldInputDecoration,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RoundedButton(
                            text: 'Cancel',
                            onPressed: () {
                              cancelEdit();
                            },
                          ),
                          RoundedButton(
                            color: Colors.teal[500],
                            text: 'Save',
                            isAsync: loading,
                            onPressed: () async {
                              if (headerController.text == initialHeader &&
                                  contentController.text == initialContent) {
                                _alertService.generalAlert(
                                    'Try Again',
                                    'Header and Content did not change',
                                    context);
                              } else if (headerController.text == '' ||
                                  contentController.text == '') {
                                _alertService.generalAlert('Try Again',
                                    'Both fields have to be filled', context);
                              } else {
                                if (!loading) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await _dataAccessService
                                      .updateEntry(widget.entry)
                                      .then((value) async {
                                    setState(() {
                                      loading = false;
                                    });
                                    if (value) {
                                      await _alertService.popUpSuccess(
                                          context, 'Entry Edited!');
                                      setState(() {
                                        editMode = false;
                                      });
                                      initialHeader = widget.entry.header;
                                      initialContent = widget.entry.content;
                                    } else {
                                      await _alertService.popUpError(context);
                                    }
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  )),
      ),
    );
  }
}
