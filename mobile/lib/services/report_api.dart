import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/care_report.dart';
import 'api_config.dart';

class ReportApi {
  final String baseUrl;
  final http.Client _client;

  ReportApi({this.baseUrl = defaultBackendBaseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<CareReport> submitSymptom(String token, String symptomText) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/reports/symptom'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'symptom_text': symptomText}),
    );

    if (response.statusCode != 200) {
      throw Exception('리포트 생성 실패 (status ${response.statusCode})');
    }

    return CareReport.fromJson(
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
    );
  }
}
