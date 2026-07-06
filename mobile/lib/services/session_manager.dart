import 'package:shared_preferences/shared_preferences.dart';

/// Holds the current login session in memory and persists it to disk so the
/// user doesn't have to log in again every time the app restarts.
class SessionManager {
  static String? token;
  static String? role;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('auth_token');
    role = prefs.getString('auth_role');
  }

  static Future<void> save(String newToken, String newRole) async {
    token = newToken;
    role = newRole;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', newToken);
    await prefs.setString('auth_role', newRole);
  }

  static Future<void> clear() async {
    token = null;
    role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_role');
  }

  static bool get isLoggedIn => token != null;
  static bool get isPatient => role == 'patient';
}
