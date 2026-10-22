import 'package:chatapp/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('welcome page opens as the app landing page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ScholarChat());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Existing customer / Get started'), findsOneWidget);
  });
}
