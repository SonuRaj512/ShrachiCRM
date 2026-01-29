class ClockData {
  final DateTime? clockIn;
  final DateTime? clockOut;
  final List<BreakModel> breaks;

  ClockData({
    this.clockIn,
    this.clockOut,
    required this.breaks,
  });

  factory ClockData.fromJson(Map<String, dynamic> json) {
    return ClockData(
      clockIn: json["clock_in"] != null ? DateTime.parse(json["clock_in"]) : null,
      clockOut: json["clock_out"] != null ? DateTime.parse(json["clock_out"]) : null,
      breaks: (json["breaks"] as List)
          .map((e) => BreakModel.fromJson(e))
          .toList(),
    );
  }
}

class BreakModel {
  final int id;
  final String breakType;
  final DateTime breakStart;
  final DateTime? breakEnd;

  BreakModel({
    required this.id,
    required this.breakType,
    required this.breakStart,
    this.breakEnd,
  });

  factory BreakModel.fromJson(Map<String, dynamic> json) {
    return BreakModel(
      id: json["id"],
      breakType: json["break_type"],
      breakStart: DateTime.parse(json["break_start"]),
      breakEnd: json["break_end"] != null ? DateTime.parse(json["break_end"]) : null,
    );
  }
}
