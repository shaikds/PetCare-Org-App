import 'package:PetCare_App/view/SplashScreen.dart';
import 'package:flutter/material.dart';

import 'auth_gate.dart';
// show splash screen for 5 seconds, then navigate to the AuthGate
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}