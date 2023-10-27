import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/magnetometer_event_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel = const MethodChannel('magnetometer');
  double headingDegrees = 0;
  MagnetometerEvent currentMagnetometerEvent =
      MagnetometerEvent(x: 0, y: 0, z: 0);
  @override
  void initState() {
    hi();
    super.initState();
  }

  Future hi() async {
    await channel.invokeMethod('streamMagnetometer');
    channel.setMethodCallHandler((call) {
      if (call.method == 'magnetometerData') {
        currentMagnetometerEvent = MagnetometerEvent(
            x: call.arguments[0], y: call.arguments[1], z: call.arguments[2]);
        double headingRadians =
            atan2(currentMagnetometerEvent.y, currentMagnetometerEvent.x);
        double headingDegrees = ((headingRadians * 180 / pi) - 90);
        if (headingDegrees < 0) {
          headingDegrees;
        }
        if ((this.headingDegrees - headingDegrees).abs() > 1) {
          setState(() {
            this.headingDegrees = headingDegrees.roundToDouble();
          });
        }
      }
      return Future(() => null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Center(
            child: Transform.rotate(
                angle: headingDegrees * -(3.1415926535897932 / 180),
                child: Image.asset('assets/images/compass_white.png')),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
