import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/api/attendance_controller.dart';
import 'package:shrachi/api/tracking_controller.dart';
import 'package:shrachi/views/screens/checkins/checkins_map.dart';
import 'package:shrachi/views/screens/checkins/ExpensePage/expense_list.dart';
import '../OfflineDatabase/DBHelper.dart';
import '../utils/internet_helper.dart';
import '../views/screens/checkins/CheckinNoMap_Screen.dart';
import 'LocationHelper/LocationHelper.dart';

class CheckinController extends GetxController {
  final isLoading = false.obs;
  var hasOutcome = false.obs;
  var isCheckedOut = false.obs;
  var existingOutcome = "".obs;

  final TrackingController trackingController = Get.put(TrackingController(30));
  final AttendanceController attendanceController = Get.put(
    AttendanceController(),
  );

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }
  ///this code is direct api calling and internet



  // Future checkInVisit({
  //   required String Type,
  //   required double lat,
  //   required double lng,
  //   required int tourPlanId,
  //   required int visitId,
  //   required bool hasCheckin,
  //   bool? islatestcheck,
  //   required DateTime startDate,
  // })
  // async {
  //   try {
  //     if (hasCheckin) {
  //       Get.to(() => ExpenseList(
  //         tourPlanId: tourPlanId,
  //         visitId: visitId,
  //         startDate: startDate,
  //       ));
  //       return;
  //     }
  //
  //     isLoading.value = true;
  //
  //     bool allowed = await LocationHelper.ensurePermission();
  //     if (!allowed) return;
  //
  //     final position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //     );
  //
  //     final token = await getToken();
  //
  //     final res = await http.post(
  //       Uri.parse('$baseUrl$startjounery'),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         'checkin_lat': position.latitude,
  //         'checkin_lng': position.longitude,
  //         'tour_plan_id': tourPlanId,
  //         'visit_id': visitId,
  //       }),
  //     );
  //
  //     final body = jsonDecode(res.body);
  //
  //     if (body['success'] == true) {
  //       if (lat == 0.0 || lng == 0.0) {
  //         Get.off(() => CheckinNoMap_Screen(
  //           tourPlanId: tourPlanId,
  //           visitId: visitId,
  //           Type: Type,
  //           StartDate: startDate,
  //         ));
  //       } else {
  //         Get.off(() => CheckinsMap(
  //           tourPlanId: tourPlanId,
  //           visitId: visitId,
  //           coordinate: LatLng(lat, lng),
  //           Type: Type,
  //           islatestcheck: islatestcheck,
  //           startDate: startDate,
  //         ));
  //       }
  //     }
  //   } catch (e, s) {
  //     debugPrint(e.toString());
  //     debugPrint(s.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  // Future<bool> submitVisitRemark({required int visitId, required String reason,}) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final response = await http.post(
  //       Uri.parse("${baseUrl}visit-rsn/$visitId"),
  //       body: {"reject_reason": reason},
  //     );
  //
  //     isLoading.value = false;
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return true;
  //     } else {
  //       print("❌ API failed: ${response.body}");
  //       return false;
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     print("⚠️ Error submitting remark: $e");
  //     return false;
  //   }
  // }
  ///this code is api hit in internet and no internet working localdatabase
  // Future checkInVisit({
  //   required String Type,
  //   required double lat,
  //   required double lng,
  //   required int tourPlanId,
  //   required int visitId,
  //   required bool hasCheckin,
  //   bool? islatestcheck,
  //   required DateTime startDate,
  // })
  // async {
  //   try {
  //     if (hasCheckin) {
  //       Get.to(() => ExpenseList(tourPlanId: tourPlanId, visitId: visitId, startDate: startDate,));
  //       return;
  //     }
  //     isLoading.value = true;
  //
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       await Geolocator.openLocationSettings();
  //       throw Exception("Location services are disabled.");
  //     }
  //
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         throw Exception("Location permissions are denied.");
  //       }
  //     }
  //
  //     if (permission == LocationPermission.deniedForever) {
  //       throw Exception("Location permissions are permanently denied.");
  //     }
  //
  //     final position = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(
  //         accuracy: LocationAccuracy.best,
  //         distanceFilter: 0,
  //       ),
  //     );
  //     final token = await getToken();
  //     final res = await http.post(
  //       Uri.parse('$baseUrl$startjounery'),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         'checkin_lat': position.latitude,
  //         'checkin_lng': position.longitude,
  //         'tour_plan_id': tourPlanId,
  //         'visit_id': visitId,
  //       }),
  //     );
  //     final body = jsonDecode(res.body);
  //     print("Checking data $body");
  //     if (body['success']) {
  //       if (!attendanceController.isClockedIn.value) {
  //         attendanceController.clockIn();
  //       }
  //       // Get.off(
  //       //   () => CheckinsMap(
  //       //     tourPlanId: tourPlanId,
  //       //     visitId: visitId,
  //       //     coordinate: LatLng(lat, lng),
  //       //   ),
  //       // );
  //       /// ✅ If lat/lng null or 0 → navigate without destination
  //       if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
  //         print("Data If part me ja raha hai");
  //         Get.off(
  //               () => CheckinNoMap_Screen(
  //             tourPlanId: tourPlanId,
  //             visitId: visitId,
  //             Type: Type,
  //             StartDate: startDate,
  //           ),
  //         );
  //         print("Lat Long gvdwvwgyvdygvcgdvghdvsgcdsvc${lat}");
  //         print("Lat Long gvdwvwgyvdygvcgdvghdvsgcdsvc${lng}");
  //       } else {
  //         /// ✅ Else normal navigation with route
  //         print("Data Else part me ja raha hai");
  //         Get.off(
  //               () => CheckinsMap(
  //             tourPlanId: tourPlanId,
  //             visitId: visitId,
  //             coordinate: LatLng(lat, lng),
  //             Type: Type,
  //             islatestcheck: islatestcheck,
  //             startDate: startDate,
  //           ),
  //         );
  //         print("Lat Long gvdwvwgyvdygvcgdvghdvsgcdsvc${lat}");
  //         print("Lat Long gvdwvwgyvdygvcgdvghdvsgcdsvc${lng}");
  //       }
  //       trackingController.startLocationUpdates();
  //     }
  //   } catch (e, stack) {
  //     debugPrint(e.toString());
  //     debugPrint(stack.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future checkInVisit({
    required String Type,
    required double lat,
    required double lng,
    required int tourPlanId,
    required int visitId,
    required bool hasCheckin,
    bool? islatestcheck,
    required DateTime startDate,
  })
  async {
    try {
      // 🔹 Already checked-in
      if (hasCheckin) {
        Get.to(() => ExpenseList(
          tourPlanId: tourPlanId,
          visitId: visitId,
          startDate: startDate,
        ));
        return;
      }

      isLoading.value = true;

      final online = await hasInternet();

      // ================= OFFLINE MODE =================
      if (!online) {
        await DatabaseHelper.instance.addToSyncQueue(
          "CHECKIN",
          visitId,
          {
            "tour_plan_id": tourPlanId,
            "visit_id": visitId,
            "lat": lat,
            "lng": lng,
            "type": Type,
            "start_date": startDate.toIso8601String(),
          },
        );

        // ✅ Clock-in locally
        if (!attendanceController.isClockedIn.value) {
          attendanceController.clockIn();
        }

        // ✅ START LIVE TRACKING (OFFLINE ALSO)
        trackingController.startLocationUpdates();

        Get.snackbar(
          "Offline",
          "Check-in saved. Live tracking started.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );

        // Navigation
        if (lat == 0.0 || lng == 0.0) {
          Get.off(() => CheckinNoMap_Screen(
            tourPlanId: tourPlanId,
            visitId: visitId,
            Type: Type,
            StartDate: startDate,
          ));
        } else {
          Get.off(() => CheckinsMap(
            tourPlanId: tourPlanId,
            visitId: visitId,
            coordinate: LatLng(lat, lng),
            Type: Type,
            islatestcheck: islatestcheck,
            startDate: startDate,
          ));
        }

        return;
      }

      // ================= ONLINE MODE =================
      bool allowed = await LocationHelper.ensurePermission();
      if (!allowed) return;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );

      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$startjounery'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'checkin_lat': position.latitude,
          'checkin_lng': position.longitude,
          'tour_plan_id': tourPlanId,
          'visit_id': visitId,
        }),
      );

      final body = jsonDecode(res.body);

      if (body['success'] == true) {

        // ✅ Attendance clock-in
        if (!attendanceController.isClockedIn.value) {
          attendanceController.clockIn();
        }

        // ✅ START LIVE TRACKING (IMPORTANT)
        trackingController.startLocationUpdates();

        // Navigation
        if (lat == 0.0 || lng == 0.0) {
          Get.off(() => CheckinNoMap_Screen(
            tourPlanId: tourPlanId,
            visitId: visitId,
            Type: Type,
            StartDate: startDate,
          ));
        } else {
          Get.off(() => CheckinsMap(
            tourPlanId: tourPlanId,
            visitId: visitId,
            coordinate: LatLng(lat, lng),
            Type: Type,
            islatestcheck: islatestcheck,
            startDate: startDate,
          ));
        }
      }
    } catch (e, s) {
      debugPrint("CHECKIN ERROR: $e");
      debugPrint(s.toString());
    } finally {
      isLoading.value = false;
    }
  }

  ///es code me koi live trackin nahi ho raha hai
  // Future checkInVisit({
  //   required String Type,
  //   required double lat,
  //   required double lng,
  //   required int tourPlanId,
  //   required int visitId,
  //   required bool hasCheckin,
  //   bool? islatestcheck,
  //   required DateTime startDate,
  // })
  // async {
  //   try {
  //     isLoading.value = true;
  //
  //     // 🔹 If already checked out → go to expense
  //     if (hasCheckin) {
  //       Get.to(() => ExpenseList(
  //         tourPlanId: tourPlanId,
  //         visitId: visitId,
  //         startDate: startDate,
  //       ));
  //       return;
  //     }
  //
  //     final online = await hasInternet();
  //
  //     // ================= OFFLINE MODE =================
  //     if (!online) {
  //       // Save action to SQLite sync queue
  //       await DatabaseHelper.instance.addToSyncQueue(
  //         "CHECKIN",
  //         visitId,
  //         {
  //           "tour_plan_id": tourPlanId,
  //           "visit_id": visitId,
  //           "lat": lat,
  //           "lng": lng,
  //           "type": Type,
  //           "start_date": startDate.toIso8601String(),
  //         },
  //       );
  //
  //       // Show success message
  //       Get.snackbar(
  //         "Offline",
  //         "Check-in saved. Will sync when internet is available.",
  //         backgroundColor: Colors.orange,
  //         colorText: Colors.white,
  //       );
  //
  //       // Navigate same as success
  //       Get.off(() => CheckinsMap(
  //         tourPlanId: tourPlanId,
  //         visitId: visitId,
  //         coordinate: LatLng(lat, lng),
  //         Type: Type,
  //         islatestcheck: islatestcheck,
  //         startDate: startDate,
  //       ));
  //
  //       return;
  //     }
  //
  //     // ================= ONLINE MODE =================
  //     bool allowed = await LocationHelper.ensurePermission();
  //     if (!allowed) return;
  //
  //     final position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best,
  //     );
  //
  //     final token = await getToken();
  //     final res = await http.post(
  //       Uri.parse('$baseUrl$startjounery'),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode({
  //         'checkin_lat': position.latitude,
  //         'checkin_lng': position.longitude,
  //         'tour_plan_id': tourPlanId,
  //         'visit_id': visitId,
  //       }),
  //     );
  //
  //     final body = jsonDecode(res.body);
  //
  //     if (body['success'] == true) {
  //       if (lat == 0.0 || lng == 0.0) {
  //         Get.off(() => CheckinNoMap_Screen(
  //           tourPlanId: tourPlanId,
  //           visitId: visitId,
  //           Type: Type,
  //           StartDate: startDate,
  //         ));
  //       } else {
  //         Get.off(() => CheckinsMap(
  //           tourPlanId: tourPlanId,
  //           visitId: visitId,
  //           coordinate: LatLng(lat, lng),
  //           Type: Type,
  //           islatestcheck: islatestcheck,
  //           startDate: startDate,
  //         ));
  //       }
  //     }
  //   } catch (e, s) {
  //     debugPrint(e.toString());
  //     debugPrint(s.toString());
  //   } finally {
  //     isLoading.value = false; // 🔐 Loader always stops
  //   }
  // }
  Future<bool> submitVisitRemark({required int visitId, required String reason,}) async {
    try {
      isLoading.value = true;

      final online = await hasInternet();

      // OFFLINE
      if (!online) {
        await DatabaseHelper.instance.addToSyncQueue(
          "VISIT_REMARK",
          visitId,
          {
            "visit_id": visitId,
            "reject_reason": reason,
          },
        );
        return true;
      }

      print("Cancel CheckIn Visit Id: $visitId");
      // ONLINE
      final response = await http.post(Uri.parse("$baseUrl$checkinCancel/$visitId"), body: {"reject_reason": reason},);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Dealer Check-In (Main Check-In)
  Future<bool> checkIncontroller({
    required double lat,
    required double lng,
    required int tourPlanId,
    required int visitId,
    required String convinceType,
    String? convinceText,
    double? checkIn_distance,
    bool isSync = false,
  })
  async {
    try {
      final online = await hasInternet();

      // OFFLINE: Local DB
      if (!online && !isSync) {
        await DatabaseHelper.instance.saveOfflineCheckin(
          lat: lat,
          lng: lng,
          tourPlanId: tourPlanId,
          visitId: visitId,
          convinceType: convinceType,
          convinceText: convinceText,
          checkIn_distance: checkIn_distance,
        );

        Get.snackbar(
          "Offline Mode",
          "Check-in saved locally. Will auto-sync when internet returns.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return true;
      }

      if (!isSync) isLoading.value = true;

      final token = await getToken();
      if (token.isEmpty) return false;

      final url = Uri.parse("$baseUrl$checkIn");
      final body = {
        "checkin_at_dealer_lat": lat.toString(),
        "checkin_at_dealer_lng": lng.toString(),
        "tour_plan_id": tourPlanId.toString(),
        "visit_id": visitId.toString(),
        "checkIn_distance": (checkIn_distance ?? 0.0).toString(),
        "type": convinceType,
        "convince_text": convinceText ?? '',
      };

      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["success"] == true) {
        if (!isSync) {
          Get.snackbar("Success", "Check-In successful", backgroundColor: Colors.green, colorText: Colors.white);
        }
        return true;
      }
      return false;
    } catch (e) {
      print("CheckIn Exception: $e");
      if (!isSync) {
        Get.snackbar("Error", "Check-in failed", backgroundColor: Colors.red);
      }
      return false;
    } finally {
      if (!isSync) isLoading.value = false;
    }
  }
  Future<bool> CheckoutController({
    required double lat,
    required double lng,
    required int tourPlanId,
    required int visitId,
    String? additionalInfo,
    required List<File> images,
    required DateTime startDate,
    bool isSync = false,
  })
  async {
    try {
      final online = await hasInternet();

      // OFFLINE: Local DB
      if (!online && !isSync) {
        await DatabaseHelper.instance.saveOfflineCheckout(
          lat: lat,
          lng: lng,
          tourPlanId: tourPlanId,
          visitId: visitId,
          images: images,
          additionalInfo: additionalInfo,
          startDate: startDate,
        );

        Get.snackbar(
          "Offline Mode",
          "Check-out saved with ${images.length} image${images.length > 1 ? 's' : ''}. Will auto-sync later.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        //Get.off(() => ExpenseList(tourPlanId: tourPlanId, visitId: visitId, startDate: startDate));
        return true;
      }

      if (!isSync) isLoading.value = true;

      final token = await getToken();
      if (token.isEmpty) return false;

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$checkInUpdate'));
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        'tour_plan_id': tourPlanId.toString(),
        'visit_id': visitId.toString(),
        'comments': additionalInfo ?? '',
        'checkout_lat': lat.toString(),
        'checkout_lng': lng.toString(),
      });

      for (var img in images) {
        if (img.existsSync()) {
          request.files.add(await http.MultipartFile.fromPath('images[]', img.path));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        if (!isSync) {
          Get.snackbar("Success", "Check-Out successful", backgroundColor: Colors.green, colorText: Colors.white);
          Get.off(() => ExpenseList(tourPlanId: tourPlanId, visitId: visitId, startDate: startDate));
        }
        return true;
      } else {
        print("❌ Checkout API Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Checkout Exception: $e");
      if (!isSync) {
        Get.snackbar("Error", "Check-out failed", backgroundColor: Colors.red);
      }
      return false;
    } finally {
      if (!isSync) isLoading.value = false;
    }
  }

  Future<void> checkOutVisit({
    required int tourPlanId,
    required int visitId,
    required String followupDate,
    String? nextFollowupDate,
    String? outcome,
    dynamic leadStatus,
    DateTime? startDate,
  })
  async {
    try {
      isLoading.value = true;

      final token = await getToken();
      final url = '$baseUrl$OutCome';

      // 🔹 Build request body safely
      final Map<String, dynamic> body = {
        'tour_plan_id': tourPlanId,
        'visit_id': visitId,
        'followup_date': followupDate,
        'next_followup_date': nextFollowupDate, // may be null
        'outcome': outcome, // 🔹 Only add lead_status_id if available
        'lead_status_id': leadStatus != null ? leadStatus.id : null,
      };

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      print("OutCome Data${res.body}");
      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);
        if (responseBody['success'] == true) {
          isCheckedOut.value = true;
          trackingController.stopLocationUpdates();

          Get.off(() => ExpenseList(tourPlanId: tourPlanId, visitId: visitId, startDate: startDate,));
          Get.snackbar(
            "Success",
            "Checkout Successful",
            backgroundColor: const Color(0xFF4CAF50),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            responseBody['message'] ?? "Checkout failed",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Server Error: ${res.statusCode}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Checkout Error: $e");
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ API Call to Check Outcome Status
  Future<void> checkOutcomeStatus(int visitId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse("${baseUrl}checkOutcome/$visitId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // ✅ Check if data exists and extract isoutcome flag
        if (body["data"] != null && body["data"].isNotEmpty) {
          final firstItem = body["data"][0];
          hasOutcome.value = firstItem["isoutcome"] == true;
        } else {
          hasOutcome.value = false;
        }
      } else {
        hasOutcome.value = false;
      }
    } catch (e) {
      hasOutcome.value = false;
      print("Error checking outcome status: $e");
    }
  }
}
