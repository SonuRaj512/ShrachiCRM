import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/api/attendance_controller.dart';
import 'package:shrachi/views/screens/auth/login.dart';
import '../OfflineDatabase/DBHelper.dart';
import '../models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/HoModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
import '../models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/TourPlanRequestModel.dart';
import '../models/TourPlanModel/CreateTourPlanModel/WharehouseModel.dart';
import '../models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import '../models/TourPlanModel/lead_status_model.dart';
import '../utils/internet_helper.dart' as ConnectivityService;
import '../views/screens/CustomErrorMessage/CustomeErrorMessage.dart';
import 'api_hendler.dart';
import 'api_services.dart';

class ApiController extends GetxController with WidgetsBindingObserver {
  final _apiHelper = ApiHandler();
  var isLoading = false.obs;
  var dealers = <Dealer>[].obs;
  var Warehouse = <WarehouseModel>[].obs;
  var selectedDealer = Rxn<Dealer>();
  var selectedWarehouse = Rxn<WarehouseModel>();
  var hoData = Rxn<HoModel>();
  var leadTypes = <LeadTypeModel>[].obs;
  var selectedLeadType = Rxn<LeadTypeModel>();
  var leadbusiness = <LeadBusinessModel>[].obs;
  var selectedbusiness = Rxn<LeadBusinessModel>();
  var leadSource = <LeadSourceModel>[].obs;
  var selectedLeadSource = Rxn<LeadSourceModel>();
  var isSubmitting = false.obs;
  var hoDetails = Rxn<HoModel>();
  var tourPlanList = <TourPlan>[].obs; // List of tour
  var errorMessage = ''.obs; // Error message
  var allTourPlansForSearch = <TourPlan>[]; //// Backup original list
  // 🔹 Lead Status
  var leadStatuses = <LeadStatus>[].obs;
  var isLoadingStatus = false.obs;
  // 🔹 Leads
  var leads = <Visit>[].obs;
  var isLoadingLeads = false.obs;
  Timer? _midnightTimer;


  TextEditingController searchController = TextEditingController();

  final ApiService _apiservice = ApiService();
  final AttendanceController _attendanceController = Get.put(AttendanceController());

