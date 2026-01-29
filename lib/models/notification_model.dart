class NotificationModel {
  final String id;
  final Map<String, dynamic> data;
  final DateTime? readAt; // Ise final hi rehne dein (Best Practice)

  NotificationModel({required this.id, required this.data, this.readAt});

  factory NotificationModel.fromJson(Map json) => NotificationModel(
    id: json['id'],
    data: json['data'],
    readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
  );

  // 🟢 Ye function add karein
  NotificationModel copyWith({DateTime? readAt}) {
    return NotificationModel(
      id: this.id,
      data: this.data,
      readAt: readAt ?? this.readAt,
    );
  }
}