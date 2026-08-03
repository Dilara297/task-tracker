import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/screens/home_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Görev Takip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 3, 46, 121)),
      ),
      home: const HomeScreen()
    );
  }
}
