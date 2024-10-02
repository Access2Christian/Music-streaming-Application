import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_streaming_app/main.dart';

void main() {
  testWidgets('Login Screen Test', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(const MyApp());

    // Verify that the Login screen is displayed.
    expect(find.text('Login'), findsOneWidget);

    // Enter email.
    await tester.enterText(find.byKey(const Key('emailField')), 'test@example.com');

    // Enter password.
    await tester.enterText(find.byKey(const Key('passwordField')), 'password123');

    // Tap the login button.
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    // Verify that navigation to Home Screen occurs.
    expect(find.text('Home'), findsOneWidget);
  });
}
