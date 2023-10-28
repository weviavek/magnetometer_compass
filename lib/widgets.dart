import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magnetometer_compass/functions.dart';

class OffLightIcon extends StatelessWidget {
  const OffLightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.flashlight_off_rounded,
      color: Colors.black,
      size: 40,
    );
  }
}

class OnLightIcon extends StatelessWidget {
  const OnLightIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.flashlight_on_rounded,
      color: Colors.amber,
      size: 40,
    );
  }
}

class AboutIcon extends StatelessWidget {
  const AboutIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.info_rounded,
      color: Colors.black,
      size: 40,
    );
  }
}

class MagneticStrength extends StatelessWidget {
  const MagneticStrength({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: Magnetometer.magnetenPowerStream,
        builder: (context, snapshot) {
          int value = snapshot.hasData ? snapshot.data!.round() : 0;
          return Text(
            'Magnetic Field Strength: $value µT',
            style:const TextStyle( color: Colors.white, fontSize: 18),
          );
        });
  }
}
