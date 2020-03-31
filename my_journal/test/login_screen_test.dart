// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
    final roundedButtonFinder = find.byType(RoundedButton(
      onPressed: () {},
    ).runtimeType);
    final registerFinder = find.text('Log In');
    final textFieldFinder = find.byType(TextField().runtimeType);

    // Verify that LoginScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(roundedButtonFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(textFieldFinder, findsNWidgets(2));
  });
}
