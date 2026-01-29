import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty;
  } catch (_) {
    return false;
  }
}


class NetworkHelper {
  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
