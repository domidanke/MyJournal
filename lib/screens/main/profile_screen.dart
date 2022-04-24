import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_journal/models/app_user.dart';
import 'package:my_journal/models/journal.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/image_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/custom_fab.dart';

final DataAccessService _dataAccessService = locator<DataAccessService>();
final ImageService _imageService = locator<ImageService>();
final NavigationService _navigationService = locator<NavigationService>();
final AuthService _authService = locator<AuthService>();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.journals});
  static String id = 'profile_screen';
  final List<Journal> journals;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future futureAppUser;
  AppUser appUser;
  File imageSelected;
  @override
  void initState() {
    super.initState();
    futureAppUser = getUserInformation();
  }

  Future<AppUser> getUserInformation() =>
      _dataAccessService.getUserInformation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFab(
        childButtons: [
          SpeedDialChild(
              child: const Icon(Icons.photo_library),
              backgroundColor: Colors.teal[700],
              label: 'Pick new Profile Picture',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () async {
                final image = await _imageService.pickImage(ImageSource.gallery,
                    circleCrop: true);
                setState(() {
                  if (image != null) {
                    imageSelected = image;
                    _dataAccessService.uploadImage(
                        imageSelected, 'profile-images/${appUser.userID}');
                    appUser.userImage = null;
                  }
                });
                print(imageSelected);
              }),
          SpeedDialChild(
              child: const Icon(Icons.photo_camera),
              backgroundColor: Colors.teal[800],
              label: 'Take new Profile Picture',
              labelStyle: const TextStyle(color: Colors.black),
              onTap: () async {
                final image = await _imageService.pickImage(ImageSource.camera,
                    circleCrop: true);
                setState(() {
                  if (image != null) {
                    imageSelected = image;
                    _dataAccessService.uploadImage(
                        imageSelected, 'profile-images/${appUser.userID}');
                    appUser.userImage = null;
                  }
                });
                print(imageSelected);
              }),
          SpeedDialChild(
            child: const Icon(
              Icons.lock_open,
            ),
            backgroundColor: Colors.teal[900],
            label: 'Log Out',
            labelStyle: const TextStyle(color: Colors.black),
            onTap: () async {
              await _authService.signOut();
              _navigationService.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureAppUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                appUser = snapshot.data;
                try {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: 200,
                            height: 200,
                            child: appUser.userImage != null
                                ? CircleAvatar(
                                    radius: 100,
                                    backgroundImage:
                                        NetworkImage(appUser.userImage))
                                : imageSelected == null
                                    ? Stack(
                                        children: [
                                          const CircleAvatar(
                                              radius: 100,
                                              backgroundImage: AssetImage(
                                                'assets/images/placeholder-journal-card.png',
                                              )),
                                          Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                decoration:
                                                    const ShapeDecoration(
                                                  //color: Colors.teal[300],
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                    icon: const Icon(Icons.add),
                                                    //color: Colors.white,
                                                    onPressed: () async {
                                                      final image =
                                                          await _imageService
                                                              .pickImage(
                                                                  ImageSource
                                                                      .gallery,
                                                                  circleCrop:
                                                                      true);
                                                      setState(() {
                                                        if (image != null) {
                                                          imageSelected = image;
                                                          _dataAccessService
                                                              .uploadImage(
                                                                  imageSelected,
                                                                  'profile-images/${appUser.userID}');
                                                        }
                                                      });
                                                    }),
                                              ))
                                        ],
                                      )
                                    : CircleAvatar(
                                        radius: 100,
                                        backgroundImage:
                                            FileImage(imageSelected))),
                        const SizedBox(
                          height: 18.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            appUser.email,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                        ),
                        Text(
                          'since ${formatDate(appUser.created)}',
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              }
            }),
      ),
    );
  }
}
