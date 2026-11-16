import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aj_ai/main.dart';

void main() {
  testWidgets('AJ AI application launches successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AJAIApp());

    expect(find.byType(AJAIApp), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
