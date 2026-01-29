// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../models/ExpenseAndOutcomeModel.dart';
//
// class OutcomeDetailScreen extends StatelessWidget {
//   final List<Checkins> checkins; // Now accepts a list of Checkins
//   final String tourSerialNo;
//
//   const OutcomeDetailScreen({
//     super.key,
//     required this.checkins,
//     required this.tourSerialNo,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         foregroundColor: Colors.white,
//         title: Text(
//           "Outcomes for Tour: $tourSerialNo",
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//       body: checkins.isEmpty
//           ? const Center(child: Text("No outcomes found for this tour."))
//           : ListView.builder(
//         padding: const EdgeInsets.all(8.0),
//         itemCount: checkins.length,
//         itemBuilder: (context, index) {
//           final outcome = checkins[index];
//           return Card(
//             color: Colors.grey[200],
//             elevation: 5,
//             //margin: const EdgeInsets.symmetric(vertical: 8.0),
//             child: Padding(
//               padding: const EdgeInsets.all(7.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Outcome ID:      ${outcome.id}",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                   const Divider(height: 10, color: Colors.grey),
//                   if (outcome.outcome != null) _buildInfoRow("Outcome:", outcome.outcome!),
//                   if (outcome.comments != null) _buildInfoRow("Comments:", outcome.comments!),
//                   _buildInfoRow("Check-in Status:", outcome.checkinStatus ? "Checked In" : "Not Checked In"),
//                   if (outcome.followupDate != null)
//                     _buildInfoRow(
//                       "Follow-up Date:",
//                       DateFormat('yyyy-MM-dd').format(outcome.followupDate!),
//                     ),
//                   if (outcome.images != null && outcome.images!.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text("Images:", style: TextStyle(fontWeight: FontWeight.bold)),
//                           ...outcome.images!
//                               .map((imagePath) => Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 2.0),
//                             child: Text(imagePath, style: const TextStyle(fontSize: 12)),
//                           ))
//                               .toList(),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120, // Align labels
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../api/api_const.dart';
import '../../../../models/ExpenseAndOutcomeModel.dart';

class OutcomeDetailScreen extends StatelessWidget {
  final List<Checkins> checkins; // Now accepts a list of Checkins
  final String tourSerialNo;

  const OutcomeDetailScreen({
    super.key,
    required this.checkins,
    required this.tourSerialNo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        title: Text(
          "Outcomes for Tour: $tourSerialNo",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: checkins.isEmpty
          ? const Center(child: Text("No outcomes found for this tour."))
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: checkins.length,
        itemBuilder: (context, index) {
          final outcome = checkins[index];
          return Card(
            color: Colors.grey[200],
            elevation: 5,
            //margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Outcome ID:      ${outcome.id}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(height: 10, color: Colors.grey),
                  // Fix applied here: Use null-aware operator (??) to provide a default value
                  _buildInfoRow("Outcome:", outcome.outcome ?? 'N/A'),
                  _buildInfoRow("Comments:", outcome.comments ?? 'N/A'),
                  _buildInfoRow("Check-in Status:", outcome.checkinStatus ? "Checked In" : "Not Checked In"),
                  if (outcome.followupDate != null)
                    _buildInfoRow(
                      "Follow-up Date:",
                      DateFormat('yyyy-MM-dd').format(outcome.followupDate!),
                    ),
                  if (outcome.images != null && outcome.images!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Images:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          ...outcome.images!.map((imagePath) {
                            final fullUrl = imageUrl + imagePath;  // 👉 FULL URL YAHAN BAN RAHA

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  fullUrl,                           // 👉 Actual full image url
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      "Failed to load image",
                                      style: TextStyle(color: Colors.red),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                  // if (outcome.images != null && outcome.images!.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //           Image("Images:", style: TextStyle(fontWeight: FontWeight.bold), image: null,),
                  //         ...outcome.images!
                  //             .map((imagePath) => Padding(
                  //           padding: const EdgeInsets.symmetric(vertical: 2.0),
                  //           child: Text(imagePath, style: const TextStyle(fontSize: 12)),
                  //         ))
                  //             .toList(),
                  //       ],
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Align labels
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}