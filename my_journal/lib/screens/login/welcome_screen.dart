import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/screens/login/loading_screen.dart';
import 'package:my_journal/screens/login/registration_screen.dart';
import 'package:my_journal/services/alert_service.dart';
import 'package:my_journal/services/auth_service.dart';
import 'package:my_journal/services/locator.dart';
import 'package:my_journal/services/navigation_service.dart';
import 'package:my_journal/utils/constants.dart';
import 'package:my_journal/widgets/buttons/rounded_button.dart';

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
                          prefixIcon: const Icon(
                            Icons.mail,
                          ),
                          hintText: 'Enter your email',
                          hintStyle: Theme.of(context).textTheme.headline4),
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
                      key: const Key('password'),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      decoration: kTextFieldInputDecoration.copyWith(
                        prefixIcon: const Icon(Icons.vpn_key),
                        hintText: 'Enter your password',
                        hintStyle: Theme.of(context).textTheme.headline4,
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
                          final authResult =
                              await _authService.signIn(email, password);
                          if (authResult != null) {
                            setState(() {
                              showSpinner = false;
                            });
                            _navigationService.navigateTo(LoadingScreen.id);
                          }
                        } catch (e) {
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
                  GestureDetector(
                    onTap: () {
                      print('FORGOT PASSWORD');
                    },
                    child: Center(
                        child: Text('Forgot Password',
                            style: Theme.of(context).textTheme.subtitle2)),
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
