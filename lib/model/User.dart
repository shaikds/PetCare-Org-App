import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String _uid;
  bool _isManager;

  UserModel({
    required String uid,
    bool isManager = false,
  })  : _isManager = isManager,
        _uid = uid;

  //get uid
  String get uid => _uid;

  //set uid
  set uid(String value) {
    uid = value;
  }

  //get ismanager
  bool get isManager => _isManager;

  //set is manager
  set isManager(bool value) {
    _isManager = value;
  }

  @override
  String toString() {
    return 'User: {uid: $_uid, isManager: $_isManager} ';
  }

//Regular Methods

// Convert the UserModel object to a Map for saving in Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'isManager': _isManager,
    };
  }

// Create a UserModel object from a Firestore document snapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
//TODO : Change here?
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception("Invalid snapshot data for UserModel");
    }
    return UserModel(
      uid: data['uid'],
      isManager: data['isManager'] ?? false,
    );
  }
}
