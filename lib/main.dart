import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'package:audioplayers/audioplayers.dart'; // Add this import at the top


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}