// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shrachi/api/api_const.dart';
// import 'package:shrachi/models/attendance_model.dart';
//
// class AttendanceController extends GetxController {
//   Timer? _timer;
//   var seconds = 0.obs;
//   final isRunning = false.obs;
//   final isClockedIn = false.obs;
//   final isLoading = false.obs;
//   final isClockOutLoading = false.obs;
//   final attendanceList = <AttendanceModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadState();
//   }
//
//   Future<void> loadState() async {
//     final prefs = await SharedPreferences.getInstance();
//     isRunning.value = prefs.getBool("isClockedIn") ?? false;
//     isClockedIn.value = prefs.getBool("isClockedIn") ?? false;
//     seconds.value = prefs.getInt("workSeconds") ?? 0;
//     if (isRunning.value) {
//       startTimer();
//       if(!kIsWeb){
//         listenToBackgroundUpdates();
//       }
//     }
//   }
//
//   Future getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token") ?? "";
//     return token;
//   }
//
//   String get formattedTime {
//     final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
//     final mins = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds.value % 60).toString().padLeft(2, '0');
//     return "$hrs:$mins:$secs";
//   }
//
//   void startTimer() {
//     if (_timer != null && _timer!.isActive) return;
//     isRunning.value = true;
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (isRunning.value) {
//         seconds.value++;
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt("workSeconds", seconds.value);
//       }
//     });
//   }
//
//   void pauseTimer() {
//     isRunning.value = false;
//   }
//
//   void resumeTimer() {
//     isRunning.value = true;
//   }
//
//   void stopTimer() {
//     isRunning.value = false;
//     isClockedIn.value = false;
//     seconds.value = 0;
//     _timer?.cancel();
//   }
//   void listenToBackgroundUpdates() {
//     final service = FlutterBackgroundService();
//     service.on('update').listen((event) {
//       if (event != null && event["seconds"] != null) {
//         seconds.value = event["seconds"];
//       }
//     });
//   }
//   // Future clockIn() async {
//   //   try {
//   //     isLoading.value = true;
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.setBool("isClockedIn", true);
//   //     await prefs.setInt("workSeconds", 0);
//   //     LocationPermission permission = await Geolocator.checkPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       permission = await Geolocator.requestPermission();
//   //     }
//   //
//   //     if (permission == LocationPermission.denied ||
//   //         permission == LocationPermission.deniedForever) {
//   //       Get.snackbar("Error", "Location permission denied");
//   //       return;
//   //     }
//   //
//   //     Position position = await Geolocator.getCurrentPosition(
//   //       locationSettings: const LocationSettings(
//   //         accuracy: LocationAccuracy.high,
//   //       ),
//   //     );
//   //
//   //     final token = await getToken();
//   //     final res = await http.post(
//   //       Uri.parse('$baseUrl$clockInApi'),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//   //     );
//   //     print("Clockin Status ${res.body}");
//   //     if (res.statusCode == 200) {
//   //       isClockedIn.value = true;
//   //       startTimer();
//   //       final service = FlutterBackgroundService();
//   //       if (!(await service.isRunning())) {
//   //         await service.startService();
//   //       }
//   //     }
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//   //
//   // Future clockOut() async {
//   //   try {
//   //     isClockOutLoading.value = true;
//   //     if (isRunning.value == false) {
//   //       Get.snackbar(
//   //         "Error",
//   //         "Please end your break time",
//   //         backgroundColor: Colors.red,
//   //         colorText: Colors.white,
//   //       );
//   //       return;
//   //     }
//   //
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.setBool("isClockedIn", false);
//   //     LocationPermission permission = await Geolocator.checkPermission();
//   //     if (permission == LocationPermission.denied) {
//   //       permission = await Geolocator.requestPermission();
//   //     }
//   //
//   //     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//   //       Get.snackbar("Error", "Location permission denied");
//   //       return;
//   //     }
//   //
//   //     Position position = await Geolocator.getCurrentPosition(
//   //       locationSettings: const LocationSettings(
//   //         accuracy: LocationAccuracy.high,
//   //       ),
//   //     );
//   //
//   //     final token = await getToken();
//   //     final res = await http.post(
//   //       Uri.parse('$baseUrl$clockOutApi'),
//   //       headers: {
//   //         "Content-Type": "application/json",
//   //         "Authorization": "Bearer $token",
//   //       },
//   //       body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//   //     );
//   //
//   //     if (res.statusCode == 200) {
//   //       isClockedIn.value = false;
//   //       stopTimer();
//   //       final service = FlutterBackgroundService();
//   //       service.invoke("stopService");
//   //       await prefs.remove("isClockedIn");
//   //       await prefs.remove("workSeconds");
//   //       Get.snackbar(
//   //         "Success",
//   //         "Clocked Out",
//   //         backgroundColor: Colors.green,
//   //         colorText: Colors.white,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   } finally {
//   //     isClockOutLoading.value = false;
//   //   }
//   // }
//   /// 🟢 CLOCK IN
//   Future clockIn() async {
//     try {
//       isLoading.value = true;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool("isClockedIn", true);
//       await prefs.setInt("workSeconds", 0);
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         Get.snackbar("Error", "Location permission denied");
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$clockInApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//       );
//
//       print("ClockIn Response: ${res.body}");
//
//       if (res.statusCode == 200) {
//         isClockedIn.value = true;
//         startBackgroundService();
//         Get.snackbar("Success", "Clocked In successfully",
//             backgroundColor: Colors.green, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// 🔴 CLOCK OUT
//   Future clockOut({bool isAuto = false}) async {
//     try {
//       isClockOutLoading.value = true;
//       if (isRunning.value == false && !isAuto) {
//         Get.snackbar(
//           "Error",
//           "Please end your break first",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setBool("isClockedIn", false);
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         if (!isAuto) {
//           Get.snackbar("Error", "Location permission denied");
//         }
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$clockOutApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//       );
//
//       print("ClockOut Response: ${res.body}");
//
//       if (res.statusCode == 200) {
//         isClockedIn.value = false;
//         final service = FlutterBackgroundService();
//         service.invoke("stopService");
//         await prefs.remove("isClockedIn");
//         await prefs.remove("workSeconds");
//
//         if (!isAuto) {
//           Get.snackbar(
//             "Success",
//             "Clocked Out",
//             backgroundColor: Colors.green,
//             colorText: Colors.white,
//           );
//         } else {
//           print("✅ Auto ClockOut done at midnight");
//         }
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isClockOutLoading.value = false;
//     }
//   }
//
//   /// 🕛 START BACKGROUND SERVICE
//   void startBackgroundService() async {
//     final service = FlutterBackgroundService();
//     if (!(await service.isRunning())) {
//       await service.startService();
//     }
//   }
//
//   /// 🕒 AUTO CLOCK OUT CHECKER
//   static Future<void> checkAutoClockOut() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isClockedIn = prefs.getBool("isClockedIn") ?? false;
//
//     if (isClockedIn) {
//       final controller = AttendanceController();
//       print("🕛 It's midnight — performing auto ClockOut...");
//       await controller.clockOut(isAuto: true);
//     }
//   }
//
//   Future breakIn({required String reason, required reasonlat, required reasonlng}) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$breakStartApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "break_type": reason,
//           "break_start_lat": reasonlat,
//           "break_start_lng": reasonlng,
//         }),
//       );
//       print("start store breack lat lng ${res.body}");
//       if (res.statusCode == 200) {
//         pauseTimer();
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future breakOut({ required reasonlat, required reasonlng}) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$breakEndApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "break_end_lat": reasonlat,
//           "break_end_lng": reasonlng,
//         }),
//       );
//       print("End store breack lat lng ${res.body}");
//       if (res.statusCode == 200) {
//         resumeTimer();
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future getAllAttendance({String? startDate, String? endDate}) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//
//       final queryParams = <String, String>{};
//       if (startDate != "null" && startDate!.isNotEmpty) {
//         queryParams['start_date'] = startDate;
//       }
//       if (endDate != "null" && endDate!.isNotEmpty) {
//         queryParams['end_date'] = endDate;
//       }
//
//       final uri = Uri.parse(
//         '$baseUrl$allAttendance',
//       ).replace(queryParameters: queryParams);
//
//       final res = await http.get(
//         uri,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         attendanceList.value =
//             (data['data'] as List)
//                 .map((json) => AttendanceModel.fromJson(json))
//                 .toList();
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
// }
// attendance_controller.dart
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shrachi/api/api_const.dart';
// import 'package:shrachi/models/attendance_model.dart';
//
// class AttendanceController extends GetxController {
//   Timer? _timer;
//   var seconds = 0.obs;
//   /// true while working (timer running)
//   final isRunning = false.obs;
//   /// true if user is clocked in (may be running or on break)
//   final isClockedIn = false.obs;
//   /// true if currently on break
//   final isOnBreak = false.obs;
//   final isLoading = false.obs; // generic loading for actions
//   final isClockOutLoading = false.obs;
//   final isBreakLoading = false.obs;
//   final attendanceList = <AttendanceModel>[].obs;
//
//   static const _prefKeyLastAutoClockOut = "lastAutoClockOut";
//   static const _prefKeyIsClockedIn = "isClockedIn";
//   static const _prefKeyWorkSeconds = "workSeconds";
//   static const _prefKeyIsOnBreak = "isOnBreak";
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadState();
//   }
//   void startTimer() {
//     if (_timer != null && _timer!.isActive) return;
//     isRunning.value = true;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (isRunning.value) {
//         seconds.value++;
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setInt(_prefKeyWorkSeconds, seconds.value);
//
//         // 🔥 AUTO CLOCKOUT CHECK
//         await _checkAutoClockOut();
//       }
//     });
//   }
//   Future<void> _checkAutoClockOut() async {
//     try {
//       if (!isClockedIn.value) return;  // user must be clocked in
//
//       final now = DateTime.now();
//       final hour = now.hour;
//       final minute = now.minute;
//
//       // Validate time → exactly 12:00 AM
//       if (hour == 00 && minute == 00) {
//         final prefs = await SharedPreferences.getInstance();
//
//         final today = "${now.year}-${now.month}-${now.day}";
//         final lastAuto = prefs.getString(_prefKeyLastAutoClockOut);
//
//         // Already auto clockout today? Then skip
//         if (lastAuto == today) return;
//
//         // Save today's date for protection
//         await prefs.setString(_prefKeyLastAutoClockOut, today);
//
//         debugPrint("⏰ AUTO CLOCKOUT triggered at midnight");
//
//         // 🔥 Perform Auto ClockOut
//         await clockOut(isAuto: true);
//
//         debugPrint("⏳ Auto clockout completed");
//       }
//     } catch (e) {
//       debugPrint("Auto ClockOut Error: $e");
//     }
//   }
//
//   Future<void> loadState() async {
//     final prefs = await SharedPreferences.getInstance();
//     final savedClockedIn = prefs.getBool(_prefKeyIsClockedIn) ?? false;
//     final savedOnBreak = prefs.getBool(_prefKeyIsOnBreak) ?? false;
//     final savedSeconds = prefs.getInt(_prefKeyWorkSeconds) ?? 0;
//
//     isClockedIn.value = savedClockedIn;
//     isOnBreak.value = savedOnBreak;
//     seconds.value = savedSeconds;
//
//     // Derive running state:
//     isRunning.value = isClockedIn.value && !isOnBreak.value;
//
//     // If clocked in and not on break, start timer + background updates
//     if (isClockedIn.value && !isOnBreak.value) {
//       startTimer();
//       if (!kIsWeb) {
//         listenToBackgroundUpdates();
//       }
//     }
//   }
//
//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token") ?? "";
//     return token;
//   }
//
//   String get formattedTime {
//     final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
//     final mins = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
//     final secs = (seconds.value % 60).toString().padLeft(2, '0');
//     return "$hrs:$mins:$secs";
//   }
//
//   // ---------- Timer control ----------
//   // void startTimer() {
//   //   if (_timer != null && _timer!.isActive) return;
//   //   isRunning.value = true;
//   //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//   //     if (isRunning.value) {
//   //       seconds.value++;
//   //       final prefs = await SharedPreferences.getInstance();
//   //       await prefs.setInt(_prefKeyWorkSeconds, seconds.value);
//   //     }
//   //   });
//   // }
//
//   void pauseTimer() {
//     isRunning.value = false;
//   }
//
//   void resumeTimer() {
//     // only resume if clocked in
//     if (isClockedIn.value) {
//       isRunning.value = true;
//       if (_timer == null || !_timer!.isActive) {
//         startTimer();
//       }
//     }
//   }
//
//   void stopTimer() {
//     isRunning.value = false;
//     isClockedIn.value = false;
//     seconds.value = 0;
//     _timer?.cancel();
//   }
//
//   void listenToBackgroundUpdates() {
//     final service = FlutterBackgroundService();
//     service.on('update').listen((event) {
//       if (event != null && event["seconds"] != null) {
//         // update seconds from background service
//         seconds.value = event["seconds"];
//         // keep the prefs in sync
//         SharedPreferences.getInstance()
//             .then((p) => p.setInt(_prefKeyWorkSeconds, seconds.value));
//       }
//     });
//   }
//
//   // ---------- Network / actions ----------
//   /// CLOCK IN
//   Future<void> clockIn() async {
//     try {
//       isLoading.value = true;
//
//       // location permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied ||
//           permission == LocationPermission.deniedForever) {
//         Get.snackbar("Error", "Location permission denied");
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
//       );
//
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$clockInApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//       );
//
//       debugPrint("ClockIn Response: ${res.body} | status: ${res.statusCode}");
//
//       if (res.statusCode == 200) {
//         // Persist state only after successful API
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool(_prefKeyIsClockedIn, true);
//         await prefs.setBool(_prefKeyIsOnBreak, false);
//         await prefs.setInt(_prefKeyWorkSeconds, 0);
//
//         isClockedIn.value = true;
//         isOnBreak.value = false;
//         seconds.value = 0;
//
//         // start timer & background service
//         startTimer();
//         startBackgroundService();
//
//         Get.snackbar("Success", "Clocked In successfully",
//             backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         // API returned error
//         Get.snackbar("Error", "ClockIn failed", backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("clockIn error: $e");
//       Get.snackbar("Error", "ClockIn failed", backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// CLOCK OUT
//   Future<void> clockOut({bool isAuto = false}) async {
//     try {
//       isClockOutLoading.value = true;
//
//       // If user currently on break and action not auto, require ending break first
//       if (isOnBreak.value && !isAuto) {
//         Get.snackbar("Error", "Please end your break first", backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       // location permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//         if (!isAuto) {
//           Get.snackbar("Error", "Location permission denied");
//         }
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
//       );
//
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$clockOutApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
//       );
//
//       debugPrint("ClockOut Response: ${res.body} | status: ${res.statusCode}");
//       //print("ClockOut Api Response ${res.body}");
//       if (res.statusCode == 200) {
//         // stop everything locally
//         final service = FlutterBackgroundService();
//         service.invoke("stopService");
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.remove(_prefKeyIsClockedIn);
//         await prefs.remove(_prefKeyIsOnBreak);
//         await prefs.remove(_prefKeyWorkSeconds);
//
//         isClockedIn.value = false;
//         isOnBreak.value = false;
//         stopTimer();
//
//         if (!isAuto) {
//           Get.snackbar("Success", "Clocked Out", backgroundColor: Colors.green, colorText: Colors.white);
//         } else {
//           debugPrint("✅ Auto ClockOut done at midnight");
//         }
//       } else {
//         Get.snackbar("Error", "ClockOut failed", backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("clockOut error: $e");
//       Get.snackbar("Error", "ClockOut failed", backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isClockOutLoading.value = false;
//     }
//   }
//
//   /// START BREAK (breakIn)
//   Future<void> breakIn({required String reason, required double? reasonlat, required double? reasonlng}) async {
//     try {
//       isBreakLoading.value = true;
//
//       if (!isClockedIn.value) {
//         Get.snackbar("Error", "You must clock in first", backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       // send break start to server
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$breakStartApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "break_type": reason,
//           "break_start_lat": reasonlat,
//           "break_start_lng": reasonlng,
//         }),
//       );
//
//       debugPrint("breakIn response: ${res.body} | status: ${res.statusCode}");
//       if (res.statusCode == 200) {
//         // pause timer locally and mark on break
//         pauseTimer();
//         isOnBreak.value = true;
//
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool(_prefKeyIsOnBreak, true);
//
//         Get.snackbar("Success", "Break started", backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         Get.snackbar("Error", "Break start failed", backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("breakIn error: $e");
//       Get.snackbar("Error", "Break start failed", backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isBreakLoading.value = false;
//     }
//   }
//
//   /// END BREAK (breakOut)
//   Future<void> breakOut({required double? reasonlat, required double? reasonlng}) async {
//     try {
//       isBreakLoading.value = true;
//
//       if (!isClockedIn.value || !isOnBreak.value) {
//         Get.snackbar("Error", "You are not on a break", backgroundColor: Colors.red, colorText: Colors.white);
//         return;
//       }
//
//       final token = await getToken();
//       final res = await http.post(
//         Uri.parse('$baseUrl$breakEndApi'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "break_end_lat": reasonlat,
//           "break_end_lng": reasonlng,
//         }),
//       );
//
//       debugPrint("breakOut response: ${res.body} | status: ${res.statusCode}");
//       if (res.statusCode == 200) {
//         // resume timer locally and clear on-break
//         isOnBreak.value = false;
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool(_prefKeyIsOnBreak, false);
//
//         resumeTimer();
//         Get.snackbar("Success", "Break ended", backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         Get.snackbar("Error", "Break end failed", backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("breakOut error: $e");
//       Get.snackbar("Error", "Break end failed", backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isBreakLoading.value = false;
//     }
//   }
//
//   Future<void> getAllAttendance({String? startDate, String? endDate}) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//
//       final queryParams = <String, String>{};
//       if (startDate != "null" && startDate != null && startDate.isNotEmpty) {
//         queryParams['start_date'] = startDate;
//       }
//       if (endDate != "null" && endDate != null && endDate.isNotEmpty) {
//         queryParams['end_date'] = endDate;
//       }
//
//       final uri = Uri.parse('$baseUrl$allAttendance').replace(queryParameters: queryParams);
//
//       final res = await http.get(uri, headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       });
//
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         attendanceList.value = (data['data'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
//       } else {
//         debugPrint("getAllAttendance failed: ${res.statusCode}");
//       }
//     } catch (e) {
//       debugPrint("getAllAttendance error: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   // background service helpers
//   void startBackgroundService() async {
//     final service = FlutterBackgroundService();
//     if (!(await service.isRunning())) {
//       await service.startService();
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/attendance_model.dart';

import '../views/screens/CustomErrorMessage/CustomeErrorMessage.dart';

class AttendanceController extends GetxController {
  Timer? _timer;
  var seconds = 0.obs;
  /// true while working (timer running)
  final isRunning = false.obs;
  /// true if user is clocked in (may be running or on break)
  final isClockedIn = false.obs;
  /// true if currently on break
  final isOnBreak = false.obs;
  final isLoading = false.obs; // generic loading for actions
  final isClockOutLoading = false.obs;
  final isBreakLoading = false.obs;
  final attendanceList = <AttendanceModel>[].obs;
  RxBool detailLoading = false.obs;
  Rx<AttendanceModel?> attendanceDetail = Rx<AttendanceModel?>(null);

  static const _prefKeyLastAutoClockOut = "lastAutoClockOut";
  static const _prefKeyIsClockedIn = "isClockedIn";
  static const _prefKeyWorkSeconds = "workSeconds";
  static const _prefKeyIsOnBreak = "isOnBreak";

  @override
  void onInit() {
    super.onInit();
    loadState();

    // 🔥 Every 10 seconds check real-time status from server
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchRealTimeStatus();
    });
  }

  // void onInit() {
  //   super.onInit();
  //   loadState();
  //   getClockStatus();   // 🔥 auto sync on app launch
  // }
  void startTimer() {
    if (_timer != null && _timer!.isActive) return;
    isRunning.value = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (isRunning.value) {
        seconds.value++;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_prefKeyWorkSeconds, seconds.value);

        // 🔥 AUTO CLOCKOUT CHECK
        await _checkAutoClockOut();
      }
    });
  }
  Future<void> _checkAutoClockOut() async {
    try {
      if (!isClockedIn.value) return;  // user must be clocked in

      final now = DateTime.now();
      final hour = now.hour;
      final minute = now.minute;

      // Validate time → exactly 12:00 AM
      if (hour == 00 && minute == 00) {
        final prefs = await SharedPreferences.getInstance();

        final today = "${now.year}-${now.month}-${now.day}";
        final lastAuto = prefs.getString(_prefKeyLastAutoClockOut);

        // Already auto clockout today? Then skip
        if (lastAuto == today) return;

        // Save today's date for protection
        await prefs.setString(_prefKeyLastAutoClockOut, today);

        debugPrint("⏰ AUTO CLOCKOUT triggered at midnight");

        // 🔥 Perform Auto ClockOut
        await clockOut(isAuto: true);

        debugPrint("⏳ Auto clockout completed");
      }
    } catch (e) {
      debugPrint("Auto ClockOut Error: $e");
    }
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClockedIn = prefs.getBool(_prefKeyIsClockedIn) ?? false;
    final savedOnBreak = prefs.getBool(_prefKeyIsOnBreak) ?? false;
    final savedSeconds = prefs.getInt(_prefKeyWorkSeconds) ?? 0;

    isClockedIn.value = savedClockedIn;
    isOnBreak.value = savedOnBreak;
    seconds.value = savedSeconds;

    // Derive running state:
    isRunning.value = isClockedIn.value && !isOnBreak.value;

    // If clocked in and not on break, start timer + background updates
    if (isClockedIn.value && !isOnBreak.value) {
      startTimer();
      if (!kIsWeb) {
        listenToBackgroundUpdates();
      }
    }
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";
    return token;
  }

  String get formattedTime {
    final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
    final mins = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds.value % 60).toString().padLeft(2, '0');
    return "$hrs:$mins:$secs";
  }

  void pauseTimer() {
    isRunning.value = false;
  }

  void resumeTimer() {
    // only resume if clocked in
    if (isClockedIn.value) {
      isRunning.value = true;
      if (_timer == null || !_timer!.isActive) {
        startTimer();
      }
    }
  }

  void stopTimer() {
    isRunning.value = false;
    isClockedIn.value = false;
    seconds.value = 0;
    _timer?.cancel();
  }

  void listenToBackgroundUpdates() {
    final service = FlutterBackgroundService();
    service.on('update').listen((event) {
      if (event != null && event["seconds"] != null) {
        // update seconds from background service
        seconds.value = event["seconds"];
        // keep the prefs in sync
        SharedPreferences.getInstance()
            .then((p) => p.setInt(_prefKeyWorkSeconds, seconds.value));
      }
    });
  }
  Future<void> fetchRealTimeStatus() async {
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("$baseUrl$getclock"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final clockIn = data["clock_in"];
        final clockOut = data["clock_out"];
        final breaks = data["breaks"] ?? [];

        // ---------- CLOCK IN STATUS ----------
        if (clockIn == null) {
          isClockedIn.value = false;
          isOnBreak.value = false;
          stopTimer();
          return;
        }

        isClockedIn.value = true;

        // ---------- BREAK STATUS ----------
        if (breaks.isNotEmpty) {
          final lastBreak = breaks.last;

          if (lastBreak["break_end"] == null) {
            // user is currently on break
            isOnBreak.value = true;
            pauseTimer();
          } else {
            isOnBreak.value = false;
            resumeTimer();
          }
        } else {
          isOnBreak.value = false;
        }

        // ---------- TIMER SET ----------
        final startTime = DateTime.parse(clockIn);
        final now = DateTime.now();
        final diff = now.difference(startTime).inSeconds;

        if (!isOnBreak.value) {
          seconds.value = diff;
          startTimer();
        }

        // ---------- CLOCK OUT CHECK ----------
        if (clockOut != null) {
          isClockedIn.value = false;
          stopTimer();
        }
      }
    } catch (e) {
      debugPrint("RealTime fetch error: $e");
    }
  }

  // Future<void> fetchRealTimeStatus() async {
  //   try {
  //     final token = await getToken();
  //
  //     final res = await http.get(
  //       Uri.parse("https://btlsalescrm.cloud/api/getclock"),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //         "Content-Type": "application/json",
  //       },
  //     );
  //
  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);
  //
  //       final clockIn = data["clock_in"];
  //       final clockOut = data["clock_out"];
  //
  //       // No clock-in → user is not working
  //       if (clockIn == null) {
  //         isClockedIn.value = false;
  //         isOnBreak.value = false;
  //         stopTimer();
  //         return;
  //       }
  //
  //       // User is clocked-in
  //       isClockedIn.value = true;
  //
  //       // Check break status API
  //       await fetchBreakStatus();
  //
  //       // Calculate running seconds from server clock-in time
  //       final startTime = DateTime.parse(clockIn);
  //       final now = DateTime.now();
  //
  //       final diff = now.difference(startTime).inSeconds;
  //
  //       // Update local timer (only if NOT on break)
  //       if (!isOnBreak.value) {
  //         seconds.value = diff;
  //         startTimer();
  //       }
  //
  //       // If clock-out exists → user already clocked out
  //       if (clockOut != null) {
  //         isClockedIn.value = false;
  //         stopTimer();
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("RealTime fetch error: $e");
  //   }
  // }

  Future<void> getClockStatus() async {
    try {
      final token = await getToken();
      final res = await http.get(
        Uri.parse("$baseUrl$getclock"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("GET CLOCK STATUS: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final clockIn = data["clock_in"];
        final clockOut = data["clock_out"];

        if (clockIn != null && clockOut == null) {
          // User already clocked in
          final ciTime = DateTime.parse(clockIn);
          final diffSeconds = DateTime.now().difference(ciTime).inSeconds;

          isClockedIn.value = true;
          isOnBreak.value = false;
          seconds.value = diffSeconds;

          startTimer();
        } else {
          // user is not clocked in
          isClockedIn.value = false;
          isOnBreak.value = false;
          seconds.value = 0;
          stopTimer();
        }
      }
    } catch (e) {
      print("Clock status error: $e");
    }
  }

  //---------- Network / actions ----------
  /// CLOCK IN
  Future<void> clockIn() async {
    try {
      isLoading.value = true;

      Position position = await Geolocator.getCurrentPosition();

      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$clockInApi'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
      );

      if (res.statusCode == 200) {
        await getClockStatus();   // 🔥 refresh from server
        // ✅ 🟢 ADDED: Clockout hone par popup
        showTopPopup("ClockIn", "Clocked In Successfully", Colors.green);
        //Get.snackbar("Success", "Clocked In", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        showTopPopup("Error", "ClockIn failed", Colors.red);
        //Get.snackbar("Error", "ClockIn failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("ClockIn Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// CLOCK OUT
  Future<void> clockOut({bool isAuto = false}) async {
    try {
      isClockOutLoading.value = true;
      Position position = await Geolocator.getCurrentPosition();

      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$clockOutApi'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
      );

      if (res.statusCode == 200) {
        await getClockStatus();   // 🔥 update everywhere

        showTopPopup("ClockOut", "Clocked Out Successfully", Colors.green);
        //Get.snackbar("Success", "Clocked Out", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        showTopPopup("Error", "ClockOut failed", Colors.red);
        //Get.snackbar("Error", "ClockOut failed");
      }
    } catch (e) {
      print("ClockOut error: $e");
    } finally {
      isClockOutLoading.value = false;
    }
  }

  // Future<void> clockOut({bool isAuto = false}) async {
  //   try {
  //     isClockOutLoading.value = true;
  //
  //     // If user currently on break and action not auto, require ending break first
  //     if (isOnBreak.value && !isAuto) {
  //       Get.snackbar("Error", "Please end your break first", backgroundColor: Colors.red, colorText: Colors.white);
  //       return;
  //     }
  //
  //     // location permission
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //     }
  //     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
  //       if (!isAuto) {
  //         Get.snackbar("Error", "Location permission denied");
  //       }
  //       return;
  //     }
  //
  //     Position position = await Geolocator.getCurrentPosition(
  //       locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  //     );
  //
  //     final token = await getToken();
  //     final res = await http.post(
  //       Uri.parse('$baseUrl$clockOutApi'),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
  //     );
  //
  //     debugPrint("ClockOut Response: ${res.body} | status: ${res.statusCode}");
  //     //print("ClockOut Api Response ${res.body}");
  //     if (res.statusCode == 200) {
  //       // stop everything locally
  //       final service = FlutterBackgroundService();
  //       service.invoke("stopService");
  //
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.remove(_prefKeyIsClockedIn);
  //       await prefs.remove(_prefKeyIsOnBreak);
  //       await prefs.remove(_prefKeyWorkSeconds);
  //
  //       isClockedIn.value = false;
  //       isOnBreak.value = false;
  //       stopTimer();
  //
  //       if (!isAuto) {
  //         Get.snackbar("Success", "Clocked Out", backgroundColor: Colors.green, colorText: Colors.white);
  //       } else {
  //         debugPrint("✅ Auto ClockOut done at midnight");
  //       }
  //     } else {
  //       Get.snackbar("Error", "ClockOut failed", backgroundColor: Colors.red, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     debugPrint("clockOut error: $e");
  //     Get.snackbar("Error", "ClockOut failed", backgroundColor: Colors.red, colorText: Colors.white);
  //   } finally {
  //     isClockOutLoading.value = false;
  //   }
  // }
  Future<void> fetchBreakStatus() async {
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("$baseUrl$breakStartApi"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final isBreak = data["on_break"] == true;

        isOnBreak.value = isBreak;

        if (isBreak) {
          pauseTimer();
        } else {
          resumeTimer();
        }
      }
    } catch (e) {
      debugPrint("break status error: $e");
    }
  }

  /// START BREAK (breakIn)
  Future<void> breakIn({required String reason, required double? reasonlat, required double? reasonlng}) async {
    try {
      isBreakLoading.value = true;

      if (!isClockedIn.value) {
        Get.snackbar("Error", "You must clock in first", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      // API CALL
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$breakStartApi'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "break_type": reason,
          "break_start_lat": reasonlat,
          "break_start_lng": reasonlng,
        }),
      );

      debugPrint("breakIn response: ${res.body}");

      if (res.statusCode == 200) {

        /// ⭐ REAL-TIME SYNC ⭐
        await getClockStatus();

        pauseTimer();
        isOnBreak.value = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_prefKeyIsOnBreak, true);

        Get.snackbar("Success", "Break started", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Break start failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("breakIn error: $e");
    } finally {
      isBreakLoading.value = false;
    }
  }

  /// END BREAK (breakOut)
  Future<void> breakOut({required double? reasonlat, required double? reasonlng}) async {
    try {
      isBreakLoading.value = true;

      if (!isClockedIn.value || !isOnBreak.value) {
        Get.snackbar("Error", "You are not on a break", backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl$breakEndApi'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "break_end_lat": reasonlat,
          "break_end_lng": reasonlng,
        }),
      );

      debugPrint("breakOut response: ${res.body}");

      if (res.statusCode == 200) {

        /// ⭐ REAL-TIME SYNC ⭐
        await getClockStatus();

        isOnBreak.value = false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_prefKeyIsOnBreak, false);

        resumeTimer();

        Get.snackbar("Success", "Break ended", backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Break end failed", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      debugPrint("breakOut error: $e");
    } finally {
      isBreakLoading.value = false;
    }
  }

  Future<void> getAllAttendance({String? startDate, String? endDate}) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      final queryParams = <String, String>{};
      if (startDate != "null" && startDate != null && startDate.isNotEmpty) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != "null" && endDate != null && endDate.isNotEmpty) {
        queryParams['end_date'] = endDate;
      }

      final uri = Uri.parse('$baseUrl$allAttendance').replace(queryParameters: queryParams);

      final res = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        attendanceList.value = (data['data'] as List).map((json) => AttendanceModel.fromJson(json)).toList();
      } else {
        debugPrint("getAllAttendance failed: ${res.statusCode}");
      }
    } catch (e) {
      debugPrint("getAllAttendance error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAttendanceById(int id) async {
    try {
      detailLoading.value = true;
      final token = await getToken();

      final res = await http.get(
        Uri.parse('$baseUrl$allAttendance/$id'), // 👈 ID BASED API
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        attendanceDetail.value =
            AttendanceModel.fromJson(data['data']);
      }
    } catch (e) {
      debugPrint("Attendance detail error: $e");
    } finally {
      detailLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // background service helpers
  void startBackgroundService() async {
    final service = FlutterBackgroundService();
    if (!(await service.isRunning())) {
      await service.startService();
    }
  }
}
