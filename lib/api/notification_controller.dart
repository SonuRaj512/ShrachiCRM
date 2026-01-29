import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/notification_model.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  final isLoading = false.obs;
  final notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  // 🟢 Sabhi notifications fetch karna
  Future getAllNotifications() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl$notification'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      final body = jsonDecode(res.body);
      if (body['success']) {
        notifications.value = (body['notifications'] as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();
        unreadCount.value = body['unreadCount'] ?? 0;
      }
    } catch (e) {
      print("Error fetching notifications: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void markAsRead(String id) {
    // 1. Index dhoondein
    final index = notifications.indexWhere((n) => n.id.toString() == id);

    if (index != -1 && notifications[index].readAt == null) {
      notifications[index] = notifications[index].copyWith(readAt: DateTime.now());
      if (unreadCount.value > 0) unreadCount.value--;
      notifications.refresh();
      // Server Update (API Hit)
      markAsReadOnServer(id);
      print("Notification $id marked as read using copyWith.");
    }
  }
  // 🟢 2. Server API Hit Function (POST Method)
  Future<void> markAsReadOnServer(String id) async {
    try {
      final token = await getToken();
      final String url = '$baseUrl$notificationread/$id';
      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      print("Notification Read ${res.body}");
      if (res.statusCode == 200) {
        print("Notification $id marked as read on server successfully.");
      } else {
        print("Failed to mark as read on server. Status: ${res.statusCode}");
        print("Response: ${res.body}");
      }
    } catch (e) {
      print("Error marking notification as read on server: $e");
    }
  }
}