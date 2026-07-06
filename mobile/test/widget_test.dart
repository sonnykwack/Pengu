import 'package:flutter_test/flutter_test.dart';
import 'package:pengu_care/main.dart';
import 'package:pengu_care/services/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    SessionManager.token = null;
    SessionManager.role = null;
  });

  testWidgets('shows the login screen when nobody is signed in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenguCareApp());
    await tester.pumpAndSettle();

    expect(find.text('Pengu Care'), findsOneWidget);
    expect(find.text('로그인'), findsOneWidget);
  });
}
