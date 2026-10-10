import 'package:flutter_test/flutter_test.dart';
import 'package:madrasah_app/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(MadrasahApp());
  });
}