  @override
  void onInit() {
    super.onInit();
    // fetchDealers();
    fetchwarehouses();
    fetchHoData();
    fetchLeadTypes();
    fetchLeadSource();
    fetchTourPlans();
    fetchLeadStatuses();
    fetchLeadsForSearch();
    fetchBusinesses();
    monitorInternet();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  Future<void> loginUser(String email, String password, String UId) async {
    // Validation Check
    if (email.isEmpty || password.isEmpty || UId.isEmpty) {
      showTopPopup("Error", "Please enter email and password", Colors.red);
      return;
    }

    try {
      isLoading.value = true;

      var url = Uri.parse("$baseUrl$loginapi");

      var response = await http.post(
        url,
        body: {
          "email": email,
          "password": password,
          "device_unique_id": UId,
        },
      ).timeout(const Duration(seconds: 20));

      var data = jsonDecode(response.body);
      // 🔹 API MESSAGE HANDLING (ADD THIS)
      String apiMessage = data["message"] ?? data["error"] ?? "";
      if (response.statusCode == 200 && data["token"] != null) {
        // Save Token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", data["token"]);
        String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await prefs.setString("last_session_date", today);
        print("Login successful! Session date saved: $today");
        // SUCCESS POPUP
        showTopPopup(
          "Success", apiMessage.isNotEmpty
              ? apiMessage // <-- API MESSAGE FIRST
              : "Login successfully", // <-- FALLBACK STATIC MESSAGE
          Colors.green,
        );
        // Navigate to Dashboard
        Get.offAllNamed("/Dasboard");
      } else {
        // INVALID CREDENTIALS POPUP
        showTopPopup(
          "Message",
          apiMessage.isNotEmpty ? apiMessage : "Invalid credentials",
          Colors.red,
        );
      }
    }
    // ❌ NO INTERNET
    on SocketException {
      showTopPopup("No Internet", "Please check your internet connection", Colors.red);
    }
    // ⏱ SERVER TIMEOUT
    on TimeoutException {
      showTopPopup("Timeout", "Server is taking too long", Colors.orange);
    }
    // ❌ ANY OTHER ERROR
    catch (e) {
      showTopPopup("Error", "Something went wrong. Please try again", Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> sendResetLink(String email) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("$baseUrl$forgetpassword");

      final response = await http.post(
        url,
        body: {
          "email": email,
        },
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password reset link sent",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", "Unable to send reset link",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
  Future logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoading.value = true;
      final token = prefs.get("access_token");
      var url = Uri.parse("$baseUrl$logoutApi");
      if (_attendanceController.isRunning.value) {
        await _attendanceController.clockOut();
      }
      var res = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Logout Sucessful${res.body}");
      if (res.statusCode == 200) {
        Get.offAll(() => Login());
        prefs.remove('access_token');
      }
    } catch (e) {
      // print("❌ Error creating tour plan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTourPlan(TourPlanRequest request) async {
    try {
      isLoading.value = true;
      final response = await _apiservice.postTourPlan(request);
       print("✅ Tour Plan Created: $response");
    } catch (e) {
       print("❌ Error creating tour plan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDealers() async {
    try {
      isLoading(true);
      final result = await ApiService.fetchDealers();
      dealers.value = result;
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void setSelectedDealer(Dealer dealer) {
    selectedDealer.value = dealer;
  }

  ///get warehouse data ik
  Future<void> fetchwarehouses() async {
    try {
      isLoading(true);
      final results = await ApiService.fetchWarehouse();
      Warehouse.value = results;
      // print("asdfgnvczsw :- $results");
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void setSelectedwarehouse(WarehouseModel warehouse) {
    selectedWarehouse.value = warehouse;
  }

  Future<void> fetchHoData() async {
    try {
      isLoading(true);
      final data = await _apiHelper.getHOData(); // Map return hoga
      hoData.value = HoModel.fromJson(data); // Model me convert
    } catch (e) {
      print("Error: $e");
      hoData.value = null;
    } finally {
      isLoading(false);
    }
  }

  //LeadBusiness
  Future<void> fetchBusinesses() async {
    try {
      isLoading.value = true;
      final result = await _apiservice.getLeadBusinesses();
      leadbusiness.assignAll(result);

      if (result.isNotEmpty) {
        // ensure first item assign ho jaye
        selectedbusiness.value = leadbusiness.first;
      } else {
        selectedbusiness.value = null; // empty list case
      }
    } catch (e) {
      // print("Error fetching businesses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void BusinessessetSelected(LeadBusinessModel? value) {
    selectedbusiness.value = value;
  }

  //LeadType
  void fetchLeadTypes() async {
    try {
      isLoading(true);
      var types = await _apiservice.fetchLeadType();
      leadTypes.assignAll(types);
    } catch (e) {
      print("Error fetching lead types: $e");
    } finally {
      isLoading(false);
    }
  }

  void setSelected(LeadTypeModel? type) {
    selectedLeadType.value = type;
  }

  //leadsource
  void fetchLeadSource() async {
    try {
      isLoading(true);
      var types = await _apiservice.fetchLeadSources();
      leadSource.assignAll(types);
    } catch (e) {
      print("Error fetching lead types: $e");
    } finally {
      isLoading(false);
    }
  }

  void setSelecteds(LeadSourceModel? type) {
    selectedLeadSource.value = type;
  }

  //lead final data api me submit
  Future<void> submitTourPlan({
    required String token,
    required String leadName,
    required String phone,
    required String contactPerson,
    required String state,
    required String city,
    required String currentBusiness,
    required String leadType,
    required String leadTypeOther,
    required String leadSource,
    required String leadSourceOther,
  }) async {
    try {
      isSubmitting.value = true;

      final response = await http.post(
        Uri.parse("${baseUrl}tourplans"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "lead_name": leadName,
          "phone": phone,
          "contact_person": contactPerson,
          "state": state,
          "city": city,
          "current_business": currentBusiness,
          "lead_type": leadType,
          "lead_type_other": leadTypeOther,
          "lead_source": leadSource,
          "lead_source_other": leadSourceOther,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == true) {
          // 🔹 Success Snackbar
          Get.snackbar(
            "Success ✅",
            data["messages"] ?? "Tour Plan submitted successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          // ✅ Next page navigate
          Get.offAllNamed("/CreatePlan"); // ya aap jo bhi page chahte ho
        }
        // else {
        //   Get.snackbar(
        //     "Failed ❌",
        //     data["message"] ?? "Something went wrong",
        //     snackPosition: SnackPosition.BOTTOM,
        //     backgroundColor: Colors.red,
        //     colorText: Colors.white,
        //   );
        // }
      }
      // else {
      //   Get.snackbar(
      //     "Error ❌",
      //     "Server error: ${response.statusCode}",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //     colorText: Colors.white,
      //   );
      // }
    } catch (e) {
      // Get.snackbar(
      //   "Exception ❌",
      //   e.toString(),
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> getHoDetails(String token) async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse("${baseUrl}ho"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["status"] == true) {
          hoDetails.value = HoModel.fromJson(jsonData["data"]);
        }
      }
      // else {
      //   Get.snackbar("Error", "Failed to load HO Details");
      // }
    } catch (e) {
      // Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  // void fetchTourPlans() async {
  //   try {
  //     isLoading(true);
  //     errorMessage('');
  //     var plans = await _apiservice.fetchTourPlans();
  //     allTourPlansForSearch = plans;
  //     tourPlanList.assignAll(plans);
  //   } catch (e, stack) {
  //     errorMessage("Failed to load tour plans: ${stack.toString()}");
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  // 1. Fetch Logic: Check Internet -> Fetch from API or SQFlite
  Future<void> fetchTourPlans() async {
    try {
      isLoading(true);
      bool isOnline = await ConnectivityService.hasInternet();

      if (isOnline) {
        // ONLINE: Get from API
        var plans = await _apiservice.fetchTourPlans();
        tourPlanList.assignAll(plans);
        allTourPlansForSearch = plans;

        // Save to Local DB Cache
        List<Map<String, dynamic>> jsonData = plans.map((e) => e.toJson()).toList();
        await DatabaseHelper.instance.saveTourPlans(jsonData);
      } else {
        // OFFLINE: Get from SQFlite
        var offlineData = await DatabaseHelper.instance.getTourPlans();
        var plans = offlineData.map((json) => TourPlan.fromJson(json)).toList();
        tourPlanList.assignAll(plans);
        allTourPlansForSearch = plans;

        Get.snackbar("Offline Mode", "Displaying cached data",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  // 2. Monitoring Internet: Auto-sync when internet returns
  void monitorInternet() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!results.contains(ConnectivityResult.none)) {
        // Internet is back! Start syncing pending actions
        syncDataToServer();
      }
    });
  }

  // 3. Sync Logic: Send local changes to API
  Future<void> syncDataToServer() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> pending = await db.query('pending_sync');

    if (pending.isEmpty) return;

    print("Internet Found! Syncing ${pending.length} items to server...");

    for (var item in pending) {
      try {
        String action = item['action_type'];
        var payload = jsonDecode(item['payload']);
        int rowId = item['id'];

        bool success = false;
        // Call specific API based on action type
        if (action == 'INSERT') {
          // success = await _apiService.addTour(payload);
          success = true; // Set to true after actual API call
        } else if (action == 'UPDATE') {
          // success = await _apiService.updateTour(payload);
          success = true;
        } else if (action == 'DELETE') {
          // success = await _apiService.deleteTour(item['tour_id']);
          success = true;
        }

        if (success) {
          // Remove from local queue if API was successful
          await db.delete('pending_sync', where: 'id = ?', whereArgs: [rowId]);
        }
      } catch (e) {
        print("Sync failed for item: $e");
      }
    }
    fetchTourPlans(); // Refresh list from server
  }

  // 4. Offline CRUD Logic: Perform action locally if offline
  Future<void> handleAction(String actionType, TourPlan plan) async {
    bool isOnline = await ConnectivityService.hasInternet();

    if (isOnline) {
      // Perform API call directly
      fetchTourPlans();
    } else {
      // Add to SQFlite queue
      await DatabaseHelper.instance.addToSyncQueue(actionType, plan.id, plan.toJson());

      // Update UI immediately (Offline-First)
      if (actionType == 'INSERT') tourPlanList.add(plan);

      Get.snackbar("Offline", "Saved locally. Syncing will happen when online.");
    }
  }

  // Search function (Works offline because it searches the local list)
  void filterSearchResults(String query) {
    if (query.isEmpty) {
      tourPlanList.assignAll(allTourPlansForSearch);
    } else {
      tourPlanList.assignAll(allTourPlansForSearch.where((plan) =>
          plan.serial_no!.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }
  // Future<void> fetchTourPlans() async {
  //   try {
  //     isLoading(true);
  //     errorMessage('');
  //     var plans = await _apiservice.fetchTourPlans();
  //
  //     // ✅ Pehle data assign karo
  //     tourPlanList.assignAll(plans);
  //     allTourPlansForSearch = plans;
  //
  //     // ✅ Ab loading false karo
  //   } catch (e, stack) {
  //     errorMessage("Failed to load tour plans: ${stack.toString()}");
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  //
  // void filterSearchResults(String query) {
  //   if (query.isEmpty) {
  //     tourPlanList.assignAll(allTourPlansForSearch);
  //   } else {
  //     tourPlanList.assignAll(
  //       allTourPlansForSearch.where((plan) {
  //         final visitName = plan.visitName?.toLowerCase() ?? '';
  //         final serialNo = plan.serial_no?.toLowerCase() ?? '';
  //         final status = plan.status.toLowerCase();
  //
  //         return plan.id.toString().contains(query) ||
  //             status.contains(query.toLowerCase()) ||
  //             visitName.contains(query.toLowerCase()) ||
  //             serialNo.contains(query.toLowerCase());
  //       }).toList(),
  //     );
  //   }
  // }


  // Helper function to format date range string
  String formatDateRange(String startDateStr, String endDateStr) {
    try {
      DateTime startDate = DateFormat("yyyy-MM-dd").parse(startDateStr);
      DateTime endDate = DateFormat("yyyy-MM-dd").parse(endDateStr);
      return '${DateFormat('dd MMM, yyyy').format(startDate)} - ${DateFormat('dd MMM, yyyy').format(endDate)}';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> fetchLeadStatuses() async {
    try {
      isLoadingStatus.value = true;
      final result = await _apiservice.getLeadStatuses();
      leadStatuses.value = result;
    } catch (e) {
      print("Error fetching lead statuses: $e");
    } finally {
      isLoadingStatus.value = false;
    }
  }

  Future fetchLeadsForSearch({String query = ""}) async {
    // This returns the list to be used by direct async calls (DropdownSearch)
    try {
      isLoadingLeads.value = true;
      final result = await _apiservice.getLeads(query: query);
      leads.value = result;
      return result;
    } catch (e) {
      print("Error fetching leads: $e");
      return [];
    } finally {
      isLoadingLeads.value = false;
    }
  }

  @override
  void onClose() {
    _midnightTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
