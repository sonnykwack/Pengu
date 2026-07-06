import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pengu_care/screens/guardian_home_screen.dart';
import 'package:pengu_care/services/pairing_api.dart';
import 'package:pengu_care/services/session_manager.dart';

void main() {
  setUp(() {
    SessionManager.token = 'test-token';
  });

  testWidgets('redeeming an invite code shows a success message', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response('{"status": "connected"}', 200);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: GuardianHomeScreen(pairingApi: PairingApi(client: mockClient)),
      ),
    );

    await tester.enterText(find.byType(TextField), 'ABC123');
    await tester.tap(find.text('연결하기'));
    await tester.pumpAndSettle();

    expect(find.textContaining('연결되었습니다'), findsOneWidget);
  });
}
