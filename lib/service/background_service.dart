// import 'dart:async';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: false,
//     ),
//     iosConfiguration: IosConfiguration(),
//   );
// }
//
// void onStart(ServiceInstance service) async {
//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService();
//   }
//
//   final prefs = await SharedPreferences.getInstance();
//   Timer? backgroundTimer;
//
//   backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//     final isClockedIn = prefs.getBool("isClockedIn") ?? false;
//     if (isClockedIn) {
//       int workSeconds = prefs.getInt("workSeconds") ?? 0;
//       workSeconds++;
//       await prefs.setInt("workSeconds", workSeconds);
//       service.invoke("update", {"seconds": workSeconds});
//     }
//   });
//
//   service.on('stopService').listen((event) {
//     backgroundTimer?.cancel();
//     service.stopSelf();
//   });
// }
//
//
// // import 'dart:async';
// // import 'dart:io';
// // import 'dart:ui'; // 👈 Required for DartPluginRegistrant
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// //
// // Future<void> initializeService() async {
// //   // ✅ Skip setup if running on Web or unsupported platform
// //   if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
// //     debugPrint('Background service not supported on this platform.');
// //     return;
// //   }
// //
// //   final service = FlutterBackgroundService();
// //
// //   await service.configure(
// //     androidConfiguration: AndroidConfiguration(
// //       onStart: onStart,
// //       isForegroundMode: true,
// //       autoStart: true,
// //       notificationChannelId: 'my_foreground',
// //       initialNotificationTitle: 'Shrachi',
// //       initialNotificationContent: 'Running in background...',
// //     ),
// //     iosConfiguration: IosConfiguration(
// //       autoStart: true,
// //       onForeground: onStart,
// //       onBackground: onIosBackground,
// //     ),
// //   );
// //
// //   service.startService();
// // }
// //
// // @pragma('vm:entry-point')
// // Future<bool> onIosBackground(ServiceInstance service) async {
// //   final prefs = await SharedPreferences.getInstance();
// //   final isClockedIn = prefs.getBool("isClockedIn") ?? false;
// //
// //   if (isClockedIn) {
// //     int workSeconds = prefs.getInt("workSeconds") ?? 0;
// //     workSeconds++;
// //     await prefs.setInt("workSeconds", workSeconds);
// //   }
// //   return true;
// // }
// //
// // @pragma('vm:entry-point')
// // void onStart(ServiceInstance service) async {
// //   // ✅ Fix: Comes from dart:ui, not flutter_background_service
// //   DartPluginRegistrant.ensureInitialized();
// //
// //   if (service is AndroidServiceInstance) {
// //     service.setAsForegroundService();
// //   }
// //
// //   final prefs = await SharedPreferences.getInstance();
// //   Timer? backgroundTimer;
// //
// //   backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
// //     final isClockedIn = prefs.getBool("isClockedIn") ?? false;
// //     if (isClockedIn) {
// //       int workSeconds = prefs.getInt("workSeconds") ?? 0;
// //       workSeconds++;
// //       await prefs.setInt("workSeconds", workSeconds);
// //       service.invoke("update", {"seconds": workSeconds});
// //     }
// //   });
// //
// //   service.on('stopService').listen((event) {
// //     backgroundTimer?.cancel();
// //     service.stopSelf();
// //   });
// // }

import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Work Timer Running",
      content: "Tracking your work time...",
    );
  }

  final prefs = await SharedPreferences.getInstance();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    final isClockedIn = prefs.getBool("isClockedIn") ?? false;

    if (isClockedIn) {
      int workSeconds = prefs.getInt("workSeconds") ?? 0;
      workSeconds++;
      await prefs.setInt("workSeconds", workSeconds);
      service.invoke("update", {"seconds": workSeconds});
    }
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
    iosConfiguration: IosConfiguration(),
  );
}

