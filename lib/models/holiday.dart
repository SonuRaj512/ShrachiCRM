class Holiday {
  final int id;
  final String name;
  final DateTime holidayDate;

  Holiday({required this.id, required this.name, required this.holidayDate});

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
    id: json['id'] as int,
    name: json['name'] as String,
    holidayDate: DateTime.parse(json['holiday_date'] as String),
  );
}
