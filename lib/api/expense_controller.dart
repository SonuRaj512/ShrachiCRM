import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/expense_model.dart';
import 'package:shrachi/views/screens/checkins/ExpensePage/expense_list.dart';

class ExpenseController extends GetxController {
  final isLoading = false.obs;
  final expenses = <ExpenseModel>[].obs;
  // ✅ New: City API data
  final cityList = <Map<String, dynamic>>[].obs;
  final cityLoading = false.obs;
  String? selectedCategory;
  String? selectedDayType;

  String foodAllowance = "0.00";
  String travelAllowance = "0.00";
  String hotelAllowance = "0.00";

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  Future getExpense({required int tourPlanId, required int visitId}) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl$allExpense').replace(
          queryParameters: {
            'tour_plan_id': tourPlanId.toString(),
            'visit_id': visitId.toString(),
          },
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      final body = jsonDecode(res.body); // decode response body
      print("Expense fetch Response Api${body}"); // print the full decoded JSON
      print(token);

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        expenses.value = (body['data'] as List).map((json) => ExpenseModel.fromJson(json)).toList();
      }
    } catch (stack) {
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }

  ///delete expense funcation is here
  Future<void> deleteExpense(int id, BuildContext context) async {
    final url = "https://btlsalescrm.cloud/api/expenses/delete/$id";

    try {
      final token = await getToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("Delete Expense Api Response ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Expense deleted successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                data['message'] ?? "Delete failed",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Server error: ${response.statusCode}"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  /// 🔵 SEND SINGLE EXPENSE FOR APPROVAL (already existing)
  Future<void> sendForApproval(int expenseId, int index) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final url = Uri.parse('${baseUrl}expenses/$expenseId/approval');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Success: backend will return updated expense, so fetch the list again
        await getExpense(
          tourPlanId: expenses[index].tourPlanId,
          visitId: expenses[index].visitId,
        );
        print('URL: $url');
        print('Token: $token');
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        Get.snackbar('Success', 'Expense sent for approval');
      } else {
        Get.snackbar('Error', 'Failed to send for approvalaaaaaaa');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  /// 🟢 NEW: BULK APPROVAL FUNCTION
  Future<void> sendAllExpensesForApproval(int visitId) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      // 🔹 Collect all expense IDs (pending/cancelled only)
      final List<int> expenseIds =
          expenses
              .where(
                (e) =>
                    e.expenseStatus == "pending" ||
                    e.expenseStatus == "cancelled",
              )
              .map<int>((e) => e.id)
              .toList();

      if (expenseIds.isEmpty) {
        Get.snackbar(
          "No Expenses",
          "Please fill up Expenses page before sending approval",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final url = Uri.parse("$baseUrl$expenseApprovebulk");
      //final url = Uri.parse("https://sharchi.equi.website/api/expenses/approve-bulk");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ token header
        },
        body: jsonEncode({"expense_ids": expenseIds, "visit_id": visitId}),
      );
      print("send for All Approval ${response.body}");
      // print('URL: $url');
      // print('Token: $token');
      // print('Response status: ${response.statusCode}');
      // print("🔹 Sending to: $url");
      // print("🔹 Body: ${jsonEncode({
      //   "expense_ids": expenseIds,
      //   "visit_id": visitId,
      // })}");
      // print("🔹 Token: $token");

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "All expenses sent for approval!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Update local list
        for (var exp in expenses) {
          if (expenseIds.contains(exp.id)) {
            exp.expenseStatus = "approval";
          }
        }
        expenses.refresh();
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'Failed to send';
        Get.snackbar(
          "Error",
          "API Error: $errorMsg",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future createExpense({
    required int tourPlanId,
    required int visitId,
    required DateTime? startDate,
    required String expensetype,
    required String date,
    String? departureTown,
    String? departureTime,
    String? arrivalTown,
    String? arrivalTime,
    String? modeOfTravel,
    String? comment,
    List? images,
    String? type,
    double? amount,
    String? location,
    //String? daType,
    // NEW FIELDS 👇
    String? cityCategory,
    String? dayType,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$expenseCreate'),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields.addAll({
        'tour_plan_id': tourPlanId.toString(),
        'visit_id': visitId.toString(),
        'startDate':startDate.toString(),
        'expensetype': expensetype,
        'expense_type': expensetype,
        'date': date,
        'departure_town': departureTown ?? '',
        'departure_time': departureTime ?? '',
        'arrival_town': arrivalTown ?? '',
        'arrival_time': arrivalTime ?? '',
        'mode_of_travel': modeOfTravel ?? '',
        "fare": amount.toString(),
        'amount': amount?.toStringAsFixed(2) ?? '0',
        'travel_amount': amount?.toStringAsFixed(2) ?? '0',
        //'da_type': daType ?? '',
        'location': location ?? '',
        'type': type ?? '',
        // NEW Back-end Fields 👇
        'city_category': cityCategory ?? '',
        'day_type': dayType ?? '',
        'remarks':comment ?? '',
        'non_conveyance_amount':
            expensetype == 'non_conveyance'
                ? (amount?.toStringAsFixed(2) ?? '0')
                : '',
      });

      if (images != null) {
        for (var img in images) {
          request.files.add(await http.MultipartFile.fromPath('images[]', img));
        }
      }

      var streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      print(jsonDecode(res.body));
      if (res.statusCode == 201) {
        await getExpense(tourPlanId: tourPlanId, visitId: visitId);
        Get.off(() => ExpenseList(tourPlanId: tourPlanId, visitId: visitId, startDate: startDate,));
      }
    } catch (stack) {
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }

  // // Fetch all cities with optional pagination
  Future<List<dynamic>> fetchCities({int page = 1}) async {
    final token = await getToken();
    final url = "${baseUrl}expenses-allowance-city?page=$page";

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(res.body); // ✅ decode JSON to Map
      print("all city fetch $data"); // ✅ print Map directly
      if (data['status'] == true) {
        return data['data']; // ✅ return list
      }
      return [];
    } catch (e) {
      print("Error fetching cities: $e");
      return [];
    }
  }

  Future<List<dynamic>> searchCities(String cityName) async {
    final token = await getToken();
    final url = "${baseUrl}expenses-allowance-city?city_name=$cityName";

    try {
      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      final data = jsonDecode(res.body); // ✅ decode JSON to Map
      print("city_name $data"); // ✅ print Map directly
      if (data['status'] == true) {
        return data['data']; // ✅ return list
      }
      return [];
    } catch (e) {
      print("Error searching cities: $e");
      return [];
    }
  }

  // Fetch allowance by category
  Future<double?> fetchAllowanceByCategory(String category) async {
    final token = await getToken();
    final url = Uri.parse('${baseUrl}expenses-allowance?category=$category');

    try {
      final res = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("response category amount ${res.body}");
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // hotel_allowance ko double me convert kar ke return
        if (data['allowance'] != null && data['allowance'].isNotEmpty) {
          return double.tryParse(
            data['allowance'][0]['hotel_allowance'] ?? '0',
          );
        }
      }
      return 0;
    } catch (e) {
      print("Error fetching allowance: $e");
      return 0;
    }
  }

  Future<void> fetchAllowance(
    Function updater,
    String? selectedCategory,
    String? selectedDayType,
  ) async {
    if (selectedCategory == null || selectedDayType == null) return;

    String typeParam = selectedDayType == "Full day" ? "full_da" : "half_da";

    final url = Uri.parse(
      "https://btlsalescrm.cloud/api/expenses-allowance?category=$selectedCategory&type=$typeParam",
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final allowance = data["allowance"] ?? {};

      updater(() {
        if (selectedDayType == "Full day") {
          foodAllowance = (allowance["food_allowance"] ?? "0.00").toString();
          hotelAllowance = (allowance["hotel_allowance"] ?? "0.00").toString();
        } else {
          // Half day
          foodAllowance =
              (allowance["haf_food_allowence"] ?? "0.00").toString();
          hotelAllowance = "0.00"; // Half day e hotel allowance nai
        }
        travelAllowance = (allowance["travel_allowance"] ?? "0.00").toString();
      });
    }
  }
}
