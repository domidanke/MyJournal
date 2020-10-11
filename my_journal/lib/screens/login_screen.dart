import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:my_journal/screens/journal_entry_overview_screen.dart';
import 'package:my_journal/widgets/custom_alert.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  void alertUser(String alertMessage) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Login failed',
          alertMessage: alertMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                key: const Key('email'),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldInputDecoration.copyWith(
                  hintText: S.of(context).loginScreenEmailTextFieldHint,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (String value) {
                  //Do something with the user input.
                  email = value;
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                key: const Key('password'),
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldInputDecoration.copyWith(
                  hintText: S.of(context).loginScreenPasswordTextFieldHint,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (String value) {
                  //Do something with the user input.
                  password = value;
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: S.of(context).loginScreenLoginButton,
                color: const Color(0xff5f2c82),
                onPressed: () async {
                  if (password == null || email == null) {
                    alertUser('Email and password cannot be blank.');
                  } else {
                    setState(() {
                      showSpinner = true;
                    });

                    try {
                      final AuthResult authResult =
                          await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                      if (authResult != null) {
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    JournalEntryOverviewScreen()));
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      print(e);
                      switch (e.code) {
                        case 'ERROR_INVALID_EMAIL':
                          {
                            alertUser(
                                S.of(context).loginScreenErrorInvalidEmail);
                          }
                          break;
                        case 'ERROR_USER_NOT_FOUND':
                          {
                            alertUser(
                                S.of(context).loginScreenErrorUserNotFound);
                          }
                          break;
                        case 'ERROR_WRONG_PASSWORD':
                          {
                            alertUser(
                                S.of(context).loginScreenErrorWrongPassword);
                          }
                          break;
                        default:
                          {
                            alertUser(S.of(context).loginScreenErrorDefault);
                          }
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
