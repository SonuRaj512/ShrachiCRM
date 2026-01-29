class LeaveTypeModel {
  final int id;
  final String name;

  LeaveTypeModel({required this.id, required this.name});

  factory LeaveTypeModel.fromJson(Map json) =>
      LeaveTypeModel(id: json['id'], name: json['name']);
}
