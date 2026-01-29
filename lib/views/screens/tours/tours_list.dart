// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:shrachi/views/screens/tours/create_plan.dart';
// import 'package:shrachi/views/screens/tours/show_tour.dart';
//
// class Tours extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final ApiController controller = Get.put(ApiController());
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tour Plans'),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: Responsive.isMd(context) ? 5 : 25,
//                   ),
//                   child: Align(
//                     alignment: Responsive.isMd(context)
//                         ? Alignment.centerLeft
//                         : Alignment.centerRight,
//                     child: SizedBox(
//                       width: Responsive.isMd(context)
//                           ? screenWidth
//                           : screenWidth / 4,
//                       child: TextField(
//                         controller: controller.searchController,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Ionicons.search),
//                           hintText: 'Search by ID, Status, Visit Name...',
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15.0),
//                 Expanded(
//                   child: Obx(() {
//                     if (controller.isLoading.value) {
//                       return Center(
//                         child: CircularProgressIndicator(
//                             color: ColorPalette.seaGreen600),
//                       );
//                     }
//                     if (controller.errorMessage.value.isNotEmpty) {
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Text(
//                             'Error: ${controller.errorMessage.value}',
//                             textAlign: TextAlign.center,
//                             style:
//                             TextStyle(color: Colors.red, fontSize: 16),
//                           ),
//                         ),
//                       );
//                     }
//                     if (controller.tourPlanList.isEmpty) {
//                       return Center(
//                         child: Text(
//                           'No tour plans found.',
//                           style: TextStyle(
//                               fontSize: 16, color: Colors.grey[700]),
//                         ),
//                       );
//                     }
//                     return SingleChildScrollView(
//                       padding: const EdgeInsets.only(bottom: 80),
//                       child: Wrap(
//                         spacing: 20,
//                         runSpacing: 20,
//                         alignment: WrapAlignment.start,
//                         children: controller.tourPlanList.map((tourPlan) {
//                           String title =
//                               'TP-${tourPlan.id.toString().padLeft(8, '0')} '
//                               '(${tourPlan.durationInDays} Days)';
//
//                           String statusText =
//                               tourPlan.status.capitalizeFirst ??
//                               tourPlan.status;
//
//                           Color statusColor = ColorPalette.pictonBlue500;
//                           IconData statusIcon =
//                               Ionicons.help_circle_outline;
//                           bool showStats = true;
//
//                           if (tourPlan.status.toLowerCase() == 'pending') {
//                             statusText = 'Pending';
//                             statusColor = Colors.black;
//                             statusIcon = Ionicons.time_outline;
//                           } else if (tourPlan.status.toLowerCase() ==
//                               'approved') {
//                             statusText = 'Approved';
//                             statusColor = ColorPalette.seaGreen600;
//                             statusIcon =
//                                 Ionicons.checkmark_circle_outline;
//                           } else if (tourPlan.status.toLowerCase() ==
//                               'rejected') {
//                             statusText = 'Rejected';
//                             statusColor = Colors.black;
//                             statusIcon = Ionicons.close_circle_outline;
//                           } else if (tourPlan.status.toLowerCase() ==
//                               'completed') {
//                             statusText = 'Completed';
//                             statusColor = Colors.green.shade700;
//                             statusIcon = Ionicons.flag_outline;
//                           }
//                           return SizedBox(
//                             width: Responsive.isMd(context)
//                                 ? screenWidth - 40
//                                 : Responsive.isXl(context)
//                                 ? (screenWidth / 2) - 30
//                                 : (screenWidth / 3) - (20 * 2 / 3) - 10,
//                             child: TourPlanWidget(
//                               title: title,
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ShowTour(tourPlan: tourPlan),
//                                   ),
//                                 );
//                               },
//                               intervalBackgroundColor: statusColor.withOpacity(0.1),
//                               intervalIcon: Ionicons.calendar_outline,
//                               intervalIconColor: statusColor,
//                               intervalText: controller.formatDateRange(
//                                   tourPlan.startDate, tourPlan.endDate),
//                               intervalTextColor: statusColor,
//                               showStats: showStats,
//                               statsBackgroundColor: statusColor.withOpacity(0.1),
//                               statsIcon: statusIcon,
//                               statsIconColor: statusColor,
//                               statsText: statusText,
//                               statsTextColor: statusColor,
//
//                               // 👇 Yaha naya field (type dikhane ke liye)
//                               extraText: tourPlan.visits.isNotEmpty
//                                   ? "Type: ${tourPlan.visits.first.type},"
//                                   : "Type: N/A",
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           // ✅ FAB fixed
//           Positioned(
//             bottom: 30,
//             right: 30,
//             child: FloatingActionButton(
//               backgroundColor: ColorPalette.seaGreen600,
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CreatePlan()),
//                 );
//               },
//               child: Icon(Ionicons.add_sharp, size: 30, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TourPlanWidget extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//   final Color intervalBackgroundColor;
//   final IconData intervalIcon;
//   final Color intervalIconColor;
//   final String intervalText;
//   final Color intervalTextColor;
//   final bool showStats;
//   final Color statsBackgroundColor;
//   final IconData statsIcon;
//   final Color statsIconColor;
//   final String statsText;
//   final Color statsTextColor;
//
//   // 👇 naya field
//   final String? extraText;
//
//   const TourPlanWidget({
//     Key? key,
//     required this.title,
//     required this.onTap,
//     required this.intervalBackgroundColor,
//     required this.intervalIcon,
//     required this.intervalIconColor,
//     required this.intervalText,
//     required this.intervalTextColor,
//     required this.showStats,
//     required this.statsBackgroundColor,
//     required this.statsIcon,
//     required this.statsIconColor,
//     required this.statsText,
//     required this.statsTextColor,
//     this.extraText,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Color(0xffe4f0fa),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//               SizedBox(height: 6),
//               Text(intervalText, style: TextStyle(color: intervalTextColor)),
//               SizedBox(height: 6),
//               if (extraText != null)
//                 Text(extraText!, style: TextStyle(color: Colors.black54)),
//               SizedBox(height: 6),
//               Row(
//                 children: [
//                   Icon(statsIcon, color: statsIconColor, size: 18),
//                   SizedBox(width: 6),
//                   Text(statsText, style: TextStyle(color: statsTextColor)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/tours/create_plan.dart';
import 'package:shrachi/views/screens/tours/show_tour.dart';

