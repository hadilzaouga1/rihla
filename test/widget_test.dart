import 'package:flutter_test/flutter_test.dart';
import 'package:rihla/main.dart';

void main() {
  testWidgets('L\'application Rihla se lance', (WidgetTester tester) async {
    await tester.pumpWidget(const RihlaApp());
    expect(find.text('Rihla'), findsOneWidget);
  });
}
