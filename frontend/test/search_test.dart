import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_streaming_app/main.dart';

void main() {
  testWidgets('Search Music Test', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const MyApp());

    // Navigate to the Home Screen if not already there.
    // This depends on your app's navigation logic.

    // Enter search query.
    await tester.enterText(find.byKey(const Key('searchField')), 'Imagine Dragons');

    // Tap the search button.
    await tester.tap(find.byKey(const Key('searchButton')));
    await tester.pump();

    // Verify that search results are displayed.
    expect(find.text('Imagine Dragons'), findsWidgets);
  });
}
