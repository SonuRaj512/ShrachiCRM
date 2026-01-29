import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../OfflineDatabase/DBHelper.dart';
import '../../utils/internet_helper.dart';
import '../../views/screens/LogoutSession_Screen/SyncProgressScreen.dart';
import '../api_controller.dart';

class LogoutFlowController extends GetxController {
  var syncing = false.obs;
  var synced = 0.obs;
  var total = 0.obs;

  final db = DatabaseHelper.instance;
  final auth = Get.find<ApiController>();

  Future<void> startLogoutFlow() async {
    final online = await hasInternet();
    if (!online) {
      Get.snackbar("No Internet",
          "Please turn on internet to sync offline data");
      return;
    }

    await _syncOfflineData();
    await auth.logout();
  }

  Future<void> _syncOfflineData() async {
    syncing.value = true;
    Get.to(() => const SyncProgressScreen());

    // Count pending
    final database = await db.database;
    final checkins = await database.query('offline_checkin');
    final checkouts = await database.query('offline_checkout');

    total.value = checkins.length + checkouts.length;

    if (total.value == 0) {
      syncing.value = false;
      Get.back();
      return;
    }

    await db.syncAllData();
    synced.value = total.value;

    syncing.value = false;
    Get.back();
  }
}
