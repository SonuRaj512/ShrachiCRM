// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import '../../models/ExpenseModel/ExpenseReport.dart';
//
// class ExpenseController extends GetxController {
//   // Observables (Reactive State)
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//   var tourPlan = Rxn<TourPlan>(); // Nullable TourPlan
//
//   // Lists
//   var nonConveyanceList = <Expense>[].obs;
//   var conveyanceList = <Expense>[].obs;
//
//   // Totals
//   var totalExpense = 0.0.obs;
//   var totalDA = 0.0.obs;
//   var totalConveyance = 0.0.obs;
//   var totalNonConveyance = 0.0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchData(); // Auto fetch on init
//   }
//
//   Future<void> fetchData() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final response = await http.get(
//         Uri.parse('https://btlsalescrm.cloud/api/expense-data/60'),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//
//         if (jsonList.isNotEmpty) {
//           tourPlan.value = TourPlan.fromJson(jsonList[0]);
//           processExpenses();
//         } else {
//           errorMessage.value = "No data found";
//         }
//       } else {
//         errorMessage.value = "Failed to load: ${response.statusCode}";
//       }
//     } catch (e) {
//       errorMessage.value = "Error: $e";
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void processExpenses() {
//     if (tourPlan.value == null) return;
//
//     // Clear previous data
//     nonConveyanceList.clear();
//     conveyanceList.clear();
//     totalExpense.value = 0.0;
//     totalDA.value = 0.0;
//     totalConveyance.value = 0.0;
//     totalNonConveyance.value = 0.0;
//
//     // Logic from your code
//     for (var visit in tourPlan.value!.visits) {
//       for (var exp in visit.expenses) {
//         totalExpense.value += exp.amount;
//
//         if (exp.expenseType == 'non_conveyance') {
//           nonConveyanceList.add(exp);
//           totalNonConveyance.value += exp.amount;
//           if (exp.type.toLowerCase().contains('da')) {
//             totalDA.value += exp.amount;
//           }
//         } else if (exp.expenseType == 'conveyance' || exp.expenseType == 'local_conveyance') {
//           conveyanceList.add(exp);
//           totalConveyance.value += exp.amount;
//         }
//       }
//     }
//   }
//
//   // Helper Methods moved to Controller
//   String formatDate(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return "-";
//     try {
//       DateTime dt = DateTime.parse(dateStr);
//       return DateFormat('dd-MM-yyyy').format(dt);
//     } catch (e) {
//       return dateStr;
//     }
//   }
//
//
//   String formatTime(String? dateStr) {
//     if (dateStr == null || dateStr.isEmpty) return "-";
//     try {
//       DateTime dt = DateTime.parse(dateStr);
//       return DateFormat('HH:mm').format(dt);
//     } catch (e) {
//       return dateStr;
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// PDF IMPORTS
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/ExpenseModel/ExpenseReport.dart';
import '../api_const.dart'; // Make sure path is correct

class ExpenseReportController extends GetxController {
  final String tourId; // <-- PARAMETER
  ExpenseReportController({required this.tourId});
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var tourPlan = Rxn<TourPlan>();

  var nonConveyanceList = <Expense>[].obs;
  var conveyanceList = <Expense>[].obs;

  var totalExpense = 0.0.obs;
  var totalDA = 0.0.obs;
  var totalConveyance = 0.0.obs;
  var totalNonConveyance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // --- HELPER: Empty Value Check ---
  String getVal(String? value) {
    if (value == null || value.trim().isEmpty || value.toLowerCase() == "null") {
      return "-";
    }
    return value;
  }
  String getVals(int? isApproved) {
    switch (isApproved) {
      case 1:
        return "approved";
      case 2:
        return "rejected";
      case 0:
      default:
        return "pending";
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('${baseUrl}expense-data/$tourId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        if (jsonList.isNotEmpty) {
          tourPlan.value = TourPlan.fromJson(jsonList[0]);
          processExpenses();
        } else {
          errorMessage.value = "No data found";
        }
      } else {
        errorMessage.value = "Failed to load: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  void processExpenses() {
    if (tourPlan.value == null) return;

    nonConveyanceList.clear();
    conveyanceList.clear();
    totalExpense.value = 0.0;
    totalDA.value = 0.0;
    totalConveyance.value = 0.0;
    totalNonConveyance.value = 0.0;

    for (var visit in tourPlan.value!.visits) {
      for (var exp in visit.expenses) {
        totalExpense.value += exp.amount;

        if (exp.expenseType == 'non_conveyance') {
          nonConveyanceList.add(exp);
          totalNonConveyance.value += exp.amount;
          if (exp.type.toLowerCase().contains('da')) {
            totalDA.value += exp.amount;
          }
        } else if (exp.expenseType == 'conveyance' || exp.expenseType == 'local_conveyance') {
          conveyanceList.add(exp);
          totalConveyance.value += exp.amount;
        }
      }
    }
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  String formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "-";
    try {
      DateTime dt = DateTime.parse(dateStr);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return dateStr;
    }
  }

  // ================= PDF DOWNLOAD LOGIC =================
  Future<void> downloadPdf() async {
    if (tourPlan.value == null) return;

    final pdf = pw.Document();
    final plan = tourPlan.value!;

    // PDF Fonts
    final fontBold = pw.Font.helveticaBold();
    final fontRegular = pw.Font.helvetica();

    // Helper functions for PDF Widgets
    pw.Widget pdfText(String text, {bool isHeader = false}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: isHeader ? fontBold : fontRegular,
            fontSize: 9,
          ),
        ),
      );
    }

    pw.Widget sectionHeader(String title) {
      return pw.Container(
        width: double.infinity,
        color: PdfColors.grey300,
        padding: const pw.EdgeInsets.all(5),
        margin: const pw.EdgeInsets.only(top: 10, bottom: 5),
        child: pw.Center(
          child: pw.Text(title, style: pw.TextStyle(font: fontBold, fontSize: 12)),
        ),
      );
    }

    pw.Widget infoRow(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 2),
        child: pw.Row(
          children: [
            pw.Expanded(child: pw.Text(label, style: pw.TextStyle(font: fontBold, fontSize: 10))),
            pw.Expanded(child: pw.Text(value, style: pw.TextStyle(font: fontRegular, fontSize: 10))),
          ],
        ),
      );
    }

    // Build Page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // Header
            pw.Center(
                child: pw.Text("Tour Plan Expenses",
                    style: pw.TextStyle(font: fontBold, fontSize: 18))),
            pw.SizedBox(height: 10),

            // Top Info
            infoRow("Name:", plan.user.name),
            infoRow("Employee Id:", plan.user.employeeCode),
            infoRow("Designation:", plan.user.designation),
            infoRow("Start Date:", formatDate(plan.startDate)),
            infoRow("End Date:", formatDate(plan.endDate)),
            infoRow("Tour No.:", plan.serialNo),
            infoRow("Expense Status:", plan.tourStatus),
            infoRow("Approval Status:", plan.tourStatus),

            pw.SizedBox(height: 10),
            //infoRow("Hotel Amount: ", "₹ 0"),
            //infoRow("Total DA:", "₹ ${totalDA.value.toStringAsFixed(2)}"),
            infoRow("Total Conveyance:","₹ ${totalConveyance.value.toStringAsFixed(2)}"),
            infoRow("Total Non-Conveyance: ", "₹ ${totalNonConveyance.value.toStringAsFixed(2)}"),
            //infoRow("Total Non-Conveyance: ", "₹ ${.value.toStringAsFixed(2)}"),
            infoRow("Total Expense:", "₹ ${totalExpense.value.toStringAsFixed(2)}"),


            // 1. Conveyance Table
            sectionHeader("Conveyance Expense"),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pdfText("Date", isHeader: true),
                    pdfText("Departure Town", isHeader: true),
                    pdfText("Departure Time", isHeader: true),
                    pdfText("Arrival Town", isHeader: true),
                    pdfText("Arrival Time", isHeader: true),
                    pdfText("Mode of Travel", isHeader: true),
                    pdfText("Fare(Rs.)", isHeader: true),
                    pdfText("Remarks", isHeader: true),
                  ],
                ),
                if (conveyanceList.isEmpty)
                  pw.TableRow(children: [pdfText("No Data")]),
                ...conveyanceList.map((e) {
                  return pw.TableRow(children: [
                    pdfText(formatDate(e.date)),
                    pdfText(getVal(e.departureTown)),
                    pdfText(getVal(e.departureTime)),
                    pdfText(getVal(e.arrivalTown)),
                    pdfText(getVal(e.arrivalTime)),
                    pdfText(getVal(e.modeOfTravel)),
                    pdfText(e.amount.toString()),
                    pdfText(getVal(e.remarks)),
                  ]);
                }).toList(),
              ],
            ),

            // 2. Non-Conveyance Table
            sectionHeader("Non-Conveyance Expense"),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              children: [
                // Header Row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pdfText("Date", isHeader: true),
                    pdfText("Tour Location", isHeader: true),
                    pdfText("Hotel Actual", isHeader: true),
                    pdfText("DA Type", isHeader: true),
                    pdfText("DA Amt", isHeader: true),
                    pdfText("Other", isHeader: true),
                    pdfText("Total", isHeader: true),
                    pdfText("Remarks", isHeader: true),
                  ],
                ),
                // Data Rows
                if (nonConveyanceList.isEmpty)
                  pw.TableRow(children: [pdfText("No Data")]),
                ...nonConveyanceList.map((e) {
                  return pw.TableRow(children: [
                    pdfText(formatDate(e.date)),
                    pdfText(getVal(e.location)),
                    pdfText(getVal("-",)),
                    pdfText(getVal(e.type)),
                    pdfText(e.type.toLowerCase().contains('da') ? e.amount.toString() : "0"),
                    pdfText(!e.type.toLowerCase().contains('da') ? e.amount.toString() : "0"),
                    pdfText(e.amount.toString()),
                    pdfText(getVal(e.remarks)),
                  ]);
                }).toList(),
              ],
            ),

            // 3. Visits Table
            sectionHeader("Local Conveyance Expense"),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.black),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pdfText("Dealer/Lead", isHeader: true),
                    pdfText("Planned Date", isHeader: true),
                    pdfText("Visit Type", isHeader: true),
                    pdfText("Check In Date", isHeader: true),
                    pdfText("Purpose of Visit", isHeader: true),
                    pdfText("Outcome", isHeader: true),
                    pdfText("Status", isHeader: true),
                    pdfText("Reject Reason", isHeader: true),
                  ],
                ),
                if (plan.visits.isEmpty)
                  pw.TableRow(children: [pdfText("No Data")]),
                ...plan.visits.map((v) {
                  return pw.TableRow(children: [
                    pdfText(getVal(v.name)),
                    pdfText(formatDate(v.visitDate)),
                    pdfText(formatDate(v.type)),
                    pdfText(v.checkins != null ? formatTime(v.checkins!.checkInTime) : "-"),
                    pdfText(getVal(v.visitPurpose)),
                    pdfText(v.checkins?.outcome ?? "-"),
                    pdfText(getVals(v.is_approved)),
                    pdfText(getVal(v.reject_reason)),
                  ]);
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    // Ye line Print Preview open karegi jahan se user "Save as PDF" kar sakta hai
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Expenses_${plan.serialNo}.pdf',
    );
  }
}