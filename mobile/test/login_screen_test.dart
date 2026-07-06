import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pengu_care/screens/login_screen.dart';
import 'package:pengu_care/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('logging in as a patient navigates to the patient home screen', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response(
        '{"access_token": "fake-token", "role": "patient"}',
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authApi: AuthApi(client: mockClient))),
    );

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), 'patient@example.com');
    await tester.enterText(textFields.at(1), 'pw123456');
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();

    expect(find.text('Pengu Care (환자)'), findsOneWidget);
  });
}
