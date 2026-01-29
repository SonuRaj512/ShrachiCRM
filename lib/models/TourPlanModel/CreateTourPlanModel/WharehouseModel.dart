class WarehouseModel {
  final int id;
  final String name;
  final String? state;
  final String? distick;

  WarehouseModel({
    required this.id,
    required this.name,
    this.state,
    this.distick,
  });

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'],
      name: json['name'],
      state: json['state_code'],
      distick: json['district'],
    );
  }
}
