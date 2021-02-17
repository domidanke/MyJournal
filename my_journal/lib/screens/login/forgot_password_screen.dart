import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../services/locator.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final AuthService _authService = locator<AuthService>();

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgot_password_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showSpinner = false;
  String email;

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
                  Text(S.of(context).forgotPasswordScreenTopLabel,
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
                              .forgotPasswordScreenEmailTextFieldHint,
                          hintStyle: Theme.of(context).textTheme.headline4),
                      onChanged: (value) {
                        //Do something with the user input.
                        email = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    text: S.of(context).forgotPasswordScreenRequestResetButton,
                    onPressed: () async {
                      if (email == null) {
                        FocusScope.of(context).unfocus();
                        _alertService.generalAlert(
                            S.of(context).forgotPasswordScreenErrorTitle,
                            S.of(context).forgotPasswordScreenErrorEmptyFields,
                            context);
                      } else {
                        setState(() {
                          showSpinner = true;
                        });

                        await _authService
                            .requestPasswordReset(email)
                            .then((_) {
                          setState(() {
                            showSpinner = false;
                          });
                          _alertService.passwordResetSucceeded(context);
                          return null;
                        }).catchError((Object error) {
                          setState(() {
                            showSpinner = false;
                          });
                          //print(error);
                          _alertService.passwordResetFailed(error, context);
                          return null;
                        });
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
                          S.of(context).forgotPasswordScreenBackToLoginButton,
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
