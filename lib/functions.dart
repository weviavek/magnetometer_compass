import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:magnetometer_compass/model/acc_medel.dart';
import 'model/magnetometer_event_model.dart';

// Class handling magnetometer functionality
class Magnetometer {
  // Instances and variables initialization
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

  // Stream controllers for accelerometer, magnetometer, and magnetic strength events
  static final _accelerometerStreamController =
      StreamController<AccelerometerEvent>();
  static final _magnetometerStreamController = StreamController<double>();
  static final _magneticStrengthStreamController = StreamController<double>();

  // Streams to provide access to accelerometer, magnetometer, and magnetic strength events
  static Stream<AccelerometerEvent> get accelerometerStream =>
      _accelerometerStreamController.stream;
  static Stream<double> get magnetometerStream =>
      _magnetometerStreamController.stream;
  static Stream<double> get magnetenPowerStream =>
      _magneticStrengthStreamController.stream;

  // Method to start magnetometer functionality
  startagnetometer() {
    channel.setMethodCallHandler((call) {
      // Handling magnetometer data
      if (call.method == 'magnetometerData') {
        currentMagnetometerEvent = MagnetometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        double headingRadians =
            atan2(currentMagnetometerEvent.y, currentMagnetometerEvent.x);
        double newHeadingDegrees = (headingRadians * 180 / pi) - 90;

        // Adjusting heading degrees
        newHeadingDegrees = (newHeadingDegrees % 360 + 360) % 359;
        if (canUpdate) {
          currentTime = DateTime.now();
          headingDegrees = newHeadingDegrees.roundToDouble();
          magneticFieldStrength =
              calculateMagneticFieldStrength(currentMagnetometerEvent);

          // Sending events to respective streams
          _accelerometerStreamController.sink.add(currentAccelerometerEvent);
          _magnetometerStreamController.sink.add(headingDegrees);
          _magneticStrengthStreamController.sink.add(magneticFieldStrength);
        }
      }
      // Handling gyroscope data
      if (call.method == 'gyroData') {
        canUpdate = (lastData - call.arguments[0]).abs() >= .05;
        currentAccelerometerEvent = AccelerometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        if (canUpdate) {
          lastData = call.arguments[0];
        }
      }
      return Future(() => null);
    });

    // Invoking methods to start streaming magnetometer and gyroscope data
    channel.invokeMethod('streamMagnetometer');
    channel.invokeMethod('gyro');
  }

  // Method to dispose of stream controllers
  void dispose() {
    _magnetometerStreamController.close();
  }

  // Method to calculate magnetic field strength
  static double calculateMagneticFieldStrength(MagnetometerEvent data) {
    double bx = data.x;
    double by = data.y;
    double bz = data.z;
    magneticFieldStrength = sqrt(bx * bx + by * by + bz * bz);

    return magneticFieldStrength;
  }
}

// Class handling flashlight functionality
class Flashlight {
  static const channel = MethodChannel('magnetometer');

  // Method to turn on flashlight
  static Future<bool> on() async {
    return await channel.invokeMethod('setFlashlightOn');
  }

  // Method to turn off flashlight
  static Future<bool> off() async {
    return await channel.invokeMethod('setFlashlightOff');
  }
}
