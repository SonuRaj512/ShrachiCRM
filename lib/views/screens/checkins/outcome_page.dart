// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/api/checkin_controller.dart';
// import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
// import 'package:shrachi/views/enums/responsive.dart';
//
// class OutcomePage extends StatefulWidget {
//   final int tourPlanId;
//   final int visitId;
//   // final double lat;
//   // final double lng;
//
//   const OutcomePage({
//     super.key,
//     required this.tourPlanId,
//     required this.visitId,
//     // required this.lat,
//     // required this.lng,
//   });
//
//   @override
//   State<OutcomePage> createState() => _OutcomePageState();
// }
//
// class _OutcomePageState extends State<OutcomePage> {
//   LeadStatus? _leadStatus;
//   DateTime? _followUpDate;
//   DateTime? _nextFollowUpDate;
//   final TextEditingController _outcomeController = TextEditingController();
//   final ApiController _apiController = Get.put(ApiController());
//   final CheckinController _checkinController = Get.put(CheckinController());
//
//   InputDecoration _dropdownDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//
//       // suffixIcon: Icon(Ionicons.chevron_down),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
//
//   Future<void> _selectDate(BuildContext context, bool isFollowUp) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFollowUp) {
//           _followUpDate = picked;
//         } else {
//           _nextFollowUpDate = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _apiController.fetchLeadStatuses();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: const BackButton(color: Colors.black),
//           title: const Text("Outcome", style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Align(
//             alignment: Alignment.center,
//             child: Obx(() {
//               return SizedBox(
//                 width:
//                     Responsive.isSm(context)
//                         ? screenWidth
//                         : Responsive.isXl(context)
//                         ? screenWidth * 0.60
//                         : screenWidth * 0.40,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       /// New Lead ke liye ye ui hai
//                       Container(
//                         child: Padding(
//                           padding: const EdgeInsets.all(0.0),
//                           child: Card(
//                             color: Colors.white,
//                             child: Column(
//                               children: [
//                                 DropdownButtonFormField<LeadStatus>(
//                                   decoration: _dropdownDecoration('Lead status'),
//                                   value: _leadStatus,
//                                   dropdownColor: Colors.white,
//                                   items: _apiController.leadStatuses.map((status) {
//                                     return DropdownMenuItem(
//                                       key: Key(status.id.toString()),
//                                       value: status,
//                                       child: Text(status.name),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _leadStatus = value;
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(height: 16),
//                                 TextFormField(
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: "Follow Up Date",
//                                     labelStyle: TextStyle(color: Colors.black),
//                                     border: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                     suffixIcon: const Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   onTap: () => _selectDate(context, true),
//                                   controller: TextEditingController(
//                                     text:
//                                     _followUpDate != null
//                                         ? "${_followUpDate!.day}-${_followUpDate!.month}-${_followUpDate!.year}"
//                                         : "",
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//
//                                 TextFormField(
//                                   readOnly: true,
//                                   decoration: InputDecoration(
//                                     labelText: "Next Follow up date",
//                                     labelStyle: TextStyle(color: Colors.black),
//                                     border: OutlineInputBorder(),
//                                     focusedBorder: OutlineInputBorder(),
//                                     suffixIcon: const Icon(
//                                       Icons.calendar_today,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   onTap: () => _selectDate(context, false),
//                                   controller: TextEditingController(
//                                     text:
//                                     _nextFollowUpDate != null
//                                         ? "${_nextFollowUpDate!.day}-${_nextFollowUpDate!.month}-${_nextFollowUpDate!.year}"
//                                         : "",
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       //client OutCome textField
//                       TextFormField(
//                         controller: _outcomeController,
//                         maxLines: 4,
//                         textAlignVertical: TextAlignVertical.top,
//                         decoration: const InputDecoration(
//                           labelText: "Client Outcome",
//                           labelStyle: TextStyle(color: Colors.black),
//                           alignLabelWithHint: true,
//                           border: OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       ElevatedButton(
//                         onPressed: () async {
//                           await _checkinController.checkOutVisit(
//                             // lat: widget.lat,
//                             // lng: widget.lng,
//                             tourPlanId: widget.tourPlanId,
//                             visitId: widget.visitId,
//                             followupDate: _followUpDate!.toString(),
//                             nextFollowupDate: _nextFollowUpDate.toString(),
//                             outcome: _outcomeController.text,
//                             leadStatus: _leadStatus!,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 16,
//                             horizontal: 15,
//                           ),
//                         ),
//                         child: _checkinController.isLoading.value
//                                 ? SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     color: Colors.white,
//                                   ),
//                                 )
//                                 : Text(
//                                   "Check Out",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/api/checkin_controller.dart';
import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
import 'package:shrachi/views/enums/responsive.dart';
import '../../../api/outcome_controller.dart';
import '../multicolor_progressbar_screen.dart';

class OutcomePage extends StatefulWidget {
  final int tourPlanId;
  final int visitId;
  final DateTime? startDate;

  const OutcomePage({
    super.key,
    required this.tourPlanId,
    required this.visitId,
    this.startDate
  });

