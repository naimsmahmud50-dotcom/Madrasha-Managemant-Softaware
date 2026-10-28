import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madrasah_app/features/academic/teacher_evaluation_screen.dart';

void main() {
  testWidgets('TeacherEvaluationScreen renders form and switches tabs smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TeacherEvaluationScreen(),
      ),
    );

    // Verify AppBar title
    expect(find.text('Teacher Evaluation & KPI'), findsOneWidget);

    // Verify tabs
    expect(find.text('New Evaluation'), findsOneWidget);
    expect(find.text('Past Records'), findsOneWidget);

    // Verify default criteria
    expect(find.text('Tarbiyah & Sunnah Modeling'), findsOneWidget);
    expect(find.text('Live Evaluation Score'), findsOneWidget);

    // Switch to Past Records tab
    await tester.tap(find.text('Past Records'));
    await tester.pumpAndSettle();

    // Verify past evaluations appear
    expect(find.text('Qari Ibrahim Khalil'), findsOneWidget);
    expect(find.text('Mawlana Abdur Rahman'), findsOneWidget);
  });
}
