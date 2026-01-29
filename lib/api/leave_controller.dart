// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shrachi/api/api_const.dart';
// import 'package:shrachi/models/leave_model.dart';
// import 'package:shrachi/models/leave_type_model.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/screens/leaves/leaves_list.dart';
//
// class LeaveController extends GetxController {
//   final isLoading = false.obs;
//   final leaves = <LeaveModel>[].obs;
//   final leaveTypes = <LeaveTypeModel>[].obs;
//
//   Future<String> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("access_token") ?? "";
//   }
//
//   Future getAllLeaves() async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.get(
//         Uri.parse('$baseUrl$leave'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         leaves.value =
//             (body['data'] as List)
//                 .map((json) => LeaveModel.fromJson(json))
//                 .toList();
//       }
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future createLeave({
//     LeaveTypeModel? leadType,
//     DateTime? startDate,
//     DateTime? endDate,
//     required String reason,
//   }) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//
//       final res = await http.post(
//         Uri.parse('$baseUrl$leave'),
//         headers: {
//           "Authorization": "Bearer $token",
//           "Content-Type": "application/json",
//           // "Accept": "application/json",
//         },
//
//         body: jsonEncode({
//           "leave_types_id": leadType?.id,
//           "reason": reason,
//           "start_date": startDate?.toIso8601String().split('T').first,
//           "end_date": endDate?.toIso8601String().split('T').first,
//         }),
//       );
//
//       print(jsonDecode(res.body));
//       print(res.statusCode);
//
//       if (res.statusCode == 200) {
//         print("successFull");
//        }
//     } catch (e, stack) {
//       print(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future updateLeave({
//     required int id,
//     LeaveTypeModel? leaveType,
//     DateTime? startDate,
//     DateTime? endDate,
//     required String reason,
//   }) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.put(
//         Uri.parse('$baseUrl$leave/$id'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "leave_types_id": leaveType?.id,
//           "reason": reason,
//           'start_date': startDate?.toIso8601String().split('T').first,
//           'end_date': endDate?.toIso8601String().split('T').first,
//         }),
//       );
//
//       print(Uri.parse('$baseUrl$leave/$id'));
//       if (res.statusCode == 200) {
//         Get.to(() => LeavesList());
//       }
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future deleteLeave({int? id}) async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.delete(
//         Uri.parse('$baseUrl$leave/$id'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       print(res.statusCode);
//       if (res.statusCode == 200) {
//         Get.snackbar(
//           "Success",
//           "Leave deleted",
//           backgroundColor: ColorPalette.seaGreen600,
//         );
//         Get.to(() => LeavesList());
//       }
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future getLeaveTypes() async {
//     try {
//       isLoading.value = true;
//       final token = await getToken();
//       final res = await http.get(
//         Uri.parse('$baseUrl$leaveType'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );
//
//       if (res.statusCode == 200) {
//         final body = jsonDecode(res.body);
//         leaveTypes.value =
//             (body['data'] as List)
//                 .map((json) => LeaveTypeModel.fromJson(json))
//                 .toList();
//       }
//     } catch (e) {
//       print(e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/models/leave_model.dart';
import 'package:shrachi/models/leave_type_model.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/screens/leaves/leaves_list.dart';

class LeaveController extends GetxController {
  final isLoading = false.obs;
  final leaves = <LeaveModel>[].obs;
  final leaveTypes = <LeaveTypeModel>[].obs;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  Future getAllLeaves() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl$leave'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        leaves.value =
            (body['data'] as List)
                .map((json) => LeaveModel.fromJson(json))
                .toList();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future createLeave({
    LeaveTypeModel? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    required String reason,
    List<XFile>? images,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$leave'));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['leave_types_id'] = leaveType?.id.toString() ?? '';
      request.fields['reason'] = reason;
      if (startDate != null) {
        request.fields['start_date'] = startDate.toIso8601String().split('T').first;
      }
      if (endDate != null) {
        request.fields['end_date'] = endDate.toIso8601String().split('T').first;
      }

      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', img.path),
          );
        }
      }

      var response = await request.send();
      var resBody = await http.Response.fromStream(response);
      print(resBody.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.to(() => LeavesList());
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future updateLeave({
    required int id,
    LeaveTypeModel? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    required String reason,
    List<XFile>? images,
  }) async {
    try {
      isLoading.value = true;
      final token = await getToken();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$leave/$id'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['leave_types_id'] = leaveType?.id.toString() ?? '';
      request.fields['reason'] = reason;
      if (startDate != null) {
        request.fields['start_date'] = startDate.toIso8601String().split('T').first;
      }
      if (endDate != null) {
        request.fields['end_date'] = endDate.toIso8601String().split('T').first;
      }

      if (images != null && images.isNotEmpty) {
        for (var img in images) {
          request.files.add(
            await http.MultipartFile.fromPath('images[]', img.path),
          );
        }
      }

      var response = await request.send();
      var resBody = await http.Response.fromStream(response);
      print("leave error: ${resBody.body}");
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.to(() => LeavesList());
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteLeave({int? id}) async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.delete(
        Uri.parse('$baseUrl$leave/$id'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print(res.statusCode);
      if (res.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Leave deleted",
          backgroundColor: ColorPalette.seaGreen600,
        );
        Get.to(() => LeavesList());
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future getLeaveTypes() async {
    try {
      isLoading.value = true;
      final token = await getToken();
      final res = await http.get(
        Uri.parse('$baseUrl$leaveType'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        leaveTypes.value =
            (body['data'] as List)
                .map((json) => LeaveTypeModel.fromJson(json))
                .toList();
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
