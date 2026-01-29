//LeadSourceModel
class LeadSourceModel {
  final int id;
  final String name;

  LeadSourceModel({required this.id, required this.name});

  factory LeadSourceModel.fromJson(Map<String, dynamic> json) {
    return LeadSourceModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
//LeadbusinessModel
class LeadBusinessModel {
  final int id;
  final String name;

  LeadBusinessModel({required this.id, required this.name});

  factory LeadBusinessModel.fromJson(Map<String, dynamic> json) {
    return LeadBusinessModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

