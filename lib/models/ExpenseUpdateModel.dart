// class UnifiedExpenseModel {
//   String type; // conveyance / non_conveyance / local_conveyance
//
//   // Common
//   String? expenseDate;
//   String? designation;
//   List<String>? images;
//
//   // Conveyance Fields
//   String? departureTown;
//   String? departureTime;
//   String? arrivalTown;
//   String? arrivalTime;
//   String? modeOfTravel;
//   String? amount;
//   String? comment;
//
//   // Non-Conveyance Fields
//   String? category;
//   String? city;
//   String? expenseType;
//   String? allowanceType;
//   String? remarks;
//   String? mislinisRemarks;
//   String? flowAmount;
//
//   // Local-Conveyance Fields
//   String? travelType;
//   String? travelAmount;
//
//   UnifiedExpenseModel({
//     required this.type,
//     this.expenseDate,
//     this.designation,
//     this.images,
//
//     this.departureTown,
//     this.departureTime,
//     this.arrivalTown,
//     this.arrivalTime,
//     this.modeOfTravel,
//     this.amount,
//     this.comment,
//
//     this.category,
//     this.city,
//     this.expenseType,
//     this.allowanceType,
//     this.remarks,
//     this.mislinisRemarks,
//     this.flowAmount,
//
//     this.travelType,
//     this.travelAmount,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       "type": type,
//       "expenseDate": expenseDate,
//       "designation": designation,
//       "images": images ?? [],
//
//       "departureTown": departureTown,
//       "departureTime": departureTime,
//       "arrivalTown": arrivalTown,
//       "arrivalTime": arrivalTime,
//       "modeOfTravel": modeOfTravel,
//       "amount": amount,
//       "comment": comment,
//
//       "category": category,
//       "city": city,
//       "expenseType": expenseType,
//       "allowanceType": allowanceType,
//       "remarks": remarks,
//       "mislinisRemarks": mislinisRemarks,
//       "flowAmount": flowAmount,
//
//       "travelType": travelType,
//       "travelAmount": travelAmount,
//     };
//   }
//
//   factory UnifiedExpenseModel.fromMap(Map<String, dynamic> map) {
//     return UnifiedExpenseModel(
//       type: map["type"],
//       expenseDate: map["expenseDate"],
//       designation: map["designation"],
//       images: map["images"] != null ? List<String>.from(map["images"]) : [],
//
//       departureTown: map["departureTown"],
//       departureTime: map["departureTime"],
//       arrivalTown: map["arrivalTown"],
//       arrivalTime: map["arrivalTime"],
//       modeOfTravel: map["modeOfTravel"],
//       amount: map["amount"],
//       comment: map["comment"] ?? "",
//
//       category: map["category"],
//       city: map["city"],
//       expenseType: map["expenseType"],
//       allowanceType: map["allowanceType"],
//       remarks: map["remarks"],
//       mislinisRemarks: map["mislinisRemarks"],
//       flowAmount: map["flowAmount"],
//
//       travelType: map["travelType"],
//       travelAmount: map["travelAmount"],
//     );
//   }
// }

class UnifiedExpenseModel {
  int id;
  String? type;

  // Conveyance
  String? departureTown;
  String? departureTime;
  String? arrivalTown;
  String? arrivalTime;
  String? modeOfTravel;
  String? amount;
  String? comment;

  // Non Conveyance
  String? category;
  String? city;
  String? expenseType;
  String? allowanceType;
  String? remarks;
  String? mislinisRemarks;
  String? flowAmount;

  // Local Conveyance
  String? travelType;
  String? travelAmount;

  UnifiedExpenseModel({
    required this.id,
    this.type,

    this.departureTown,
    this.departureTime,
    this.arrivalTown,
    this.arrivalTime,
    this.modeOfTravel,
    this.amount,
    this.comment,

    this.category,
    this.city,
    this.expenseType,
    this.allowanceType,
    this.remarks,
    this.mislinisRemarks,
    this.flowAmount,

    this.travelType,
    this.travelAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "type": type,

      "departureTown": departureTown,
      "departureTime": departureTime,
      "arrivalTown": arrivalTown,
      "arrivalTime": arrivalTime,
      "modeOfTravel": modeOfTravel,
      "amount": amount,
      "comment": comment,

      "category": category,
      "city": city,
      "expenseType": expenseType,
      "allowanceType": allowanceType,
      "remarks": remarks,
      "mislinisRemarks": mislinisRemarks,
      "flowAmount": flowAmount,

      "travelType": travelType,
      "travelAmount": travelAmount,
    };
  }
}
