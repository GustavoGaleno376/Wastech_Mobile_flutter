import 'package:flutter_test/flutter_test.dart';
import 'package:wastech_mobile/main.dart';

void main() {
  testWidgets('Dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WastechApp());
    expect(find.text('Wastech'), findsOneWidget);
    expect(find.text('Olá, Gustavo'), findsOneWidget);
  });
}
