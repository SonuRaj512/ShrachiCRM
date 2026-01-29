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
        notifications.value =
            (body['notifications'] as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();
        unreadCount.value = body['unreadCount'];
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
