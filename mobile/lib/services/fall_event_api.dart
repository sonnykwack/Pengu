import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class FallEventApi {
  final String baseUrl;
  final http.Client _client;

  FallEventApi({this.baseUrl = defaultBackendBaseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<void> reportFall(
    String token, {
    required double peakMagnitude,
    required DateTime detectedAt,
  }) async {
    await _client.post(
      Uri.parse('$baseUrl/events/fall'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'peak_magnitude': peakMagnitude,
        'detected_at': detectedAt.toUtc().toIso8601String(),
      }),
    );
  }
}
