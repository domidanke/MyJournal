import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:my_journal/screens/registration_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

void main() {
  testWidgets('RegistrationScreen is properly rendered',
      (WidgetTester tester) async {
    // Create RegistrationScreen
    final Widget registrationScreen = RegistrationScreen();

    // Build testable RegistrationScreen using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          const AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: registrationScreen,
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 10), EnginePhase.build,
        const Duration(minutes: 1));

    // Create Finders
    final widgetFinder = find.byWidget(registrationScreen);
    final roundedButtonFinder = find.byType(RoundedButton);
    final registerFinder = find.text('Register');
    final textFieldFinder = find.byType(TextField);
    final emailTextFieldFinder = find.byKey(const Key('email'));
    final passwordTextFieldFinder = find.byKey(const Key('password'));

    // Verify that RegistrationScreen exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(roundedButtonFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);
    expect(textFieldFinder, findsNWidgets(2));
    expect(emailTextFieldFinder, findsOneWidget);
    expect(passwordTextFieldFinder, findsOneWidget);
  });

  //Todo: Test positive and negative resgistration scenarios
}
