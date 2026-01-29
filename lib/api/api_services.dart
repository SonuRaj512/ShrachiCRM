import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_hendler.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/WharehouseModel.dart';
import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
import '../models/ExpenseAndOutcomeModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/TourPlanRequestModel.dart';
import '../models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'api_const.dart';

class ApiService {
  static String token = '';
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, String> body,
  ) async {
    var url = Uri.parse("$baseUrl$dealerapi");

    var response = await http.post(url, body: body);

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body),
    };
  }

  /// Load token from SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token') ?? '';
  }

  // fetch all dealers
  static Future<List<Dealer>> fetchDealers() async {
    final response = await ApiHandler.getRequest("dealer");
    print(response["customers"]);
    List data = response["customers"];
    return data.map((e) => Dealer.fromJson(e)).toList();
  }

  // fetch all Warehouse
  static Future<List<WarehouseModel>> fetchWarehouse() async {
    final response = await ApiHandler.getRequest("warehouse");

    List data = response["data"];
    return data.map((e) => WarehouseModel.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> getHOData() async {
    final response = await http.get(Uri.parse("$baseUrl$hoapi"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body["status"] == true) {
        return body["data"];
      } else {
        throw Exception("Invalid response: ${body["message"]}");
      }
    } else {
      throw Exception("Failed to load data: ${response.statusCode}");
    }
  }

  //Lead Business
  Future<List<LeadBusinessModel>> getLeadBusinesses() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl$fetchbusiness"),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == true && data["data"] != null) {
        return (data["data"] as List)
            .map((e) => LeadBusinessModel.fromJson(e))
            .toList();
      }
    }
    return [];
  }

  //Lead Type
  Future<List<LeadTypeModel>> fetchLeadType() async {
    // Token le aao
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.get(
      Uri.parse("$baseUrl$leadType"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == true && body["data"] != null) {
        final List data = body["data"];
        return data.map((e) => LeadTypeModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }

  //LeadSources
  Future<List<LeadSourceModel>> fetchLeadSources() async {
    // Token le aao
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.get(
      Uri.parse("$baseUrl$leadSource"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["status"] == true && body["data"] != null) {
        final List data = body["data"];
        return data.map((e) => LeadSourceModel.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Failed: ${response.statusCode}");
    }
  }

  //postCreateTourPlan
  Future<Map<String, dynamic>> postTourPlan(TourPlanRequest request) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';
      final url = Uri.parse("$baseUrl$tourplansapi");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );
      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);

        if (body["success"] == true) {
          print("✅ Tour plan created successfully: ${body["message"]}");
          return body["data"];
        } else {
          print("❌ Failed: ${body["message"]}");
          throw Exception("Failed to post tour plan: ${body["message"]}");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception while posting tour plan: $e");
      throw Exception("Exception while posting tour plan: $e"); // ✅ fix
    }
  }

  ///Fetch Tour Plane
  Future<List<TourPlan>> fetchTourPlans() async {
    final token = await _getToken();
    final url = Uri.parse("$baseUrl$fetchtourplans");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    print("Show Tour Plane Data ${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => TourPlan.fromJson(json)).toList();
      } else {
        throw Exception('API returned success false or no data');
      }
    } else {
      // Agar server error de, toh exception throw karo.
      throw Exception(
        'Failed to load tour plans. Status code: ${response.statusCode}',
      );
    }
  }

  Future getLeadStatuses() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse("$baseUrl$leadstatus"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == true && data["data"] != null) {
        return (data["data"] as List)
            .map((json) => LeadStatus.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future getLeads({String query = ""}) async {
    final token = await _getToken();
    final uri = Uri.parse(
      "$baseUrl$leadsname",
    ).replace(queryParameters: {"name": query});
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == true && data["data"] != null) {
        return (data["data"] as List)
            .map((json) => Visit.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<TourResponse> fetchTours({String? serialNo, String? type, String? visitSerialNo,}) async {
    final token = await _getToken();

    String apiUrl = "${baseUrl}user-tours";

    Map<String, String> queryParams = {};

    if (serialNo != null && serialNo.isNotEmpty) {
      queryParams["serial_no"] = serialNo;
    }

    if (type != null && type.isNotEmpty) {
      queryParams["type"] = type;
    }

    if (visitSerialNo != null && visitSerialNo.isNotEmpty) {
      queryParams["visit_serial_no"] = visitSerialNo;
    }

    if (queryParams.isNotEmpty) {
      apiUrl += "?" + Uri(queryParameters: queryParams).query;
    }

    print("FINAL API URL => $apiUrl");

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("expense or outcome response error => ${response.body}");

    if (response.statusCode == 200) {
      return tourResponseFromJson(response.body);
    } else {
      throw Exception("Failed to load tours");
    }
  }

  Future<List<Expense>> fetchExpensesByVisitId(String visitId) async {
    final response = await http.get(
      Uri.parse("https://btlsalescrm.cloud/api/user-tours?user_id=25"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load tours");
    }

    final data = jsonDecode(response.body);

    List tours = data["tours"] ?? [];

    List<Expense> finalExpenses = [];

    for (var tour in tours) {
      for (var visit in tour["visits"] ?? []) {
        if (visit["id"].toString() == visitId) {
          List expenses = visit["expenses"] ?? [];
          finalExpenses.addAll(
            expenses.map((e) => Expense.fromJson(e)).toList(),
          );
        }
      }
    }

    return finalExpenses;
  }

}
