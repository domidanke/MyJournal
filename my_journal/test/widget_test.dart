// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/login_screen.dart';
import 'package:my_journal/screens/my_journal_screen.dart';
import 'package:my_journal/screens/register_screen.dart';
import 'package:my_journal/screens/welcome_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
  testWidgets('RoundedButton is properly rendered',
      (WidgetTester tester) async {
    // Create RoundedButton
    Widget roundedButton = RoundedButton(
      text: 'Test',
      color: Colors.lightBlueAccent,
      onPressed: () {},
    );

    // Build testable RoundedButton using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: roundedButton,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(roundedButton);
    final buttonTextFinder = find.text('Test');

    // Verify that RoundedButton exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(buttonTextFinder, findsOneWidget);
  });

  testWidgets('WelcomeScreen is properly rendered',
      (WidgetTester tester) async {
    // Create WelcomeScreen
    Widget welcomeScreen = WelcomeScreen();

    // Build testable WelcomeScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: welcomeScreen,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(welcomeScreen);
    final titleFinder = find.text('myJournal');
    final registerFinder = find.text('Register');
    final loginFinder = find.text('Log In');

    // Verify that WelcomeScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(loginFinder, findsOneWidget);
  });

  testWidgets('RegisterScreen is properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    Widget registrationScreen = RegistrationScreen();

    // Build testable RegistrationScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: registrationScreen,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(registrationScreen);

    // Verify that RegistrationScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('LoginScreen is properly rendered', (WidgetTester tester) async {
    // Create LoginScreen
    Widget loginScreen = LoginScreen();

    // Build testable RegistrationScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: loginScreen,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(loginScreen);

    // Verify that LoginScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
  });

  testWidgets('MyJournalScreen is properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    Widget myJournalScreen = MyJournalScreen();

    // Build testable RegistrationScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: myJournalScreen,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(myJournalScreen);

    // Verify that MyJournalScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
  });
}
