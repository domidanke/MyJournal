import 'package:flutter/material.dart';
import 'package:my_journal/screens/my_journal_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';
import 'package:my_journal/constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
              text: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, MyJournalScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
