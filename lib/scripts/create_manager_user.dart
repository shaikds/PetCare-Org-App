import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const email = 'admin@admin.admin';
  const password = 'admin';
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  try {
    // Create the user
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      // Add to Firestore as manager
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'isManager': true,
      });
      print('Manager user created: UID=${user.uid}');
      // Delete the user
      await user.delete();
      print('Manager user deleted.');
    }
  } catch (e) {
    print('Error: $e');
  }
} 