// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'api_const.dart';
//
// class StateController extends GetxController {
//   var isLoading = false.obs;
//   var statesList = <String>[].obs;
//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("access_token") ?? "";
//   }
//   Future<void> fetchStates() async {
//     isLoading.value = true;
//    final token = getToken();
//    const apiUrl = '${baseUrl}states';
//
//     try {
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         // assuming response: { "success": true, "data": [ { "id": 1, "name": "Bihar" }, ... ] }
//
//         if (data['data'] != null) {
//           statesList.value = List<String>.from(
//             data['data'].map((item) => item['name'].toString()),
//           );
//         }
//       } else {
//         print('❌ Failed to load states. Status: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('⚠️ Error fetching states: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
