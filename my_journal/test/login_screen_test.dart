import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:my_journal/screens/login_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
  testWidgets('WelcomeScreen is properly rendered',
      (WidgetTester tester) async {
    // Create WelcomeScreen
    final Widget welcomeScreen = WelcomeScreen();

    // Build testable WelcomeScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          const AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: welcomeScreen,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 10), EnginePhase.build,
        const Duration(minutes: 1));

    // Create Finders
    final widgetFinder = find.byWidget(welcomeScreen);
    final roundedButtonFinder = find.byType(RoundedButton);
    final faIconFinder = find.byIcon(Icons.email);
    final titleFinder = find.text('MyJournal');
    final emailTextFieldFinder = find.byKey(const Key('email'));
    final passwordTextFieldFinder = find.byKey(const Key('password'));
    final registerFinder = find.text('Register');
    final loginFinder = find.text('Log In');

    // Verify that WelcomeScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(roundedButtonFinder, findsOneWidget);
    expect(faIconFinder, findsOneWidget);
    expect(titleFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(loginFinder, findsOneWidget);
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);
  });

  testWidgets('Log In alerts are properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    final Widget welcomeScreen = WelcomeScreen();

    // Build testable LoginScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: welcomeScreen,
      ),
    );

    // Enter invalid email
    await tester.enterText(find.byKey(const Key('email')), 'lukas.tajak');
    await tester.enterText(find.byKey(const Key('password')), 'test123');

    // Tap the RoundedButton
    await tester.tap(find.text('Log In'));

    // Rebuild the widget after the state has changed.
    await tester.pump();
  });
}
