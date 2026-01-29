class HoModel {
  final int id;
  final String code;
  final String name;
  final String address;
  final String address2;
  final String postCode;
  final String city;
  final String countryRegionCode;
  final String phoneNo;
  final String email;

  HoModel({
    required this.id,
    required this.code,
    required this.name,
    required this.address,
    required this.address2,
    required this.postCode,
    required this.city,
    required this.countryRegionCode,
    required this.phoneNo,
    required this.email,
  });

  factory HoModel.fromJson(Map<String, dynamic> json) {
    return HoModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? "",
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      address2: json['address_2'] ?? "",
      postCode: json['post_code'] ?? "",
      city: json['city'] ?? "",
      countryRegionCode: json['country_region_code'] ?? "",
      phoneNo: json['phone_no'] ?? "",
      email: json['email'] ?? "",
    );
  }
}
