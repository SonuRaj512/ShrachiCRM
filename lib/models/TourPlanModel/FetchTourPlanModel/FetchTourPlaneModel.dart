// // tour_plan_model.dart (Ek nayi file bana sakte hain)
//
// import 'dart:convert';
//
// class TourPlan {
//   final int id;
//   final int userId;
//   final String? serial_no; // API se "yyyy-MM-dd" format mein aa raha hai
//   final String startDate; // API se "yyyy-MM-dd" format mein aa raha hai
//   final String endDate; // API se "yyyy-MM-dd" format mein aa raha hai
//   // final String tourPlanOption;
//   // final String? visitDate; // Yeh root level par null ho sakta hai
//   // final String? visitPurpose;
//   final String? visitName;
//   late final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final List<Visit> visits;
//   final String toure_status;
//   final ExpenseOverallStatus? expenseOverallStatus;
//
//   TourPlan({
//     required this.id,
//     required this.userId,
//     required this.serial_no,
//     required this.startDate,
//     required this.endDate,
//     // required this.tourPlanOption,
//     // this.visitDate,
//     // this.visitPurpose,
//     this.visitName,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.visits,
//     required this.toure_status,
//     this.expenseOverallStatus,
//   });
//   factory TourPlan.fromJson(Map<String, dynamic> json) {
//     var visitsList = json['visits'] as List;
//     List<Visit> parsedVisits = visitsList.map((i) => Visit.fromJson(i)).toList();
//     return TourPlan(
//       id: json['id'],
//       userId: json['user_id'],
//       serial_no: json['serial_no'],
//       startDate: json['start_date'],
//       endDate: json['end_date'],
//       // tourPlanOption: json['tour_plan_option'],
//       // visitDate: json['visit_date'],
//       // visitPurpose: json['visit_purpose'],
//       visitName: json['visit_name'],
//       status: json['status'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       visits: parsedVisits,
//       toure_status: json['tour_status'],
//       // ✅ NEW FIELD
//       expenseOverallStatus: json['expense_overall_status'] != null
//           ? ExpenseOverallStatus.fromJson(
//         json['expense_overall_status'],
//       )
//           : null,
//     );
//   }
//   // Helper to get duration in days
//   int get durationInDays {
//     try {
//       DateTime start = DateTime.parse(startDate);
//       DateTime end = DateTime.parse(endDate);
//       return end.difference(start).inDays + 1;
//     } catch (e) {
//       return 0;
//     }
//   }
// }
// class ExpenseOverallStatus {
//   final String status;
//   final String label;
//
//   ExpenseOverallStatus({
//     required this.status,
//     required this.label,
//   });
//
//   factory ExpenseOverallStatus.fromJson(Map<String, dynamic> json) {
//     return ExpenseOverallStatus(
//       status: json['status'],
//       label: json['label'],
//     );
//   }
// }
//
// class Visit {
//   final int id;
//   final int tourPlanId;
//   final bool hasCheckin;
//   final bool isCheckin;
//   final bool isjourney;
//   final bool islatestcheck;
//   final double? lat;
//   final double? lng;
//   final String type;
//   String visitDate; // API se "yyyy-MM-dd" format mein aa raha hai
//   String name;
//   final String? deptName;
//   String? visitPurpose;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int? customerId;
//   final String? transitName;
//   final String? ho;
//   final String? Reject_reason;
//   final Leads? lead;
//   final int? isApproved;
//
//   Visit({
//     required this.id,
//     required this.tourPlanId,
//     required this.hasCheckin,
//     required this.isCheckin,
//     required this.isjourney,
//     required this.islatestcheck,
//     this.lat,
//     this.lng,
//     required this.type,
//     required this.visitDate,
//     required this.name,
//     this.deptName,
//     this.visitPurpose,
//     required this.createdAt,
//     required this.updatedAt,
//     this.customerId,
//     this.transitName,
//     this.ho,
//     this.Reject_reason,
//     this.lead,
//     required this.isApproved,
//   });
//
//   factory Visit.fromJson(Map<String, dynamic> json) {
//     return Visit(
//       id: json['id'],
//       tourPlanId: json['tour_plan_id'],
//       hasCheckin: json['has_checkin'],
//       isCheckin: json['is_checkin'],
//       isjourney: json['start_journey'],
//       islatestcheck: json['latest_check'],
//       lat: json['lat'] != null ? double.parse(json['lat']) : null,
//       lng: json['lat'] != null ? double.parse(json['lng']) : null,
//       type: json['type'],
//       visitDate: json['visit_date'],
//       name: json['name'],
//       deptName: json['lead'] != null ? json['dept_name'] : null,
//       visitPurpose: json['visit_purpose'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       customerId: json['customer_id'],
//       transitName: json['transit_name'],
//       ho: json['ho'],
//       Reject_reason: json['reject_reason'],
//       lead: json['lead'] != null ? Leads.fromJson(json['lead']) : null,
//       isApproved: json['is_approved'],
//     );
//   }
// }
//
// class Leads {
//   final int id;
//   final String type;
//   final String primaryNo;
//   final String? leadSource;
//   final String? contactPerson;
//   final String? state;
//   final String? city;
//   final String? currentBalance;
//   final List? productsCode;
//   final int? currentBusiness;
//   final int? varientCode;
//   final int? itemModelCode;
//   final int? categoryCode;
//   final int? leadStatusId;
//   List<String>? products;
//   final String? address;
//
//   Leads({
//     required this.id,
//     required this.type,
//     required this.primaryNo,
//     this.leadSource,
//     this.contactPerson,
//     this.state,
//     this.city,
//     this.currentBalance,
//     this.productsCode,
//     this.currentBusiness,
//     this.varientCode,
//     this.itemModelCode,
//     this.categoryCode,
//     this.leadStatusId,
//     this.products,
//     this.address,
//   });
//
//   factory Leads.fromJson(Map json) => Leads(
//     id: json['id'],
//     type: json['lead_type'],
//     primaryNo: json['primary_no'],
//     leadSource: json['lead_source'],
//     contactPerson: json['contact_person'],
//     state: json['state'],
//     city: json['city'],
//     currentBalance: json['current_balance'],
//     productsCode: jsonDecode(json['products_code']),
//     currentBusiness: json['current_busniess'],
//     varientCode: json['varient_code'],
//     itemModelCode: json['item_model_code'],
//     categoryCode: json['category_code'],
//     leadStatusId: json['lead_status_id'],
//     products: json['products'] != null ? List<String>.from(json['products']) : null,
//     address: json['address'],
//   );
// }

