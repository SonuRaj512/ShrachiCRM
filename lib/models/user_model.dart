// class UserModel {
//   final int id;
//   final String name;
//   final String? employeeCode;
//   final String email;
//   final String? address;
//   final String? phone;
//   final String? lat;
//   final String? lng;
//   final bool isEdited;
//   final String? designation;
//   final String? zone_code;
//   final String? state_code;
//   final String? image;
//   final String? joinDate;
//   // 👇👇 NEW FIELD
//   final List<StateZoneAssignment> stateZoneAssignments;
//
//   UserModel({
//     required this.id,
//     required this.name,
//     this.employeeCode,
//     required this.email,
//     this.address,
//     required this.phone,
//     this.lat,
//     this.lng,
//     required this.isEdited,
//     this.designation,
//     this.zone_code,
//     this.state_code,
//     this.image,
//     this.joinDate,
//     required this.stateZoneAssignments, // 👈 NEW REQUIRED FIELD
//   });
//
//   factory UserModel.fromJson(Map json) => UserModel(
//     id: json['id'],
//     name: json['name'],
//     employeeCode: json['employee_code'],
//     email: json['email'],
//     isEdited: json['sale_people_info']['is_edited'] ?? false,
//     address: json['sale_people_info']['address'],
//     phone: json['sale_people_info']['phone'],
//     lat: json['sale_people_info']['lat'],
//     lng: json['sale_people_info']['lng'],
//     //designation: json['sale_people']['designation_name'],
//     designation:json['sale_people_info']?['designation']?['designation_name'] ?? 'N/A',
//     zone_code: json['sale_people_info']?['zone_assign']?['zone_code'] ?? 'Nil', // 👈 check spelling
//     state_code: json['sale_people_info']?['zone_assign']?['state_code'] ?? 'Nil', // 👈 check spelling
//     image: json['sale_people_info']['image'],
//     joinDate: json['sale_people_info']['join_date'],
//     // 👇👇 NEW LIST PARSER
//     stateZoneAssignments: (json['state_zoneassignments'] as List<dynamic>)
//         .map((e) => StateZoneAssignment.fromJson(e))
//         .toList(),
//   );
// }
class UserModel {
  // Root fields
  final int id;
  final String name;
  final String? employeeCode;
  final String email;
  final String? status;

  // sale_people_info fields
  final int? saleInfoId;
  final int? userId;
  final String? image;
  final String? address;
  final String? city;
  final String? pincode;
  final String? employeeId;
  final String? phone;
  final String? state;
  final String? stateDescription;
  final String? lat;
  final String? lng;
  final String? joinDate;
  final bool isEdited;
  final String? designation;
  final String? saleInfoCreatedAt;
  final String? saleInfoUpdatedAt;

  // Nested Objects
  //final Designation? designation; // Designation object inside sale_people_info
  final List<StateZoneAssignment> stateZoneAssignments;

  UserModel({
    required this.id,
    required this.name,
    this.employeeCode,
    required this.email,
    this.status,
    this.saleInfoId,
    this.userId,
    this.image,
    this.address,
    this.city,
    this.pincode,
    this.employeeId,
    this.phone,
    this.state,
    this.stateDescription,
    this.lat,
    this.lng,
    this.joinDate,
    required this.isEdited,
    this.designation,
    this.saleInfoCreatedAt,
    this.saleInfoUpdatedAt,
    //this.designation,
    required this.stateZoneAssignments,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // sale_people_info mapping
    var info = json['sale_people_info'] ?? {};

    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      employeeCode: json['employee_code'],
      email: json['email'] ?? '',
      status: json['status'],

      // Parsing sale_people_info fields
      saleInfoId: info['id'],
      userId: info['user_id'],
      image: info['image'],
      address: info['address'],
      city: info['city'],
      pincode: info['pincode'],
      employeeId: info['employee_id'],
      phone: info['phone'],
      state: info['state'],
      stateDescription: info['state_description'],
      lat: info['lat'],
      lng: info['lng'],
      joinDate: info['join_date'],
      isEdited: info['is_edited'] ?? false,
      saleInfoCreatedAt: info['created_at'],
      saleInfoUpdatedAt: info['updated_at'],
      designation:json['sale_people_info']?['designation']?['designation_name'] ?? 'N/A',
      // Parsing nested designation object
      // designation: info['designation'] != null
      //     ? designation.fromJson(info['designation'])
      //     : null,

      // Parsing state_zoneassignments list
      stateZoneAssignments: (json['state_zoneassignments'] as List? ?? [])
          .map((e) => StateZoneAssignment.fromJson(e))
          .toList(),
    );
  }
}
class StateZoneAssignment {
  final int id;
  final String employeeCode;
  final String zoneCode;
  final String stateCode;
  final String? stateDescription;

  StateZoneAssignment({
    required this.id,
    required this.employeeCode,
    required this.zoneCode,
    required this.stateCode,
    this.stateDescription,
  });

  factory StateZoneAssignment.fromJson(Map<String, dynamic> json) {
    return StateZoneAssignment(
      id: json['id'],
      employeeCode: json['employee_code'] ?? '',
      zoneCode: json['zone_code'] ?? '',
      stateCode: json['state_code'] ?? '',
      stateDescription: json['state_description'],
    );
  }
}
