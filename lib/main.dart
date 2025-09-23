import 'package:flutter/material.dart';
import 'splash_screen.dart'; // ganti import ke splash_screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // splashscreen muncul pertama
    );
  }
}
