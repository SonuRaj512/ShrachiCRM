class LeadTypeModel {
  final int id;
  final String name;

  LeadTypeModel({required this.id, required this.name});

  factory LeadTypeModel.fromJson(Map<String, dynamic> json) {
    return LeadTypeModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
