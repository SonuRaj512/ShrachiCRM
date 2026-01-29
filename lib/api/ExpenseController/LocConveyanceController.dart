import 'dart:convert';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
class LocalConveyanceController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<String> travelModes = <String>[].obs;

  Future<void> fetchLocalConveyance() async {
    try {
      isLoading.value = true;
      travelModes.clear();

      final url = "https://btlsalescrm.cloud/api/conveyance?type=Local%20Conveyance";

      final response = await http.get(Uri.parse(url));

      print("LOCAL Conveyance API Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData["status"] == true) {
          final list = jsonData["data"] as List;

          travelModes.value =
              list.map((e) => e["name"].toString()).toList(); // only name needed
        }
      }
    } catch (e) {
      print("Error fetching Local Conveyance: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
