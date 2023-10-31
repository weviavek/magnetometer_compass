import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:magnetometer_compass/model/acc_medel.dart';
import 'model/magnetometer_event_model.dart';

class Magnetometer {
  MagnetometerEvent currentMagnetometerEvent =
      MagnetometerEvent(x: 0, y: 0, z: 0);
  AccelerometerEvent currentAccelerometerEvent =
      AccelerometerEvent(x: 0, y: 0, z: 0);
  DateTime currentTime = DateTime.now();
  bool canUpdate = true;
  final channel = const MethodChannel('magnetometer');
  double headingDegrees = 0;
  double lastData = 0;
  static double magneticFieldStrength = 0;

  static final _accelerometerStreamController = StreamController<AccelerometerEvent>();
  static final _magnetometerStreamController = StreamController<double>();
  static final _magneticStrengthStreamController = StreamController<double>();

  static Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerStreamController.stream;
  static Stream<double> get magnetometerStream =>
      _magnetometerStreamController.stream;
  static Stream<double> get magnetenPowerStream =>
      _magneticStrengthStreamController.stream;

  startagnetometer() {
    channel.setMethodCallHandler((call) {
      if (call.method == 'magnetometerData') {
        currentMagnetometerEvent = MagnetometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        double headingRadians =
            atan2(currentMagnetometerEvent.y, currentMagnetometerEvent.x);
        double newHeadingDegrees = (headingRadians * 180 / pi) - 90;

        newHeadingDegrees = (newHeadingDegrees % 360 + 360) % 359;
          currentTime = DateTime.now();
          headingDegrees = newHeadingDegrees.roundToDouble();
          magneticFieldStrength =
              calculateMagneticFieldStrength(currentMagnetometerEvent);
          _accelerometerStreamController.sink.add(currentAccelerometerEvent);
          _magnetometerStreamController.sink.add(headingDegrees);
          _magneticStrengthStreamController.sink.add(magneticFieldStrength);
      }
      if (call.method == 'gyroData') {
       // canUpdate = (lastData - call.arguments).abs() >= 0.02;
        currentAccelerometerEvent = AccelerometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        if (canUpdate) {
          lastData = call.arguments;
        }
      }
      return Future(() => null);
    });
    channel.invokeMethod('streamMagnetometer');

    channel.invokeMethod('gyro');
  }

  void dispose() {
    _magnetometerStreamController.close();
  }

  static double calculateMagneticFieldStrength(MagnetometerEvent data) {
    double bx = data.x;
    double by = data.y;
    double bz = data.z;
    magneticFieldStrength = sqrt(bx * bx + by * by + bz * bz);

    return magneticFieldStrength;
  }
}

class Flashlight {
  static const channel = MethodChannel('magnetometer');
  static Future<bool> on() async {
    return await channel.invokeMethod('setFlashlightOn');
  }

  static Future<bool> off() async {
    return await channel.invokeMethod('setFlashlightOff');
  }
}
