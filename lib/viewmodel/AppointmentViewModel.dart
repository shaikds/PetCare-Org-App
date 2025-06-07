import 'package:flutter/cupertino.dart';

import '../model/Appointment.dart';
import '../repo/AppointmentRepo.dart';

class AppointmentViewModel extends ChangeNotifier {
  late AppointmentRepo appointmentRepository;

  // appointments;
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  AppointmentViewModel() {
    appointmentRepository = AppointmentRepo();
  }

  Future<void> fetchAppointments() async {
    _appointments = await appointmentRepository.getAppointments();
    notifyListeners();
  }

  Future<bool> createAppointment(String name, String email, String phone,
      String notes, String petId) async {
    try {
      // create appointment
      Appointment appointment = Appointment(
          null,
          petId,
          name,
          email,
          phone,
          notes,
          // time stamp firebase
          DateTime.now().millisecondsSinceEpoch);

      bool result = await appointmentRepository.createAppointment(appointment);
      await fetchAppointments();
      return true;
    } catch (e) {
      print("Error adding appointment: $e");
      return false;
    }
  }
}
