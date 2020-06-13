import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_journal/screens/create_entry.dart';
import 'package:my_journal/screens/my_journal_screen.dart';
import 'package:my_journal/widgets/home_card.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('MyJournal Screen is loaded and rendered properly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MyJournalScreen()));

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byIcon(Icons.lock_open), findsOneWidget);
    expect(find.byType(HomeCard), findsNWidgets(3));
  });

  testWidgets('HomeCard 1 is clickable and navigates properly',
      (WidgetTester tester) async {
    final mockObserver = MockNavigatorObserver();
    await tester.pumpWidget(
      MaterialApp(
        home: MyJournalScreen(),
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
    expect(find.byType(IconButton), findsNWidgets(6));
    expect(find.text('How Did you feel?'), findsOneWidget);
  });
}
