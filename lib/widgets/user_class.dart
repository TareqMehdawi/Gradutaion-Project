class Users {
  String id;
  final String name;
  final String number;

  Users({
    this.id = '',
    required this.name,
    required this.number,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': number,
      };

  static Users fromJson(Map<String, dynamic> json) =>
      Users(id: json['id'], name: json['name'], number: json['number']);
}

class StudentsReservation {
  String id;
  final String doctor;
  final String service;
  final int people;
  final String time;
  final String date;

  StudentsReservation({
    this.id = '',
    required this.doctor,
    required this.service,
    required this.people,
    required this.time,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor': doctor,
        'service': service,
        'people': people,
        'time': time,
        'date': date,
      };

  static StudentsReservation fromJson(Map<String, dynamic> json) =>
      StudentsReservation(
          id: json['id'],
          doctor: json['doctor'],
          service: json['service'],
          people: json['people'],
          time: json['time'],
          date: json['date'],
      );
}
