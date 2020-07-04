import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/screens/journal_entry_overview_screen.dart';
import 'package:my_journal/widgets/custom_alert.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  void alertUser(String alertMessage) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CustomAlert(
          alertTitle: 'Registration failed',
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
                  hintText: 'Enter your email',
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
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
                  hintText: 'Enter your password',
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Register',
                color: const Color(0xff49a09d),
                onPressed: () async {
                  if (password == null || email == null) {
                    alertUser('Email and password cannot be blank.');
                  } else {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);

                      if (newUser != null) {
                        setState(() {
                          showSpinner = false;
                        });

                        Navigator.pushNamed(
                            context, JournalEntryOverviewScreen.id);
                      }
                    } catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      switch (e.code) {
                        case 'ERROR_INVALID_EMAIL':
                          {
                            alertUser('Please enter a valid email address.');
                          }
                          break;
                        case 'ERROR_WEAK_PASSWORD':
                          {
                            alertUser(
                                'The password must be at least 6 characters long.');
                          }
                          break;
                        case 'ERROR_EMAIL_ALREADY_IN_USE':
                          {
                            alertUser(
                                'The email address is already in use by another account.');
                          }
                          break;
                        default:
                          {
                            alertUser(
                                'Something went wrong. Please try again later.');
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
