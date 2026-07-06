import 'package:flutter/material.dart';

import '../services/pairing_api.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';
import 'monitor_screen.dart';
import 'symptom_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  final PairingApi? pairingApi;

  const PatientHomeScreen({super.key, this.pairingApi});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  late final PairingApi _pairingApi = widget.pairingApi ?? PairingApi();
  String? _inviteCode;
  String? _errorMessage;

  Future<void> _createInvite() async {
    try {
      final code = await _pairingApi.createInvite(SessionManager.token!);
      setState(() {
        _inviteCode = code;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = '$e');
    }
  }

  Future<void> _logout() async {
    await SessionManager.clear();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengu Care (환자)'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MonitorScreen()),
              ),
              child: const Text('낙상 감지 모니터링 시작'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SymptomScreen()),
              ),
              child: const Text('증상 입력하기'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const Text('보호자 연결'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createInvite,
              child: const Text('초대 코드 만들기'),
            ),
            if (_inviteCode != null) ...[
              const SizedBox(height: 12),
              Text(
                '초대 코드: $_inviteCode',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Text('이 코드를 보호자에게 알려주세요'),
            ],
            if (_errorMessage != null) Text(_errorMessage!),
          ],
        ),
      ),
    );
  }
}
