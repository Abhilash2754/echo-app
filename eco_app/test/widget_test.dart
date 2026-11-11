import 'package:flutter_test/flutter_test.dart';
import 'package:eco_app/main.dart';

void main() {
  testWidgets('Eco App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const EcoApp());

    expect(find.byType(EcoApp), findsOneWidget);
  });
}