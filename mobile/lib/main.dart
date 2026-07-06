import 'package:flutter/material.dart';

import 'screens/guardian_home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/patient_home_screen.dart';
import 'services/session_manager.dart';

void main() {
  runApp(const PenguCareApp());
}

class PenguCareApp extends StatelessWidget {
  const PenguCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengu Care',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Loads any saved login session and routes to the right screen: login if
/// nobody is signed in, otherwise the patient or guardian home screen.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<void> _loadFuture = SessionManager.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!SessionManager.isLoggedIn) {
          return const LoginScreen();
        }
        return SessionManager.isPatient
            ? const PatientHomeScreen()
            : const GuardianHomeScreen();
      },
    );
  }
}
