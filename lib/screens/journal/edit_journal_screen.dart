import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/journal/journal_preview_screen.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/image_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';
import 'package:my_journal/widgets/journal/mini_image.dart';

import '../../utils/constants.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final ImageService _imageService = locator<ImageService>();

class EditJournalScreen extends StatefulWidget {
  const EditJournalScreen(this.journal);
  final Journal journal;
  static String id = 'edit_journal_screen';
  @override
  _EditJournalScreenState createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  static int currentStep = 0;
  static Map<int, bool> completedMap = {0: false, 1: false, 2: false, 3: false};
  String initialTitle;
  final TextEditingController titleController = TextEditingController();
  final titleFormKey = GlobalKey<FormState>();
  bool loading = false;

  String initialCategory;
  List<String> journalCategories = [];

  dynamic initialImageFile;

  Journal journalToEdit;
  final controlDetails =
      ControlsDetails(currentStep: currentStep, stepIndex: 0);

  @override
  void initState() {
    super.initState();
    initTextControls();
  }

  //region Init Text Controls
  void initTextControls() {
    initialTitle = widget.journal.title;
    initialCategory = widget.journal.category;
    journalCategories = kCategoryIconMapping.keys.toList();
    initialImageFile = widget.journal.image;
    titleController.text = initialTitle;
    journalToEdit = Journal(
        journalID: widget.journal.journalID,
        title: initialTitle,
        category: initialCategory,
        image: initialImageFile);

    titleController.addListener(() {
      journalToEdit.title = titleController.text;
    });
  }
  //endregion

  //region CreateJournal-Steps
  List<Step> createJournalSteps() {
    return [
      Step(
          title: const Text('Update Title'),
          isActive: currentStep == 0,
          state: completedMap[0] ? StepState.complete : StepState.indexed,
          content: Column(
            children: <Widget>[
              Form(
                key: titleFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  maxLength: 20,
                  controller: titleController,
                  decoration: kTextFieldInputDecoration,
                  validator: (val) {
                    if (val.isEmpty) {
                      return 'Title cannot be empty';
                    } else {
                      return null;
                    }
                  },
                ),
              )
            ],
          )),
      Step(
          title: const Text('Choose Category'),
          isActive: currentStep == 1,
          state: completedMap[1] ? StepState.complete : StepState.indexed,
          content: DropdownButtonFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            icon: const Icon(Icons.keyboard_arrow_down),
            value: journalToEdit.category,
            hint: const Text('Category'),
            validator: (value) => value == null ? 'field required' : null,
            onChanged: (category) {
              setState(() {
                journalToEdit.icon = Icon(kCategoryIconMapping[category]);
                journalToEdit.category = category;
              });
            },
            items: journalCategories
                .map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          )),
      Step(
        title: const Text('Pick Image'),
        isActive: currentStep == 2,
        state: completedMap[2] ? StepState.complete : StepState.indexed,
        content: Padding(
            padding: const EdgeInsets.only(left: 10, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: journalToEdit.image.runtimeType == String ||
                      journalToEdit.image == null
                  ? <Widget>[
                      MiniImage(
                          image: journalToEdit.image == null
                              ? Image.asset(
                                  'assets/images/placeholder-journal-card.png',
                                  fit: BoxFit.fill,
                                )
                              : Image.network(journalToEdit.image,
                                  fit: BoxFit.fill)),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            color: Colors.grey,
                            onPressed: () async {
                              final image = await _imageService
                                  .pickImage(ImageSource.gallery);
                              setState(() {
                                if (image != null) {
                                  journalToEdit.image = image;
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_camera),
                            color: Colors.grey,
                            onPressed: () async {
                              final image = await _imageService
                                  .pickImage(ImageSource.camera);
                              setState(() {
                                if (image != null) {
                                  journalToEdit.image = image;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ]
                  : <Widget>[
                      MiniImage(
                        image:
                            Image.file(journalToEdit.image, fit: BoxFit.fill),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            journalToEdit.image = initialImageFile;
                          });
                        },
                      ),
                    ],
            )),
      ),
    ];
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: CustomFab(childButtons: [
          SpeedDialChild(
            child: const Icon(
              Icons.delete,
            ),
            backgroundColor: Colors.teal[500],
            label: 'Delete Journal',
            labelStyle: const TextStyle(fontSize: 18.0, color: Colors.black),
            onTap: () {
              _alertService.deleteJournal(context, widget.journal);
            },
          ),
        ]),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
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
                        journalToEdit.title,
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 32.0),
                        child:
                            Icon(kCategoryIconMapping[journalToEdit.category]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Stepper(
                  steps: createJournalSteps(),
                  currentStep: currentStep,
                  controlsBuilder: (BuildContext context, controlDetails) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        children: <Widget>[
                          RoundedButton(
                            text: currentStep < 2 ? 'Continue' : 'Preview',
                            width: 100.0,
                            onPressed: currentStep < 2
                                ? controlDetails.onStepContinue
                                : () {
                                    if (journalToEdit.image ==
                                            initialImageFile &&
                                        journalToEdit.title == initialTitle &&
                                        journalToEdit.category ==
                                            initialCategory) {
                                      _alertService.generalAlert('Try Again',
                                          'Nothing Changed', context);
                                    } else {
                                      _navigationService.navigateTo(
                                          JournalPreviewScreen.id,
                                          args: journalToEdit);
                                    }
                                  },
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          GestureDetector(
                            child: Text(
                              'Back',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            onTap: controlDetails.onStepCancel,
                          ),
                        ],
                      ),
                    );
                  },
                  onStepContinue: () {
                    setState(() {
                      switch (currentStep) {
                        case 0:
                          if (titleFormKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            completedMap[currentStep] = true;
                            currentStep += 1;
                          }
                          break;

                        case 1:
                          completedMap[currentStep] = true;
                          currentStep += 1;
                          break;

                        case 2:
                          // if (_imageFile == null) {
                          //   _alertService.generalAlert(
                          //       'Could Not Proceed', 'Pick an Image', context);
                          // } else {
                          //   newJournal.journalImage = _imageFile;
                          //   completedMap[currentStep] = true;
                          //   currentStep += 1;
                          // }
                          break;

                        default:
                          break;
                      }
                    });
                  },
                  onStepCancel: () {
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
    titleController.dispose();
    super.dispose();
    currentStep = 0;
    completedMap = {0: false, 1: false, 2: false, 3: false};
  }
}
