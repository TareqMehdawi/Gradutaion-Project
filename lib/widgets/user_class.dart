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
