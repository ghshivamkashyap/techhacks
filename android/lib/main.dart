import 'package:flutter/material.dart';
import 'package:qr_reader_app/screens/welcome_screen.dart';

void main() {
  runApp(const RapidReceiptsApp());
}

class RapidReceiptsApp extends StatelessWidget {
  const RapidReceiptsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapid Receipts',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF6049),
      ),
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
