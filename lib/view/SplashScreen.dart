// shows assetimage for 5 seconds, then navigates to AuthGate
import 'package:flutter/material.dart';

import '../auth_gate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthGate()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(children: [
        Image.network(
          'https://firebasestorage.googleapis.com/v0/b/pets-org.appspot.com/o/easyadopt.png?alt=media&token=e38bf2b6-53e3-4514-a983-dfb14d0174a0',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        const Center(
            child: CircularProgressIndicator(
          color: Colors.brown,
          strokeCap: StrokeCap.round,
          strokeWidth: 2,
        )),
      ])),
    );
  }
}
