// import 'dart:convert';
// import 'package:easy_stepper/easy_stepper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:shrachi/views/screens/tours/update_plan.dart';
//
// import '../../../api/api_controller.dart';
//
// class ShowTour extends StatefulWidget {
//   final TourPlan tourPlan;
//   final String status;
//   const ShowTour({super.key, required this.tourPlan, required this.status});
//
//   @override
//   State<ShowTour> createState() => _ShowTourState();
// }
//
// class _ShowTourState extends State<ShowTour> {
//   final ApiController controller = Get.put(ApiController());
//   late int activeStep;
//   bool _isSubmitting = false;
//   bool _isSubmitted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     activeStep = _getStep(widget.tourPlan.status);
//     _isSubmitted = widget.tourPlan.status.toLowerCase() == 'approval';
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchTourPlans();
//     });
//   }
//
//   int _getStep(String status) {
//     switch (status.toLowerCase()) {
//       case "pending":
//         return 0;
//       case "approval":
//         return 1;
//       case "confirmed":
//         return 2;
//       case "cancelled":
//       case "rejected":
//         return 1;
//       default:
//         return 0;
//     }
//   }
//
//   /// ✅ Send for Approval API call
//   Future<void> _sendForApproval() async {
//     setState(() => _isSubmitting = true);
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('access_token');
//
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Token missing. Please login again.')),
//         );
//         setState(() => _isSubmitting = false);
//         return;
//       }
//
//       final url = Uri.parse('https://sharchi.equi.website/api/tour-plans/${widget.tourPlan.id}/approval');
//
//       final response = await http.put(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('✅ Tour Plan sent for approval successfully!'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         setState(() {
//           _isSubmitted = true;
//           activeStep = _getStep('approval');
//         });
//       } else {
//         final error = jsonDecode(response.body);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('❌ Failed: ${error['message'] ?? 'Unknown error'}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//
//     setState(() => _isSubmitting = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final statusLower = widget.tourPlan.status.toLowerCase();
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           title: const Text(
//             'Show Tour Plan',
//             style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
//           ),
//           leading: IconButton(onPressed: (){
//             Navigator.pop(context, true);
//           }, icon: Icon(Icons.arrow_back_rounded,color: Colors.white,)),
//           backgroundColor: ColorPalette.seaGreen600,
//           //elevation: 1,
//         ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//
//               // ✅ SHOW BUTTONS (Now allowed for cancelled too)
//               if (statusLower != 'confirmed')
//                 AnimatedSwitcher(
//                   duration: const Duration(milliseconds: 400),
//                   child: _isSubmitted
//                       ? _submittedStatusCard(screenWidth)
//                       : _actionButtons(screenWidth, context),
//                 ),
//
//               const SizedBox(height: 10),
//
//               // ✅ Details + Stepper + Visits
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _tourDetailsCard(screenWidth),
//                       const SizedBox(height: 20),
//                       // EasyStepper(
//                       //   activeStep: activeStep,
//                       //   showLoadingAnimation: false,
//                       //   internalPadding: 0,
//                       //   stepRadius: 12,
//                       //   fitWidth: true,
//                       //   lineStyle: LineStyle(
//                       //     lineLength: Responsive.isMd(context)
//                       //         ? screenWidth / 4 - 20
//                       //         : screenWidth / 6 - 20,
//                       //     lineType: LineType.normal,
//                       //     activeLineColor: Colors.black.withOpacity(0.3),
//                       //     finishedLineColor: Colors.black.withOpacity(0.3),
//                       //     unreachedLineColor: Colors.black.withOpacity(0.3),
//                       //   ),
//                       //   showStepBorder: false,
//                       //   steps: _getStepperSteps(widget.tourPlan.status),
//                       // ),
//                       Container(
//                         width: double.infinity, // full width
//                         padding: EdgeInsets.zero,
//                         margin: EdgeInsets.zero,
//                         child: EasyStepper(
//                           activeStep: activeStep,
//                           showLoadingAnimation: false,
//                           internalPadding: 0,
//                           stepRadius: 12,
//                           fitWidth: true,
//                           alignment: Alignment.center,
//                           lineStyle: LineStyle(
//                             lineLength: (screenWidth /
//                                 _getStepperSteps(widget.tourPlan.status).length) -
//                                 25,
//                             lineType: LineType.normal,
//                             activeLineColor: Colors.black.withOpacity(0.3),
//                             finishedLineColor: Colors.black.withOpacity(0.3),
//                             unreachedLineColor: Colors.black.withOpacity(0.3),
//                           ),
//                           showStepBorder: false,
//                           steps: _getStepperSteps(widget.tourPlan.status),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//                       _visitList(screenWidth),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ✅ Modern button row
//   Widget _actionButtons(double screenWidth, BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _modernButton(
//           context,
//           icon: _isSubmitting ? Icons.hourglass_top : Ionicons.checkmark_sharp,
//           label: _isSubmitting ? 'Submitting...' : 'Send For Approval',
//           color: _isSubmitting ? Colors.grey : ColorPalette.seaGreen600,
//           onPressed: _isSubmitting ? null : _sendForApproval,
//           width: screenWidth * 0.42,
//         ),
//         const SizedBox(width: 10),
//         _modernButton(
//           context,
//           icon: Ionicons.pencil_sharp,
//           label: 'Modify Plan',
//           color: ColorPalette.shark800,
//           onPressed: _isSubmitting
//               ? null
//               : () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => UpdatePlan(tourPlan: widget.tourPlan),
//               ),
//             );
//           },
//           width: screenWidth * 0.42,
//         ),
//       ],
//     );
//   }
//
//   Widget _submittedStatusCard(double width) {
//     return Container(
//       key: const ValueKey('submitted'),
//       width: width * 0.9,
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.green.shade300),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.check_circle, color: Colors.green, size: 22),
//           SizedBox(width: 8),
//           Text(
//             'Submitted for approval',
//             style: TextStyle(
//               color: Colors.green,
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _modernButton(
//       BuildContext context, {
//         required IconData icon,
//         required String label,
//         required Color color,
//         required VoidCallback? onPressed,
//         required double width,
//       }) {
//     return SizedBox(
//       width: width,
//       height: 48,
//       child: ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           elevation: 2,
//         ),
//         onPressed: onPressed,
//         icon: Icon(icon, color: Colors.white, size: 20),
//         label: Text(
//           label,
//           style: const TextStyle(color: Colors.white, fontSize: 15),
//         ),
//       ),
//     );
//   }
//
//   ///Stepper with Cancelled (Rejected) State
//   // List<EasyStep> _getStepperSteps(String status) {
//   //   if (status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'rejected') {
//   //     return [
//   //       EasyStep(
//   //         customStep: const CircleAvatar(
//   //           radius: 12,
//   //           backgroundColor: Colors.white,
//   //           child: CircleAvatar(radius: 11, backgroundColor: Colors.red),
//   //         ),
//   //         customTitle: const Text(
//   //           'Rejected',
//   //           style: TextStyle(
//   //               fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
//   //         ),
//   //       ),
//   //     ];
//   //   }
//   //
//   //   List<String> titles = ['New', 'Send For Approval', 'Approved'];
//   //   int active = 0;
//   //
//   //   switch (status.toLowerCase()) {
//   //     case 'pending':
//   //       active = 0;
//   //       break;
//   //     case 'approval':
//   //       active = 1;
//   //       break;
//   //     case 'confirmed':
//   //       active = 2;
//   //       break;
//   //   }
//   //
//   //   return List.generate(titles.length, (i) {
//   //     return EasyStep(
//   //       customStep: CircleAvatar(
//   //         radius: 12,
//   //         backgroundColor: Colors.white,
//   //         child: CircleAvatar(
//   //           radius: 11,
//   //           backgroundColor:
//   //           i <= active ? ColorPalette.seaGreen500 : const Color(0xff6A7580),
//   //         ),
//   //       ),
//   //       customTitle: Text(
//   //         titles[i],
//   //         textAlign: TextAlign.center,
//   //         style: const TextStyle(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.bold,
//   //           color: Colors.grey,
//   //         ),
//   //       ),
//   //     );
//   //   });
//   // }
//   List<EasyStep> _getStepperSteps(String status) {
//     final lowerStatus = status.toLowerCase();
//     //When rejected or cancelled — show all steps in red
//     if (lowerStatus == 'rejected' || lowerStatus == 'cancelled') {
//       List<String> titles = ['New', 'Send For Approval', 'Rejected'];
//
//       return List.generate(titles.length, (i) {
//         return EasyStep(
//           customStep: CircleAvatar(
//             radius: 12,
//             backgroundColor: Colors.white,
//             child: CircleAvatar(
//               radius: 11,
//               backgroundColor: Colors.red.shade600,
//             ),
//           ),
//           customTitle: Text(
//             titles[i],
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.red.shade600,
//             ),
//           ),
//         );
//       });
//     }
//     // Normal statuses — green progression
//     List<String> titles = ['New', 'Send For Approval', 'Approved'];
//     int active = 0;
//     switch (lowerStatus) {
//       case 'pending':
//         active = 0;
//         break;
//       case 'approval':
//         active = 1;
//         break;
//       case 'confirmed':
//         active = 2;
//         break;
//     }
//
//     return List.generate(titles.length, (i) {
//       final isActive = i <= active;
//
//       return EasyStep(
//         customStep: CircleAvatar(
//           radius: 12,
//           backgroundColor: Colors.white,
//           child: CircleAvatar(
//             radius: 11,
//             backgroundColor:
//             isActive ? ColorPalette.seaGreen500 : const Color(0xffC4C4C4),
//           ),
//         ),
//         customTitle: Text(
//           titles[i],
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: isActive ? ColorPalette.seaGreen600 : Colors.grey.shade500,
//           ),
//         ),
//       );
//     });
//   }
//
//
//   Widget _tourDetailsCard(double screenWidth) {
//     return SizedBox(
//       width: Responsive.isMd(context)
//           ? screenWidth
//           : Responsive.isXl(context)
//           ? screenWidth * 0.60
//           : screenWidth * 0.40,
//       child: Card(
//         elevation: 4,
//         color: Colors.white,
//         shadowColor: Colors.black.withOpacity(0.1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Text(
//                   'Tour Plan Details',
//                   style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black.withOpacity(0.8),
//                   ),
//                 ),
//               ),
//
//               const Divider(height: 1, color: Colors.grey),
//
//               const SizedBox(height: 8),
//
//               // Table-style details
//               _buildDetailRow('Plan Name', widget.tourPlan.serial_no ?? ''),
//               _buildDetailRow(
//                 'Start Date',
//                 DateFormat('EEE, dd MMM yyyy')
//                     .format(DateTime.parse(widget.tourPlan.startDate)),
//               ),
//               _buildDetailRow(
//                 'End Date',
//                 DateFormat('EEE, dd MMM yyyy')
//                     .format(DateTime.parse(widget.tourPlan.endDate)),
//               ),
//               _buildDetailRow(
//                   'Planned Tour Days', '${widget.tourPlan.durationInDays}'),
//               _buildDetailRow('Actual Tour Days', '0'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Custom reusable row
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[700],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//   TableRow _buildTableRow(String title, String value) {
//     return TableRow(children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.black.withOpacity(0.5),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
//         child: Text(
//           value,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     ]);
//   }
//
//   Widget _visitList(double screenWidth) {
//     return SizedBox(
//       width: Responsive.isMd(context)
//           ? screenWidth - 20
//           : screenWidth / 3 - 20,
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: widget.tourPlan.visits.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 18),
//         itemBuilder: (_, index) {
//           final visit = widget.tourPlan.visits[index];
//
//           return Card(
//             elevation: 3,
//             color: Colors.white,
//             shadowColor: Colors.black.withOpacity(0.1),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // 🗓 Date
//                   Text(
//                     DateFormat('EEEE, dd MMM yyyy')
//                         .format(DateTime.parse(visit.visitDate)),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: ColorPalette.pictonBlue500,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // Divider
//                   Divider(
//                     color: Colors.grey.shade300,
//                     thickness: 1,
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   // 📋 Details
//                   _buildVisitRow('Name', visit.name ?? '-'),
//                   _buildVisitRow(
//                       'Type', visit.type.replaceAll('_', ' ').capitalizeFirst!),
//                   if (visit.type != 'new_lead' &&
//                       visit.type != 'followup_lead') ...[
//                     _buildVisitRow('Purpose of Visit', visit.visitPurpose ?? '-'),
//                   ],
//                   if (visit.type == 'new_lead' ||
//                       visit.type == 'followup_lead') ...[
//                     _buildVisitRow('Lead Type', visit.lead?.type ?? '-'),
//                     _buildVisitRow('Lead Source', visit.lead?.leadSource ?? '-'),
//                     _buildVisitRow('State', visit.lead?.state ?? '-'),
//                   ],
//
//                   const SizedBox(height: 14),
//
//                   // ✅ Status Badge
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 14, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: visit.isApproved != 0
//                             ? Colors.green.shade600
//                             : Colors.orange.shade600,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             visit.isApproved != 0
//                                 ? Icons.check_circle
//                                 : Icons.timer_outlined,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             visit.isApproved != 0 ? "Approved" : "Pending",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   /// Reusable small row widget for details
//   Widget _buildVisitRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }

