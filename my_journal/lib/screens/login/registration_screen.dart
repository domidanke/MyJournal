import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/models/app_user.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/data-access_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../services/locator.dart';
import '../main/main_screen.dart';

final NavigationService _navigationService = locator<NavigationService>();
final DataAccessService _dataAccessService = locator<DataAccessService>();
final AlertService _alertService = locator<AlertService>();
final AuthService _authService = locator<AuthService>();

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            height: 400,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(S.of(context).registrationScreenTopLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1),
                  const SizedBox(
                    height: 36.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextField(
                      key: const Key('email'),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldInputDecoration.copyWith(
                          hintText: S
                              .of(context)
                              .registrationScreenEmailTextFieldHint,
                          hintStyle: Theme.of(context).textTheme.headline4),
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextField(
                      key: const Key('password'),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldInputDecoration.copyWith(
                          hintText: S
                              .of(context)
                              .registrationScreenPasswordTextFieldHint,
                          hintStyle: Theme.of(context).textTheme.headline4),
                      onChanged: (value) {
                        //Do something with the user input.
                        password = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    text: S.of(context).registrationScreenRegistrationButton,
                    //color: Colors.teal[500],
                    onPressed: () async {
                      if (password == null || email == null) {
                        FocusScope.of(context).unfocus();
                        _alertService.generalAlert(
                            'Try Again', 'Fields are not filled out', context);
                      } else {
                        setState(() {
                          showSpinner = true;
                        });

                        try {
                          final newUser =
                              await _authService.signUp(email, password);

                          if (newUser != null) {
                            final AppUser createUser = AppUser(
                              userID: newUser.uid,
                              email: newUser.email,
                            );
                            await _dataAccessService.createUser(createUser);
                            showSpinner = false;
                            _navigationService.navigateTo(MainScreen.id);
                          }
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          _alertService.registrationFailed(e.code, context);
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigationService.goBack();
                    },
                    child: Center(
                      child: Text(
                          S.of(context).registrationScreenBackToLoginButton,
                          style: Theme.of(context).textTheme.subtitle2),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
