import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../services/locator.dart';
import '../../utils/constants.dart';
import 'entry_overview_screen.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();
final AlertService _alertService = locator<AlertService>();

class WriteEntryScreen extends StatefulWidget {
  const WriteEntryScreen(this.entry);
  final Entry entry;
  static String id = 'write_entry_screen';
  @override
  _WriteEntryScreenState createState() => _WriteEntryScreenState();
}

class _WriteEntryScreenState extends State<WriteEntryScreen> {
  final contentFormKey = GlobalKey<FormState>();
  final TextEditingController contentController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    contentController.addListener(() {
      widget.entry.content = contentController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FittedBox(
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
                          margin:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: widget.entry.journal.icon,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).viewInsets.bottom == 0.0
                          ? MediaQuery.of(context).size.height - 300.0
                          : MediaQuery.of(context).size.height -
                              200.0 -
                              MediaQuery.of(context).viewInsets.bottom,
                      child: Form(
                        key: contentFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          key: const Key('contentTextFieldKey'),
                          controller: contentController,
                          style: const TextStyle(
                            height: 1.5,
                          ),
                          decoration: kTextFieldInputDecoration.copyWith(
                              hintText: 'Write your Content...',
                              hintStyle: Theme.of(context).textTheme.headline4),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Content cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              RoundedButton(
                color: Colors.teal[700],
                width: 120,
                text: 'Add Entry',
                isAsync: loading,
                onPressed: () async {
                  if (!loading) {
                    if (contentFormKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      await _dataAccessService
                          .addNewEntry(widget.entry)
                          .then((_) async {
                        setState(() {
                          loading = false;
                        });

                        await _alertService.popUpSuccess(
                            context, 'Entry Added!');
                        if (widget.entry.journal.comingFromHome) {
                          widget.entry.journal.comingFromHome = false;
                          _navigationService.navigateHome();
                          _navigationService.navigateTo(EntryOverviewScreen.id,
                              args: widget.entry.journal);
                        } else {
                          _navigationService.goBack(n: 2);
                        }
                      }).catchError((Object error) async {
                        await _alertService.popUpError(context);
                      });
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
