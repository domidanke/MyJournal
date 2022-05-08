import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/screens/login/registration_screen.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

import '../../main.dart';

final NavigationService _navigationService = locator<NavigationService>();
final AlertService _alertService = locator<AlertService>();
final AuthService _authService = locator<AuthService>();

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool showSpinner = false;
  String email;
  String password;
  String emailHint = 'Enter your email';
  FocusNode emailFocusNode = FocusNode();
  String passwordHint = 'Enter your password';
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

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
                  Text('MyJournal',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3),
                  const SizedBox(
                    height: 36.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextField(
                      key: const Key('login_email'),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      focusNode: emailFocusNode,
                      decoration: kTextFieldInputDecoration.copyWith(
                          prefixIcon: const Icon(
                            Icons.mail,
                          ),
                          hintText: emailFocusNode.hasFocus ? '' : emailHint,
                          hintStyle: Theme.of(context).textTheme.headline6),
                      onChanged: (String value) {
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
                      key: const Key('login_password'),
                      obscureText: true,
                      focusNode: passwordFocusNode,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldInputDecoration.copyWith(
                        prefixIcon: const Icon(Icons.vpn_key),
                        hintText:
                            passwordFocusNode.hasFocus ? '' : passwordHint,
                        hintStyle: Theme.of(context).textTheme.headline6,
                      ),
                      onChanged: (String value) {
                        password = value;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  RoundedButton(
                    text: 'Log In',
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
                          await _authService.signIn(email, password);
                          setState(() {
                            showSpinner = false;
                          });
                          final isDarkMode = await _authService.getIsDarkMode();
                          MyJournalApp.themeNotifier.value =
                              isDarkMode ? ThemeMode.dark : ThemeMode.light;
                          _navigationService.navigateHome();
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          _alertService.loginFailed(e.code, context);
                        }
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      _navigationService.navigateTo(RegistrationScreen.id);
                    },
                    child: Center(
                        child: Text('Register',
                            style: Theme.of(context).textTheme.subtitle2)),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     print('FORGOT PASSWORD');
                  //   },
                  //   child: Center(
                  //       child: Text('Forgot Password',
                  //           style: Theme.of(context).textTheme.subtitle2)),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