import 'dart:convert';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/tours/update_plan.dart';
import '../../../api/api_controller.dart';

class ShowTour extends StatefulWidget {
  final TourPlan tourPlan;
  final String status;

  const ShowTour({super.key, required this.tourPlan, required this.status});

  @override
  State<ShowTour> createState() => _ShowTourState();
}

class _ShowTourState extends State<ShowTour> {
  final ApiController controller = Get.put(ApiController());
  late int activeStep;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  String currentStatus = '';

  @override
  void initState() {
    super.initState();
    currentStatus = widget.tourPlan.status;
    activeStep = _getStep(currentStatus);
    _isSubmitted = currentStatus.toLowerCase() == 'approval';

    // Initial fetch for realtime sync
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTourPlans();
    });
  }

  int _getStep(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return 0;
      case "approval":
        return 1;
      case "confirmed":
        return 2;
      case "cancelled":
        return 3;
      case "rejected":
        return 1;
      default:
        return 0;
    }
  }

  /// ✅ Send for Approval API call
  Future<void> _sendForApproval() async {
    setState(() => _isSubmitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token missing. Please login again.')),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      final url = Uri.parse(
        '${baseUrl}tour-plans/${widget.tourPlan.id}/approval',
      );

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Tour Plan sent for approval successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // ✅ Update local UI + refetch from API for realtime update
        setState(() {
          currentStatus = 'approval';
          _isSubmitted = true;
          activeStep = _getStep(currentStatus);
        });

        // 🔄 Fetch latest data from API
        controller.fetchTourPlans();
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed: ${error['message'] ?? 'Unknown error'}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusLower = currentStatus.toLowerCase();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: const Text(
            'Show Tour Plan',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // ✅ Buttons
              if (statusLower != 'confirmed')
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child:
                      _isSubmitted
                          ? _submittedStatusCard(screenWidth)
                          : _actionButtons(screenWidth, context),
                ),

              const SizedBox(height: 10),

              // ✅ Details + Stepper + Visits
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _tourDetailsCard(screenWidth),
                      const SizedBox(height: 20),

                      // ✅ Stepper
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.zero,
                        child: EasyStepper(
                          activeStep: activeStep,
                          showLoadingAnimation: false,
                          internalPadding: 0,
                          stepRadius: 12,
                          fitWidth: true,
                          alignment: Alignment.center,
                          lineStyle: LineStyle(
                            lineLength:
                                (screenWidth /
                                    _getStepperSteps(currentStatus).length) -
                                25,
                            lineType: LineType.normal,
                            activeLineColor: Colors.black.withOpacity(0.3),
                            finishedLineColor: Colors.black.withOpacity(0.3),
                            unreachedLineColor: Colors.black.withOpacity(0.3),
                          ),
                          showStepBorder: false,
                          steps: _getStepperSteps(currentStatus),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _visitList(screenWidth),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Buttons
  Widget _actionButtons(double screenWidth, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _modernButton(
          context,
          icon: _isSubmitting ? Icons.hourglass_top : Ionicons.checkmark_sharp,
          label: _isSubmitting ? 'Submitting...' : 'Send For Approval',
          color: _isSubmitting ? Colors.grey : ColorPalette.seaGreen600,
          onPressed: _isSubmitting ? null : _sendForApproval,
          width: screenWidth * 0.42,
        ),
        const SizedBox(width: 10),
        _modernButton(
          context,
          icon: Ionicons.pencil_sharp,
          label: 'Modify Plan',
          color: ColorPalette.shark800,
          onPressed:
              _isSubmitting
                  ? null
                  : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdatePlan(tourPlan: widget.tourPlan),
                      ),
                    );
                  },
          width: screenWidth * 0.42,
        ),
      ],
    );
  }

  Widget _submittedStatusCard(double width) {
    return Container(
      key: const ValueKey('submitted'),
      width: width * 0.9,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, color: Colors.green, size: 22),
          SizedBox(width: 8),
          Text(
            'Submitted for approval',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modernButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    required double width,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 20),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  /// ✅ Stepper
  // List<EasyStep> _getStepperSteps(String status) {
  //   final lowerStatus = status.toLowerCase();
  //   if (lowerStatus == 'rejected' || lowerStatus == 'cancelled') {
  //     List<String> titles = ['New', 'Send For Approval', 'Rejected'];
  //     return List.generate(titles.length, (i) {
  //       return EasyStep(
  //         customStep: CircleAvatar(
  //           radius: 12,
  //           backgroundColor: Colors.white,
  //           child: CircleAvatar(
  //             radius: 11,
  //             backgroundColor: Colors.red.shade600,
  //           ),
  //         ),
  //         customTitle: Text(
  //           titles[i],
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.red.shade600,
  //           ),
  //         ),
  //       );
  //     });
  //   }
  //
  //   List<String> titles = ['New', 'Send For Approval', 'Approved'];
  //   int active = 0;
  //
  //   switch (lowerStatus) {
  //     case 'pending':
  //       active = 0;
  //       break;
  //     case 'approval':
  //       active = 1;
  //       break;
  //     case 'confirmed':
  //       active = 2;
  //       break;
  //   }
  //   return List.generate(titles.length, (i) {
  //     final isActive = i <= active;
  //     return EasyStep(
  //       customStep: CircleAvatar(
  //         radius: 12,
  //         backgroundColor: Colors.white,
  //         child: CircleAvatar(
  //           radius: 11,
  //           backgroundColor:
  //           isActive ? ColorPalette.seaGreen500 : const Color(0xffC4C4C4),
  //         ),
  //       ),
  //       customTitle: Text(
  //         titles[i],
  //         textAlign: TextAlign.center,
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.bold,
  //           color:
  //           isActive ? ColorPalette.seaGreen600 : Colors.grey.shade500,
  //         ),
  //       ),
  //     );
  //   });
  // }
  List<EasyStep> _getStepperSteps(String status) {
    final lowerStatus = status.toLowerCase();

    // ------------------ REJECTED / CANCELLED ------------------
    if (lowerStatus == 'rejected' || lowerStatus == 'cancelled') {
      List<String> titles = ['New', 'Send For Approval', 'Rejected'];

      return List.generate(titles.length, (i) {
        return EasyStep(
          customStep: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: Colors.red.shade600,
            ),
          ),
          customTitle: Text(
            titles[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade600,
            ),
          ),
        );
      });
    }

    // ---------------------------------------------------------
    //             NORMAL / PARTIAL / APPROVED STATES
    // ---------------------------------------------------------

    List<String> titles = ['New', 'Send For Approval', 'Approved'];
    int active = 0;

    switch (lowerStatus) {
      case 'pending': // initial
        active = 0;
        break;

      case 'approval': // sent for approval
        active = 1;
        break;

      case 'partially approved': // new added
        titles = ['New', 'Send For Approval', 'Partially Approved'];
        active = 2;
        break;

      case 'confirmed': // final approved
        titles = ['New', 'Send For Approval', 'Approved'];
        active = 2;
        break;
    }

    return List.generate(titles.length, (i) {
      final isActive = i <= active;

      return EasyStep(
        customStep: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 11,
            backgroundColor:
                isActive ? ColorPalette.seaGreen500 : const Color(0xffC4C4C4),
          ),
        ),
        customTitle: Text(
          titles[i],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isActive ? ColorPalette.seaGreen600 : Colors.grey.shade500,
          ),
        ),
      );
    });
  }

  /// ✅ Tour Details
  Widget _tourDetailsCard(double screenWidth) {
    return SizedBox(
      width:
          Responsive.isMd(context)
              ? screenWidth
              : Responsive.isXl(context)
              ? screenWidth * 0.60
              : screenWidth * 0.40,
      child: Card(
        elevation: 4,
        color: Colors.grey[200],
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Tour Plan Details',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              _buildDetailRow('Plan Name', widget.tourPlan.serial_no ?? ''),
              _buildDetailRow(
                'Start Date',
                DateFormat(
                  'EEE, dd MMM yyyy',
                ).format(DateTime.parse(widget.tourPlan.startDate)),
              ),
              _buildDetailRow(
                'End Date',
                DateFormat(
                  'EEE, dd MMM yyyy',
                ).format(DateTime.parse(widget.tourPlan.endDate)),
              ),
              _buildDetailRow(
                'Planned Tour Days',
                '${widget.tourPlan.durationInDays}',
              ),
              _buildDetailRow('Actual Tour Days', '0'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Visits List
  // Widget _visitList(double screenWidth) {
  //   return SizedBox(
  //     width: Responsive.isMd(context)
  //         ? screenWidth - 20
  //         : screenWidth / 3 - 20,
  //     child: ListView.separated(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: widget.tourPlan.visits.length,
  //       separatorBuilder: (_, __) => const SizedBox(height: 18),
  //       itemBuilder: (_, index) {
  //         final visit = widget.tourPlan.visits[index];
  //         return Card(
  //           elevation: 3,
  //           color: Colors.grey[200],
  //           shadowColor: Colors.black.withOpacity(0.1),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Padding(
  //             padding:
  //             const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(visit.visitDate)),
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w600,
  //                     color: ColorPalette.pictonBlue500,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Divider(color: Colors.grey.shade300, thickness: 1),
  //                 const SizedBox(height: 7),
  //                 //_buildVisitRow('Visit Id', visit.id.toString()),
  //                 _buildVisitRow('Name', visit.name ?? '-'),
  //                 _buildVisitRow('Type', visit.type.replaceAll('_', ' ').capitalizeFirst!),
  //                 if (visit.type != 'new_lead' && visit.type != 'followup_lead') ...[
  //                   _buildVisitRow('Purpose of Visit', visit.visitPurpose ?? '-'),
  //                 ],
  //                 if (visit.type == 'new_lead' || visit.type == 'followup_lead') ...[
  //                   _buildVisitRow('Lead Type', visit.lead?.type ?? '-'),
  //                   _buildVisitRow('Lead Source', visit.lead?.leadSource ?? '-'),
  //                   _buildVisitRow('State', visit.lead?.state ?? '-'),
  //                 ],
  //                 const SizedBox(height: 12),
  //                 Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       // Container(
  //                       //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //                       //   decoration: BoxDecoration(
  //                       //     color: visit.isApproved == 1
  //                       //         ? Colors.green.shade600
  //                       //         : visit.isApproved == 2
  //                       //         ? Colors.red.shade600
  //                       //         : Colors.orange.shade600,
  //                       //     borderRadius: BorderRadius.circular(30),
  //                       //   ),
  //                       //   child: Row(
  //                       //     mainAxisSize: MainAxisSize.min,
  //                       //     children: [
  //                       //       Icon(
  //                       //         visit.isApproved == 1
  //                       //             ? Icons.check_circle
  //                       //             : visit.isApproved == 2
  //                       //             ? Icons.cancel
  //                       //             : Icons.timer_outlined,
  //                       //         color: Colors.white,
  //                       //         size: 18,
  //                       //       ),
  //                       //       const SizedBox(width: 6),
  //                       //       Text(
  //                       //         visit.isApproved == 1
  //                       //             ? "Approved"
  //                       //             : visit.isApproved == 2
  //                       //             ? "Rejected"
  //                       //             : "Pending",
  //                       //         style: const TextStyle(
  //                       //           color: Colors.white,
  //                       //           fontSize: 13,
  //                       //           fontWeight: FontWeight.w600,
  //                       //         ),
  //                       //       ),
  //                       //     ],
  //                       //   ),
  //                       // ),
  //                       Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  //                         decoration: BoxDecoration(
  //                           color: visit.isApproved == 1
  //                               ? Colors.green.shade600
  //                               : visit.isApproved == 2
  //                               ? Colors.red.shade600
  //                               : visit.isApproved == 3
  //                               ? Colors.deepOrange
  //                               : Colors.orange.shade600,
  //                           borderRadius: BorderRadius.circular(30),
  //                         ),
  //                         child: Row(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Icon(
  //                               visit.isApproved == 1
  //                                   ? Icons.check_circle
  //                                   : visit.isApproved == 2
  //                                   ? Icons.cancel
  //                                   : visit.isApproved == 3
  //                                   ? Icons.block
  //                                   : Icons.timer_outlined,
  //                               color: Colors.white,
  //                               size: 18,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Text(
  //                               visit.isApproved == 1
  //                                   ? "Approved"
  //                                   : visit.isApproved == 2
  //                                   ? "Rejected"
  //                                   : visit.isApproved == 3
  //                                   ? "Cancelled"
  //                                   : "Pending",
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 13,
  //                                 fontWeight: FontWeight.w600,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       /// 🔴 Show reject reason if rejected
  //                       // if (visit.isApproved == 2 && visit.Reject_reason != null)
  //                       //   Padding(
  //                       //     padding: const EdgeInsets.only(top: 6, left: 4),
  //                       //     child: Text(
  //                       //       "Reason: ${visit.Reject_reason}",
  //                       //       style: const TextStyle(
  //                       //         color: Colors.red,
  //                       //         fontSize: 13,
  //                       //         fontWeight: FontWeight.w500,
  //                       //       ),
  //                       //     ),
  //                       //   ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _visitList(double screenWidth) {
    // --------------------------------------------
    // Step 1: calculate all days between start → end
    // --------------------------------------------
    DateTime start = DateTime.parse(widget.tourPlan.startDate);
    DateTime end = DateTime.parse(widget.tourPlan.endDate);

    List<DateTime> allDates = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      allDates.add(start.add(Duration(days: i)));
    }

    // --------------------------------------------
    // Step 2: Extract visit days from API data
    // --------------------------------------------
    List<DateTime> visitDates =
        widget.tourPlan.visits.map((v) => DateTime.parse(v.visitDate)).toList();

    // --------------------------------------------
    // Step 3: Find dates where NO visit is present
    // --------------------------------------------
    List<DateTime> noVisitDates =
        allDates
            .where(
              (date) =>
                  !visitDates.any(
                    (vd) =>
                        vd.year == date.year &&
                        vd.month == date.month &&
                        vd.day == date.day,
                  ),
            )
            .toList();

    return SizedBox(
      width: Responsive.isMd(context) ? screenWidth - 20 : screenWidth / 3 - 20,
      child: Column(
        children: [
          // --------------------------------------------
          // Existing Visit Cards (NO CHANGES)
          // --------------------------------------------
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.tourPlan.visits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (_, index) {
              final visit = widget.tourPlan.visits[index];
              return _visitCard(visit);
            },
          ),

          const SizedBox(height: 20),

          // --------------------------------------------
          // NEW FEATURE ➝ Dates WITH NO VISITS
          // --------------------------------------------
          if (noVisitDates.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  noVisitDates.map((date) {
                    return Card(
                      elevation: 3,
                      color: Colors.grey[200],
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, dd MMM yyyy').format(date),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.red.shade600,
                              ),
                            ),
                            const Divider(),
                            const Text(
                              "There are no visits on this date.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  ///VisitCard list ui
  Widget _visitCard(Visit visit) {
    return Card(
      elevation: 3,
      color: Colors.grey[200],
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat(
                'EEEE, dd MMM yyyy',
              ).format(DateTime.parse(visit.visitDate)),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorPalette.pictonBlue500,
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 7),

            _buildVisitRow('Name', visit.name ?? '-'),
            _buildVisitRow(
              'Type',
              visit.type.replaceAll('_', ' ').capitalizeFirst!,
            ),
            if (visit.type != 'new_lead' && visit.type != 'followup_lead')
              _buildVisitRow('Purpose of Visit', visit.visitPurpose ?? 'Nil'),

            if (visit.type == 'new_lead' || visit.type == 'followup_lead') ...[
              _buildVisitRow('Lead Type', visit.lead?.type ?? '-'),
              _buildVisitRow('Lead Source', visit.lead?.leadSource ?? '-'),
              _buildVisitRow('State', visit.lead?.state ?? '-'),
            ],

            const SizedBox(height: 12),

            // Approval Status Chip (your existing UI)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    visit.isApproved == 1
                        ? Colors.green.shade600
                        : visit.isApproved == 2
                        ? Colors.red.shade600
                        : visit.isApproved == 3
                        ? Colors.deepOrange
                        : Colors.orange.shade600,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    visit.isApproved == 1
                        ? Icons.check_circle
                        : visit.isApproved == 2
                        ? Icons.cancel
                        : visit.isApproved == 3
                        ? Icons.block
                        : Icons.timer_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    visit.isApproved == 1
                        ? "Approved"
                        : visit.isApproved == 2
                        ? "Rejected"
                        : visit.isApproved == 3
                        ? "Cancelled"
                        : "Pending",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // 🔴 Show reject reason if rejected
            if (visit.isApproved == 2 && visit.Reject_reason != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  "Reject Reason: ${visit.Reject_reason}",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
