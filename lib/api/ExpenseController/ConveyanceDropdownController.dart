import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../api_const.dart';

class ConveyanceController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<String> travelModes = <String>[].obs;

  final String apiUrl = "${baseUrl}conveyance?type=Conveyance";

  Future<void> fetchConTravelModes() async {
    try {
      isLoading.value = true;
      travelModes.clear();

      final response = await http.get(Uri.parse(apiUrl));

      print("CONVEYANCE API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true && jsonData["data"] is List) {
          travelModes.value =
          List<String>.from(jsonData["data"].map((e) => e["name"].toString()));
        }
      }
    } catch (e) {
      print("FETCH TRAVEL MODE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchLocConTravelModes() async {
    final ApiUrl = "https://btlsalescrm.cloud/api/conveyance?type=Local%20Conveyance";
    try {
      isLoading.value = true;
      travelModes.clear();

      final response = await http.get(Uri.parse(ApiUrl));

      print("CONVEYANCE API RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true && jsonData["data"] is List) {
          travelModes.value =
          List<String>.from(jsonData["data"].map((e) => e["name"].toString()));
        }
      }
    } catch (e) {
      print("FETCH TRAVEL MODE ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
