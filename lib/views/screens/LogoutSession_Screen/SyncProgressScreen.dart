import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../api/LogoutSessionController/LogoutFlowController.dart';

class SyncProgressScreen extends StatelessWidget {
  const SyncProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LogoutFlowController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Syncing Data")),
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text("Syncing ${c.synced.value} of ${c.total.value} records"),
          ],
        )),
      ),
    );
  }
}
