import 'package:count_frontend/screens/scan_screen/scan_food_input.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';


void main() {
  testWidgets('ScanFoodScreen UI test', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(MaterialApp(home: ScanFoodScreen()));

    // Verify initial state
    expect(find.text('Scan Food'), findsOneWidget);
    expect(find.text('No image selected'), findsOneWidget);
    expect(find.text('Take Picture'), findsOneWidget);
    
    // Tap on 'Take Picture' button
    await tester.tap(find.text('Take Picture'));
    await tester.pump();

    // Check if image picker was triggered (mock needed for full test)
    // Note: Full integration test requires mocking ImagePicker
  });
}
