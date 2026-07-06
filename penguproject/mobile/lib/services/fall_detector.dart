import '../models/fall_event.dart';
import '../models/sensor_sample.dart';

/// Threshold-based fall detector using the free-fall + impact pattern common
/// in fall-detection literature: gravity briefly disappears as the phone
/// falls, then a sharp spike hits as it/the person lands.
class FallDetector {
  final double freeFallThreshold;
  final double impactThreshold;
  final Duration impactWindow;

  DateTime? _freeFallStartedAt;

  FallDetector({
    this.freeFallThreshold = 6.0,
    this.impactThreshold = 24.5,
    this.impactWindow = const Duration(seconds: 2),
  });

  /// Feed one sensor reading in. Returns a [FallEvent] the moment a fall
  /// pattern completes, otherwise null.
  FallEvent? process(SensorSample sample) {
    final magnitude = sample.magnitude;

    if (_freeFallStartedAt == null) {
      if (magnitude < freeFallThreshold) {
        _freeFallStartedAt = sample.timestamp;
      }
      return null;
    }

    final elapsed = sample.timestamp.difference(_freeFallStartedAt!);
    if (elapsed > impactWindow) {
      _freeFallStartedAt = null;
      return null;
    }

    if (magnitude > impactThreshold) {
      _freeFallStartedAt = null;
      return FallEvent(detectedAt: sample.timestamp, peakMagnitude: magnitude);
    }

    return null;
  }
}
