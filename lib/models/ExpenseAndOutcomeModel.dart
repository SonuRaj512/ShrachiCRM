// import 'dart:convert';
//
// TourResponse tourResponseFromJson(String str) => TourResponse.fromJson(json.decode(str));
//
// String tourResponseToJson(TourResponse data) => json.encode(data.toJson());
//
// class TourResponse {
//   final int userId;
//   final List<Tour> tours;
//
//   TourResponse({
//     required this.userId,
//     required this.tours,
//   });
//
//   factory TourResponse.fromJson(Map<String, dynamic> json) => TourResponse(
//     userId: json["user_id"],
//     tours: List<Tour>.from(json["tours"].map((x) => Tour.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "tours": List<dynamic>.from(tours.map((x) => x.toJson())),
//   };
// }
//
// class Tour {
//   final int id;
//   final int userId;
//   final DateTime startDate;
//   final DateTime endDate;
//   final dynamic tourPlanOption;
//   final dynamic visitDate;
//   final dynamic visitPurpose;
//   final dynamic visitName;
//   final String status;
//   final dynamic rejectedReason;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final String serialNo;
//   final List<Visits1> visits;
//
//   Tour({
//     required this.id,
//     required this.userId,
//     required this.startDate,
//     required this.endDate,
//     required this.tourPlanOption,
//     required this.visitDate,
//     required this.visitPurpose,
//     required this.visitName,
//     required this.status,
//     required this.rejectedReason,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.serialNo,
//     required this.visits,
//   });
//
//   factory Tour.fromJson(Map<String, dynamic> json) => Tour(
//     id: json["id"],
//     userId: json["user_id"],
//     startDate: DateTime.parse(json["start_date"]),
//     endDate: DateTime.parse(json["end_date"]),
//     tourPlanOption: json["tour_plan_option"],
//     visitDate: json["visit_date"],
//     visitPurpose: json["visit_purpose"],
//     visitName: json["visit_name"],
//     status: json["status"],
//     rejectedReason: json["rejected_reason"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     serialNo: json["serial_no"],
//     visits: List<Visits1>.from(json["visits"].map((x) => Visits1.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": userId,
//     "start_date": startDate.toIso8601String(),
//     "end_date": endDate.toIso8601String(),
//     "tour_plan_option": tourPlanOption,
//     "visit_date": visitDate,
//     "visit_purpose": visitPurpose,
//     "visit_name": visitName,
//     "status": status,
//     "rejected_reason": rejectedReason,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "serial_no": serialNo,
//     "visits": List<dynamic>.from(visits.map((x) => x.toJson())),
//   };
// }
//
// class Visits1 {
//   final int? id;
//   final String? lat;
//   final String? lng;
//   final int? tourPlanId;
//   final String? type;
//   final DateTime? visitDate;
//   final String? name;
//   final dynamic? deptName;
//   final String? visitPurpose;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final dynamic? locationId;
//   final int? customerId;
//   final dynamic? transitName;
//   final dynamic? ho;
//   final dynamic? serviceName;
//   final dynamic? activityName;
//   final dynamic? otherActivity;
//   final dynamic? otherService;
//   final int? isApproved;
//   final String? visitSerialNo;
//   final int? isOnTourplan;
//   final dynamic? rejectReason;
//   final bool? hasCheckin;
//   final bool? isCheckin;
//   final List<dynamic> leads; // You might want to define a Lead class
//   final List<Expense> expenses;
//   final Checkins? checkins;
//
//   Visits1({
//     required this.id,
//     required this.lat,
//     required this.lng,
//     required this.tourPlanId,
//     required this.type,
//     required this.visitDate,
//     required this.name,
//     required this.deptName,
//     required this.visitPurpose,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.locationId,
//     required this.customerId,
//     required this.transitName,
//     required this.ho,
//     required this.serviceName,
//     required this.activityName,
//     required this.otherActivity,
//     required this.otherService,
//     required this.isApproved,
//     required this.visitSerialNo,
//     required this.isOnTourplan,
//     required this.rejectReason,
//     required this.hasCheckin,
//     required this.isCheckin,
//     required this.leads,
//     required this.expenses,
//     required this.checkins,
//   });
//
//   factory Visits1.fromJson(Map<String, dynamic> json) => Visits1(
//     id: json["id"],
//     lat: json["lat"],
//     lng: json["lng"],
//     tourPlanId: json["tour_plan_id"],
//     type: json["type"],
//     visitDate: DateTime.parse(json["visit_date"]),
//     name: json["name"],
//     deptName: json["dept_name"],
//     visitPurpose: json["visit_purpose"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     locationId: json["location_id"],
//     customerId: json["customer_id"],
//     transitName: json["transit_name"],
//     ho: json["ho"],
//     serviceName: json["service_name"],
//     activityName: json["activity_name"],
//     otherActivity: json["other_activity"],
//     otherService: json["other_service"],
//     isApproved: json["is_approved"],
//     visitSerialNo: json["visit_serial_no"],
//     isOnTourplan: json["is_on_tourplan"],
//     rejectReason: json["reject_reason"],
//     hasCheckin: json["has_checkin"],
//     isCheckin: json["is_checkin"],
//     leads: List<dynamic>.from(json["leads"].map((x) => x)),
//     expenses: List<Expense>.from(json["expenses"].map((x) => Expense.fromJson(x))),
//     checkins: json["checkins"] == null ? null : Checkins.fromJson(json["checkins"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "lat": lat,
//     "lng": lng,
//     "tour_plan_id": tourPlanId,
//     "type": type,
//     "visit_date": visitDate?.toIso8601String(),
//     "name": name,
//     "dept_name": deptName,
//     "visit_purpose": visitPurpose,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//     "location_id": locationId,
//     "customer_id": customerId,
//     "transit_name": transitName,
//     "ho": ho,
//     "service_name": serviceName,
//     "activity_name": activityName,
//     "other_activity": otherActivity,
//     "other_service": otherService,
//     "is_approved": isApproved,
//     "visit_serial_no": visitSerialNo,
//     "is_on_tourplan": isOnTourplan,
//     "reject_reason": rejectReason,
//     "has_checkin": hasCheckin,
//     "is_checkin": isCheckin,
//     "leads": List<dynamic>.from(leads.map((x) => x)),
//     "expenses": List<dynamic>.from(expenses.map((x) => x.toJson())),
//     "checkins": checkins?.toJson(),
//   };
// }
//
// class Checkins {
//   final int id;
//   final String checkinLat;
//   final String checkinLng;
//   final String? checkoutLat;
//   final String? checkoutLng;
//   final int userId;
//   final int tourPlanId;
//   final int visitId;
//   final String? comments;
//   final List<String>? images;
//   final DateTime? followupDate;
//   final dynamic nextFollowupDate;
//   final String? outcome;
//   final dynamic leadStatusId;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int outchecked;
//   final bool isoutcome;
//   final bool checkinStatus;
//   final bool? startJourney;
//   final bool? latestCheck;
//   final dynamic leadStatuses;
//   final dynamic leadStatus;
//
//   Checkins({
//     required this.id,
//     required this.checkinLat,
//     required this.checkinLng,
//     required this.checkoutLat,
//     required this.checkoutLng,
//     required this.userId,
//     required this.tourPlanId,
//     required this.visitId,
//     required this.comments,
//     required this.images,
//     required this.followupDate,
//     required this.nextFollowupDate,
//     required this.outcome,
//     required this.leadStatusId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.outchecked,
//     required this.isoutcome,
//     required this.latestCheck,
//     required this.startJourney,
//     required this.checkinStatus,
//     required this.leadStatuses,
//     required this.leadStatus,
//   });
//
//   factory Checkins.fromJson(Map<String, dynamic> json) => Checkins(
//     id: json["id"],
//     checkinLat: json["checkin_lat"],
//     checkinLng: json["checkin_lng"],
//     checkoutLat: json["checkout_lat"],
//     checkoutLng: json["checkout_lng"],
//     userId: json["user_id"],
//     tourPlanId: json["tour_plan_id"],
//     visitId: json["visit_id"],
//     comments: json["comments"],
//     images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
//     followupDate: json["followup_date"] == null ? null : DateTime.parse(json["followup_date"]),
//     nextFollowupDate: json["next_followup_date"],
//     outcome: json["outcome"],
//     leadStatusId: json["lead_status_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     outchecked: json["outchecked"],
//     isoutcome: json["isoutcome"],
//     startJourney: json["start_journey"],
//     latestCheck: json["latest_check"],
//     checkinStatus: json["checkin_status"],
//     leadStatuses: json["lead_statuses"],
//     leadStatus: json["lead_status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "checkin_lat": checkinLat,
//     "checkin_lng": checkinLng,
//     "checkout_lat": checkoutLat,
//     "checkout_lng": checkoutLng,
//     "user_id": userId,
//     "tour_plan_id": tourPlanId,
//     "visit_id": visitId,
//     "comments": comments,
//     "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
//     "followup_date": followupDate?.toIso8601String(),
//     "next_followup_date": nextFollowupDate,
//     "outcome": outcome,
//     "lead_status_id": leadStatusId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "outchecked": outchecked,
//     "isoutcome": isoutcome,
//     "latest_check":latestCheck,
//     "start_journey":startJourney,
//     "checkin_status": checkinStatus,
//     "lead_statuses": leadStatuses,
//     "lead_status": leadStatus,
//
//   };
// }
//
// class Expense {
//   final int id;
//   final int visitId;
//   final int salesPersonId;
//   final int tourPlanId;
//   final String type;
//   final String expensetype;
//   final String amount;
//   final DateTime date;
//   final String? description;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final dynamic departureTown;
//   final dynamic arrivalTown;
//   final dynamic departureTime;
//   final dynamic arrivalTime;
//   final dynamic modeOfTravel;
//   final dynamic fare;
//   final String? location;
//   final dynamic daType;
//   final dynamic otherAmount;
//   final dynamic nonConveyanceAmount;
//   final dynamic remarks;
//   final String expenseStatus;
//   final dynamic rejectedReason;
//
//   Expense({
//     required this.id,
//     required this.visitId,
//     required this.salesPersonId,
//     required this.tourPlanId,
//     required this.type,
//     required this.expensetype,
//     required this.amount,
//     required this.date,
//     required this.description,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.departureTown,
//     required this.arrivalTown,
//     required this.departureTime,
//     required this.arrivalTime,
//     required this.modeOfTravel,
//     required this.fare,
//     required this.location,
//     required this.daType,
//     required this.otherAmount,
//     required this.nonConveyanceAmount,
//     required this.remarks,
//     required this.expenseStatus,
//     required this.rejectedReason,
//   });
//
//   factory Expense.fromJson(Map<String, dynamic> json) => Expense(
//     id: json["id"],
//     visitId: json["visit_id"],
//     salesPersonId: json["sales_person_id"],
//     tourPlanId: json["tour_plan_id"],
//     type: json["type"],
//     expensetype: json["expensetype"],
//     amount: json["amount"],
//     date: DateTime.parse(json["date"]),
//     description: json["description"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     departureTown: json["departure_town"],
//     arrivalTown: json["arrival_town"],
//     departureTime: json["departure_time"],
//     arrivalTime: json["arrival_time"],
//     modeOfTravel: json["mode_of_travel"],
//     fare: json["fare"],
//     location: json["location"],
//     daType: json["da_type"],
//     otherAmount: json["other_amount"],
//     nonConveyanceAmount: json["non_conveyance_amount"],
//     remarks: json["remarks"],
//     expenseStatus: json["expense_status"],
//     rejectedReason: json["rejected_reason"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "visit_id": visitId,
//     "sales_person_id": salesPersonId,
//     "tour_plan_id": tourPlanId,
//     "type": type,
//     "expensetype": expensetype,
//     "amount": amount,
//     "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
//     "description": description,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "departure_town": departureTown,
//     "arrival_town": arrivalTown,
//     "departure_time": departureTime,
//     "arrival_time": arrivalTime,
//     "mode_of_travel": modeOfTravel,
//     "fare": fare,
//     "location": location,
//     "da_type": daType,
//     "other_amount": otherAmount,
//     "non_conveyance_amount": nonConveyanceAmount,
//     "remarks": remarks,
//     "expense_status": expenseStatus,
//     "rejected_reason": rejectedReason,
//   };
// }

