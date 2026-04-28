import 'package:flutter_test/flutter_test.dart';
import 'package:booknest/main.dart';

void main() {
  testWidgets('BookNest app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BookNestApp());
    expect(find.byType(BookNestApp), findsOneWidget);
  });
}