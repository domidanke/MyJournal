import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/registration_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
  testWidgets('RegistrationScreen is properly rendered',
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
    final roundedButtonFinder = find.byType(RoundedButton);
    final registerFinder = find.text('Register');
    final textFieldFinder = find.byType(TextField);
    final emailTextFieldFinder = find.byKey(Key('email'));
    final passwordTextFieldFinder = find.byKey(Key('password'));

    // Verify that RegistrationScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(roundedButtonFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(textFieldFinder, findsNWidgets(2));
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);
  });

  testWidgets('Registration alerts are properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    Widget registrationScreen = RegistrationScreen();

    // Build testable RegistrationScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: registrationScreen,
      ),
    );

    // Enter invalid email
    await tester.enterText(find.byKey(Key('email')), 'lukas.tajak');
    await tester.enterText(find.byKey(Key('password')), 'test123');

    // Tap the RoundedButton
    await tester.tap(find.text('Register'));

    // Rebuild the widget after the state has changed.
    await tester.pump();
  });

  //Todo: Test positive and negative resgistration scenarios
}
