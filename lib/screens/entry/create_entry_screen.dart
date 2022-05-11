import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/models/entry.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/entry/write_entry_screen.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();

class CreateEntryScreen extends StatefulWidget {
  const CreateEntryScreen(this.journal);
  final Journal journal;
  static String id = 'create_entry_screen';
  @override
  _CreateEntryScreenState createState() => _CreateEntryScreenState();
}

class _CreateEntryScreenState extends State<CreateEntryScreen> {
  static int currentStep = 0;
  static Map<int, bool> completedMap = {0: false, 1: false, 2: false, 3: false};
  final formKey = GlobalKey<FormState>();
  final TextEditingController headerController = TextEditingController();
  final headerFormKey = GlobalKey<FormState>();
  Entry newEntry = Entry();
  final controlDetails =
      ControlsDetails(currentStep: currentStep, stepIndex: 0);

  @override
  void initState() {
    super.initState();
    initPlaceholders();
  }

  //region Init Placeholder
  void initPlaceholders() {
    newEntry.journal = widget.journal;
    newEntry.eventDate = DateTime.now();
    newEntry.feeling = 2;
    newEntry.specialDay = false;
    headerController.addListener(() {
      newEntry.header = headerController.text;
    });
  }
  //endregion

  //region Show Custom Date Picker
  void showCustomDatePicker(BuildContext context) {
    if (Platform.isIOS) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          isDismissible: false,
          context: context,
          builder: (BuildContext bc) {
            return SizedBox(
              height: 350.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    height: 250.0,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (selectedDate) {
                        newEntry.eventDate = selectedDate;
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('Confirm'),
                    onPressed: () {
                      setState(() {});
                      _navigationService.goBack();
                    },
                  )
                ],
              ),
            );
          });
    } else {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now())
          .then((selectedDate) {
        if (selectedDate != null) {
          setState(() {
            newEntry.eventDate = selectedDate;
          });
        }
      });
    }
  }
  //endregion

  //region Show Custom Slider
  Widget getCustomSlider() {
    if (Platform.isIOS) {
      return CupertinoSlider(
        //thumbColor: Colors.teal[300],
        //activeColor: Colors.teal[500],
        min: 0.0,
        max: 4.0,
        divisions: 4,
        value: newEntry.feeling.toDouble(),
        onChanged: (_feeling) {
          setState(() => newEntry.feeling = _feeling.toInt());
        },
      );
    } else {
      return Container(
        alignment: Alignment.center,
        width: 200,
        child: Slider(
          min: 0.0,
          max: 4.0,
          divisions: 4,
          //activeColor: Colors.teal[300],
          //inactiveColor: const Color(0xffdddddd),
          value: newEntry.feeling.toDouble(),
          onChanged: (_feeling) {
            setState(() => newEntry.feeling = _feeling.toInt());
          },
        ),
      );
    }
  }
  //endregion

  //region CreateJournal-Steps
  List<Step> addEntrySteps() {
    return [
      Step(
        title: const Text('Pick Date'),
        isActive: currentStep == 0,
        state: completedMap[0] ? StepState.complete : StepState.indexed,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(formatDate(newEntry.eventDate),
                style: Theme.of(context).textTheme.headline6),
            Column(
              children: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.date_range,
                    //color: Colors.teal[300],
                  ),
                  onPressed: () {
                    showCustomDatePicker(context);
                  },
                ),
                Text(
                  'Change Date',
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ],
        ),
      ),
      Step(
        title: const Text('How did you feel?'),
        isActive: currentStep == 1,
        state: completedMap[1] ? StepState.complete : StepState.indexed,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  kFeelingIcons[newEntry.feeling.toInt()],
                  size: 36.0,
                  //color: Colors.teal[300],
                )
              ],
            ),
            getCustomSlider(),
          ],
        ),
      ),
      Step(
        title: const Text('Special Day?'),
        isActive: currentStep == 2,
        state: completedMap[2] ? StepState.complete : StepState.indexed,
        content: Column(
          children: <Widget>[
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        newEntry.specialDay = !newEntry.specialDay;
                      });
                    },
                    color: newEntry.specialDay
                        ? Colors.orangeAccent
                        : Colors.black45,
                    icon: Icon(
                      newEntry.specialDay ? Icons.star : Icons.star_border,
                      size: 32.0,
                    )),
              ),
            ),
            const Text(
              'Special Day',
              style: TextStyle(fontSize: 12.0),
            )
          ],
        ),
      ),
      Step(
          title: const Text('Choose Header'),
          isActive: currentStep == 3,
          state: completedMap[3] ? StepState.complete : StepState.indexed,
          content: Form(
            key: headerFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              maxLength: 20,
              controller: headerController,
              decoration: kTextFieldInputDecoration,
              validator: (val) {
                if (val.isEmpty) {
                  return 'Header cannot be empty';
                } else {
                  return null;
                }
              },
            ),
          )),
    ];
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
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
                      _navigationService.goBack(n: 2);
                    },
                  ),
                  Text(
                    widget.journal.title,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 32.0),
                    child: Icon(kCategoryIconMapping[widget.journal.category]),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Stepper(
              steps: addEntrySteps(),
              currentStep: currentStep,
              controlsBuilder: (BuildContext context, controlDetails) {
                return Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    children: <Widget>[
                      RoundedButton(
                        text: currentStep < 3 ? 'Continue' : 'Start Writing',
                        width: currentStep < 3 ? 100.0 : 150.0,
                        onPressed: currentStep < 3
                            ? controlDetails.onStepContinue
                            : () {
                                if (headerFormKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _navigationService.navigateTo(
                                      WriteEntryScreen.id,
                                      args: newEntry);
                                }
                              },
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Back',
                        ),
                        onTap: controlDetails.onStepCancel,
                      ),
                    ],
                  ),
                );
              },
              onStepContinue: () {
                setState(() {
                  completedMap[currentStep] = true;
                  currentStep += 1;
                });
              },
              onStepCancel: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  if (currentStep > 0) {
                    currentStep -= 1;
                    completedMap[currentStep] = false;
                  } else {
                    _navigationService.goBack(n: 2);
                  }
                });
              },
            ),
          ),
        ],
      )),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    headerController.dispose();
    super.dispose();
    currentStep = 0;
    completedMap = {0: false, 1: false, 2: false, 3: false};
  }
}