import '../multicolor_progressbar_screen.dart';

class Tours extends StatefulWidget {
  final String? targetTourId;
  const Tours({super.key, this.targetTourId});

  @override
  State<Tours> createState() => _ToursState();
}

class _ToursState extends State<Tours> {
  final ApiController controller = Get.put(ApiController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchTourPlans();

      //Notification ID
      if (widget.targetTourId != null) {
        String idToSearch = widget.targetTourId!.toString();
        controller.searchController.text = idToSearch;
        controller.filterSearchResults(idToSearch);
        controller.tourPlanList.refresh();
      }
    });
  }
  // 🔹 Popup function for locked tours
  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Ionicons.lock_closed, color: Colors.red),
            SizedBox(width: 10),
            Text("Access Denied"),
          ],
        ),
        content: Text(
          "This tour plan is locked and cannot be accessed because the expenses have been fully approved.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
          title: Center(child: Text('Tour Plan Summary',style: TextStyle(color: Colors.white),))
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            child: Column(
              children: [
                // 🔍 Search Box
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.isMd(context) ? 5 : 25,
                  ),
                  child: Align(
                    alignment:
                        Responsive.isMd(context)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: SizedBox(
                      width:
                          Responsive.isMd(context)
                              ? screenWidth
                              : screenWidth / 4,
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Ionicons.search),
                          hintText: 'Search By Tour ID...',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: (value) => controller.filterSearchResults(value),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                //Data Section
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: MultiColorCircularLoader(size: 40)
                        // CircularProgressIndicator(
                        //   color: ColorPalette.seaGreen600,
                        // ),
                      );
                    }
                    if (controller.tourPlanList.isEmpty) {
                      return Center(
                        child: Text(
                          'No tour plans found.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: ColorPalette.seaGreen600,
                      onRefresh: () async => controller.fetchTourPlans(),
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 4,
                          alignment: WrapAlignment.start,
                          children: controller.tourPlanList.map((tourPlan) {
                            // --- 1. Tour Status ---
                            String statusText = tourPlan.status.capitalizeFirst ?? tourPlan.status;
                            Color statusColor;
                            IconData statusIcon;
                            switch (tourPlan.status.toLowerCase()) {
                              case 'pending':
                                statusColor = Colors.red;
                                statusIcon = Ionicons.time_outline;
                                break;
                              case 'confirmed':
                                statusText = 'Approved';
                                statusColor = ColorPalette.seaGreen600;
                                statusIcon = Ionicons.checkmark_circle_outline;
                                break;
                              case 'partially approved':
                                statusColor = ColorPalette.oranged;
                                statusIcon = Ionicons.checkmark_circle_outline;
                                break;
                              case 'cancelled':
                                statusText = 'Rejected';
                                statusColor = Colors.red;
                                statusIcon = Ionicons.close_circle_outline;
                                break;
                              default:
                                statusColor = ColorPalette.pictonBlue500;
                                statusIcon = Ionicons.help_circle_outline;
                            }

                            // --- 2. NEW: Expense Status Logic (ONLY FOR APPROVED) ---
                            final expenseData = tourPlan.expenseOverallStatus;
                            bool isLocked = expenseData != null && expenseData.status.toLowerCase() == 'confirmed';
                            String? expText = isLocked ? "Expense: ${expenseData.label}" : null;
                            Color? expColor = isLocked ? Colors.green.shade800 : null;
                            IconData? expIcon = isLocked ? Ionicons.checkmark_done_circle : null;
                            // String? expText;
                            // Color? expColor;
                            // IconData? expIcon;

                            // Validation: Status null na ho AUR status specifically 'approved' ho
                            if (expenseData != null && expenseData.status.toLowerCase() == 'confirmed') {
                              expText = "Expense: ${expenseData.label}"; // e.g., "Expense: Fully Approved"
                              expColor = Colors.green.shade700;
                              expIcon = Ionicons.checkmark_done_circle;
                            }

                            return SizedBox(
                              width: Responsive.isMd(context)
                                  ? screenWidth - 40
                                  : (screenWidth / 3) - 20,
                              child: TourPlanWidget(
                                title: tourPlan.serial_no ?? 'N/A',
                                isLocked: isLocked,
                                onTap: () async {
                                  if (isLocked) {
                                    _showLockedDialog(context);
                                  } else {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ShowTour(
                                              tourPlan: tourPlan,
                                              status: tourPlan.status,
                                            ),
                                      ),
                                    );

                                    // 🔄 Refresh after returning from next screen
                                    if (result == true) {
                                      setState(() {
                                        // Re-fetch or refresh your data here
                                        controller.fetchTourPlans();
                                      });
                                    }
                                  }
                                },
                                statusColor: statusColor,
                                intervalIcon: Ionicons.calendar_outline,
                                intervalText: controller.formatDateRange(
                                  tourPlan.startDate,
                                  tourPlan.endDate,
                                ),
                                statsIcon: statusIcon,
                                statsText: statusText,

                                // --- 3. Pass Expense details to Widget ---
                                expenseText: expText,
                                expenseColor: expColor,
                                expenseIcon: expIcon,
                              ),
                            );
                          }).toList(),
                          // children: controller.tourPlanList.map((tourPlan) {
                          //       // Title
                          //       String title = tourPlan.serial_no.toString();
                          //       // 'TP-${tourPlan.serial_no.toString().padLeft(8, '0')} '
                          //       // '(${tourPlan.durationInDays} Days)';
                          //       // Status Logic
                          //       String statusText = tourPlan.status.capitalizeFirst ?? tourPlan.status;
                          //       Color statusColor;
                          //       IconData statusIcon;
                          //       switch (tourPlan.status.toLowerCase()) {
                          //         case 'pending':
                          //           statusText = 'Pending';
                          //           statusColor = Colors.red;
                          //           statusIcon = Ionicons.time_outline;
                          //           break;
                          //         case 'confirmed':
                          //           statusText = 'Approved';
                          //           statusColor = ColorPalette.seaGreen600;
                          //           statusIcon = Ionicons.checkmark_circle_outline;
                          //           break;
                          //         case 'partially approved':
                          //           statusText = 'Partially Approved';
                          //           statusColor = ColorPalette.oranged;
                          //           statusIcon = Ionicons.checkmark_circle_outline;
                          //           break;
                          //         case 'cancelled':
                          //           statusText = 'Rejected';
                          //           statusColor = Colors.red;
                          //           statusIcon = Ionicons.close_circle_outline;
                          //           break;
                          //         // case 'confirmed':
                          //         //   statusText = 'confirmed';
                          //         //   statusColor = Colors.green.shade700;
                          //         //   statusIcon = Ionicons.flag_outline;
                          //         //   break;aa
                          //         default:
                          //           statusText = 'Send for approval';
                          //           statusColor = ColorPalette.pictonBlue500;
                          //           statusIcon = Ionicons.help_circle_outline;
                          //       }
                          //
                          //       return SizedBox(
                          //         width:
                          //             Responsive.isMd(context)
                          //                 ? screenWidth - 40
                          //                 : Responsive.isXl(context)
                          //                 ? (screenWidth / 2) - 30
                          //                 : (screenWidth / 3) -
                          //                     (20 * 2 / 3) -
                          //                     10,
                          //         child: TourPlanWidget(
                          //           title: title,
                          //           onTap: () async {
                          //             final result = await Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => ShowTour(
                          //                   tourPlan: tourPlan,
                          //                   status: tourPlan.status,
                          //                 ),
                          //               ),
                          //             );
                          //
                          //             // 🔄 Refresh after returning from next screen
                          //             if (result == true) {
                          //               setState(() {
                          //                 // Re-fetch or refresh your data here
                          //                 controller.fetchTourPlans();
                          //               });
                          //             }
                          //           },
                          //           statusColor: statusColor, //yeh add kiya
                          //           intervalIcon: Ionicons.calendar_outline,
                          //           intervalText: controller.formatDateRange(
                          //             tourPlan.startDate,
                          //             tourPlan.endDate,
                          //           ),
                          //           statsIcon: statusIcon,
                          //           statsText: statusText,
                          //           // extraText: tourPlan.visits.isNotEmpty
                          //           //     ? "Type: ${tourPlan.visits.first.type}"
                          //           //     : "Type: N/A",
                          //         ),
                          //       );
                          // }).toList(),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          //FAB
          Positioned(
            bottom: 30,
            right: 30,
            child: FloatingActionButton(
              backgroundColor: ColorPalette.seaGreen600,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePlan()),
                );
              },
              child: Icon(Ionicons.add_sharp, size: 30, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class TourPlanWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color statusColor;
  final IconData intervalIcon;
  final String intervalText;
  final IconData statsIcon;
  final String statsText;
  final String? extraText;
  final String? expenseText;
  final Color? expenseColor;
  final IconData? expenseIcon;
  final bool isLocked;


  const TourPlanWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.statusColor,
    required this.intervalIcon,
    required this.intervalText,
    required this.statsIcon,
    required this.statsText,
    this.extraText,
    this.expenseText,
    this.expenseColor,
    this.expenseIcon,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardBgColor = isLocked ? const Color(0xFFD6D6D6) : const Color(0xffe4f0fa);
    return Card(
      color: cardBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: statusColor,
                    ),
                  ),
                  // Agar isLocked true hai to Red Lock Icon dikhega
                  if (isLocked)
                    const Icon(
                      Ionicons.lock_closed,
                      color: Colors.red,
                      size: 20,
                    ),
                ],
              ),
              // Text(
              //   title,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              //     color: statusColor,
              //   ),
              // ),
              SizedBox(height: 6),

              // 🔹 Interval Row
              Row(
                children: [
                  Icon(intervalIcon, size: 18, color: statusColor),
                  SizedBox(width: 6),
                  Text(intervalText, style: TextStyle(color: statusColor)),
                ],
              ),
              SizedBox(height: 6),

              // 🔹 Extra Text (Type)
              if (extraText != null)
                Text(
                  extraText!,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              SizedBox(height: 6),

              // 🔹 Status Row
              Row(
                children: [
                  Icon(statsIcon, color: statusColor, size: 18),
                  SizedBox(width: 6),
                  Text(
                    statsText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // 🔹 Expense Status Section
              if (expenseText != null) ...[
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(expenseIcon, size: 18, color: expenseColor),
                    SizedBox(width: 8),
                    Text(
                      expenseText!,
                      style: TextStyle(
                        color: expenseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
