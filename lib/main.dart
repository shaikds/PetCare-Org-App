import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'package:flutter_login/viewmodel/PetsViewModel\.dart'; // Import the PetViewModel class
import 'package:provider/provider.dart';

// const clientId =
//     '611343030352-heq86rlqv3gne1fbik0vooal5p1cvfdd.apps.googleusercontent.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if(FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }
  // FlutterFireUIAuth.configureProviders([
  //   const EmailProviderConfiguration(),
  //   const GoogleProviderConfiguration(clientId: clientId),
  // ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => PetViewModel(),
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: MyApp(),
      ),
    ),
  );
}
