import 'package:flutter/material.dart';
import 'package:magnetometer_compass/functions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double headingDegrees = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Center(
                child: StreamBuilder<double>(
                    stream: Magnetometer().magnetometerStream,
                    builder: (context, headingDegrees) {
                      return Transform.rotate(
                          angle: headingDegrees.hasData
                              ? headingDegrees.data! *
                                  -(3.1415926535897932 / 180)
                              : 0,
                          child:
                              Image.asset('assets/images/compass_white.png'));
                    }),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final status = await Flashlight.on();
                    print(status);
                  },
                  child: Text("ON")),
              ElevatedButton(
                  onPressed: () async {
                    final status = await Flashlight.off();
                    print(status);
                  },
                  child: Text("OFF"))
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
