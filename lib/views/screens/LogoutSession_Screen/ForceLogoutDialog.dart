// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../api/LogoutSessionController/LogoutFlowController.dart';
//
// class ForceLogoutScreen extends StatelessWidget {
//   const ForceLogoutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LogoutFlowController());
//
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.lock, size: 80),
//               const SizedBox(height: 16),
//               const Text(
//                 "Your previous session has expired. For security reasons, please log out and log in again to continue today’s work.",
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: controller.startLogoutFlow,
//                 child: const Text("Logout"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/LogoutSessionController/LogoutFlowController.dart';

class ForceLogoutScreen extends StatelessWidget {
  const ForceLogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogoutFlowController());

    return WillPopScope(
      onWillPop: () async => false, //Back press disable
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titlePadding: const EdgeInsets.only(top: 24),
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        title: Column(
          children: [
            /// 🔷 APP LOGO
            Image.asset(
              'assets/images/ShrachiCRMLogo.jpeg',
              height: 60,
            ),
            const SizedBox(height: 12),

            /// 🔐 HEADING
            const Text(
              "Session Expired",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: const Text(
          "Your previous session has expired.\n\n"
              "For security reasons, please log out and log in again to continue today’s work.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.startLogoutFlow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
