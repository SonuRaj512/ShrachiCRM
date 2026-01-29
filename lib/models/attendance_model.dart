import 'package:intl/intl.dart';

class AttendanceModel {
  final int id;
  final String clockIn;
  final String clockOut;
  final String totalTime;
  final String breakTime;
  final String workingTime;
  final String createdAt;

  AttendanceModel({
    required this.id,
    required this.clockIn,
    required this.clockOut,
    required this.totalTime,
    required this.breakTime,
    required this.workingTime,
    required this.createdAt,
  });

  factory AttendanceModel.fromJson(Map json) => AttendanceModel(
    id: json['id'],
    clockIn: json['clock_in'],
    clockOut: json['clock_out'],
    totalTime: json['total_time'],
    breakTime: json['break_time'],
    workingTime: json['working_time'],
    createdAt: json['created_at'],
  );
}
