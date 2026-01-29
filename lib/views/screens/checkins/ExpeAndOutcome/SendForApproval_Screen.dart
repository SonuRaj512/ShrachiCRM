// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../api/SendforApprovalController.dart';
//
// class SendForApproval_Screen extends StatefulWidget {
//   final int tourPlanId;
//
//   const SendForApproval_Screen({super.key, required this.tourPlanId});
//
//   @override
//   State<SendForApproval_Screen> createState() => _SendForApproval_ScreenState();
// }
//
// class _SendForApproval_ScreenState extends State<SendForApproval_Screen> {
//   final TourPlanController controller = Get.put(TourPlanController());
//
//   @override
//   void initState() {
//     super.initState();
//     controller.fetchTourPlan(id: widget.tourPlanId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: Obx(() {
//           final serial = controller.tourPlan.value?.serialNo ?? "Loading...";
//           return Text("Tour Plan - $serial",style: TextStyle(color: Colors.white),);
//         }),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final tourPlan = controller.tourPlan.value;
//         if (tourPlan == null) {
//           return const Center(child: Text("No Data Found"));
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: tourPlan.visits.length,
//           itemBuilder: (context, index) {
//             final visit = tourPlan.visits[index];
//
//             // Check if Outcome & Expense are missing
//             final missingOutcome = visit.checkin == null || visit.checkin!.outcome == null;
//             final missingExpense = visit.expenses.isEmpty;
//             final hasError = missingOutcome || missingExpense;
//
//             return Card(
//               color: Colors.white,
//               elevation: 3,
//               margin: const EdgeInsets.symmetric(vertical: 6),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 side: BorderSide(
//                   color: hasError ? Colors.redAccent : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               child: ListTile(
//                 title: Text(
//                   visit.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Type: ${visit.type}", style: const TextStyle(color: Colors.black)),
//                     //Text("Visit No: ${visit.visitSerialNo}", style: const TextStyle(color: Colors.black)),
//                     Text("CheckIn: ${visit.isCheckin} | CheckedOut: ${visit.hasCheckin}", style: const TextStyle(color: Colors.black)),
//
//                     const SizedBox(height: 4),
//
//                     // ✅ Outcome section
//                     if (!missingOutcome)
//                       const Text("Outcome Added", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600))
//                     else
//                       const Text("No Outcome", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
//
//                     // ✅ Expense section
//                     if (!missingExpense)
//                       Text(
//                         "Expense Added (${visit.expenses.length})",
//                         style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//                       )
//                     else
//                       const Text("No Expense", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
//
//                     // ✅ Edit button (only if error)
//                     if (hasError)
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: TextButton.icon(
//                           onPressed: () {
//                             // Navigate to Outcome/Expense page
//                             controller.navigateToEditPage(
//                               visitId: visit.id,
//                               tourPlanId: widget.tourPlanId,
//                             );
//                           },
//                           icon: const Icon(Icons.edit, color: Colors.red),
//                           label: const Text("Add", style: TextStyle(color: Colors.red)),
//                         ),
//                       ),
//                   ],
//                 ),
//                 trailing: Icon(
//                   visit.hasCheckin
//                       ? Icons.check_circle
//                       : visit.isCheckin
//                       ? Icons.timelapse
//                       : Icons.location_on,
//                   color: visit.hasCheckin
//                       ? Colors.green
//                       : visit.isCheckin
//                       ? Colors.orange
//                       : Colors.blue,
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: ElevatedButton.icon(
//             onPressed: () => controller.sendForApproval(widget.tourPlanId),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               minimumSize: const Size(double.infinity, 50),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             icon: const Icon(Icons.send, color: Colors.white),
//             label: const Text(
//               "Send for Approval",
//               style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/SendforApprovalController.dart';
import '../../ExpenseReportPage/ExpenseReport.dart';

class SendForApproval_Screen extends StatefulWidget {
  final int tourPlanId;
  //final String id;
  final DateTime? startdate;
  final String? ExpenseFullyApproved;

  const SendForApproval_Screen({super.key, required this.tourPlanId, this.startdate, this.ExpenseFullyApproved,});

  @override
  State<SendForApproval_Screen> createState() => _SendForApproval_ScreenState();
}

class _SendForApproval_ScreenState extends State<SendForApproval_Screen> {
  final SendForApprovalController  controller = Get.put(SendForApprovalController ());

  @override
  void initState() {
    super.initState();
    controller.fetchTourPlan(id: widget.tourPlanId);
    print("SendForApproval Screen Start Date : ${widget.startdate}");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              final serial = controller.tourPlan.value?.serialNo ?? "Loading...";
              return Text(
                "TOUR ID - $serial",
                style: const TextStyle(color: Colors.white),
              );
            }),
            // ElevatedButton(
            //     onPressed: (){
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ExpenseReportScreen(tourId : widget.tourPlanId.toString())),
            //       );
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         //Icon(Icons.report),
            //         SizedBox(width: 10,),
            //         Text("Expense Report")
            //       ],
            //     )
            // ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: Text("All Expenses Report :",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpenseReportScreen(tourId: widget.tourPlanId.toString()),
                          ),
                        );
                      },
                      child: const Text("Expense Report",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: size.width,
              //height: size.height,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tourPlan = controller.tourPlan.value;
                if (tourPlan == null) {
                  return const Center(child: Text("No Data Found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tourPlan.visits.length,
                  itemBuilder: (context, index) {
                    final visit = tourPlan.visits[index];

                    // ✅ Conditions
                    final missingOutcome = visit.checkin == null || visit.checkin!.outcome == null;
                    final missingExpense = visit.expenses.isEmpty;
                    final hasError = missingOutcome || missingExpense;

                    // ✅ Determine card border color only after SendForApproval is pressed
                    Color borderColor = Colors.transparent;
                    if (controller.showApprovalColors.value) {
                      if (hasError) {
                        borderColor = Colors.redAccent;
                      } else {
                        borderColor = Colors.green;
                      }
                    }

                    return Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: borderColor,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          visit.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Type: ${visit.type}", style: const TextStyle(color: Colors.black)),
                            Text("CheckIn: ${visit.isCheckin} | CheckedOut: ${visit.hasCheckin}",
                                style: const TextStyle(color: Colors.black)),

                            const SizedBox(height: 4),

                            // ✅ Outcome section
                            if (!missingOutcome)
                              const Text("Outcome Added",
                                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600))
                            else
                              const Text("No Outcome",
                                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),

                            // ✅ Expense section
                            if (!missingExpense)
                              Text(
                                "Expense Added (${visit.expenses.length})",
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                              )
                            else
                              const Text("No Expense",
                                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),

                            // ✅ Edit button (only if error)
                            if (hasError)
                              Align(

                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    controller.navigateToEditPage(
                                      visitId: visit.id,
                                      tourPlanId: widget.tourPlanId,
                                      startDate: widget.startdate,
                                    );
                                  },
                                  icon: const Icon(Icons.edit, color: Colors.red),
                                  label: const Text("Add", style: TextStyle(color: Colors.red)),
                                ),
                              ),
                          ],
                        ),
                        trailing: Icon(
                          visit.hasCheckin
                              ? Icons.check_circle
                              : visit.isCheckin
                              ? Icons.timelapse
                              : Icons.location_on,
                          color: visit.hasCheckin
                              ? Colors.green
                              : visit.isCheckin
                              ? Colors.orange
                              : Colors.blue,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
        bottomNavigationBar: Obx(() {
          final tour = controller.tourPlan.value;
          if (tour == null) return const SizedBox();
          final serial = controller.tourPlan.value?.serialNo ?? "Loading...";
          final bool isPending = controller.hasPendingExpense.value;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  final String? expenseStatus = widget.ExpenseFullyApproved;
                  final serial = controller.tourPlan.value?.serialNo ?? "";

                  /// 🚫 NO PENDING EXPENSE
                  if (!isPending) {

                    /// ✅ CASE: Expense Fully Approved
                    if (expenseStatus == "confirmed") {
                      Get.snackbar(
                        "All Expense",
                        "Expense fully approved for this TOUR ID : $serial",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    /// ✅ CASE: Null OR Any Other Status
                    Get.snackbar(
                      "Already Submitted",
                      "Submitted all of your Expenses of $serial",
                      backgroundColor: Colors.blueGrey,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  }

                  ///PENDING → API HIT
                  controller.sendForApproval(widget.tourPlanId);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isPending ? Colors.blue : Colors.blue.shade200,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: isPending ? 3 : 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  isPending ? Icons.send : Icons.check_circle,
                  color: Colors.white,
                ),
                label: Text(
                  isPending ? "Send For Approval" : "Submitted",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      // bottomNavigationBar: Obx(() {
      //   bool isSent = controller.isAlreadySent.value;
      //   final tour = controller.tourPlan.value;
      //   if (tour == null) return const SizedBox();
      //
      //   final SendForAllExpense = tour.has_pending_expense.;
      //
      //   final isConfirmed = SendForAllExpense == "confirmed";
      //   final isPartiallyApproved = SendForAllExpense == "partially approved";
      //   return SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.all(12.0),
      //       child: ElevatedButton.icon(
      //         onPressed: () {
      //           if (isConfirmed) {
      //             Get.snackbar(
      //               "Already Sent",
      //               "This tour plan is already sent for approval.",
      //               backgroundColor: Colors.orange,
      //               colorText: Colors.white,
      //               snackPosition: SnackPosition.TOP,
      //             );
      //           } else {
      //             controller.sendForApproval(widget.tourPlanId);
      //           }
      //         },
      //         // 🔥 Color Change (lighter when already sent)
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: isSent ? Colors.blue.shade200 : Colors.blue,
      //           minimumSize: const Size(double.infinity, 50),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //         ),
      //
      //         icon: const Icon(Icons.send, color: Colors.white),
      //         label: Text(
      //           isSent ? "Already Sent" : "Send for Approval",
      //           style: TextStyle(
      //             fontSize: 16,
      //             color: Colors.white,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
      // }),
    );
  }
}
