import 'dart:math';

import 'package:flutter/material.dart';
import 'package:magnetometer_compass/about_dialog.dart';
import 'package:magnetometer_compass/functions.dart';
import 'package:magnetometer_compass/model/acc_medel.dart';
import 'package:magnetometer_compass/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool status = false;
  double headingDegrees = 0;
  @override
  void initState() {
    Magnetometer().startagnetometer();
    Flashlight.off();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                color: Colors.black,
                child: Center(
                  child: StreamBuilder<double>(
                      stream: Magnetometer.magnetometerStream,
                      builder: (context, headingDegrees) {
                        return Transform.rotate(
                            angle: headingDegrees.hasData
                                ? headingDegrees.data! * -(pi / 180)
                                : 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                  'assets/images/compass_white.png'),
                            ));
                      }),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      InkWell(
                        child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: AboutIcon()),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => const AboutApp(),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      InkWell(
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: status
                                ? const OnLightIcon()
                                : const OffLightIcon()),
                        onTap: () async {
                          status
                              ? await Flashlight.off().then((value) {
                                  setState(() {
                                    status = value;
                                  });
                                })
                              : await Flashlight.on().then((value) {
                                  setState(() {
                                    status = value;
                                  });
                                });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15, left: 12),
                  child: MagneticStrength(),
                ),
              ),
              StreamBuilder<AccelerometerEvent>(
                  stream: Magnetometer.accelerometerStream,
                  builder: (context, snapshot) {
                    return Positioned(
                        left: snapshot.hasData
                            ? 150 + ((snapshot.data!.x / 10) * 150)
                            : 0,
                        top: snapshot.hasData
                            ? 150 + ((snapshot.data!.y / 10) * 150)
                            : 0,
                        child:const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                          ),
                        ));
                  }),
            ],
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
