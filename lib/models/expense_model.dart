// class ExpenseModel {
//   final int id; // ✅ Added ID
//   final int tourPlanId;
//   final int visitId;
//   final DateTime date;
//   final String? expenseType;
//   final String? type;
//   final String? departureTown;
//   final DateTime? departureTime;
//   final String? arrivalTown;
//   final DateTime? arrivalTime;
//   final String? modeOfTravel;
//   final double? fare;
//   final String? remarks;
//   final List? images;
//   final String? location;
//   final double? amount;
//   final String? daType;
//   final String? serialNo;
//   String? expenseStatus; // ✅ Added for status
//
//   ExpenseModel({
//     required this.id, // ✅ constructor
//     required this.tourPlanId,
//     required this.visitId,
//     required this.date,
//     required this.expenseType,
//     this.type,
//     this.departureTown,
//     this.departureTime,
//     this.arrivalTown,
//     this.arrivalTime,
//     this.modeOfTravel,
//     this.fare,
//     this.remarks,
//     this.images,
//     this.location,
//     this.amount,
//     this.daType,
//     this.serialNo,
//     this.expenseStatus, // ✅ constructor
//   });
//
//   factory ExpenseModel.fromJson(Map json) => ExpenseModel(
//     id: json['id'], // ✅ from JSON
//     tourPlanId: json['tour_plan_id'],
//     visitId: json['visit_id'],
//     date: DateTime.parse(json['date']),
//     expenseType: json['expensetype'],
//     type: json['type'],
//     departureTown: json['departure_town'],
//     departureTime: json['departure_time'] != null
//         ? DateTime.parse(json['departure_time'])
//         : null,
//     arrivalTown: json['arrival_town'],
//     arrivalTime: json['arrival_time'] != null
//         ? DateTime.parse(json['arrival_time'])
//         : null,
//     modeOfTravel: json['mode_of_travel'],
//     fare: json['fare'] != null
//         ? double.tryParse(json['fare'].toString())
//         : null,
//     remarks: json['remarks'],
//     images: (json['images'] as List? ?? []),
//     location: json['location'],
//     amount: json['amount'] != null
//         ? double.tryParse(json['amount'].toString())
//         : null,
//     daType: json['da_type'],
//     serialNo: json['serial_no'],
//     expenseStatus: json['expense_status'] ?? 'pending', // ✅ default value
//   );
// }
class CheckinModel {
  final int id;
  final String checkinLat;
  final String checkinLng;
  final String? checkoutLat;
  final String? checkoutLng;
  final int userId;
  final int tourPlanId;
  final int visitId;
  final String? comments;
  final List<String> images;
  final String? followupDate;
  final String? nextFollowupDate;
  final String? outcome; // ✅ Outcome field
  final int? leadStatusId;
  final String createdAt;
  final String updatedAt;
  final bool isOutcome;
  final bool checkinStatus;
  final String? outcomeStatus;
  final String? outchecked;
  final String checkinAtDealerLat;
  final String checkinAtDealerLng;
  final String? checkinDealerTime;
  final String? checkoutDealerTime;
  final String? checkInDatetime;
  final String? convinceType;
  final String? convinceText;
  final String? checkInDistance;
  final dynamic leadStatuses;

  CheckinModel({
    required this.id,
    required this.checkinLat,
    required this.checkinLng,
    this.checkoutLat,
    this.checkoutLng,
    required this.userId,
    required this.tourPlanId,
    required this.visitId,
    this.comments,
    required this.images,
    this.followupDate,
    this.nextFollowupDate,
    this.outcome,
    this.leadStatusId,
    required this.createdAt,
    required this.updatedAt,
    required this.isOutcome,
    required this.checkinStatus,
    this.outcomeStatus,
    this.outchecked,
    required this.checkinAtDealerLat,
    required this.checkinAtDealerLng,
    this.checkinDealerTime,
    this.checkoutDealerTime,
    this.checkInDatetime,
    this.convinceType,
    this.convinceText,
    this.checkInDistance,
    this.leadStatuses,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      id: json['id'],
      checkinLat: json['checkin_lat'],
      checkinLng: json['checkin_lng'],
      checkoutLat: json['checkout_lat'],
      checkoutLng: json['checkout_lng'],
      userId: json['user_id'],
      tourPlanId: json['tour_plan_id'],
      visitId: json['visit_id'],
      comments: json['comments'],
      images: List<String>.from(json['images'] ?? []),
      followupDate: json['followup_date'],
      nextFollowupDate: json['next_followup_date'],
      outcome: json['outcome'], // ✅ Outcome parsed here
      leadStatusId: json['lead_status_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isOutcome: json['isoutcome'],
      checkinStatus: json['checkin_status'],
      outcomeStatus: json['outcome_status'],
      outchecked: json['outchecked'],
      checkinAtDealerLat: json['checkin_at_dealer_lat'],
      checkinAtDealerLng: json['checkin_at_dealer_lng'],
      checkinDealerTime: json['checkin_dealer_time'],
      checkoutDealerTime: json['checkout_dealer_time'],
      checkInDatetime: json['check_in_datetime'],
      convinceType: json['convince_type'],
      convinceText: json['convince_text'],
      checkInDistance: json['checkIn_distance'],
      leadStatuses: json['lead_statuses'],
    );
  }
}
class VisitModel {
  final int id;
  final CheckinModel? checkins;

  VisitModel({
    required this.id,
    this.checkins,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      checkins: json['checkins'] != null
          ? CheckinModel.fromJson(json['checkins'])
          : null,
    );
  }
}
class ExpenseModel {
  final int id;
  final int tourPlanId;
  final int visitId;
  final DateTime date;
  final String? expenseType;
  final String? type;
  final String? departureTown;
  final DateTime? departureTime;
  final String? arrivalTown;
  final DateTime? arrivalTime;
  final String? modeOfTravel;
  final double? fare;
  final String? remarks;
  final List? images;
  final String? location;
  final double? amount;
  final String? daType;
  String? expenseStatus;
  final VisitModel? visit; // ✅ Nested Visit

  ExpenseModel({
    required this.id,
    required this.tourPlanId,
    required this.visitId,
    required this.date,
    required this.expenseType,
    this.type,
    this.departureTown,
    this.departureTime,
    this.arrivalTown,
    this.arrivalTime,
    this.modeOfTravel,
    this.fare,
    this.remarks,
    this.images,
    this.location,
    this.amount,
    this.daType,
    this.expenseStatus,
    this.visit,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['id'],
    tourPlanId: json['tour_plan_id'],
    visitId: json['visit_id'],
    date: DateTime.parse(json['date']),
    expenseType: json['expensetype'],
    type: json['type'],
    departureTown: json['departure_town'],
    departureTime: json['departure_time'] != null
        ? DateTime.parse(json['departure_time'])
        : null,
    arrivalTown: json['arrival_town'],
    arrivalTime: json['arrival_time'] != null
        ? DateTime.parse(json['arrival_time'])
        : null,
    modeOfTravel: json['mode_of_travel'],
    fare: json['fare'] != null ? double.tryParse(json['fare'].toString()) : null,
    remarks: json['remarks'],
    images: (json['images'] as List? ?? []),
    location: json['location'],
    amount: json['amount'] != null ? double.tryParse(json['amount'].toString()) : null,
    daType: json['da_type'],
    expenseStatus: json['expense_status'] ?? 'pending',
    visit: json['visit'] != null ? VisitModel.fromJson(json['visit']) : null,
  );
}
