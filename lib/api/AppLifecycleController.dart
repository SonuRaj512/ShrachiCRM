// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import 'api_controller.dart';
// class AppLifecycleController extends GetxController with WidgetsBindingObserver {
//   final ApiController _apiController = Get.find<ApiController>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // App jaise hi wapas khulegi, date check hogi
//       _apiController.checkDateAndLogout();
//     }
//   }
//
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.onClose();
//   }
// }