import 'package:flutter/material.dart';

import '../services/pairing_api.dart';
import '../services/session_manager.dart';
import 'login_screen.dart';

class GuardianHomeScreen extends StatefulWidget {
  final PairingApi? pairingApi;

  const GuardianHomeScreen({super.key, this.pairingApi});

  @override
  State<GuardianHomeScreen> createState() => _GuardianHomeScreenState();
}

class _GuardianHomeScreenState extends State<GuardianHomeScreen> {
  late final PairingApi _pairingApi = widget.pairingApi ?? PairingApi();
  final _codeController = TextEditingController();
  String? _statusMessage;

  Future<void> _redeem() async {
    try {
      await _pairingApi.redeemInvite(
        SessionManager.token!,
        _codeController.text.trim(),
      );
      setState(() => _statusMessage = '환자와 연결되었습니다. 앞으로 낙상/증상 알림을 이메일로 받습니다.');
    } catch (e) {
      setState(() => _statusMessage = '$e');
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
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengu Care (보호자)'),
        actions: [IconButton(onPressed: _logout, icon: const Icon(Icons.logout))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('환자에게 받은 초대 코드를 입력하세요'),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _redeem, child: const Text('연결하기')),
            if (_statusMessage != null) ...[
              const SizedBox(height: 12),
              Text(_statusMessage!),
            ],
          ],
        ),
      ),
    );
  }
}
