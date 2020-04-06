import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_journal/constants.dart';
import 'package:my_journal/widgets/rounded_button.dart';
import 'my_journal_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;

  void alertUser(String alertTitle, String alertMessage) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.android) {
          return AlertDialog(
            title: Text(alertTitle),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(alertMessage),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text(alertTitle),
            content: Text(alertMessage),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldInputDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldInputDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      setState(() {
                        showSpinner = false;
                      });

                      Navigator.pushNamed(context, MyJournalScreen.id);
                    }
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    // TODO: Show error message to user
                    print(e);
                    switch (e.code) {
                      case 'ERROR_INVALID_EMAIL':
                        {
                          alertUser(
                            'Login Failed',
                            'Please enter a valid email address.',
                          );
                        }
                        break;
                      case 'ERROR_USER_NOT_FOUND':
                        {
                          alertUser(
                            'Login Failed',
                            'Sorry, we can\'t find an account with this email address.',
                          );
                        }
                        break;
                      case 'ERROR_WRONG_PASSWORD':
                        {
                          alertUser(
                            'Login Failed',
                            'Username or password is invalid. Please try again.',
                          );
                        }
                        break;
                      default:
                        {
                          alertUser(
                            'Login Failed',
                            'Something went wrong. Please try again later',
                          );
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
