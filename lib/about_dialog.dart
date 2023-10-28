import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Image.asset('assets/images/icon.jpg'),
      ),
      content: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'About Simple Compass',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Welcome to Simple Compass, the ultimate compass app for your mobile device! Our app takes advantage of the built-in magnetometer sensor in your phone to provide you with a reliable and accurate compass, helping you navigate the world around you.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '🧭 Compass Functionality: Never lose your way again! Simple Compass utilizes your phone\'s magnetometer sensor to deliver real-time compass readings, ensuring you always know your direction.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '🔦 Built-in Flashlight: Need extra help in the dark? Simple Compass includes a handy built-in flashlight to light up your path. It\'s perfect for those moments when you need both direction and illumination.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Why Choose Simple Compass?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '🎯 Accuracy: We\'ve designed our compass to be as precise as possible, so you can rely on it wherever you go.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '👨‍👩‍👦‍👦 User-Friendly: Simple Compass is incredibly easy to use, making it suitable for all ages. Just launch the app, and you\'re ready to explore.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '🔦 Convenience: With the built-in flashlight, you\'ll be prepared for any situation, whether you\'re navigating a trail or searching for lost items in the dark.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We value your feedback and are here to assist you with any questions or concerns. Feel free to reach out to us at any time:',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '📧 Email: we.viavek@gmail.com',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              '📱 Phone: +919497056350',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Thank you for choosing Simple Compass as your compass and flashlight solution. We\'re dedicated to helping you explore the world with confidence and convenience.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            Text(
              'Stay on course and illuminate your path with Simple Compass!',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) => const AboutDialog(
                    applicationName: "Compass",
                    applicationLegalese:
                        "About Simple Compass Welcome to Simple Compass, the ultimate compass app for your mobile device! Our app takes advantage of the built-in magnetometer sensor in your phone to provide you with a reliable and accurate compass, helping you navigate the world around you. Key Features: 🧭 Compass Functionality: Never lose your way again! Simple Compass utilizes your phone's magnetometer sensor to deliver real-time compass readings, ensuring you always know your direction. 🔦 Built-in Flashlight: Need extra help in the dark? Simple Compass includes a handy built-in flashlight to light up your path. It's perfect for those moments when you need both direction and illumination.",
                    applicationVersion: '1.0.1',
                  )),
          child: const Text("More Details"),
        )
      ],
    );
  }
}
