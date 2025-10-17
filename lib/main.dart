import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Pastikan import ini ada
import 'providers/cart_provider.dart';  // Pastikan import ini ada
import 'splash_screen.dart';

void main() {
  runApp(
    // MultiProvider digunakan untuk menyediakan lebih dari satu provider
    MultiProvider(
      providers: [
        // Daftarkan CartProvider di sini agar bisa diakses seluruh aplikasi
        ChangeNotifierProvider(create: (context) => CartProvider()),
        // Anda bisa menambahkan provider lain di sini nanti
        // Provider(create: ...),
      ],
      child: const MyApp(), // MyApp sekarang berada DI DALAM provider
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fashion Katalog',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    );
  }
}
