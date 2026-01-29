import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/service/background_service.dart';
import 'package:shrachi/service/tracking_service.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/LogoutSession_Screen/ForceLogoutDialog.dart';
import 'package:uid/uid.dart';
import 'OfflineDatabase/ConnectivityService.dart';
import 'api/api_controller.dart';
import 'api/routes.dart';
import 'global.dart';
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Generate Unique ID once and store globally
  globalUniqueId = UId.getId();
  final prefs = await SharedPreferences.getInstance();
  final forceLogout = prefs.getBool("force_logout") ?? false;
  print("Global Unique ID: $globalUniqueId");
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
  );
  // if(!kIsWeb){
  //   await initializeService();
  //   await initializeTrackingService();
  // }
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    await initializeService();
    await initializeTrackingService();
  } else {
    debugPrint('Skipping background service for web.');
  }
  Get.put(ApiController());
  Get.put(ConnectivityService());
  runApp(
    forceLogout ? const ForceLogoutScreen() : const MyApp(),
    //const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _noScreenshot = NoScreenshot.instance;

  void enableScreenshot() async {
    await _noScreenshot.screenshotOn();
  }

  @override
  void initState() {
    super.initState();
    enableScreenshot();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shrachi',
      navigatorKey: Get.key,
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black.withValues(alpha: 0.5),
          selectedItemColor: Colors.black,
          enableFeedback: false,
          elevation: 0,
        ),
        splashColor: Colors.transparent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: !Responsive.isMd(context),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          //leadingWidth: 30,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelLarge: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
        ),
      ),
      //home: Splash(),
    );
  }
}
// Splashimport 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shrachi/views/screens/auth/login.dart';
// // 1. YE LINE SABSE IMPORTANT HAI: Global Key banaiye
// final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       // 2. Navigator key aur ScaffoldMessenger key dono dijiye
//       navigatorKey: Get.key,
//       scaffoldMessengerKey: snackbarKey,
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }