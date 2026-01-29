import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../api/ExpenseController/ExpenseReport.dart';
// ================= 3. VIEW (UI Updated) =================

class ExpenseReportScreen extends StatefulWidget {
  final String tourId;
  const ExpenseReportScreen({super.key, required this.tourId,});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  late ExpenseReportController controller;

  @override
  void initState() {
    super.initState();

    // ******** IMPORTANT FIX ********
    controller = Get.put(
      ExpenseReportController(tourId: widget.tourId),
      tag: widget.tourId,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchData();
    });
  }
  @override
  Widget build(BuildContext context) {
  // Styles
    TextStyle headerStyle() => GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    TextStyle cellStyle() => GoogleFonts.roboto(
      fontSize: 13,
    );

    TextStyle boldCell() => GoogleFonts.roboto(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
    // Helper Widgets
    Widget excelCell(String text, {bool isHeader = false, Alignment alignment = Alignment.centerLeft}) {
      return Container(
        padding: const EdgeInsets.all(8),
        alignment: alignment,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: isHeader ? Colors.grey.shade300 : Colors.white,
        ),
        child: Text(
          text,
          style: isHeader ? boldCell() : cellStyle(),
          textAlign: TextAlign.left,
        ),
      );
    }

    Widget excelRow(List<String> data, {bool header = false, List<int>? flexes}) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < data.length; i++)
              Expanded(
                flex: flexes?[i] ?? 2,
                child: excelCell(
                  data[i],
                  isHeader: header,
                ),
              )
          ],
        ),
      );
    }

    Widget sectionTitle(String text) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        color: Colors.grey.shade400,
        child: Center(
          child: Text(text, style: headerStyle()),
        ),
      );
    }

    Widget infoRow(String k1, String v1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(k1, style: boldCell())),
            // Yahan controller.getVal use kiya taaki empty pe '-' aaye
            Expanded(child: Text(controller.getVal(v1), style: cellStyle())),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tour Plan Expenses"),
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        actions: [
          // === PDF BUTTON ===
          IconButton(
            onPressed: () {
              // PDF Download Call
              controller.downloadPdf();
            },
            icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
            tooltip: "Download PDF",
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        if (controller.tourPlan.value == null) {
          return const Center(child: Text("No data found"));
        }

        final plan = controller.tourPlan.value!;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            sectionTitle("Tour Plan Expenses"),
            const SizedBox(height: 10),

            // ---------- TOP INFO ----------
            infoRow("Name: ", plan.user.name),
            infoRow("Employee Id: ", plan.user.employeeCode),
            infoRow("Designation: ", plan.user.designation),
            infoRow("Start Date: ", controller.formatDate(plan.startDate)),
            infoRow("End Date: ", controller.formatDate(plan.endDate)),
            //infoRow("Submission Date: ", controller.formatDate(plan.createdAt)),
            infoRow("Tour No.: ", plan.serialNo),
            infoRow("Expense Status: ", plan.tourStatus),
            infoRow("Approval Status: ", plan.status),

            const SizedBox(height: 10),
            infoRow("Total Expense: ", controller.totalExpense.value.toStringAsFixed(2)),
            infoRow("Hotel Amount: ", "0"),
            infoRow("Total DA: ", controller.totalDA.value.toStringAsFixed(2)),
            infoRow("Total Conveyance: ", controller.totalConveyance.value.toStringAsFixed(2)),
            infoRow("Total Non-Conveyance: ", controller.totalNonConveyance.value.toStringAsFixed(2)),

            const SizedBox(height: 25),

            // ================= EXCEL: NON-CONVEYANCE TABLE =================
            sectionTitle("Non-Conveyance Details"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 950,
                child: Column(
                  children: [
                    excelRow(
                      [
                        "Date", "Tour Location", "Hotel Actual", "DA Type",
                        "DA Amt", "Others", "Total", "Remarks"
                      ],
                      header: true,
                      flexes: [2, 3, 2, 2, 2, 2, 2, 3],
                    ),

                    if (controller.nonConveyanceList.isEmpty)
                      excelRow(["No Records", "-", "-", "-", "-", "-", "-", "-"]),

                    ...controller.nonConveyanceList.map((e) => excelRow(
                      [
                        controller.formatDate(e.date),
                        controller.getVal(e.location),
                        "-", // Hotel fixed
                        controller.getVal(e.type),
                        e.type.toLowerCase().contains('da') ? e.amount.toString() : "0",
                        !e.type.toLowerCase().contains('da') ? e.amount.toString() : "0",
                        e.amount.toString(),
                        controller.getVal(e.remarks)
                      ],
                      flexes: [2, 3, 2, 2, 2, 2, 2, 3],
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= EXCEL: CONVEYANCE TABLE =================
            sectionTitle("Conveyance Details"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1050,
                child: Column(
                  children: [
                    excelRow(
                      [
                        "Date", "Departure Town", "Departure Time", "Arrival Town",
                        "Arrival Time", "Mode Of Travel", "Fare(Rs.)", "Comments"
                      ],
                      header: true,
                      flexes: [2, 2, 2, 2, 2, 2, 2, 3],
                    ),

                    if (controller.conveyanceList.isEmpty)
                      excelRow(["No Records", "-", "-", "-", "-", "-", "-", "-"]),

                    ...controller.conveyanceList.map((e) => excelRow(
                      [
                        controller.formatDate(e.date),
                        controller.getVal(e.departureTown),
                        controller.formatTime(e.departureTime),
                        controller.getVal(e.arrivalTown),
                        controller.formatTime(e.arrivalTime),
                        controller.getVal(e.modeOfTravel),
                        e.amount.toString(),
                        controller.getVal(e.remarks)
                      ],
                      flexes: [2, 2, 2, 2, 2, 2, 2, 3],
                    )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= EXCEL: VISIT TABLE =================
            sectionTitle("Visit Details"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1050,
                child: Column(
                  children: [
                    excelRow(
                      [
                        "Dealer/Lead", "Planned Date", "Visit Type", "Check In Date",
                        "Purpose Of Visit", "Outcome"
                      ],
                      header: true,
                      flexes: [3, 2, 2, 3, 3, 3],
                    ),

                    if (plan.visits.isEmpty)
                      excelRow(["No Visits", "-", "-", "-", "-", "-"]),

                    ...plan.visits.map((v) => excelRow(
                      [
                        controller.getVal(v.name),
                        controller.formatDate(v.visitDate),
                        controller.getVal(v.type),
                        v.checkins != null ? controller.formatTime(v.checkins!.checkInTime) : "Not Checked In",
                        controller.getVal(v.visitPurpose),
                        v.checkins?.outcome ?? "-"
                      ],
                      flexes: [3, 2, 2, 3, 3, 3],
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        );
      }),
    );
  }
}