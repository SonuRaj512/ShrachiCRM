import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';

import '../../models/Profile/PrivacyModel.dart';

class PolicyService {
  static const String url = "$baseUrl$privacy_policy";

  static Future<PrivacyPolicyModel> fetchPrivacyPolicy() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PrivacyPolicyModel.fromJson(data);
    } else {
      throw Exception("Failed to load privacy policy");
    }
  }
}


class PolicyController extends GetxController {
  var isLoading = true.obs;
  var policy = Rxn<PolicyModel>();

  Future<void> fetchPolicy(String type) async {
    try {
      isLoading(true);

      final url = "$baseUrl$type";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        policy.value =
            PolicyModel.fromJson(jsonDecode(response.body));
      } else {
        Get.snackbar("Error", "Failed to load policy");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
