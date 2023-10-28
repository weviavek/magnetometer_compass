import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'model/magnetometer_event_model.dart';

class Magnetometer {
  MagnetometerEvent currentMagnetometerEvent =
      MagnetometerEvent(x: 0, y: 0, z: 0);
  DateTime currentTime = DateTime.now();
  bool canUpdate = true;
  final channel = const MethodChannel('magnetometer');
  double headingDegrees = 0;

  final _magnetometerStreamController = StreamController<double>();

  Stream<double> get magnetometerStream => _magnetometerStreamController.stream;

  Magnetometer() {
    channel.setMethodCallHandler((call) {
      if (call.method == 'magnetometerData') {
        currentMagnetometerEvent = MagnetometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        double headingRadians =
            atan2(currentMagnetometerEvent.y, currentMagnetometerEvent.x);
        double newHeadingDegrees = ((headingRadians * 180 / pi) - 90);
        canUpdate =
            currentTime.difference(DateTime.now()).inMicroseconds.abs() > 30000
                ? true
                : false;

        if (canUpdate) {
          currentTime = DateTime.now();
          headingDegrees = newHeadingDegrees.roundToDouble();
          _magnetometerStreamController.sink.add(headingDegrees);
        }
      }
      return Future(() => null);
    });
    channel.invokeMethod('streamMagnetometer');
  }

  void dispose() {
    _magnetometerStreamController.close();
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
