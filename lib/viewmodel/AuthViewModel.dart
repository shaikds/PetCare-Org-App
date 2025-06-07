import 'package:flutter/material.dart';
import '../repo/AuthRepo.dart';
import '../model/User.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepo _authRepo = AuthRepo();
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authRepo.signIn(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> signUp(String email, String password, {bool isManager = false}) async {
    _setLoading(true);
    try {
      _user = await _authRepo.signUp(email, password, isManager: isManager);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepo.signOut();
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<void> createManagerUser(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepo.createManagerUser(email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