  @override
  State<OutcomePage> createState() => _OutcomePageState();
}

class _OutcomePageState extends State<OutcomePage> {
  final VisitDetailController visitDetailController = Get.put(VisitDetailController());
  final ApiController _apiController = Get.put(ApiController());
  final CheckinController _checkinController = Get.put(CheckinController());

  LeadStatus? _leadStatus;
  DateTime? _followUpDate;
  DateTime? _nextFollowUpDate;
  final TextEditingController _outcomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _apiController.fetchLeadStatuses();
      await visitDetailController.fetchVisitData(widget.visitId);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isFollowUp) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.startDate!,
      firstDate: widget.startDate!,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFollowUp) {
          _followUpDate = picked;
        } else {
          _nextFollowUpDate = picked;
        }
      });
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.4), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.6), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          leading: const BackButton(color: Colors.white),
          title: const Text("Outcome Screen", style: TextStyle(color: Colors.white)),
          elevation: 0,
        ),
        body: Obx(() {
             // 🔹 Show loader while fetching data
             if (visitDetailController.isLoading.value) {
                return const Center(
                   child: MultiColorCircularLoader(size: 40,)
                   //CircularProgressIndicator(color: Colors.blue),
                );
             }

          return SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: Obx(() {
                final visitType = visitDetailController.visitType.value;

                return SizedBox(
                  width: Responsive.isSm(context)
                      ? screenWidth
                      : Responsive.isXl(context)
                      ? screenWidth * 0.60
                      : screenWidth * 0.40,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // 🔹 Condition to switch UI
                        if (visitType == "new_lead" || visitType == "followup_lead") ...[
                          /// 🟢 New Lead UI (Lead Status + Dates + Outcome)
                          Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  DropdownButtonFormField<LeadStatus>(
                                    decoration: _dropdownDecoration('Lead Status'),
                                    value: _leadStatus,
                                    dropdownColor: Colors.white,
                                    items: _apiController.leadStatuses.map((status) {
                                      return DropdownMenuItem(
                                        key: Key(status.id.toString()),
                                        value: status,
                                        child: Text(status.name),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _leadStatus = value;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 16),
                                  ///this code is follow up date
                                  // TextFormField(
                                  //   readOnly: true,
                                  //   decoration: InputDecoration(
                                  //     labelText: "Follow Up Date",
                                  //     labelStyle: const TextStyle(color: Colors.black),
                                  //     border: const OutlineInputBorder(),
                                  //     suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                                  //   ),
                                  //   onTap: () => _selectDate(context, true),
                                  //   controller: TextEditingController(
                                  //     text: _followUpDate != null
                                  //         ? "${_followUpDate!.day}-${_followUpDate!.month}-${_followUpDate!.year}"
                                  //         : "",
                                  //   ),
                                  // ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: "Next Follow Up Date",
                                      labelStyle: const TextStyle(color: Colors.black),
                                      border: const OutlineInputBorder(),
                                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                                    ),
                                    onTap: () => _selectDate(context, false),
                                    controller: TextEditingController(
                                      text: _nextFollowUpDate != null
                                          ? "${_nextFollowUpDate!.day}-${_nextFollowUpDate!.month}-${_nextFollowUpDate!.year}"
                                          : "",
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _outcomeController,
                                    maxLines: 4,
                                    decoration: const InputDecoration(
                                      labelText: "Meeting Outcome",
                                      labelStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          /// 🟣 Other Visit Types UI (Dealer Info + Outcome)
                          Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text("Visit Type :", style: TextStyle(fontWeight: FontWeight.w600)),
                                          SizedBox(height: 6),
                                          Text("Name :", style: TextStyle(fontWeight: FontWeight.w600)),
                                          SizedBox(height: 6),
                                          Text("Visit Date :", style: TextStyle(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Obx(() => Text(visitDetailController.visitType.value)),
                                          const SizedBox(height: 6),
                                          Obx(() => Text(visitDetailController.dealerName.value)),
                                          const SizedBox(height: 6),
                                          Obx(() => Text(visitDetailController.visitDate.value)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Text("start date:${widget.startDate}"),
                          SizedBox(height: 10,),
                          TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Follow Up Date",
                              labelStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(),
                              suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                            ),
                            onTap: () => _selectDate(context, true),
                            controller: TextEditingController(
                              text: _followUpDate != null
                                  ? "${_followUpDate!.day}-${_followUpDate!.month}-${_followUpDate!.year}"
                                  : "",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _outcomeController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: "Meeting Outcome",
                              labelStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                       //🔘 Common Button
                        ElevatedButton(
                          onPressed: () async {
                            await _checkinController.OutComeVisit(
                              tourPlanId: widget.tourPlanId,
                              visitId: widget.visitId,
                              followupDate: _followUpDate?.toString() ?? "",
                              nextFollowupDate: _nextFollowUpDate?.toString(),
                              outcome: _outcomeController.text,
                              leadStatus: _leadStatus,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          ),
                          child: _checkinController.isLoading.value
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white),
                          ) : const Text(
                            "Submit Outcome",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/api/checkin_controller.dart';
// import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
// import 'package:shrachi/views/enums/responsive.dart';
//
// import '../../../api/outcome_controller.dart';
//
// class OutcomePage extends StatefulWidget {
//   final int tourPlanId;
//   final int visitId;
//
//   const OutcomePage({
//     super.key,
//     required this.tourPlanId,
//     required this.visitId,
//   });
//
//   @override
//   State<OutcomePage> createState() => _OutcomePageState();
// }
//
// class _OutcomePageState extends State<OutcomePage> {
//   final VisitDetailController visitDetailController =
//   Get.put(VisitDetailController());
//   final ApiController _apiController = Get.put(ApiController());
//   final CheckinController _checkinController = Get.put(CheckinController());
//
//   LeadStatus? _leadStatus;
//   DateTime? _followUpDate;
//   DateTime? _nextFollowUpDate;
//   final TextEditingController _outcomeController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _apiController.fetchLeadStatuses();
//       await visitDetailController.fetchVisitData(widget.visitId);
//     });
//   }
//   Future<void> _selectDate(BuildContext context, bool isFollowUp) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isFollowUp) {
//           _followUpDate = picked;
//         } else {
//           _nextFollowUpDate = picked;
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leading: const BackButton(color: Colors.black),
//           title: const Text("Outcome", style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.white,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Align(
//             alignment: Alignment.center,
//             child: Obx(() {
//               return SizedBox(
//                 width: Responsive.isSm(context)
//                     ? screenWidth
//                     : Responsive.isXl(context)
//                     ? screenWidth * 0.60
//                     : screenWidth * 0.40,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       /// 🔹 Dealer Info Card
//                       // Card(
//                       //   color: Colors.white,
//                       //   child: Padding(
//                       //     padding: const EdgeInsets.all(12.0),
//                       //     child: visitDetailController.isLoading.value
//                       //         ? const Center(
//                       //       child: Padding(
//                       //         padding: EdgeInsets.all(16.0),
//                       //         child: CircularProgressIndicator(),
//                       //       ),
//                       //     )
//                       //         : Column(
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //       children: [
//                       //         _buildInfoRow(
//                       //           "Dealer Name:",
//                       //           visitDetailController.dealerName.value,
//                       //         ),
//                       //         const SizedBox(height: 10),
//                       //         _buildInfoRow(
//                       //           "Visit Type:",
//                       //           visitDetailController.visitType.value,
//                       //         ),
//                       //         const SizedBox(height: 10),
//                       //         _buildInfoRow(
//                       //           "Visit Date:",
//                       //           visitDetailController.visitDate.value,
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//
//                       Container(
//                         child: Card(
//                           color: Colors.white,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 7.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               //crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text("Dealer Name : ",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4,),
//                                         Text(
//                                           "Visit Type : ",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         SizedBox(height: 4,),
//                                         Text("Visit Date : ",
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Obx(() => Text(
//                                           visitDetailController.dealerName.value,
//                                           style: const TextStyle(color: Colors.black87),
//                                         )),
//                                         SizedBox(height: 7,),
//                                         Obx(() => Text(
//                                           visitDetailController.visitType.value,
//                                           style: const TextStyle(color: Colors.black87),
//                                         ),
//                                         ),
//                                         SizedBox(height: 7,),
//                                         Obx(() => Text(
//                                           visitDetailController.visitDate.value,
//                                           style: const TextStyle(color: Colors.black87),
//                                         )),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10,),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           labelText: "Follow Up Date",
//                           labelStyle: TextStyle(color: Colors.black),
//                           border: OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(),
//                           suffixIcon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black,
//                           ),
//                         ),
//                         onTap: () => _selectDate(context, true),
//                         controller: TextEditingController(
//                           text:
//                           _followUpDate != null
//                               ? "${_followUpDate!.day}-${_followUpDate!.month}-${_followUpDate!.year}"
//                               : "",
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // 📝 Client Outcome
//                       TextFormField(
//                         controller: _outcomeController,
//                         maxLines: 4,
//                         decoration: const InputDecoration(
//                           labelText: "Client Outcome",
//                           labelStyle: TextStyle(color: Colors.black),
//                           border: OutlineInputBorder(),
//                           focusedBorder: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//
//                       ElevatedButton(
//                         onPressed: () async {
//                           await _checkinController.checkOutVisit(
//                             tourPlanId: widget.tourPlanId,
//                             visitId: widget.visitId,
//                             followupDate: _followUpDate?.toString() ?? "",
//                             nextFollowupDate: _nextFollowUpDate?.toString(),
//                             outcome: _outcomeController.text,
//                             leadStatus: _leadStatus!,
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 16, horizontal: 15),
//                         ),
//                         child: _checkinController.isLoading.value
//                             ? const SizedBox(
//                           width: 20,
//                           height: 20,
//                           child:
//                           CircularProgressIndicator(color: Colors.white),
//                         )
//                             : const Text(
//                           "Check Out",
//                           style: TextStyle(
//                               fontSize: 16, color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
//         Flexible(
//           child: Text(
//             value,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(color: Colors.black87),
//           ),
//         ),
//       ],
//     );
//   }
// }
