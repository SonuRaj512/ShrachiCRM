// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/views/components/tour_plan_widget.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:shrachi/views/screens/checkins/visit_list.dart';
// import 'package:get/get.dart';
// import '../../../api/SendforApprovalController.dart';
// import 'ExpeAndOutcome/SendForApproval_Screen.dart';
//
// class CheckinsSearch extends StatefulWidget {
//   const CheckinsSearch({super.key});
//
//   @override
//   State<CheckinsSearch> createState() => _CheckinsSearchState();
// }
//
// class _CheckinsSearchState extends State<CheckinsSearch> {
//   final _searchController = TextEditingController();
//   final ApiController controller = Get.put(ApiController());
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.fetchTourPlans();
//     });
//   }
//
//   // ✅ Fixed version — includes startDate and endDate (inclusive)
//   bool _shouldShowButton(String startDate, String endDate) {
//     final now = DateTime.now();
//     final start = DateTime.parse(startDate);
//     final end = DateTime.parse(endDate);
//
//     return (now.isAtSameMomentAs(start) || now.isAfter(start)) &&
//         (now.isAtSameMomentAs(end) || now.isBefore(end));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Check In (New)'),
//           automaticallyImplyLeading: false,
//         ),
//         body: Container(
//           padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
//           child: Column(
//             children: [
//               // 🟢 Search bar
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: Responsive.isMd(context) ? 5 : 25,
//                 ),
//                 child: Align(
//                   alignment: Responsive.isMd(context)
//                       ? Alignment.centerLeft
//                       : Alignment.centerRight,
//                   child: SizedBox(
//                     width: Responsive.isMd(context)
//                         ? screenWidth
//                         : screenWidth / 4,
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: (value) {
//                         controller.filterSearchResults(value.trim());
//                       },
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Ionicons.search),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.black,
//                             width: 2,
//                           ),
//                         ),
//                         hintText: 'Search by Tour ID',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 15.0),
//
//               // 🟢 Tour List
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Obx(() {
//                     final tourPlan = controller.tourPlanList
//                         .where((plan) => plan.status.toString() == 'confirmed')
//                         .toList();
//
//                     if (controller.isLoading.value) {
//                       return SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.6,
//                         width: MediaQuery.of(context).size.width,
//                         child: const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.green,
//                           ),
//                         ),
//                       );
//                     }
//
//                     return Wrap(
//                       spacing: 20,
//                       runSpacing: 10,
//                       children: List.generate(tourPlan.length, (index) {
//                         final item = tourPlan[index];
//
//                         return SizedBox(
//                           width: Responsive.isMd(context)
//                               ? screenWidth - 40
//                               : Responsive.isXl(context)
//                               ? screenWidth / 2 - 40
//                               : screenWidth / 3 - 40,
//                           child: TourPlanWidget(
//                             title:
//                             '${item.serial_no} (${DateTime.parse(item.endDate).difference(DateTime.parse(item.startDate)).inDays} Days)',
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       VisitList(tourPlanId: item.id),
//                                 ),
//                               );
//                             },
//                             intervalBackgroundColor:
//                             ColorPalette.pictonBlue100,
//                             intervalIcon: Ionicons.time_outline,
//                             intervalIconColor: ColorPalette.pictonBlue500,
//                             intervalText:
//                             '${DateFormat('dd MMM, yyyy').format(DateTime.parse(item.startDate))} - '
//                                 '${DateFormat('dd MMM, yyyy').format(DateTime.parse(item.endDate))}',
//                             intervalTextColor: ColorPalette.pictonBlue500,
//                              trailing: IconButton(
//                                icon: const Icon(
//                                  Ionicons.paper_plane_outline,
//                                  color: Colors.red,
//                                ),
//                                onPressed: () {
//                                  Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                      builder: (_) => SendForApproval_Screen(
//                                        tourPlanId: item.id,
//                                      ),
//                                    ),
//                                  );
//                                },
//                              )
//                             // 🟢 Show send icon if valid date range
//                             // trailing:
//                             // _shouldShowButton(
//                             //     item.startDate, item.endDate,
//                             // )
//                             //     ? IconButton(
//                             //   icon: const Icon(
//                             //     Ionicons.paper_plane_outline,
//                             //     color: Colors.red,
//                             //   ),
//                             //   onPressed: () {
//                             //     Navigator.push(
//                             //       context,
//                             //       MaterialPageRoute(
//                             //         builder: (_) => TourPlanScreen(
//                             //           tourPlanId: item.id,
//                             //         ),
//                             //       ),
//                             //     );
//                             //   },
//                             // )
//                             //     : null,
//                           ),
//                         );
//                       }),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/views/components/tour_plan_widget.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/checkins/visit_list.dart';
import 'package:get/get.dart';
import 'ExpeAndOutcome/SendForApproval_Screen.dart';

class CheckinsSearch extends StatefulWidget {
  const CheckinsSearch({super.key});

  @override
  State<CheckinsSearch> createState() => _CheckinsSearchState();
}

class _CheckinsSearchState extends State<CheckinsSearch> {
  final _searchController = TextEditingController();
  final ApiController controller = Get.put(ApiController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTourPlans();
    });
  }
  Future<void> _handleRefresh() async {
     await controller.fetchTourPlans();
    //await Future.delayed(const Duration(seconds: 1));

  }
  /// ✅ FINAL SEND FOR APPROVAL VALIDATION
  bool _allVisitsCheckedOut(dynamic tourItem) {
    if (tourItem.visits == null || tourItem.visits.isEmpty) {
      return false;
    }

    /// 🔥 STEP 1: Count ONLY Approved visits
    final approvedVisits = tourItem.visits.where((visit) {
      return visit.isApproved == 1; // ✅ Approved only
    }).toList();

    /// 🔥 STEP 2: Agar ek bhi approved visit nahi → button nahi
    if (approvedVisits.isEmpty) return false;

    /// 🔥 STEP 3: Sab approved visits checked-out hone chahiye
    return approvedVisits.every((visit) => visit.hasCheckin == true);
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Alert",style: TextStyle(color: Colors.red),),
        content: Text(msg),
        actions: [
          TextButton(
            child: Text("OK",style: TextStyle(color: Colors.black),),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
  Color _expenseStatusColor(String? status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "partial":
        return Colors.orange;
      case "pending":
        return Colors.blue;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          ///title: const Text('Check In (New)'),
          title: Center(child: Text('Approved Tour Summary',style: TextStyle(color: Colors.white),)),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMd(context) ? 5 : 25,
                ),
                child: Align(
                  alignment: Responsive.isMd(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: SizedBox(
                    width: Responsive.isMd(context)
                        ? screenWidth
                        : screenWidth / 4,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        controller.filterSearchResults(value.trim());
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Ionicons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        hintText: 'Search by Tour ID',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              // 🟢 Tour List
              Expanded(
                child: RefreshIndicator.noSpinner(
                  onRefresh: _handleRefresh,
                  // color: Colors.blue, // Spinner ka color
                  // backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      /// ✅ TOUR FILTER (CONFIRMED + PARTIAL APPROVED)
                      final tourPlan = controller.tourPlanList.where((plan) {
                        return plan.status == 'confirmed' ||
                            plan.status == 'partially approved';
                      }).toList();
                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        );
                      }
                      final today = DateTime.now();
                      return Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(tourPlan.length, (index) {
                          final item = tourPlan[index];
                          final start = DateTime.parse(item.startDate);
                          final end = DateTime.parse(item.endDate);
                          final totalDays = end.difference(start).inDays + 1;
                          final dayText = totalDays == 1 ? "Day" : "Days";

                          bool isPast = end.isBefore(today);
                          bool isCurrent = today.isAfter(start) && today.isBefore(end);
                          bool isFuture = start.isAfter(today);
                          // Decide onTap behavior
                          VoidCallback onTapFunction;
                          if (isCurrent || isPast) {
                            onTapFunction = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VisitList(tourPlanId: item.id),
                                ),
                              );
                            };
                          }
                          // else if (isPast) {
                          //   onTapFunction = () {
                          //     _showAlert(context,
                          //         "This tour has already ended. You cannot open it.");
                          //   };
                          // }
                          else {
                            onTapFunction = () {
                              _showAlert(
                                  context,
                                  "This tour has not started yet. Please wait until the start date.");
                            };
                          }
                          return Opacity(
                            opacity: isCurrent
                                ? 1.0
                                : (isPast ? 1.0 : 0.5), // 🔥 PAST = 1.0 (visible), FUTURE = 0.5
                            child: Card(
                              elevation: 4,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 🔵 Tour Plan Details

                                  TourPlanWidget(
                                   title: '${item.serial_no} ($totalDays $dayText)',
                                    onTap: onTapFunction,
                                    intervalBackgroundColor: ColorPalette.pictonBlue100,
                                    intervalIcon: Ionicons.time_outline,
                                    intervalIconColor: ColorPalette.pictonBlue500,
                                    intervalText:
                                    '${DateFormat('dd MMM, yyyy').format(start)} - ${DateFormat('dd MMM, yyyy').format(end)}',
                                    intervalTextColor: ColorPalette.pictonBlue500,
                                    tour_status: item.toure_status,
                                    // 👇 Expense Status
                                    expenseStatusLabel: item.expenseOverallStatus?.label,
                                    expenseStatusKey: item.expenseOverallStatus?.status,
                                    //Expense_status: item.expenseOverallStatus?.label,
                                  ),

                                  /// 🟢 Send For Approval (only current)
                                  if (_allVisitsCheckedOut(item))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          // icon: const Icon(
                                          //   Ionicons.paper_plane_outline,
                                          //   size: 18,
                                          //   color: Colors.white,
                                          // ),
                                          label: const Text(
                                            "View Expense Details",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    SendForApproval_Screen(
                                                      tourPlanId: item.id,
                                                      startdate: start,
                                                      ExpenseFullyApproved: item.expenseOverallStatus?.status,
                                                    )
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
              ///
              // Expanded(
              //   child: SingleChildScrollView(
              //     child: Obx(() {
              //       final tourPlan = controller.tourPlanList
              //           .where((plan) => plan.status.toString() == 'confirmed')
              //           .toList();
              //
              //       if (controller.isLoading.value) {
              //         return SizedBox(
              //           height: MediaQuery.of(context).size.height * 0.6,
              //           width: MediaQuery.of(context).size.width,
              //           child: const Center(
              //             child: CircularProgressIndicator(
              //               color: Colors.green,
              //             ),
              //           ),
              //         );
              //       }
              //       return Wrap(
              //         spacing: 20,
              //         runSpacing: 10,
              //         children: List.generate(tourPlan.length, (index) {
              //           final item = tourPlan[index];
              //           return Card(
              //             elevation: 4,
              //             shadowColor: Colors.white,
              //             color: Colors.white,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12),
              //             ),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 /// 🔵 TourPlan Details
              //                 TourPlanWidget(
              //                   title: '${item.serial_no} (${DateTime.parse(item.endDate).difference(DateTime.parse(item.startDate)).inDays} Days)',
              //                   onTap: () {
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => VisitList(tourPlanId: item.id),
              //                       ),
              //                     );
              //                   },
              //                   intervalBackgroundColor: ColorPalette.pictonBlue100,
              //                   intervalIcon: Ionicons.time_outline,
              //                   intervalIconColor: ColorPalette.pictonBlue500,
              //                   intervalText:
              //                   '${DateFormat('dd MMM, yyyy').format(DateTime.parse(item.startDate))} - '
              //                       '${DateFormat('dd MMM, yyyy').format(DateTime.parse(item.endDate))}',
              //                   intervalTextColor: ColorPalette.pictonBlue500,
              //                   tour_status: item.toure_status,
              //                 ),
              //                 // const SizedBox(height: 12),
              //                   /// 🟢 Send For Approval Button (Conditional)
              //                  if (_allVisitsCheckedOut(item))
              //                   Padding(
              //                     padding: const EdgeInsets.only(left: 2.0,right: 2),
              //                     child: SizedBox(
              //                       width: double.infinity,
              //                       child: ElevatedButton.icon(
              //                         icon: const Icon(
              //                           Ionicons.paper_plane_outline,
              //                           size: 18,
              //                           color: Colors.white,
              //                         ),
              //                         label: const Text(
              //                           "Send For Approval",
              //                           style: TextStyle(fontSize: 12, color: Colors.white),
              //                         ),
              //                         onPressed: () {
              //                           Navigator.push(
              //                             context,
              //                             MaterialPageRoute(
              //                               builder: (_) => SendForApproval_Screen(
              //                                 tourPlanId: item.id,
              //                               ),
              //                             ),
              //                           );
              //                         },
              //                         style: ElevatedButton.styleFrom(
              //                           backgroundColor: Colors.green,
              //                           padding: const EdgeInsets.symmetric(vertical: 8),
              //                           shape: RoundedRectangleBorder(
              //                             borderRadius: BorderRadius.circular(8),
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //               ],
              //             ),
              //           );
              //         }),
              //       );
              //     }),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

