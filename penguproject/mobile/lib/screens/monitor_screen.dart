import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../models/fall_event.dart';
import '../models/sensor_sample.dart';
import '../services/fall_detector.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  final FallDetector _detector = FallDetector();
  final List<FallEvent> _events = [];
  StreamSubscription<AccelerometerEvent>? _subscription;
  double _currentMagnitude = 0;

  @override
  void initState() {
    super.initState();
    _subscription = accelerometerEventStream().listen(_onAccelerometerEvent);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final sample = SensorSample(
      x: event.x,
      y: event.y,
      z: event.z,
      timestamp: DateTime.now(),
    );
    final fallEvent = _detector.process(sample);
    setState(() {
      _currentMagnitude = sample.magnitude;
      if (fallEvent != null) {
        _events.insert(0, fallEvent);
      }
    });
  }

  void _simulateFall() {
    final start = DateTime.now();
    _detector.process(
      SensorSample(x: 0, y: 0, z: 1.0, timestamp: start),
    );
    final fallEvent = _detector.process(
      SensorSample(
        x: 0,
        y: 0,
        z: 30.0,
        timestamp: start.add(const Duration(milliseconds: 400)),
      ),
    );
    if (fallEvent != null) {
      setState(() => _events.insert(0, fallEvent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('낙상 감지 모니터링')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('현재 가속도 크기'),
                    Text(
                      _currentMagnitude.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateFall,
              child: const Text('테스트: 낙상 시뮬레이션'),
            ),
            const SizedBox(height: 16),
            Text('감지된 이벤트 (${_events.length}건)'),
            Expanded(
              child: ListView.builder(
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return ListTile(
                    leading: const Icon(Icons.warning_amber, color: Colors.red),
                    title: Text('낙상 감지: ${event.detectedAt}'),
                    subtitle: Text(
                      '충격 크기: ${event.peakMagnitude.toStringAsFixed(2)}',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