import 'dart:convert';

class TourPlan {
  final int id;
  final int userId;
  final String? serial_no;
  final String startDate;
  final String endDate;
  final String? visitName;
  late final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Visit> visits;
  final String toure_status;
  final ExpenseOverallStatus? expenseOverallStatus;

  TourPlan({
    required this.id,
    required this.userId,
    required this.serial_no,
    required this.startDate,
    required this.endDate,
    this.visitName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.visits,
    required this.toure_status,
    this.expenseOverallStatus,
  });

  factory TourPlan.fromJson(Map<String, dynamic> json) {
    var visitsList = json['visits'] as List? ?? [];
    List<Visit> parsedVisits =
    visitsList.map((i) => Visit.fromJson(i)).toList();

    return TourPlan(
      id: json['id'],
      userId: json['user_id'],
      serial_no: json['serial_no'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      visitName: json['visit_name'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      visits: parsedVisits,
      toure_status: json['tour_status'],
      expenseOverallStatus: json['expense_overall_status'] != null
          ? ExpenseOverallStatus.fromJson(json['expense_overall_status'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "serial_no": serial_no,
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "visits": visits.map((v) => v.toJson()).toList(),
    "tour_status": toure_status,
    "expense_overall_status": expenseOverallStatus != null
        ? {
      "status": expenseOverallStatus!.status,
      "label": expenseOverallStatus!.label,
    }
        : null
  };

  String toJsonString() => jsonEncode(toJson());

  static TourPlan fromJsonString(String jsonStr) {
    return TourPlan.fromJson(jsonDecode(jsonStr));
  }

  int get durationInDays {
    try {
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      return end.difference(start).inDays + 1;
    } catch (e) {
      return 0;
    }
  }
}

class ExpenseOverallStatus {
  final String status;
  final String label;

  ExpenseOverallStatus({required this.status, required this.label});

  factory ExpenseOverallStatus.fromJson(Map<String, dynamic> json) {
    return ExpenseOverallStatus(
      status: json['status'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() => {"status": status, "label": label};
}

class Visit {
  final int id;
  final int tourPlanId;
  final bool hasCheckin;
  final bool isCheckin;
  final bool isjourney;
  final bool islatestcheck;
  final double? lat;
  final double? lng;
  final String type;
  String visitDate;
  String name;
  final String? deptName;
  String? visitPurpose;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? customerId;
  final String? transitName;
  final String? ho;
  final String? Reject_reason;
  final Leads? lead;
  final int? isApproved;

  Visit({
    required this.id,
    required this.tourPlanId,
    required this.hasCheckin,
    required this.isCheckin,
    required this.isjourney,
    required this.islatestcheck,
    this.lat,
    this.lng,
    required this.type,
    required this.visitDate,
    required this.name,
    this.deptName,
    this.visitPurpose,
    required this.createdAt,
    required this.updatedAt,
    this.customerId,
    this.transitName,
    this.ho,
    this.Reject_reason,
    this.lead,
    required this.isApproved,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'],
      tourPlanId: json['tour_plan_id'],
      hasCheckin: json['has_checkin'],
      isCheckin: json['is_checkin'],
      isjourney: json['start_journey'],
      islatestcheck: json['latest_check'],
      lat: json['lat'] != null ? double.parse(json['lat'].toString()) : null,
      lng: json['lng'] != null ? double.parse(json['lng'].toString()) : null,
      type: json['type'],
      visitDate: json['visit_date'],
      name: json['name'],
      deptName: json['dept_name'],
      visitPurpose: json['visit_purpose'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customerId: json['customer_id'],
      transitName: json['transit_name'],
      ho: json['ho'],
      Reject_reason: json['reject_reason'],
      lead: json['lead'] != null ? Leads.fromJson(json['lead']) : null,
      isApproved: json['is_approved'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tour_plan_id": tourPlanId,
    "has_checkin": hasCheckin,
    "is_checkin": isCheckin,
    "start_journey": isjourney,
    "latest_check": islatestcheck,
    "lat": lat,
    "lng": lng,
    "type": type,
    "visit_date": visitDate,
    "name": name,
    "dept_name": deptName,
    "visit_purpose": visitPurpose,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "customer_id": customerId,
    "transit_name": transitName,
    "ho": ho,
    "reject_reason": Reject_reason,
    "is_approved": isApproved,
    "lead": lead?.toJson(),
  };
}

class Leads {
  final int id;
  final String type;
  final String primaryNo;
  final String? leadSource;
  final String? contactPerson;
  final String? state;
  final String? city;
  final String? currentBalance;
  final List? productsCode;
  final int? currentBusiness;
  final int? varientCode;
  final int? itemModelCode;
  final int? categoryCode;
  final int? leadStatusId;
  List<String>? products;
  final String? address;

  Leads({
    required this.id,
    required this.type,
    required this.primaryNo,
    this.leadSource,
    this.contactPerson,
    this.state,
    this.city,
    this.currentBalance,
    this.productsCode,
    this.currentBusiness,
    this.varientCode,
    this.itemModelCode,
    this.categoryCode,
    this.leadStatusId,
    this.products,
    this.address,
  });

  factory Leads.fromJson(Map json) => Leads(
    id: json['id'],
    type: json['lead_type'],
    primaryNo: json['primary_no'],
    leadSource: json['lead_source'],
    contactPerson: json['contact_person'],
    state: json['state'],
    city: json['city'],
    currentBalance: json['current_balance'],
    productsCode: json['products_code'] != null
        ? List.from(jsonDecode(json['products_code'].toString()))
        : null,
    currentBusiness: json['current_busniess'],
    varientCode: json['varient_code'],
    itemModelCode: json['item_model_code'],
    categoryCode: json['category_code'],
    leadStatusId: json['lead_status_id'],
    products: json['products'] != null ? List<String>.from(json['products']) : null,
    address: json['address'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lead_type": type,
    "primary_no": primaryNo,
    "lead_source": leadSource,
    "contact_person": contactPerson,
    "state": state,
    "city": city,
    "current_balance": currentBalance,
    "products_code": productsCode != null ? jsonEncode(productsCode) : null,
    "current_busniess": currentBusiness,
    "varient_code": varientCode,
    "item_model_code": itemModelCode,
    "category_code": categoryCode,
    "leadStatusId": leadStatusId,
    "products": products,
    "address": address,
  };
}
