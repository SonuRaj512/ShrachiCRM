// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../views/screens/checkins/ExpensePage/expense_list.dart';
// import 'api_const.dart';
//
// class SendForApprovalController  extends GetxController {
//   var isLoading = false.obs;
//   var tourPlan = Rxn<TourPlanModel>();
//   var showApprovalColors = false.obs; // 👈 Controls when card borders become visible after button click
//   var isAlreadySent = false.obs;
//
//
//   Future<void> fetchTourPlan({required int id}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token") ?? "";
//     try {
//       isLoading.value = true;
//
//       print("TourIdId$id");
//       final url = Uri.parse("${baseUrl}tourplans/$id");
//       final response = await http.get(
//         url,
//         headers: {
//           "Accept": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print("SendForApprovalController${response.body}");
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         tourPlan.value = TourPlanModel.fromJson(data['tourPlans']);
//         // ✅ CHECK STATUS & UPDATE FLAG
//         if (tourPlan.value?.status?.toLowerCase() == "send for approval") {
//           isAlreadySent.value = true;
//         }
//       } else {
//         Get.snackbar("Error", "Failed to load tour plan");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> sendForApproval(int tourPlanId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString("access_token") ?? "";
//     final tour = tourPlan.value;
//     if (tour == null) return;
//
//     // ✅ Enable color visibility
//     showApprovalColors.value = true;
//
//     final invalidVisits = tour.visits.where((v) =>
//     v.checkin == null || v.checkin!.outcome == null || v.expenses.isEmpty).toList();
//
//     // ✅ Show color update on UI
//     tourPlan.refresh();
//
//     if (invalidVisits.isNotEmpty) {
//       Get.snackbar(
//         "Message",
//         "Please complete Outcome and Expense for all visits before sending.",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     try {
//       isLoading(true);
//       final url = "${baseUrl}expenses/approve-bulk/$tourPlanId";
//       final response = await http.post(Uri.parse(url),headers: {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token', // 👈 IMPORTANT
//       },);
//
//       print("SendForApproval Post ${response.body}");
//       print("SendForApproval tourPlaneId $tourPlanId");
//       if (response.statusCode == 200) {
//         Get.snackbar("Success", "Tour sent for approval successfully!",
//             backgroundColor: Colors.green, colorText: Colors.white);
//       } else {
//         Get.snackbar("Error", "Failed to send for approval.",
//             backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString(),
//           backgroundColor: Colors.redAccent, colorText: Colors.white);
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   void navigateToEditPage({required int visitId, required int tourPlanId}) {
//     Get.to(() => ExpenseList(
//       tourPlanId: tourPlanId,
//       visitId: visitId,
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/screens/checkins/ExpensePage/expense_list.dart';
import 'api_const.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/screens/checkins/ExpensePage/expense_list.dart';
import 'api_const.dart';

class SendForApprovalController extends GetxController {
  var isLoading = false.obs;
  var tourPlan = Rxn<TourPlanModel>();
  var showApprovalColors = true.obs;
  /// 🔥 MAIN FLAG
  RxBool hasPendingExpense = false.obs;


  // 🔥 NEW VARIABLE (button hide)
  var isAlreadySent = false.obs;

  Future<void> fetchTourPlan({required int id}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse("${baseUrl}tourplans/$id"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        tourPlan.value = TourPlanModel.fromJson(data['tourPlans']);

        /// 🔥 VALUE AAYI = ALREADY SUBMITTED
        if (tourPlan.value!.has_pending_expense.toString().trim().toLowerCase() == "true") {
          hasPendingExpense.value = true;
        } else {
          hasPendingExpense.value = false;
        }
      }
      else {
        Get.snackbar("Error", "Failed to load tour plan");
      }
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> sendForApproval(int tourPlanId) async {
    final tour = tourPlan.value!;

    /// 🚫 ALREADY SUBMITTED
    if (!hasPendingExpense.value) {
      Get.snackbar(
        "Already Submitted",
        "Already submitted send for all expense approval.",
        backgroundColor: Colors.blueGrey,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    /// 🔍 VALIDATION
    showApprovalColors.value = true;

    final invalidVisits = tour.visits.where((v) =>
    v.checkin == null ||
        v.checkin!.outcome == null ||
        v.expenses.isEmpty).toList();

    if (invalidVisits.isNotEmpty) {
      Get.snackbar(
        "Incomplete Data",
        "Please complete Outcome & Expense for all visits.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("${baseUrl}expenses/approve-bulk/$tourPlanId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        /// 🔥 NOW MARK AS SUBMITTED
        hasPendingExpense.value = false;
        tourPlan.value!.has_pending_expense = true;
        tourPlan.refresh();

        Get.snackbar(
          "Success",
          "Tour sent for approval successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading(false);
    }
  }
  void navigateToEditPage({required int visitId, required int tourPlanId, required DateTime? startDate}) {
    Get.to(() => ExpenseList(
      tourPlanId: tourPlanId,
      visitId: visitId,
      startDate: DateFormat("dd-MM-yyyy").parse(startDate.toString()),
      //startDate: DateTime.parse(_dateController.text),
    ),);
  }
}

class TourPlanModel {
  final int id;
  final String serialNo;
  String status;
  bool has_pending_expense;
  final String tourStatus;
  final List<VisitModel> visits;

  TourPlanModel({
    required this.id,
    required this.serialNo,
    required this.status,
    required this.has_pending_expense,
    required this.tourStatus,
    required this.visits,
  });

  factory TourPlanModel.fromJson(Map<String, dynamic> json) {
    return TourPlanModel(
      id: json['id'],
      serialNo: json['serial_no'] ?? '',
      status: json['status'] ?? '',
      has_pending_expense: json['has_pending_expense'] ?? '',
      tourStatus: json['tour_status'] ?? '',
      visits: (json['visits'] as List<dynamic>?)
          ?.map((e) => VisitModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class VisitModel {
  final int id;
  final String name;
  final String type;
  final String visitSerialNo;
  final bool hasCheckin;
  final bool isCheckin;
  final CheckinModel? checkin;
  final List<ExpenseModel> expenses;

  VisitModel({
    required this.id,
    required this.name,
    required this.type,
    required this.visitSerialNo,
    required this.hasCheckin,
    required this.isCheckin,
    required this.checkin,
    required this.expenses,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      visitSerialNo: json['visit_serial_no'] ?? '',
      hasCheckin: json['has_checkin'] ?? false,
      isCheckin: json['is_checkin'] ?? false,
      checkin: json['checkins'] != null
          ? CheckinModel.fromJson(json['checkins'])
          : null,
      expenses: (json['expenses'] as List<dynamic>?)
          ?.map((e) => ExpenseModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CheckinModel {
  final int id;
  final String? comments;
  final bool isOutcome;
  final bool isOutchecked;
  final String? outcome;

  CheckinModel({
    required this.id,
    this.comments,
    required this.isOutcome,
    required this.isOutchecked,
    this.outcome,
  });

  factory CheckinModel.fromJson(Map<String, dynamic> json) {
    return CheckinModel(
      id: json['id'],
      comments: json['comments'],
      isOutcome: json['isoutcome'] ?? false,
      isOutchecked: json['outchecked'] == 1,
      outcome: json['outcome'],
    );
  }
}

class ExpenseModel {
  final int? id;
  final String? type;
  final String? amount;
  final String? remark;

  ExpenseModel({
    this.id,
    this.type,
    this.amount,
    this.remark,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      type: json['type'] ?? '',
      amount: json['amount']?.toString(),
      remark: json['remark'] ?? '',
    );
  }
}