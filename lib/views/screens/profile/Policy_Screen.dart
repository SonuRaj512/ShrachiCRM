// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
//
// import '../../../api/ProfileController/PrivacypolicyController.dart';
// import '../../../models/Profile/PrivacyModel.dart';
//
// class PrivacyPolicy extends StatefulWidget {
//   const PrivacyPolicy({super.key});
//
//   @override
//   State<PrivacyPolicy> createState() => _PrivacyPolicyState();
// }
//
// class _PrivacyPolicyState extends State<PrivacyPolicy> {
//   late Future<PrivacyPolicyModel> _policyFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _policyFuture = PolicyService.fetchPrivacyPolicy();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Privacy Policy"),
//           centerTitle: true,
//         ),
//         body: FutureBuilder<PrivacyPolicyModel>(
//           future: _policyFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   "Something went wrong",
//                   style: TextStyle(color: Colors.red),
//                 ),
//               );
//             }
//
//             final policy = snapshot.data!;
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// TITLE
//                   Text(
//                     policy.title,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   /// HTML CONTENT
//                   Html(
//                     data: policy.content,
//                     style: {
//                       "p": Style(
//                         fontSize: FontSize(15),
//                         lineHeight: LineHeight(1.4),
//                       ),
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../api/ProfileController/PrivacypolicyController.dart';

class PolicyScreen extends StatelessWidget {
  final String policyType;
  final String appBarTitle;

  PolicyScreen({
    super.key,
    required this.policyType,
    required this.appBarTitle,
  });

  final PolicyController controller = Get.put(PolicyController());

  @override
  Widget build(BuildContext context) {
    controller.fetchPolicy(policyType);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text(appBarTitle,style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.policy.value == null) {
            return const Center(
              child: Text("No data found"),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  controller.policy.value!.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// HTML CONTENT
                Html(
                  data: controller.policy.value!.content,
                  style: {
                    "p": Style(
                      fontSize: FontSize(15),
                      lineHeight: LineHeight(1.4),
                    ),
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
