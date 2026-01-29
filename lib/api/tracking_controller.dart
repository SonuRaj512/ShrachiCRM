// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shrachi/api/api_const.dart';
//
// class TrackingController extends GetxController {
//   final int intervalSeconds;
//   Timer? _locationTimer;
//
//   TrackingController([int? interval]) : intervalSeconds = interval ?? 10;
//
//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("access_token") ?? "";
//   }
//
//   Future<void> sendCoordinate(Position position) async {
//     try {
//       print('Sending...');
//       final token = await getToken();
//       await http.post(
//         Uri.parse('$baseUrl$tracking'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//       );
//     } catch (e) {
//       debugPrint("Error sending location: $e");
//     }
//   }
//
//   void startLocationUpdates() async {
//     _locationTimer?.cancel();
//
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//       await sendCoordinate(position);
//     } catch (e) {
//       debugPrint("Error fetching location: $e");
//     }
//
//     _locationTimer = Timer.periodic(Duration(seconds: intervalSeconds), (
//       timer,
//     ) async {
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//           locationSettings: const LocationSettings(
//             accuracy: LocationAccuracy.high,
//           ),
//         );
//         await sendCoordinate(position);
//       } catch (e) {
//         debugPrint("Error fetching location: $e");
//       }
//     });
//   }
//
//   void stopLocationUpdates() {
//     _locationTimer?.cancel();
//     _locationTimer = null;
//   }
//
//   @override
//   void onClose() {
//     stopLocationUpdates();
//     super.onClose();
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shrachi/api/api_const.dart';

class TrackingController extends GetxController {
  Timer? _locationTimer;
  final int intervalSeconds;
  final isTracking = false.obs;

  TrackingController([int? interval]) : intervalSeconds = interval ?? 10;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  Future<void> sendCoordinate(Position position) async {
    try {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$tracking'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
      );
      print(jsonDecode(res.body));
    } catch (e) {
      debugPrint("Error sending location: $e");
    }
  }

  Future<void> startLocationUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("trackingInterval", intervalSeconds);
    await prefs.setBool("isTracking", true);

    final service = FlutterBackgroundService();
    if (!(await service.isRunning())) {
      await service.startService();
    }

    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(Duration(seconds: intervalSeconds), (
        timer,
        ) async {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      await sendCoordinate(position);
    });

    isTracking.value = true;
  }

  Future<void> stopLocationUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isTracking", false);
    final service = FlutterBackgroundService();
    service.invoke("stopTracking");
    _locationTimer?.cancel();
    _locationTimer = null;
    isTracking.value = false;
  }

  @override
  void onClose() {
    stopLocationUpdates();
    super.onClose();
  }
}
