import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'My Compass',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
