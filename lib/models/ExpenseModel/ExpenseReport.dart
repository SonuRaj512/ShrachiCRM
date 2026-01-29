class TourPlan {
  final int id;
  final String serialNo;
  final String status;
  final String tourStatus;
  final String startDate;
  final String endDate;
  final String createdAt;
  final User user;
  final List<Visit> visits;

  TourPlan({
    required this.id, required this.serialNo, required this.status,
    required this.tourStatus, required this.startDate, required this.endDate,
    required this.createdAt, required this.user, required this.visits,
  });

  factory TourPlan.fromJson(Map<String, dynamic> json) {
    var list = json['visits'] as List? ?? [];
    List<Visit> visitsList = list.map((i) => Visit.fromJson(i)).toList();
    return TourPlan(
      id: json['id'] ?? 0,
      serialNo: json['serial_no'] ?? '',
      status: json['status'] ?? '',
      tourStatus: json['tour_status'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      visits: visitsList,
    );
  }
}

class User {
  final String name;
  final String employeeCode;
  final String designation;

  User({required this.name, required this.employeeCode, required this.designation});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      employeeCode: json['employee_code'] ?? '',
      designation: json['designation']?['designation_name'] ?? '',
    );
  }
}

class Visit {
  final String name;
  final String visitDate;
  final String type;
  final String visitPurpose;
  final int is_approved;
  final String reject_reason;
  final List<Expense> expenses;
  final CheckIns? checkins;

  Visit({
    required this.name,
    required this.visitDate,
    required this.type,
    required this.visitPurpose,
    required this.is_approved,
    required this.reject_reason,
    required this.expenses,
    this.checkins,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    var expList = json['expenses'] as List? ?? [];
    List<Expense> expensesList = expList.map((i) => Expense.fromJson(i)).toList();
    return Visit(
      name: json['name'] ?? 'Unknown',
      visitDate: json['visit_date'] ?? '',
      type: json['type'] ?? '',
      visitPurpose: json['visit_purpose'] ?? '',
      is_approved: json['is_approved'] ?? '',
      reject_reason: json['reject_reason'] ?? '',
      expenses: expensesList,
      checkins: json['checkins'] != null ? CheckIns.fromJson(json['checkins']) : null,
    );
  }
}

class CheckIns {
  final String checkInTime;
  final String outcome;

  CheckIns({required this.checkInTime, required this.outcome});

  factory CheckIns.fromJson(Map<String, dynamic> json) {
    return CheckIns(
      checkInTime: json['checkin_dealer_time'] ?? '',
      outcome: json['outcome'] ?? '',
    );
  }
}

class Expense {
  final String expenseType;
  final String type;
  final double amount;
  final String date;
  final String departureTown;
  final String arrivalTown;
  final String departureTime;
  final String arrivalTime;
  final String modeOfTravel;
  final String remarks;
  final String location;

  Expense({
    required this.expenseType, required this.type, required this.amount,
    required this.date, required this.departureTown, required this.arrivalTown,
    required this.departureTime, required this.arrivalTime, required this.modeOfTravel,
    required this.remarks, required this.location,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      expenseType: json['expensetype'] ?? '',
      type: json['type'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: json['date'] ?? '',
      departureTown: json['departure_town'] ?? '',
      arrivalTown: json['arrival_town'] ?? '',
      departureTime: json['departure_time'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      modeOfTravel: json['mode_of_travel'] ?? '',
      remarks: json['remarks'] ?? '',
      location: json['location'] ?? '',
    );
  }
}