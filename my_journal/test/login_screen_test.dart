import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/screens/login_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
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
    final roundedButtonFinder = find.byType(RoundedButton);
    final registerFinder = find.text('Log In');
    final textFieldFinder = find.byType(TextField);
    final emailTextFieldFinder = find.byKey(Key('email'));
    final passwordTextFieldFinder = find.byKey(Key('password'));

    // Verify that LoginScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(roundedButtonFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(textFieldFinder, findsNWidgets(2));
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);
  });

  testWidgets('Log In alerts are properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    Widget registrationScreen = LoginScreen();

    // Build testable LoginScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: registrationScreen,
      ),
    );

    // Enter invalid email
    await tester.enterText(find.byKey(Key('email')), 'lukas.tajak');
    await tester.enterText(find.byKey(Key('password')), 'test123');

    // Tap the RoundedButton
    await tester.tap(find.text('Log In'));

    // Rebuild the widget after the state has changed.
    await tester.pump();
  });

  //Todo: Test positive and negative login scenarios
}
