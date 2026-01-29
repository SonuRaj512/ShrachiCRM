import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// // ============================= CONTROLLER ==============================
// class FlowController extends GetxController {
//   String apiBase = "https://btlsalescrm.cloud/api/allowance-search";
//
//   String token = "";
//   RxString finalAmount = "".obs;
//   RxString allowanceTitle = "".obs;   // Food / Hotel / Travel allowance name
//
//   var categoryWiseCityList = <String>[].obs;
//   var expenseTypeList = <String>[].obs;
//   var allowanceTypeList = <String>[].obs;
//
//   var isCityLoading = false.obs;
//   var isExpenseLoading = false.obs;
//   var isAllowanceLoading = false.obs;
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadToken();  // ⬅ token load hoga shared prefs se
//   }
//
//   // ==================== LOAD TOKEN ====================
//   Future<void> loadToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     token = prefs.getString("access_token") ?? "";
//
//     print("TOKEN LOADED: $token");
//   }
//
//   // COMMON HEADERS
//   Map<String, String> get headers => {
//     "Authorization": "Bearer $token",
//     "Accept": "application/json",
//   };
//
//   // ==================== CATEGORY ⇒ CITY ====================
//   Future<void> fetchCities(String category) async {
//     try {
//       isCityLoading.value = true;
//       categoryWiseCityList.clear();
//
//       final url = "$apiBase?category=$category";
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: headers,
//       );
//
//       print("CITY API RESPONSE: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData["status"] == true) {
//
//           // Extract city_name from the list
//           if (jsonData["city_allowances"] != null) {
//             categoryWiseCityList.value = List<String>.from(
//               jsonData["city_allowances"].map((e) => e["city_name"].toString()),
//             );
//           }
//         }
//       }
//     } finally {
//       isCityLoading.value = false;
//     }
//   }
//
//
// // ==================== CITY ⇒ EXPENSE TYPE ====================
//   Future<void> fetchExpenseTypes(String category, String expenseType) async {
//     try {
//       isExpenseLoading.value = true;
//       expenseTypeList.clear();
//
//       final url = "$apiBase?category=$category&expense_type=$expenseType";
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       print("Expense_Types API RESPONSE: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData["status"] == true) {
//           if (jsonData["data"] != null && jsonData["data"] is List) {
//             expenseTypeList.value =
//             List<String>.from(jsonData["data"].map((e) => e["allownace_type"] ?? ""));
//           }
//         }
//       }
//     } finally {
//       isExpenseLoading.value = false;
//     }
//   }
//
//
// // ==================== EXPENSE ⇒ ALLOWANCE TYPE ====================
//   Future<void> fetchAllowanceTypes(String category, String expenseType) async {
//     try {
//       isAllowanceLoading.value = true;
//       allowanceTypeList.clear();
//
//       final url =
//           "$apiBase?category=$category&expense_type=$expenseType";
//
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       print("Allownace_Type API RESPONSE: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData["status"] == true) {
//           if (jsonData["data"] != null && jsonData["data"] is List) {
//             allowanceTypeList.value =
//             List<String>.from(jsonData["data"].map((e) => e["allownace_type"]));
//           } else {
//             allowanceTypeList.value = [];
//           }
//         }
//       }
//     } finally {
//       isAllowanceLoading.value = false;
//     }
//   }
//
//   Future<void> fetchAllowanceAmount(String category, String expenseType, String allowanceType) async {
//     try {
//       isAllowanceLoading.value = true;
//       finalAmount.value = "";
//       allowanceTitle.value = ""; // <-- ADD THIS
//
//       final url =
//           "$apiBase?category=$category&expense_type=$expenseType&allownace_type=$allowanceType";
//
//       final response = await http.get(Uri.parse(url), headers: headers);
//
//       print("AMOUNT API RESPONSE: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final jsonData = jsonDecode(response.body);
//
//         if (jsonData["status"] == true && jsonData["data"] != null) {
//           var data = jsonData["data"];
//
//           // ------------ FIND WHICH ALLOWANCE IS NOT NULL ------------
//           if (data["food_allowance"] != null) {
//             allowanceTitle.value = "Food Allowance";
//           }
//           else if (data["hotel_allowance"] != null) {
//             allowanceTitle.value = "Hotel Allowance";
//           }
//           else if (data["travel_allowance"] != null) {
//             allowanceTitle.value = "Travel Allowance";
//           }
//           else {
//             allowanceTitle.value = "Allowance";
//           }
//
//           // ------------ SET AMOUNT ------------
//           if (data["amount"] != null) {
//             finalAmount.value = data["amount"].toString();
//           }
//         }
//       }
//     } finally {
//       isAllowanceLoading.value = false;
//     }
//   }
//
// }
class FlowController extends GetxController {
  String apiBase = "https://btlsalescrm.cloud/api/allowance-search";

  String token = "";
  RxString finalAmount = "".obs;
  RxString allowanceTitle = "".obs; // Food / Hotel / Travel allowance name

  var categoryWiseCityList = <String>[].obs;
  var expenseTypeList = <String>[].obs;
  var allowanceTypeList = <String>[].obs;

  var isCityLoading = false.obs;
  var isExpenseLoading = false.obs;
  var isAllowanceLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadToken(); // ⬅ token load hoga shared prefs se
  }

  // ==================== LOAD TOKEN ====================
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString("access_token") ?? "";

    print("TOKEN LOADED: $token");
  }

  // COMMON HEADERS
  Map<String, String> get headers => {
    "Authorization": "Bearer $token",
    "Accept": "application/json",
  };

  // ==================== CATEGORY ⇒ CITY ====================
  Future<void> fetchCities(String category) async {
    try {
      isCityLoading.value = true;
      categoryWiseCityList.clear();

      final url = "$apiBase?category=$category";

      final response = await http.get(Uri.parse(url), headers: headers);

      print("CITY API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          // Extract city_name from the list
          if (jsonData["city_allowances"] != null) {
            categoryWiseCityList.value = List<String>.from(
              jsonData["city_allowances"].map((e) => e["city_name"].toString()),
            );
          }
        }
      }
    } finally {
      isCityLoading.value = false;
    }
  }

  // ==================== CITY ⇒ EXPENSE TYPE ====================
  Future<void> fetchExpenseTypes(String category, String expenseType) async {
    try {
      isExpenseLoading.value = true;
      expenseTypeList.clear();

      final url = "$apiBase?category=$category&expense_type=$expenseType";
      final response = await http.get(Uri.parse(url), headers: headers);

      print("Expense_Types API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          if (jsonData["data"] != null && jsonData["data"] is List) {
            expenseTypeList.value = List<String>.from(
              jsonData["data"].map((e) => e["allownace_type"] ?? ""),
            );
          }
        }
      }
    } finally {
      isExpenseLoading.value = false;
    }
  }

  // ==================== EXPENSE ⇒ ALLOWANCE TYPE ====================
  Future<void> fetchAllowanceTypes(String category, String expenseType) async {
    try {
      isAllowanceLoading.value = true;
      allowanceTypeList.clear();

      final url = "$apiBase?category=$category&expense_type=$expenseType";

      final response = await http.get(Uri.parse(url), headers: headers);

      print("Allownace_Type API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          if (jsonData["data"] != null && jsonData["data"] is List) {
            allowanceTypeList.value = List<String>.from(
              jsonData["data"].map((e) => e["allownace_type"]),
            );
          } else {
            allowanceTypeList.value = [];
          }
        }
      }
    } finally {
      isAllowanceLoading.value = false;
    }
  }

  Future<void> fetchAllowanceAmount(String category, String expenseType, String allowanceType,) async {
    try {
      isAllowanceLoading.value = true;
      finalAmount.value = "";
      allowanceTitle.value = ""; // <-- ADD THIS

      final url =
          "$apiBase?category=$category&expense_type=$expenseType&allownace_type=$allowanceType";


      final response = await http.get(Uri.parse(url), headers: headers);

      print("AMOUNT API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true && jsonData["data"] != null) {
          var data = jsonData["data"];

          // ------------ FIND WHICH ALLOWANCE IS NOT NULL ------------
          if (data["food_allowance"] != null) {
            allowanceTitle.value = "Food Allowance";
          } else if (data["hotel_allowance"] != null) {
            allowanceTitle.value = "Hotel Allowance";
          } else if (data["travel_allowance"] != null) {
            allowanceTitle.value = "Travel Allowance";
          } else {
            allowanceTitle.value = "Allowance";
          }

          // ------------ SET AMOUNT ------------
          if (data["amount"] != null) {
            finalAmount.value = data["amount"].toString();
          }
        }
      }
    } finally {
      isAllowanceLoading.value = false;
    }
  }
}
