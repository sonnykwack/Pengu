import 'dart:math';

class SensorSample {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  SensorSample({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  /// Signal Magnitude Vector: total acceleration regardless of direction.
  /// At rest this is ~9.8 (gravity). In free fall it drops near 0.
  double get magnitude => sqrt(x * x + y * y + z * z);
}
