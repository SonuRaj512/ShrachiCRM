import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../api/LogoutSessionController/LogoutFlowController.dart';

class AutoLogoutDialog extends StatelessWidget {
  const AutoLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogoutFlowController());

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text("Auto Logout Warning"),
      content: const Text(
          "You will be automatically logout in 30 minutes.\n Please make sure to sync your data."),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Later"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            controller.startLogoutFlow();
          },
          child: const Text("Sync & Logout"),
        ),
      ],
    );
  }
}
