import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'api_const.dart';

class VisitDetailController extends GetxController {
  var dealerName = ''.obs;
  var visitType = ''.obs;
  var visitDate = ''.obs;
  var isLoading = false.obs;

  /// Fetch Visit Details by Visit ID
  Future<void> fetchVisitData(int visitId) async {
    try {
      isLoading.value = true;
      final url = Uri.parse("${baseUrl}checkin/$visitId");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        dealerName.value = data['name'] ?? 'N/A';
        visitType.value = data['type'] ?? 'N/A';

        final rawDate = data['visit_date'];
        if (rawDate != null && rawDate.isNotEmpty) {
          final parsedDate = DateTime.tryParse(rawDate);
          visitDate.value = parsedDate != null
              ? "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}"
              : 'N/A';
        } else {
          visitDate.value = 'N/A';
        }
      } else {
        Get.snackbar("Error", "Failed to fetch visit data (Status ${res.statusCode})",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
////2 days of Oct
