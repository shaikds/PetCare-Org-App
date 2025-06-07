class Appointment {
  var id;
  var petId;
  var name;
  var email;
  var phone;
  var notes;
  var timestamp;

  Appointment(
      this.id, this.petId, this.name,this.email, this.phone, this.notes, this.timestamp);

  // from json to json
  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    petId = json['petId'];
    name = json['name'];
    phone = json['phone'];
    notes = json['notes'];
    timestamp = json['timestamp'];
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'name': name,
      'phone': phone,
      'notes': notes,
      'timestamp': timestamp
    };
  }
}
