import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/views/layouts/authenticated_layout.dart';

import '../views/screens/CustomErrorMessage/CustomeErrorMessage.dart';
import '../views/screens/tours/update_plan.dart';

class TourPlanController extends GetxController {
  final isLoading = false.obs;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  // --- Create new visits (existing) ---
  Future addNewVisits({
    required String startDate,
    required String endDate,
    required List visits,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$tourplansapi'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "start_date": startDate,
          "end_date": endDate,
          "visits": visits,
        }),
      );

      print("TourPlaneCreateApiResponse : $visits");
      //print(jsonDecode(res.body));
      if (res.statusCode == 201) {
        Get.off(() => AuthenticatedLayout(newIndex: 1));
        showTopPopup("Success", "Tour plan created", Colors.green);

        // Get.snackbar(
        //   "Success",
        //   "Tour plan created",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
      }
    } catch (e, stack) {
      print(e.toString());
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }

  // --- New: Update existing tour plan ---
  Future updateTourPlan({
   //required BuildContext context,
    required String tourPlanId,
    required String startDate,
    required String endDate,
    required List visits,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.put(
        Uri.parse('$baseUrl$updatetourplans/$tourPlanId'), // PUT to /tour-plans/id
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "start_date": startDate,
          "end_date": endDate,
          "visits": visits,
        }),
      );
      print("TourPlaneUpdate Api response: ${jsonDecode(res.body)}");
      if (res.statusCode == 200) {
        Get.off(() => AuthenticatedLayout(newIndex: 1));
        showTopPopup("Success", "Tour plan updated", Colors.green);

        // Get.snackbar(
        //   "Success",
        //   "Tour plan updated",
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        //Navigator.pop(context);
       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UpdatePlan()));
      } else {
        showTopPopup("Error", "Failed to update tour plan", Colors.red);

        // Get.snackbar(
        //   "Error",
        //   "Failed to update tour plan",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } catch (e, stack) {
      // print(e.toString());
      // print(stack);
      showTopPopup("Error", "Exception occurred: $e", Colors.red);

      // Get.snackbar(
      //   "Error",
      //   "Exception occurred: $e",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isLoading.value = false;
    }
  }
}
