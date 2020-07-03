import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:my_journal/screens/create_entry.dart';
import 'package:my_journal/screens/my_journal_screen.dart';
import 'package:my_journal/screens/select_entry.dart';
import 'package:my_journal/widgets/rounded_button.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  FirebaseUser loggedInUser;

  testWidgets('MyJournal Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: MyJournalScreen(
      loggedInUser: loggedInUser,
    )));

    expect(find.text('Welcome Back'), findsOneWidget);
    //expect(find.byIcon(Icons.lock_open), findsOneWidget);
    //expect(find.byType(HomeCard), findsNWidgets(3));
  });

  testWidgets(
      'HomeCard Create Entries is clickable, navigates properly, and renders Create Entry correctly',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: MyJournalScreen(
          loggedInUser: loggedInUser,
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    final cardButton = find.byKey(const Key('CreateEntryKey'));
    expect(cardButton, findsOneWidget);
    await tester.tap(cardButton);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// Navigated page is present in the screen.
    expect(find.byType(CreateEntry), findsOneWidget);
    expect(
        find.text(DateFormat.yMMMd().format(DateTime.now())), findsOneWidget);
    expect(find.byIcon(Icons.date_range), findsOneWidget);
    expect(find.text('Change Date'), findsOneWidget);
    expect(find.text('How Did You feel?'), findsOneWidget);
    expect(find.byType(IconButton), findsNWidgets(7));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Special Day'), findsOneWidget);
    expect(find.byType(RoundedButton), findsOneWidget);
    expect(find.text('Save Journal Entry'), findsOneWidget);
  });

  testWidgets(
      'HomeCard View Entries is clickable, navigates properly, and renders empty Select Entry List correctly',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: MyJournalScreen(
          loggedInUser: loggedInUser,
        ),
        navigatorObservers: [mockObserver],
      ),
    );

    final cardButton = find.byKey(const Key('SelectEntriesKey'));
    expect(cardButton, findsOneWidget);
    await tester.tap(cardButton);
    await tester.pumpAndSettle();

    /// Verify that a push event happened
    verify(mockObserver.didPush(any, any));

    /// Navigated page is present in the screen.
    expect(find.byType(SelectEntry), findsOneWidget);
    expect(find.text("You don't have any\nEntries yet"), findsOneWidget);
  });
}
