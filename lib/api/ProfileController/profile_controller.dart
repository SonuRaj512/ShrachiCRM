import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'package:shrachi/models/user_model.dart';
import 'package:shrachi/views/layouts/authenticated_layout.dart';

import '../../models/ProfileStatesModel.dart';

class ProfileController extends GetxController {
  final isLoading = false.obs;
  var isRefreshing = false.obs;
  var statesList = <StateModel>[].obs;
  final user = Rx<UserModel?>(null);
  final checkinsPrevious = 0.obs;
  final checkinsThisMonth = 0.obs;
  final workingDays = 0.obs;
  final activeDays = 0.obs;
  final previousDays = 0.obs;
  final leadPendingThisMonth = 0.obs;
  final leadPendingPreviousMonth = 0.obs;
  final leadFollowThisMonth = 0.obs;
  final leadFollowPreviousMonth = 0.obs;
  final latestTours = <TourPlan>[].obs;

  Future getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";
    return token;
  }

  Future profileDetails() async {
    try {
      isRefreshing.value = true;
      isLoading.value = true;
      final token = await getToken();

      final res = await http.get(
        Uri.parse('$baseUrl$me'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        user.value = UserModel.fromJson(body['data']);
        checkinsPrevious.value = body['checkinsPrevious'];
        checkinsThisMonth.value = body['checkinsThisMonth'];
        workingDays.value = body['workingDays'];
        activeDays.value = body['activeDays'];
        previousDays.value = body['previousDays'];
        leadPendingThisMonth.value = body['leadPendingThisMonth'];
        leadPendingPreviousMonth.value = body['leadPendingPreviousMonth'];
        leadFollowThisMonth.value = body['leadFollowThisMonth'];
        leadFollowPreviousMonth.value = body['leadFollowPreviousMonth'];
        latestTours.value =
            (body['latestTours'] as List)
                .map((json) => TourPlan.fromJson(json))
                .toList();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isRefreshing.value = false;
      isLoading.value = false;
    }
  }

  Future editProfile({
    required String name,
    required String email,
    //required String phone,
    required String address,
    required String state,
    required String state_description,
    required String lat,
    required String lng,
    required File? image,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$updateProfile'),
      );

      request.headers.addAll({"Authorization": "Bearer $token"});

      request.fields.addAll({
        "name": name,
        "email": email,
        //"phone": phone,
        "address": address,
        "state": state,
        "state_description": state_description,
        "lat": lat,
        "lng": lng,
      });

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await profileDetails();
        Get.to(() => AuthenticatedLayout(newIndex: 3));
        Get.snackbar(
          "Success",
          "Profile updated",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        var resBody = await response.stream.bytesToString();
        print("Error ${response.statusCode}: $resBody");
        Get.snackbar(
          "Error",
          "Failed to update profile",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Edit profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Future editProfile({
  //   required String name,
  //   required String email,
  //   required String phone,
  //   required String address,
  //   required String lat,
  //   required String lng,
  //   required File? image,
  // }) async {
  //   try {
  //     isLoading.value = true;
  //     final token = await getToken();
  //     final res = await http.post(
  //       Uri.parse('$baseUrl$updateProfile'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({
  //         "name": name,
  //         "email": email,
  //         "phone": phone,
  //         "address": address,
  //         "lat": lat,
  //         "lng": lng,
  //       }),
  //     );
  //     if (image != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath('image', image.path),
  //       );
  //     }
  //
  //     var response = await request.send();
  //     if (res.statusCode == 200) {
  //       Get.to(() => AuthenticatedLayout(newIndex: 3));
  //       await profileDetails();
  //       Get.snackbar(
  //         "Success",
  //         "Profile updated",
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // ✅ Fetch states list from API
  Future<void> fetchStates() async {
    isLoading.value = true;

    final token = await getToken();
    const apiUrl = '${baseUrl}states';
    //const apiUrl = 'https://btlsalescrm.cloud/api/states';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("🌐 Fetch States → ${response.statusCode}");
      print("📦 Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          statesList.value =
              (data['data'] as List)
                  .map((item) => StateModel.fromJson(item))
                  .toList();
        } else {
          print("⚠️ Unexpected response format: $data");
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch states (${response.statusCode})',
        );
      }
    } catch (e) {
      print('⚠️ Exception fetching states: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchStates(); // ✅ Automatically fetch states on controller load
  }
}
