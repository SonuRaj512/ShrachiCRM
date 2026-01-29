import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';

@pragma('vm:entry-point')
void onStartTracking(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Location Tracking Active",
      content: "Sending location in background...",
    );
  }

  final prefs = await SharedPreferences.getInstance();
  int interval = prefs.getInt("trackingInterval") ?? 10;

  Timer.periodic(Duration(seconds: interval), (timer) async {
    final isTracking = prefs.getBool("isTracking") ?? true;
    if (!isTracking) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final token = prefs.getString("access_token") ?? "";
      await http.post(
        Uri.parse('$baseUrl$tracking'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"lat": position.latitude, "lng": position.longitude}),
      );
    } catch (e) {
      debugPrint("Background tracking error: $e");
    }
  });

  service.on("stopTracking").listen((event) async {
    await prefs.setBool("isTracking", false);
    service.stopSelf();
  });
}

Future<void> initializeTrackingService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStartTracking,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
  );
}
