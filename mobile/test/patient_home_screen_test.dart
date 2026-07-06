import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pengu_care/screens/patient_home_screen.dart';
import 'package:pengu_care/services/pairing_api.dart';
import 'package:pengu_care/services/session_manager.dart';

void main() {
  setUp(() {
    SessionManager.token = 'test-token';
  });

  testWidgets('creating an invite code shows it on screen', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(
        '{"invite_code": "ABC123"}',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: PatientHomeScreen(pairingApi: PairingApi(client: mockClient)),
      ),
    );

    await tester.tap(find.text('초대 코드 만들기'));
    await tester.pumpAndSettle();

    expect(find.text('초대 코드: ABC123'), findsOneWidget);
  });
}
