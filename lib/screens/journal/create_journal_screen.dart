import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/screens/journal/journal_preview_screen.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/image_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';
import 'package:my_journal/widgets/journal/mini_image.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final ImageService _imageService = locator<ImageService>();

class CreateJournalScreen extends StatefulWidget {
  static String id = 'create_journal_screen';

  @override
  _CreateJournalScreenState createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  static int currentStep = 0;
  static Map<int, bool> completedMap = {0: false, 1: false, 2: false, 3: false};
  final titleFormKey = GlobalKey<FormState>();
  final dropdownFormKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  List<String> journalCategories = [];
  String selectedCategory;
  File imageSelected;
  Journal newJournal;
  final controlDetails =
      ControlsDetails(currentStep: currentStep, stepIndex: 0);

  @override
  void initState() {
    super.initState();
    initPlaceholders();
  }

  //region Init Placeholder
  void initPlaceholders() {
    newJournal = Journal(comingFromHome: true);
    journalCategories = kCategoryIconMapping.keys.toList();
    titleController.addListener(() {
      setState(() {
        newJournal.title = titleController.text;
      });
    });
    newJournal.icon = const Icon(Icons.edit);
  }
//   //endregion

  //region CreateJournal-Steps
  List<Step> createJournalSteps() {
    return [
      Step(
          title: const Text('Enter Title'),
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
            key: dropdownFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            icon: const Icon(Icons.keyboard_arrow_down),
            value: selectedCategory,
            hint: const Text('Category'),
            validator: (value) => value == null ? 'field required' : null,
            onChanged: (category) {
              setState(() {
                newJournal.icon = Icon(kCategoryIconMapping[category]);
                selectedCategory = category;
                newJournal.category = category;
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
              children: imageSelected == null
                  ? <Widget>[
                      Container(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.photo_camera),
                            onPressed: () async {
                              final image = await _imageService
                                  .pickImage(ImageSource.camera);
                              setState(() {
                                if (image != null) {
                                  imageSelected = image;
                                }
                              });
                            }),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.photo_library),
                            //color: Colors.white,
                            onPressed: () async {
                              final image = await _imageService
                                  .pickImage(ImageSource.gallery);
                              setState(() {
                                if (image != null) {
                                  imageSelected = image;
                                }
                              });
                            }),
                      ),
                    ]
                  : <Widget>[
                      MiniImage(
                        image: Image.file(imageSelected, fit: BoxFit.fill),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        //color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            imageSelected = null;
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
                      _navigationService.goBack();
                    },
                  ),
                  const Text(
                    'Create Your Journal',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 32.0),
                    child: Icon(kCategoryIconMapping[newJournal.category]),
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
                        //color: Colors.teal[300],
                        width: 100.0,
                        onPressed: currentStep < 2
                            ? controlDetails.onStepContinue
                            : () {
                                if (imageSelected == null) {
                                  _alertService.generalAlert(
                                      'Could Not Proceed',
                                      'Pick an Image',
                                      context);
                                } else {
                                  newJournal.image = imageSelected;
                                  _navigationService.navigateTo(
                                      JournalPreviewScreen.id,
                                      args: newJournal);
                                }
                              },
                      ),
                      const SizedBox(
                        width: 30.0,
                      ),
                      GestureDetector(
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //color: Colors.grey,
                          ),
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
                      if (newJournal.category == null) {
                        _alertService.generalAlert(
                            'Could Not Proceed', 'Select a Category', context);
                      } else {
                        completedMap[currentStep] = true;
                        currentStep += 1;
                      }
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
                    _navigationService.goBack();
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
    imageSelected = null;
  }
}
