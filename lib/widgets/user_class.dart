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

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        name: json['name'],
        number: json['phoneNumber'],
        email: json['email'],
        image: json['imageUrl'],
        type: json['type'],
      );
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
  final String image;
  final String duration;
  final String officehour;
  final String imageemp;

  StudentsReservation(
      {this.id = '',
      required this.empName,
      required this.service,
      required this.people,
      required this.time,
      required this.date,
      required this.student,
      required this.empId,
      required this.image,
      required this.duration,
      required this.officehour,
      required this.imageemp});

  Map<String, dynamic> toJson() => {
        'id': id,
        'empName': empName,
        'empId': empId,
        'service': service,
        'people': people,
        'time': time,
        'date': date,
        'student': student,
        'image': image,
        'duration': duration,
        'officehour': officehour,
        'imageemp': imageemp
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
          image: json['image'],
          duration: json['duration'],
          officehour: json['officehour'],
          imageemp: json['imageemp']);
}

class SetEmpService {
  String id;
  final String duration;
  final String service;
  final Map days;
  final String image;

  SetEmpService(
      {this.id = '',
      required this.duration,
      required this.service,
      required this.days,
      required this.image});

  Map<String, dynamic> toJson() => {
        'id': id,
        'service': service,
        'days': days,
        'duration': duration,
        'image': image
      };

  static SetEmpService fromJson(Map<String, dynamic> json) => SetEmpService(
        id: json['id'],
        service: json['service'],
        days: json['days'],
        duration: json['duration'],
        image: json['image'],
      );
}

class UserAccount {
  String id;
  final String name;
  final String number;
  final String email;
  final String image;
  final String type;
  final String office;
  final Map officeHours;

  UserAccount({
    this.id = '',
    this.image = '',
    this.type = '',
    required this.name,
    required this.number,
    required this.email,
    this.office = '',
    required this.officeHours,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'phoneNumber': number,
        'email': email,
        'imageUrl': image,
        'office': office,
        'officeHours': officeHours,
      };

  static UserAccount fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'],
        name: json['name'],
        number: json['phoneNumber'],
        email: json['email'],
        image: json['imageUrl'],
        type: json['type'],
        office: json['office'],
        officeHours: json['officeHours'],
      );
}

class UserWorkingHours {
  String id;
  final String workingHours;

  UserWorkingHours({
    this.id = '',
    this.workingHours = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'workingHours': workingHours,
      };

  static UserWorkingHours fromJson(Map<String, dynamic> json) =>
      UserWorkingHours(
        id: json['id'],
        workingHours: json['officeHours'],
      );
}

class SendFeedback {
  final String id;
  final String title;
  final String name;
  final String message;
  final String email;

  SendFeedback({
    required this.id,
    required this.title,
    required this.name,
    required this.message,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'name': name,
        'message': message,
        'email': email,
      };

  static SendFeedback fromJson(Map<String, dynamic> json) => SendFeedback(
        id: json['id'],
        title: json['title'],
        name: json['name'],
        message: json['message'],
        email: json['email'],
      );
}

class Notifications {
  final String id;
  final String body;
  final String title;
  final String name;
  final String date;

  Notifications({
    required this.id,
    required this.body,
    required this.title,
    required this.name,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'body': body,
        'title': title,
        'name': name,
        'date': date,
      };

  static Notifications fromJson(Map<String, dynamic> json) => Notifications(
        id: json['id'],
        body: json['body'],
        title: json['title'],
        name: json['name'],
        date: json['date'],
      );
}
