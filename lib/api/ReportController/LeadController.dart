import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_const.dart';

class LeadController extends GetxController {
  var isLoading = false.obs;
  var leadsList = [].obs;
  var followupList = [].obs;
  // Filtering Dates (Initial value empty rakhi hai base API ke liye)
  var startDate = "".obs;
  var endDate = "".obs;
  RxList<Map<String, dynamic>> flatLeadsList = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchLeads();
    fetchFollowupLeads();
  }
  // Retrieve auth token from shared preferences
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  // Function to fetch data (Handles Initial Total Data & Filtered Data)
  Future<void> fetchFollowupLeads() async {
    try {
      isLoading(true);
      final token = await getToken();

      // Start with the base URL for total data
      String url = '$baseUrl$followup_leads';

      // Logic: Only append parameters if BOTH dates are selected by the user
      if (startDate.value.isNotEmpty && endDate.value.isNotEmpty) {
        url = '$url?start_date=${startDate.value}&end_date=${endDate.value}';
        print("DEBUG: Fetching Filtered Data -> $url");
      } else {
        print("DEBUG: Fetching Total Data (No Filters) -> $url");
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          followupList.value = jsonResponse['data'];
        }
      } else {
        Get.snackbar("Error", "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Check your connection: $e");
    } finally {
      isLoading(false);
    }
  }

  // Helper to clear filters and show total data again
  void resetToTotalData() {
    startDate.value = "";
    endDate.value = "";
    fetchFollowupLeads();
  }
  Future<void> fetchLeads() async {
    try {
      isLoading(true);

      final token = await getToken();
      String url = '$baseUrl$pending_leads';

      if (startDate.value.isNotEmpty && endDate.value.isNotEmpty) {
        url =
        '$url?start_date=${startDate.value}&end_date=${endDate.value}';
      }

      print("API URL => $url");

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          leadsList.value = jsonResponse['data']; // ✅ IMPORTANT
          print("DATA LENGTH => ${leadsList.length}");
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
  //  Future<void> fetchLeads() async {
  //   try {
  //     isLoading(true);
  //     final token = await getToken();
  //
  //     String url = '$baseUrl$pending_leads';
  //
  //     // Agar dates select ho chuki hain, toh filter query add karein
  //     if (startDate.value.isNotEmpty && endDate.value.isNotEmpty) {
  //       url = '$url?start_date=${startDate.value}&end_date=${endDate.value}';
  //     }
  //
  //     print("Fetching from: $url"); // Debugging ke liye
  //
  //     var response = await http.get(
  //         Uri.parse(url),
  //       headers: {
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(response.body);
  //       // if (jsonResponse['success'] == true) {
  //       //   leadsList.value = jsonResponse['data'];
  //       // }
  //       if (jsonResponse['success'] == true) {
  //         List rawData = jsonResponse['data'];
  //
  //         List<Map<String, dynamic>> tempList = [];
  //
  //         for (var item in rawData) {
  //           var tour = item['tour'];
  //           List visits = item['visits'] ?? [];
  //
  //           for (var visit in visits) {
  //             tempList.add({
  //               "tour": tour,
  //               "visit": visit,
  //               "lead": visit['lead'],
  //             });
  //           }
  //         }
  //
  //         flatLeadsList.value = tempList;
  //       }
  //
  //     }
  //     else {
  //       Get.snackbar("Error", "Server Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Connection Error: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  // Reset the list and filters to initial state
  void updateFilter(String start, String end) {
    startDate.value = start;
    endDate.value = end;
    fetchLeads(); // Filtered API call
  }
}