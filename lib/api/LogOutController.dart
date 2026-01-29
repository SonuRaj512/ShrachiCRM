// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class ApiController {
//   Future<bool> logout() async {
//     const url = "https://btlsalescrm.cloud/api/logout";
//
//     try {
//       final response = await http.post(Uri.parse(url), headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer YOUR_TOKEN_HERE"
//       });
//
//       if (response.statusCode == 200) {
//         return true;
//       } else {
//         print("Logout Failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       print("Logout Error: $e");
//       return false;
//     }
//   }
// }
