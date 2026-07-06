import 'package:flutter_test/flutter_test.dart';

import 'package:pengu_care/main.dart';

void main() {
  testWidgets('Home page shows title and monitoring entry point', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenguCareApp());

    expect(find.text('Pengu Care'), findsOneWidget);
    expect(find.text('낙상 감지 모니터링 시작'), findsOneWidget);
  });
}
