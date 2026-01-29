import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_const.dart';

class ApiHandler {
  // common GET request
  static Future<dynamic> getRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return _handleResponse(response);
  }

  // Warehouse GET request
  static Future<dynamic> getWarehouseRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    return _handleResponse(response);
  }

  // response handler
  static dynamic _handleResponse(http.Response response) {
    // print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("API Error: ${response.statusCode} ${response.body}");
    }
  }

  // generic GET method
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse("$baseUrl$endpoint"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  // specific HO method
  Future<Map<String, dynamic>> getHOData() async {
    final response = await get("ho");
    if (response["status"] == true) {
      return response["data"];
    } else {
      throw Exception("Invalid response: ${response["message"]}");
    }
  }
}
