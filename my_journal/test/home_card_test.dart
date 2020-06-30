import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/widgets/home_card.dart';

void main() {
  testWidgets('HomeCard is properly rendered', (WidgetTester tester) async {
    // Create RoundedButton
    final Widget homeCardTest = HomeCard(
      headerText: 'This is a header text',
      text: 'This is a bottom text',
      image: const AssetImage('images/journal.jpg'),
      icon: Icon(
        Icons.email,
      ),
    );

    // Build testable RoundedButton using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: homeCardTest,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(homeCardTest);
    final headerTextFinder = find.text('This is a header text');
    final bottomTextFinder = find.text('This is a bottom text');
    final iconFinder = find.byIcon(Icons.email);
    final cardButton = find.byType(GestureDetector);

    // Verify that HomeCard exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    // Verify that the header text exists and is properly rendered
    expect(headerTextFinder, findsOneWidget);
    // Verify that the bottom text exists and is properly rendered
    expect(bottomTextFinder, findsOneWidget);
    // Verify that the icon exists and is properly rendered
    expect(iconFinder, findsOneWidget);
    // Verify that the gesture detector exists
    expect(cardButton, findsOneWidget);
  });
}
