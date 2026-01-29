class NotificationModel {
  final String id;
  final Map<String, dynamic> data;
  final DateTime? readAt;

  NotificationModel({required this.id, required this.data, this.readAt});

  factory NotificationModel.fromJson(Map json) => NotificationModel(
    id: json['id'],
    data: json['data'],
    readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
  );
}