import 'dart:convert';

TourResponse tourResponseFromJson(String str) => TourResponse.fromJson(json.decode(str));

String tourResponseToJson(TourResponse data) => json.encode(data.toJson());

class TourResponse {
  final int userId;
  final List<Tour> tours;

  TourResponse({
    required this.userId,
    required this.tours,
  });

  factory TourResponse.fromJson(Map<String, dynamic> json) => TourResponse(
    userId: json["user_id"] as int? ?? 0,
    tours: List<Tour>.from(json["tours"]?.map((x) => Tour.fromJson(x)) ?? []), // Handle null 'tours' list
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "tours": List<dynamic>.from(tours.map((x) => x.toJson())),
  };
}

class Tour {
  final int id;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final dynamic tourPlanOption;
  final dynamic visitDate;
  final dynamic visitPurpose;
  final dynamic visitName;
  final String status;
  final dynamic rejectedReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String serialNo;
  final String? tourStatus;
  final List<Visits1> visits;

  Tour({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.tourPlanOption,
    this.visitDate,
    this.visitPurpose,
    this.visitName,
    required this.status,
    this.rejectedReason,
    required this.createdAt,
    required this.updatedAt,
    required this.serialNo,
    this.tourStatus,
    required this.visits,
  });

  factory Tour.fromJson(Map<String, dynamic> json) => Tour(
    id: json["id"] as int? ?? 0, // Default 0 if null
    userId: json["user_id"] as int? ?? 0, // Default 0 if null
    startDate: json["start_date"] == null ? DateTime.now() : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? DateTime.now() : DateTime.parse(json["end_date"]),
    tourPlanOption: json["tour_plan_option"],
    visitDate: json["visit_date"],
    visitPurpose: json["visit_purpose"],
    visitName: json["visit_name"],
    status: json["status"] as String? ?? 'unknown', // Default 'unknown' if null
    rejectedReason: json["rejected_reason"],
    createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime.now() : DateTime.parse(json["updated_at"]),
    serialNo: json["serial_no"] as String? ?? 'N/A', // Default 'N/A' if null
    tourStatus: json["tour_status"] as String?,
    visits: List<Visits1>.from(json["visits"]?.map((x) => Visits1.fromJson(x)) ?? []), // Handle null 'visits' list
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "tour_plan_option": tourPlanOption,
    "visit_date": visitDate,
    "visit_purpose": visitPurpose,
    "visit_name": visitName,
    "status": status,
    "rejected_reason": rejectedReason,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "serial_no": serialNo,
    "tour_status": tourStatus,
    "visits": List<dynamic>.from(visits.map((x) => x.toJson())),
  };
}

