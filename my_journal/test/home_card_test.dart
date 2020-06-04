import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_journal/widgets/home_card.dart';

void main() {
  testWidgets('RoundedButton is properly rendered',
      (WidgetTester tester) async {
    // Create RoundedButton
    final Widget homeCard = HomeCard(
      headerText: 'This is a test',
      text: 'Click to test',
      image: const AssetImage('images/journal.jpg'),
      icon: Icon(
        Icons.email,
      ),
      onTap: () {},
    );

    // Build testable RoundedButton using WidgetTester
    await tester.pumpWidget(
      MaterialApp(
        home: homeCard,
      ),
    );

    // Create Finders
    final widgetFinder = find.byWidget(homeCard);
    final headerTextFinder = find.text('This is a test');

    // Verify that RoundedButton exists and is properly rendered
    expect(widgetFinder, findsOneWidget);
    expect(headerTextFinder, findsOneWidget);
  });

  //TODO: Test onPress functionality of RoundedButton
}
