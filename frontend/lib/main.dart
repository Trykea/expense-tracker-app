import 'package:flutter/material.dart';
import 'package:frontend/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker app',
      theme: ThemeData().copyWith(

        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 63, 17, 177)),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
