import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_const.dart';

class ExpenseUpdateController {
  Future<bool> updateExpense({
    required int expenseId,
    required Map<String, dynamic> body,
    required List<XFile> images,
  }) async {
    final url = "$baseUrl$ExpenseUpdate/$expenseId";
    print("API URL: $url"); // Debug URL

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("access_token");

      var request = http.MultipartRequest("POST", Uri.parse(url));

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });

      request.fields['_method'] = 'PUT';

      // Adding Body Fields
      body.forEach((key, value) {
        if (value != null) {
          // Normal case:
          request.fields[key] = value.toString();
        }
      });

      // Adding Images
      if (images.isNotEmpty) {
        for (var img in images) {
          request.files.add(await http.MultipartFile.fromPath(
            "images[]", // Ensure backend expects 'photo[]' not 'photo'
            img.path,
          ));
        }
      }
      //
      // print("Sending Headers: ${request.headers}");
      // print("Sending Fields: ${request.fields}");
      // print("Sending Files Count: ${request.files.length}");

      var response = await request.send();
      var resBody = await response.stream.bytesToString();

      // print("Response Status: ${response.statusCode}");
      // print("Response Body: $resBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("UPDATE ERROR: $e");
      return false;
    }
  }
}