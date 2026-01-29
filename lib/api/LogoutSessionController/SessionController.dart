import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../views/screens/LogoutSession_Screen/AutoLogoutDialog.dart';
import '../../views/screens/LogoutSession_Screen/ForceLogoutDialog.dart';

class SessionController extends GetxController with WidgetsBindingObserver {

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _startSessionWatcher();
  }

  void _startSessionWatcher() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final now = DateTime.now();

      //11:29 PM – warning
      if (now.hour == 23 && now.minute == 29) {
      //if (now.hour == 13 && now.minute == 42) {
        if (!Get.isDialogOpen!) {
          Get.dialog(const AutoLogoutDialog(), barrierDismissible: false);
        }
      }

      //11:59 PM – force logout
      if (now.hour == 23 && now.minute == 59) {
      //if (now.hour == 13 && now.minute == 44) {
        _forceLogout();
      }
    });
  }

  Future<void> _forceLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("force_logout", true);
    Get.offAll(() => const ForceLogoutScreen());
  }

  @override
  void onClose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
