import 'package:PetCare_App/model/Appointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // fetch all user appointments
  Future<List<Appointment>> getUserAppointments() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return [];

      QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Appointment> appointments = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Appointment.fromJson(data);
      }).toList();

      return appointments;
    } catch (e) {
      print("Error fetching user appointments: $e");
      return [];
    }
  }

  Future<bool> createAppointment(Appointment appointment) async {
    try {
      // get id of document
      appointment.id = _firestore.collection('appointments').doc().id;
      // put in firestore
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toJson());
      return true;
    } catch (e) {
      print("Error creating appointment: $e");
      return false;
    }
  }

  Future<List<Appointment>> getAppointments() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('appointments').get();

      List<Appointment> appointments = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Appointment.fromJson(data);
      }).toList();

      return appointments;
    } catch (e) {
      print("Error fetching appointments: $e");
      return [];
    }
  }
}