class Visits1 {
  final int? id;
  final String? lat;
  final String? lng;
  final int? tourPlanId;
  final String? type;
  final DateTime? visitDate;
  final String? address;
  final String? name;
  final dynamic? deptName;
  final String? visitPurpose;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic? locationId;
  final int? customerId;
  final dynamic? transitName;
  final dynamic? ho;
  final dynamic? serviceName;
  final dynamic? activityName;
  final dynamic? otherActivity;
  final dynamic? otherService;
  final int? isApproved;
  final String? visitSerialNo;
  final int? isOnTourplan;
  final dynamic? rejectReason;
  final bool? hasCheckin;
  final bool? isCheckin;
  final bool? startJourney;
  final bool? latestCheck;
  final List<dynamic> leads;
  final List<Expense> expenses;
  final Checkins? checkins;

  Visits1({
    this.id,
    this.lat,
    this.lng,
    this.tourPlanId,
    this.type,
    this.visitDate,
    this.address,
    this.name,
    this.deptName,
    this.visitPurpose,
    this.createdAt,
    this.updatedAt,
    this.locationId,
    this.customerId,
    this.transitName,
    this.ho,
    this.serviceName,
    this.activityName,
    this.otherActivity,
    this.otherService,
    this.isApproved,
    this.visitSerialNo,
    this.isOnTourplan,
    this.rejectReason,
    this.hasCheckin,
    this.isCheckin,
    this.startJourney,
    this.latestCheck,
    required this.leads,
    required this.expenses,
    this.checkins,
  });

