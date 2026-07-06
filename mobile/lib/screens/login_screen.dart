import 'package:flutter/material.dart';

import '../services/auth_api.dart';
import '../services/session_manager.dart';
import 'guardian_home_screen.dart';
import 'patient_home_screen.dart';

class LoginScreen extends StatefulWidget {
  final AuthApi? authApi;

  const LoginScreen({super.key, this.authApi});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthApi _authApi = widget.authApi ?? AuthApi();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignup = false;
  String _role = 'patient';
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = _isSignup
          ? await _authApi.signup(
              _emailController.text.trim(),
              _passwordController.text,
              _role,
            )
          : await _authApi.login(
              _emailController.text.trim(),
              _passwordController.text,
            );

      await SessionManager.save(result.token, result.role);
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => result.role == 'patient'
              ? const PatientHomeScreen()
              : const GuardianHomeScreen(),
        ),
      );
    } catch (e) {
      setState(() => _errorMessage = '$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengu Care')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            if (_isSignup) ...[
              const SizedBox(height: 16),
              const Text('역할을 선택하세요'),
              RadioListTile<String>(
                title: const Text('환자로 사용'),
                value: 'patient',
                groupValue: _role,
                onChanged: (value) => setState(() => _role = value!),
              ),
              RadioListTile<String>(
                title: const Text('보호자로 사용'),
                value: 'guardian',
                groupValue: _role,
                onChanged: (value) => setState(() => _role = value!),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: Text(_isSignup ? '가입하기' : '로그인'),
            ),
            TextButton(
              onPressed: () => setState(() => _isSignup = !_isSignup),
              child: Text(_isSignup ? '이미 계정이 있어요' : '계정이 없어요, 가입할게요'),
            ),
            if (_errorMessage != null) Text(_errorMessage!),
          ],
        ),
      ),
    );
  }
}
