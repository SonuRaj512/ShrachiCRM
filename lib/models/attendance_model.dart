class AttendanceModel {
  final int id;
  final String clockIn;
  final String clockOut;
  final String clockInLat;
  final String clockInLng;
  final String clockOutLat;
  final String clockOutLng;
  final String totalTime;
  final String breakTime;
  final String workingTime;
  final String createdAt;
  final List<BreakModel> breaks;

  AttendanceModel({
    required this.id,
    required this.clockIn,
    required this.clockOut,
    required this.clockInLat,
    required this.clockInLng,
    required this.clockOutLat,
    required this.clockOutLng,
    required this.totalTime,
    required this.breakTime,
    required this.workingTime,
    required this.createdAt,
    required this.breaks,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      clockIn: json['clock_in'] ?? "",
      clockOut: json['clock_out'] ?? "",
      clockInLat: json['clock_in_lat'] ?? "",
      clockInLng: json['clock_in_lng'] ?? "",
      clockOutLat: json['clock_out_lat'] ?? "",
      clockOutLng: json['clock_out_lng'] ?? "",
      totalTime: json['total_time'] ?? "00:00",
      breakTime: json['break_time'] ?? "00:00",
      workingTime: json['working_time'] ?? "00:00",
      createdAt: json['created_at'] ?? "",
      breaks: json['breaks'] != null
          ? (json['breaks'] as List)
          .map((e) => BreakModel.fromJson(e))
          .toList()
          : [],
    );
  }
}

class BreakModel {
  final int id;
  final String breakStart;
  final String breakEnd;
  final String durationSeconds;
  final String breakType;

  BreakModel({
    required this.id,
    required this.breakStart,
    required this.breakEnd,
    required this.durationSeconds,
    required this.breakType,
  });

  factory BreakModel.fromJson(Map<String, dynamic> json) {
    return BreakModel(
      id: json['id'] ?? 0,
      breakStart: json['break_start'] ?? "",
      breakEnd: json['break_end'] ?? "", // 👈 Suspect
      durationSeconds: json['duration']?.toString() ?? "0", // String conversion safety
      breakType: json['break_type'] ?? "",
    );
  }
}

// class AttendanceModel {
//   final int id;
//   final String clockIn;
//   final String clockOut;
//   final String clockInLat;
//   final String clockInLng;
//   final String clockOutLat;
//   final String clockOutLng;
//   final String totalTime;
//   final String breakTime;
//   final String workingTime;
//   final String createdAt;
//   final List<BreakModel> breaks;
//
//   AttendanceModel({
//     required this.id,
//     required this.clockIn,
//     required this.clockOut,
//     required this.clockInLat,
//     required this.clockInLng,
//     required this.clockOutLat,
//     required this.clockOutLng,
//     required this.totalTime,
//     required this.breakTime,
//     required this.workingTime,
//     required this.createdAt,
//     required this.breaks,
//   });
//
//   factory AttendanceModel.fromJson(Map<String, dynamic> json) {
//     return AttendanceModel(
//       id: json['id'],
//       clockIn: json['clock_in'],
//       clockOut: json['clock_out'],
//       clockInLat: json['clock_in_lat'] ?? "",
//       clockInLng: json['clock_in_lng'] ?? "",
//       clockOutLat: json['clock_out_lat'] ?? "",
//       clockOutLng: json['clock_out_lng'] ?? "",
//       totalTime: json['total_time'],
//       breakTime: json['break_time'],
//       workingTime: json['working_time'],
//       createdAt: json['created_at'],
//       breaks: json['breaks'] != null
//           ? (json['breaks'] as List)
//           .map((e) => BreakModel.fromJson(e))
//           .toList()
//           : [],
//     );
//   }
// }
//
// class BreakModel {
//   final int id;
//   final String breakStart;
//   final String breakEnd;
//   final String durationSeconds;
//   final String breakType;
//
//   BreakModel({
//     required this.id,
//     required this.breakStart,
//     required this.breakEnd,
//     required this.durationSeconds,
//     required this.breakType,
//   });
//
//   factory BreakModel.fromJson(Map<String, dynamic> json) {
//     return BreakModel(
//       id: json['id'],
//       breakStart: json['break_start'],
//       breakEnd: json['break_end'],
//       durationSeconds: json['duration'],
//       breakType: json['break_type'],
//     );
//   }
// }