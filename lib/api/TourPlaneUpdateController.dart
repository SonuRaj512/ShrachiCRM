import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import '../views/screens/tours/tours_list.dart';
import 'api_const.dart';

class TourPlanUpdateController extends GetxController {
  // Observables for UI reactivity
  var isDeleting = false.obs;
  var isLoading = false.obs;
  var tourPlan = Rxn<TourPlan>();

  // Text editing controllers
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Initialize with a TourPlan
  void initializeTourPlan(TourPlan plan) {
    tourPlan.value = plan;
    startDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.startDate));
    endDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.endDate));
  }

  // Add a new visit to the list
  void addVisit(Visit newVisit) {
    tourPlan.value?.visits.add(newVisit);
    tourPlan.refresh(); // Notify listeners
  }

  // Update an existing visit in the list
  void updateVisit(int visitId, Visit updatedVisit) {
    int index =
        tourPlan.value?.visits.indexWhere((v) => v.id == visitId) ?? -1;
    if (index != -1) {
      tourPlan.value?.visits[index] = updatedVisit;
      tourPlan.refresh();
    }
  }
  //
  // // Delete a visit from the list
  // void deleteVisit(int visitId) {
  //   tourPlan.value?.visits.removeWhere((v) => v.id == visitId);
  //   tourPlan.refresh();
  // }

  // API call to update the entire tour plan
  Future<void> updateTourPlan() async {
    if (tourPlan.value == null) return;

    isLoading.value = true;
    final url = Uri.parse("${baseUrl}tour-plans/${tourPlan.value!.id}");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      // Format dates for the API
      DateTime parsedStart =
      DateFormat("dd-MM-yyyy").parse(startDateController.text);
      String apiStartDate = DateFormat("yyyy-MM-dd").format(parsedStart);

      DateTime parsedEnd =
      DateFormat("dd-MM-yyyy").parse(endDateController.text);
      String apiEndDate = DateFormat("yyyy-MM-dd").format(parsedEnd);

      // Prepare visits data
      final visitsData = tourPlan.value!.visits.map((visit) {
        // For new visits, 'id' will be null or 0. For existing, it will have a value.
        // The backend will create a new visit if 'id' is not provided.
        return {
          "id": visit.id == 0 ? null : visit.id,
          "type": visit.type,
          "visit_date":
          DateFormat("yyyy-MM-dd").format(DateTime.parse(visit.visitDate)),
          "name": visit.name,
          "visit_purpose": visit.visitPurpose,
          // Add other fields as required by the API...
          if (visit.type == 'new_lead' && visit.lead != null)
            "lead": {
              "lead_type": visit.lead!.type,
              "primary_no": visit.lead!.primaryNo,
              "lead_source": visit.lead!.leadSource,
              "contact_person": visit.lead!.contactPerson,
              "state": visit.lead!.state,
              "city": visit.lead!.city,
              "address": visit.lead!.address,
              "current_busniess": visit.lead!.currentBusiness,
              // ... other lead properties
            }
        };
      }).toList();

      final body = {
        "start_date": apiStartDate,
        "end_date": apiEndDate,
        "visits": visitsData,
      };

      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Tour plan updated successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAll(() => Tours()); // Navigate back to the list
      } else {
        Get.snackbar("Error", "Failed to update: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // API call to delete the tour plan
  Future<void> deleteTourPlan() async {
    if (tourPlan.value == null) return;

    isLoading.value = true;
    final url = Uri.parse("${baseUrl}tour-plans/${tourPlan.value!.id}");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final response = await http.delete(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Tour plan deleted successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.off(() => Tours());
      } else {
        Get.snackbar("Error", "Failed to delete: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a visit from the list
  Future<bool> deleteVisit(int visitId) async {
    try {
      isDeleting.value = true;

      final response = await http.delete(
        Uri.parse("${baseUrl}visitdestroy/$visitId"),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Visit deleted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green, // ✅ Green background on success
          colorText: Colors.white,        // ✅ White text
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          "Failed to delete visit",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,    // ❌ Red background on error
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,      // ❌ Red background on exception
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}