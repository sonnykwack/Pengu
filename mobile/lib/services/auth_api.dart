import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class AuthResult {
  final String token;
  final String role;

  const AuthResult({required this.token, required this.role});
}

class AuthApi {
  final String baseUrl;
  final http.Client _client;

  AuthApi({this.baseUrl = defaultBackendBaseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<AuthResult> signup(String email, String password, String role) {
    return _authRequest('/auth/signup', {
      'email': email,
      'password': password,
      'role': role,
    });
  }

  Future<AuthResult> login(String email, String password) {
    return _authRequest('/auth/login', {'email': email, 'password': password});
  }

  Future<AuthResult> _authRequest(String path, Map<String, String> body) async {
    final response = await _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractError(response));
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return AuthResult(
      token: json['access_token'] as String,
      role: json['role'] as String,
    );
  }

  String _extractError(http.Response response) {
    try {
      final json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      return json['detail'] as String? ?? '오류가 발생했습니다';
    } catch (_) {
      return '오류가 발생했습니다 (${response.statusCode})';
    }
  }
}
