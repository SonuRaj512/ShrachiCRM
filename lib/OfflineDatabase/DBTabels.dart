// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import '../api/api_services.dart';
// import '../models/ExpenseModel/ExpenseReport.dart';
// import 'ConnectivityService.dart';
// import 'DBHelper.dart';
//
// class TourController extends GetxController {
//   var tourPlanList = <TourPlan>[].obs;
//   var isLoading = false.obs;
//   var errorMessage = ''.obs;
//
//   final DatabaseHelper db = DatabaseHelper();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchTourPlans();
//   }
//
//   Future<void> fetchTourPlans() async {
//     isLoading.value = true;
//     try {
//       bool online = await ConnectivityService.hasInternet();
//       if (online) {
//         // ✅ API call
//         var plans = await ApiService().fetchTourPlans();
//         tourPlanList.assignAll(plans);
//         await db.saveTourPlans(plans); // save locally
//       } else {
//         // ✅ Offline mode
//         var plans = await db.getTourPlans();
//         tourPlanList.assignAll(plans);
//       }
//     } catch (e) {
//       errorMessage.value = e.toString();
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> addTourPlan(TourPlan plan) async {
//     tourPlanList.add(plan);
//     await db.saveTourPlans(tourPlanList);
//
//     if (await ConnectivityService.hasInternet()) {
//       await ApiService().addTourPlan(plan); // server sync
//     }
//   }
//
//   Future<void> updateTourPlan(TourPlan plan) async {
//     int index = tourPlanList.indexWhere((p) => p.id == plan.id);
//     if (index != -1) {
//       tourPlanList[index] = plan;
//       await db.saveTourPlans(tourPlanList);
//     }
//     if (await ConnectivityService.hasInternet()) {
//       await ApiService().updateTourPlan(plan);
//     }
//   }
//
//   Future<void> deleteTourPlan(int id) async {
//     tourPlanList.removeWhere((p) => p.id == id);
//     await db.saveTourPlans(tourPlanList);
//     if (await ConnectivityService.hasInternet()) {
//       await ApiService().deleteTourPlan(id);
//     }
//   }
// }
