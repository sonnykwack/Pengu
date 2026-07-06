import 'package:flutter/material.dart';

import '../models/care_report.dart';
import '../services/report_api.dart';
import '../services/session_manager.dart';

class SymptomScreen extends StatefulWidget {
  final ReportApi? reportApi;

  const SymptomScreen({super.key, this.reportApi});

  @override
  State<SymptomScreen> createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  late final ReportApi _reportApi = widget.reportApi ?? ReportApi();
  final _controller = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  CareReport? _report;

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _report = null;
    });

    try {
      final report = await _reportApi.submitSymptom(SessionManager.token!, text);
      setState(() => _report = report);
    } catch (e) {
      setState(() => _errorMessage = '리포트를 만들지 못했어요: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('증상 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('어디가 어떻게 아픈지 편하게 말하듯이 적어주세요. (키보드의 마이크 버튼으로 음성 입력도 가능해요)'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예: 아침부터 허리가 계속 아파요',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: Text(_isLoading ? '전송 중...' : '보호자에게 보낼 리포트 만들기'),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null) Text(_errorMessage!),
            if (_report != null) _ReportCard(report: _report!),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final CareReport report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('심각도: ${report.severity}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(report.summary),
            const SizedBox(height: 8),
            Text('권장 조치: ${report.recommendedAction}'),
          ],
        ),
      ),
    );
  }
}
