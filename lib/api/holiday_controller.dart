import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/holiday.dart';

class HolidayController extends GetxController {
  final isLoading = false.obs;
  final holidays = <Holiday>[].obs;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  Future getAllHolidays() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl$holiday'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final body = jsonDecode(res.body);
      if (body['success']) {
        holidays.value =
            (body['data'] as List)
                .map((json) => Holiday.fromJson(json))
                .toList();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
