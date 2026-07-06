import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pengu_care/screens/symptom_screen.dart';
import 'package:pengu_care/services/report_api.dart';
import 'package:pengu_care/services/session_manager.dart';

void main() {
  setUp(() {
    SessionManager.token = 'test-token';
  });

  testWidgets('submitting symptom text shows the generated report', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(
        '{"summary": "허리 통증 호소", "severity": "중등도", '
        '"recommended_action": "안정을 취하고 지켜봐 주세요"}',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: SymptomScreen(reportApi: ReportApi(client: mockClient)),
      ),
    );

    await tester.enterText(find.byType(TextField), '허리가 아파요');
    await tester.tap(find.text('보호자에게 보낼 리포트 만들기'));
    await tester.pumpAndSettle();

    expect(find.text('심각도: 중등도'), findsOneWidget);
    expect(find.text('허리 통증 호소'), findsOneWidget);
  });
}
