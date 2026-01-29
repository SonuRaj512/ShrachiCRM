import 'package:shrachi/models/leave_type_model.dart';

class LeaveModel {
  final int id;
  final int userId;
  final int leaveTypeId;
  final String reason;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveTypeModel? leaveType;

  LeaveModel({
    required this.id,
    required this.userId,
    required this.leaveTypeId,
    required this.reason,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.leaveType,
  });

  factory LeaveModel.fromJson(Map json) => LeaveModel(
    id: json['id'],
    userId: json['user_id'],
    leaveTypeId: json['leave_types_id'],
    reason: json['reason'],
    status: json['status'],
    startDate: DateTime.parse(json['start_date']),
    endDate: DateTime.parse(json['end_date']),
    leaveType: LeaveTypeModel.fromJson(json['leave_types']),
  );
}
