import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import 'DBHelper.dart';

  // Check if device has any active internet connection
   Future<bool> hasInternet() async {
    var result = await (Connectivity().checkConnectivity());
    // In latest version connectivity_plus returns a List
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

class ConnectivityService extends GetxService {
  var isOnline = false.obs;
  bool _previouslyOnline = false;
  Timer? _syncTimer;
  bool _isSyncing = false; // To prevent overlapping syncs
  bool _isUpdatingStatus = false; // SONU RAJ: Added to prevent concurrent status updates

  @override
  Future<void> onInit() async {
    super.onInit();
    await _checkInitialConnectivity();
    Connectivity().onConnectivityChanged.listen(_handleConnectivityChanged);

    // 🔥 GLOBAL TIMER: Yeh app mein kahin bhi rahe, har 30 sec mein sync check karega
    _startGlobalSyncTimer();
  }

  void _startGlobalSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (isOnline.value && !_isSyncing) {
        print("GLOBAL TIMER: Triggering background sync...");
        _performSync();
      }
    });
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;
    try {
      _isSyncing = true;
      await DatabaseHelper.instance.syncAllData();
    } catch (e) {
      print("Sync Error: $e");
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    await _updateConnectionStatus(connectivityResult);
  }

  // SONU RAJ: Added error handling for connectivity changes
  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    // Async call karein but await nahi karein (listener expects void)
    _updateConnectionStatus(results).catchError((error) {
      print("Error updating connection status: $error");
    });
  }

  // SONU RAJ: Enhanced connectivity check with actual internet verification and race condition fix
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    // SONU RAJ: Prevent concurrent execution to avoid race conditions
    if (_isUpdatingStatus) {
      print("⚠️ Connection status update already in progress, skipping...");
      return;
    }

    try {
      _isUpdatingStatus = true;

      // Pehle network connectivity check karein
      final bool hasNetworkConnection = results.any((result) =>
      result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);

      // SONU RAJ: Added actual internet verification (not just network connectivity)
      bool nowOnline = false;
      if (hasNetworkConnection) {
        nowOnline = await hasInternet();
        print("🌐 Network Connected: $hasNetworkConnection, Internet Available: $nowOnline");
      } else {
        print("❌ No Network Connection");
      }

      // Jab offline se online aaye tab turant sync trigger karein
      if (!_previouslyOnline && nowOnline) {
        print("✅ Internet Restored → Immediate Sync Triggered");
        _performSync();
      }

      isOnline.value = nowOnline;
      _previouslyOnline = nowOnline;
    } finally {
      _isUpdatingStatus = false;
    }
  }

  @override
  void onClose() {
    _syncTimer?.cancel(); // App close hone par timer stop
    super.onClose();
  }
}