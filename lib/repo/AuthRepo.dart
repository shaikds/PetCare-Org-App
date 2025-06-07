import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/User.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await _userFromFirebaseUser(credential.user);
  }

  Future<UserModel> signUp(String email, String password, {bool isManager = false}) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    UserModel user = UserModel(uid: credential.user!.uid, isManager: isManager);
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createManagerUser(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    UserModel user = UserModel(uid: credential.user!.uid, isManager: true);
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    // Optionally delete the user after creation
    await credential.user!.delete();
  }

  Future<UserModel> _userFromFirebaseUser(User? user) async {
    if (user == null) throw Exception('No user');
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
    if (!snapshot.exists) {
      // If user doc doesn't exist, create a default one
      UserModel newUser = UserModel(uid: user.uid, isManager: false);
      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      return newUser;
    }
    return UserModel.fromSnapshot(snapshot);
  }
} 