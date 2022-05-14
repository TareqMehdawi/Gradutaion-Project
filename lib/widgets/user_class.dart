class Users {
  String id;
  final String name;
  final String number;
  final String email;
  final String image;
  final String type;

  Users({
    this.id = '',
    this.image = '',
    this.type = '',
    required this.name,
    required this.number,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'phoneNumber': number,
        'email': email,
        'imageUrl': image,
      };

  static Users fromJson(Map<String, dynamic> json) =>
      Users(id: json['id'], name: json['name'], number: json['phoneNumber'],email: json['email'],image:  json['imageUrl'],type: json['type'],);
}

class StudentsReservation {
  String id;
  final String empName;
  final String empId;
  final String service;
  final int people;
  final String time;
  final String date;
  final String student;

  StudentsReservation({
    this.id = '',
    required this.empName,
    required this.service,
    required this.people,
    required this.time,
    required this.date,
    required this.student,
    required this.empId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'empName': empName,
        'empId': empId,
        'service': service,
        'people': people,
        'time': time,
        'date': date,
    'student': student,
      };

  static StudentsReservation fromJson(Map<String, dynamic> json) =>
      StudentsReservation(
          id: json['id'],
          empName: json['empName'],
          empId: json['empId'],
          service: json['service'],
          people: json['people'],
          time: json['time'],
          date: json['date'],
          student: json['student'],
      );
}

class setEmpService {
  String id;
  final String Duration;
  final String Service;
  final String Time;
  final List<String> days;

  setEmpService({
    this.id = '',
    required this.Duration,
    required this.Service,
    required this.Time,
    required this.days,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
      'Service': Service,
      'days': days,
      'Duration': Duration,
      'Time': Time,
  };

  static setEmpService fromJson(Map<String, dynamic> json) =>
      setEmpService(
        id: json['id'],
        Service: json['Service'],
        days: json['days'],
        Duration: json['Duration'],
        Time: json['Time'],
      );
}
