import 'package:flutter/material.dart';

import 'screens/monitor_screen.dart';

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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengu Care')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MonitorScreen()),
            );
          },
          child: const Text('낙상 감지 모니터링 시작'),
        ),
      ),
    );
  }
}
