import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrachi/views/screens/checkins/ExpensePage/expense_list.dart';
import '../../../../api/SendforApprovalController.dart';
import '../../ExpenseReportPage/ExpenseReport.dart';

class SendForApproval_Screen extends StatefulWidget {
  final int tourPlanId;
  //final String id;
  final DateTime? startdate;
  final String? ExpenseFullyApproved;

  const SendForApproval_Screen({
    super.key,
    required this.tourPlanId,
    this.startdate,
    this.ExpenseFullyApproved,
  });

  @override
  State<SendForApproval_Screen> createState() => _SendForApproval_ScreenState();
}

class _SendForApproval_ScreenState extends State<SendForApproval_Screen> {
  final SendForApprovalController controller = Get.put(
    SendForApprovalController(),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchTourPlan(id: widget.tourPlanId);
    print("SendForApproval Screen Start Date : ${widget.startdate}");
  }
  Future<void> _refreshData() async {
    await controller.fetchTourPlan(id: widget.tourPlanId);
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
                      child: Text(
                        "All Expenses Report :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ExpenseReportScreen(
                                  tourId: widget.tourPlanId.toString(),
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        "Expense Report",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
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
                      final missingOutcome =
                          visit.checkin == null || visit.checkin!.outcome == null;
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
                          side: BorderSide(color: borderColor, width: 2),
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
                              Text(
                                "Type: ${visit.type}",
                                style: const TextStyle(color: Colors.black),
                              ),
                              Text(
                                "CheckIn: ${visit.isCheckin} | CheckedOut: ${visit.hasCheckin}",
                                style: const TextStyle(color: Colors.black),
                              ),

                              const SizedBox(height: 4),

                              // ✅ Outcome section
                              if (!missingOutcome)
                                const Text(
                                  "Outcome Added",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              else
                                const Text(
                                  "No Outcome",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                              // ✅ Expense section
                              if (!missingExpense)
                                Text(
                                  "Expense Added (${visit.expenses.length})",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              else
                                const Text(
                                  "No Expense",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                              // ✅ Edit button (only if error)
                              if (hasError)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Get.to(
                                            ()=> ExpenseList(
                                          visitId: visit.id,
                                          tourPlanId: widget.tourPlanId,
                                          startDate: widget.startdate,
                                        ),
                                      );
                                      print("Add Button SendForApproval Screen Start Date : ${widget.startdate}",);
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.red),
                                    ),
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
                            color:
                                visit.hasCheckin
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
                final String? expenseStatus =
                    widget.ExpenseFullyApproved; // 'confirmed', 'partial', etc.
                final serial = controller.tourPlan.value?.serialNo ?? "";

                // logic: Agar pending hai YA partial approve hai, to API hit hogi
                bool canSend = isPending || expenseStatus == "partial";

                if (!canSend) {
                  /// ✅ CASE: Expense Fully Approved
                  if (expenseStatus == "confirmed") {
                    Get.snackbar(
                      "All Expense",
                      "Expense fully approved for this TOUR ID: $serial",
                      // Green se change karke professional 'Dark Teal/Navy' color diya hai
                      backgroundColor: const Color(0xFF102A43),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.TOP,
                      margin: const EdgeInsets.all(15),
                      icon: const Icon(Icons.verified, color: Colors.white),
                    );
                    return;
                  }

                  /// ✅ CASE: Already Submitted (But not partial)
                  Get.snackbar(
                    "Already Submitted",
                    "Submitted all of your Expenses of $serial",
                    backgroundColor: Colors.blueGrey,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }
                /// ✅ PENDING ya PARTIAL APPROVED → API HIT
                controller.sendForApproval(widget.tourPlanId);
              },
              style: ElevatedButton.styleFrom(
                // Agar pending ya partial hai to bright blue, nahi to light blue
                backgroundColor:
                    (isPending || widget.ExpenseFullyApproved == "partial")
                        ? Colors.blue
                        : Colors.blue.shade200,
                minimumSize: const Size(double.infinity, 50),
                elevation:
                    (isPending || widget.ExpenseFullyApproved == "partial")
                        ? 3
                        : 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                (isPending || widget.ExpenseFullyApproved == "partial")
                    ? Icons.send
                    : (widget.ExpenseFullyApproved == "confirmed"
                        ? Icons.verified
                        : Icons.check_circle),
                //: Icons.check_circle,
                color: Colors.white,
              ),
              label: Text(
                (isPending || widget.ExpenseFullyApproved == "partial")
                    ? "Send For Approval"
                    : (widget.ExpenseFullyApproved == "confirmed"
                        ? "Expense Fully Approved"
                        : "Submitted"),
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
    );
  }
}
