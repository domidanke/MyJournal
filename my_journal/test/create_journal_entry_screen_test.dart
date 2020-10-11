import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_journal/generated/l10n.dart';
import 'package:my_journal/screens/create_journal_entry_screen.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

String formatDate(date) {
  return date.month.toString() +
      '-' +
      date.day.toString() +
      '-' +
      date.year.toString();
}

void main() {
  testWidgets('CreateJournalEntryScreen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(localizationsDelegates: [
      const AppLocalizationDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ], home: CreateJournalEntryScreen()));

    await tester.pumpAndSettle(const Duration(seconds: 10), EnginePhase.build,
        const Duration(minutes: 1));

    expect(find.byType(CreateJournalEntryScreen), findsOneWidget);
    expect(find.text(formatDate(DateTime.now())), findsOneWidget);

    expect(find.byIcon(Icons.date_range), findsOneWidget);
    expect(find.byKey(const Key('changeDateButton')), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(7));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byKey(const Key('specialDayButton')), findsOneWidget);
    expect(find.byType(RoundedButton), findsOneWidget);
  });

  testWidgets('TextFields receive and render user input correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(localizationsDelegates: [
      const AppLocalizationDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ], home: CreateJournalEntryScreen()));

    await tester.pumpAndSettle(const Duration(seconds: 10), EnginePhase.build,
        const Duration(minutes: 1));

    final headerTextField = find.byKey(const Key('headerTextFieldKey'));
    expect(headerTextField, findsOneWidget);
    final contentTextField = find.byKey(const Key('contentTextFieldKey'));
    expect(contentTextField, findsOneWidget);

    /// TODO: Test user input
    //await tester.enterText(headerTextField, 'Test Header');
    //expect(find.text('Test Header'), findsOneWidget);
    //await tester.enterText(
    //    headerTextField, 'We want a max of 15 characters in the header');
    //expect(find.text('We want a max o'), findsOneWidget);
    //await tester.enterText(contentTextField,
    //    'This is a Test for the content a user ought to create');
    //expect(find.text('This is a Test for the content a user ought to create'),
    //    findsOneWidget);
  });

  testWidgets('FaveIconButton changes correctly on tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(localizationsDelegates: [
      const AppLocalizationDelegate(),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ], home: CreateJournalEntryScreen()));

    await tester.pumpAndSettle(const Duration(seconds: 10), EnginePhase.build,
        const Duration(minutes: 1));

    /// TODO: Test user input
    //final faveIcon = find.byIcon(Icons.favorite_border);
    //await tester.tap(faveIcon);
    //await tester.pumpAndSettle();
    //expect(find.byIcon(Icons.favorite), findsOneWidget);
    //final faveIconTapped = find.byIcon(Icons.favorite);
    //await tester.tap(faveIconTapped);
    //await tester.pumpAndSettle();
    //expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
