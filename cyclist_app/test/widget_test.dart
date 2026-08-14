import 'package:flutter_test/flutter_test.dart';
import 'package:vikasit_nagpur_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VikasitNagpurApp());
    expect(find.byType(VikasitNagpurApp), findsOneWidget);
  });
}
