import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class PairingApi {
  final String baseUrl;
  final http.Client _client;

  PairingApi({this.baseUrl = defaultBackendBaseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<String> createInvite(String token) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/pairings/invite'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('초대 코드 생성에 실패했어요');
    }

    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return json['invite_code'] as String;
  }

  Future<void> redeemInvite(String token, String inviteCode) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/pairings/redeem'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'invite_code': inviteCode}),
    );

    if (response.statusCode != 200) {
      throw Exception('연결에 실패했어요. 초대 코드를 다시 확인해주세요');
    }
  }
}
