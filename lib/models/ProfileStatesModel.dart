class StateModel {
  final String code;
  final String description;

  StateModel({required this.code, required this.description});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
