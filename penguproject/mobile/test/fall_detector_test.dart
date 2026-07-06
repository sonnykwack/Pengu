import 'package:flutter_test/flutter_test.dart';
import 'package:pengu_care/models/sensor_sample.dart';
import 'package:pengu_care/services/fall_detector.dart';

SensorSample _sample(double magnitude, DateTime time) {
  // Put all the magnitude on one axis; only the magnitude matters here.
  return SensorSample(x: 0, y: 0, z: magnitude, timestamp: time);
}

void main() {
  test('detects a fall: free fall followed by impact within the window', () {
    final detector = FallDetector();
    final start = DateTime(2026, 1, 1, 12, 0, 0);

    expect(detector.process(_sample(9.8, start)), isNull); // resting
    expect(
      detector.process(_sample(1.0, start.add(const Duration(milliseconds: 100)))),
      isNull,
    ); // free fall begins

    final event = detector.process(
      _sample(30.0, start.add(const Duration(milliseconds: 400))),
    ); // impact

    expect(event, isNotNull);
    expect(event!.peakMagnitude, 30.0);
  });

  test('does not fire if impact never happens within the window', () {
    final detector = FallDetector();
    final start = DateTime(2026, 1, 1, 12, 0, 0);

    detector.process(_sample(1.0, start));
    final result = detector.process(
      _sample(30.0, start.add(const Duration(seconds: 3))),
    ); // too late

    expect(result, isNull);
  });

  test('normal walking does not trigger a false positive', () {
    final detector = FallDetector();
    final start = DateTime(2026, 1, 1, 12, 0, 0);

    final walkingMagnitudes = [9.8, 10.5, 9.2, 10.1, 9.6, 10.3, 9.9];
    for (var i = 0; i < walkingMagnitudes.length; i++) {
      final result = detector.process(
        _sample(
          walkingMagnitudes[i],
          start.add(Duration(milliseconds: 200 * i)),
        ),
      );
      expect(result, isNull);
    }
  });
}
