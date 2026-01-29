//
//
// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
//
// Future<void> deleteExpense(int id) async {
//   final url = "https://btlsalescrm.cloud/api/expenses/delete/$id";
//
//   try {
//     final response = await http.get(Uri.parse(url)); // OR use http.delete if backend supports
//
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data['status'] == true) {
//         Fluttertoast.showToast(msg: "Expense deleted successfully");
//       } else {
//         Fluttertoast.showToast(msg: data['message'] ?? "Delete failed");
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
//     }
//   } catch (e) {
//     Fluttertoast.showToast(msg: "Error: $e");
//   }
// }
//
//