  factory Visits1.fromJson(Map<String, dynamic> json) => Visits1(
    id: json["id"] as int?,
    lat: json["lat"] as String?,
    lng: json["lng"] as String?,
    tourPlanId: json["tour_plan_id"] as int?,
    type: json["type"] as String?,
    visitDate: json["visit_date"] == null ? null : DateTime.parse(json["visit_date"]),
    address: json["address"] as String?,
    name: json["name"] as String?,
    deptName: json["dept_name"],
    visitPurpose: json["visit_purpose"] as String?,
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    locationId: json["location_id"],
    customerId: json["customer_id"] as int?,
    transitName: json["transit_name"],
    ho: json["ho"],
    serviceName: json["service_name"],
    activityName: json["activity_name"],
    otherActivity: json["other_activity"],
    otherService: json["other_service"],
    isApproved: json["is_approved"] as int?,
    visitSerialNo: json["visit_serial_no"] as String?,
    isOnTourplan: json["is_on_tourplan"] as int?,
    rejectReason: json["reject_reason"],
    hasCheckin: json["has_checkin"] as bool?,
    isCheckin: json["is_checkin"] as bool?,
    startJourney: json["start_journey"] as bool?,
    latestCheck: json["latest_check"] as bool?,
    leads: List<dynamic>.from(json["leads"]?.map((x) => x) ?? []),
    expenses: List<Expense>.from(json["expenses"]?.map((x) => Expense.fromJson(x)) ?? []),
    checkins: json["checkins"] == null ? null : Checkins.fromJson(json["checkins"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lat": lat,
    "lng": lng,
    "tour_plan_id": tourPlanId,
    "type": type,
    "visit_date": visitDate?.toIso8601String(),
    "address": address,
    "name": name,
    "dept_name": deptName,
    "visit_purpose": visitPurpose,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "location_id": locationId,
    "customer_id": customerId,
    "transit_name": transitName,
    "ho": ho,
    "service_name": serviceName,
    "activity_name": activityName,
    "other_activity": otherActivity,
    "other_service": otherService,
    "is_approved": isApproved,
    "visit_serial_no": visitSerialNo,
    "is_on_tourplan": isOnTourplan,
    "reject_reason": rejectReason,
    "has_checkin": hasCheckin,
    "is_checkin": isCheckin,
    "start_journey": startJourney,
    "latest_check": latestCheck,
    "leads": List<dynamic>.from(leads.map((x) => x)),
    "expenses": List<dynamic>.from(expenses.map((x) => x.toJson())),
    "checkins": checkins?.toJson(),
  };
}

class Checkins {
  final int id;
  final String checkinLat;
  final String checkinLng;
  final String? checkoutLat;
  final String? checkoutLng;
  final int userId;
  final int tourPlanId;
  final int visitId;
  final String? comments;
  final List<String>? images;
  final DateTime? followupDate;
  final dynamic nextFollowupDate;
  final String? outcome;
  final dynamic leadStatusId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? outchecked;
  final bool isoutcome;
  final bool checkinStatus;
  final bool? startJourney;
  final bool? latestCheck;
  final dynamic leadStatuses;
  final dynamic leadStatus;
  final dynamic outcomeStatus;
  final String? checkinAtDealerLat;
  final String? checkinAtDealerLng;

  Checkins({
    required this.id,
    required this.checkinLat,
    required this.checkinLng,
    this.checkoutLat,
    this.checkoutLng,
    required this.userId,
    required this.tourPlanId,
    required this.visitId,
    this.comments,
    this.images,
    this.followupDate,
    this.nextFollowupDate,
    this.outcome,
    this.leadStatusId,
    required this.createdAt,
    required this.updatedAt,
    this.outchecked,
    required this.isoutcome,
    required this.checkinStatus,
    this.latestCheck,
    this.startJourney,
    this.leadStatuses,
    this.leadStatus,
    this.outcomeStatus,
    this.checkinAtDealerLat,
    this.checkinAtDealerLng,
  });

  factory Checkins.fromJson(Map<String, dynamic> json) => Checkins(
    id: json["id"] as int? ?? 0,
    checkinLat: json["checkin_lat"] as String? ?? '', // Default empty string
    checkinLng: json["checkin_lng"] as String? ?? '', // Default empty string
    checkoutLat: json["checkout_lat"] as String?,
    checkoutLng: json["checkout_lng"] as String?,
    userId: json["user_id"] as int? ?? 0,
    tourPlanId: json["tour_plan_id"] as int? ?? 0,
    visitId: json["visit_id"] as int? ?? 0,
    comments: json["comments"] as String?,
    images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
    followupDate: json["followup_date"] == null ? null : DateTime.parse(json["followup_date"]),
    nextFollowupDate: json["next_followup_date"],
    outcome: json["outcome"] as String?,
    leadStatusId: json["lead_status_id"],
    createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime.now() : DateTime.parse(json["updated_at"]),
    outchecked: json["outchecked"] as int?,
    isoutcome: json["isoutcome"] as bool? ?? false, // Default false
    startJourney: json["start_journey"] as bool?,
    latestCheck: json["latest_check"] as bool?,
    checkinStatus: json["checkin_status"] as bool? ?? false, // Default false
    leadStatuses: json["lead_statuses"],
    leadStatus: json["lead_status"],
    outcomeStatus: json["outcome_status"],
    checkinAtDealerLat: json["checkin_at_dealer_lat"] as String?,
    checkinAtDealerLng: json["checkin_at_dealer_lng"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "checkin_lat": checkinLat,
    "checkin_lng": checkinLng,
    "checkout_lat": checkoutLat,
    "checkout_lng": checkoutLng,
    "user_id": userId,
    "tour_plan_id": tourPlanId,
    "visit_id": visitId,
    "comments": comments,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
    "followup_date": followupDate?.toIso8601String(),
    "next_followup_date": nextFollowupDate,
    "outcome": outcome,
    "lead_status_id": leadStatusId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "outchecked": outchecked,
    "isoutcome": isoutcome,
    "latest_check":latestCheck,
    "start_journey":startJourney,
    "checkin_status": checkinStatus,
    "lead_statuses": leadStatuses,
    "lead_status": leadStatus,
    "outcome_status": outcomeStatus,
    "checkin_at_dealer_lat": checkinAtDealerLat,
    "checkin_at_dealer_lng": checkinAtDealerLng,
  };
}

class Expense {
  final int id;
  final int visitId;
  final int salesPersonId;
  final int tourPlanId;
  //final String visitserialno;
  final String type;
  final String expensetype;
  final String amount;
  final DateTime date;
  final String? description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic departureTown;
  final dynamic arrivalTown;
  final dynamic departureTime;
  final dynamic arrivalTime;
  final dynamic modeOfTravel;
  final dynamic fare;
  final String? location;
  final dynamic daType;
  final dynamic otherAmount;
  final dynamic nonConveyanceAmount;
  final dynamic remarks;
  final String expenseStatus;
  final dynamic rejectedReason;

  Expense({
    required this.id,
    required this.visitId,
    required this.salesPersonId,
    required this.tourPlanId,
    //required this.visitserialno,
    required this.type,
    required this.expensetype,
    required this.amount,
    required this.date,
    this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.departureTown,
    this.arrivalTown,
    this.departureTime,
    this.arrivalTime,
    this.modeOfTravel,
    this.fare,
    this.location,
    this.daType,
    this.otherAmount,
    this.nonConveyanceAmount,
    this.remarks,
    required this.expenseStatus,
    this.rejectedReason,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json["id"] as int? ?? 0,
    visitId: json["visit_id"] as int? ?? 0,
    salesPersonId: json["sales_person_id"] as int? ?? 0,
    tourPlanId: json["tour_plan_id"] as int? ?? 0,
    //visitserialno: json["visit_serial_no"] as String? ?? '',
    type: json["type"] as String? ?? '',
    expensetype: json["expensetype"] as String? ?? '',
    amount: json["amount"] as String? ?? '0.00',
    date: json["date"] == null ? DateTime.now() : DateTime.parse(json["date"]),
    description: json["description"] as String?,
    status: json["status"] as String? ?? 'unknown',
    createdAt: json["created_at"] == null ? DateTime.now() : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime.now() : DateTime.parse(json["updated_at"]),
    departureTown: json["departure_town"],
    arrivalTown: json["arrival_town"],
    departureTime: json["departure_time"],
    arrivalTime: json["arrival_time"],
    modeOfTravel: json["mode_of_travel"],
    fare: json["fare"],
    location: json["location"] as String?,
    daType: json["da_type"],
    otherAmount: json["other_amount"],
    nonConveyanceAmount: json["non_conveyance_amount"],
    remarks: json["remarks"],
    expenseStatus: json["expense_status"] as String? ?? 'unknown',
    rejectedReason: json["rejected_reason"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "visit_id": visitId,
    "sales_person_id": salesPersonId,
    "tour_plan_id": tourPlanId,
    //"visit_serial_no": visitserialno,
    "type": type,
    "expensetype": expensetype,
    "amount": amount,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "description": description,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "departure_town": departureTown,
    "arrival_town": arrivalTown,
    "departure_time": departureTime,
    "arrival_time": arrivalTime,
    "mode_of_travel": modeOfTravel,
    "fare": fare,
    "location": location,
    "da_type": daType,
    "other_amount": otherAmount,
    "non_conveyance_amount": nonConveyanceAmount,
    "remarks": remarks,
    "expense_status": expenseStatus,
    "rejected_reason": rejectedReason,
  };
}