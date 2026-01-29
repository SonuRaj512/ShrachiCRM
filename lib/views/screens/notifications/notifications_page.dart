import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrachi/api/notification_controller.dart';
import '../checkins/checkins_search.dart';
import '../multicolor_progressbar_screen.dart';
import '../tours/tours_list.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController notificationController = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Obx(() {
          if (notificationController.isLoading.value) {
            return const Center(
                child: MultiColorCircularLoader(size: 40,)
                //CircularProgressIndicator()
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await notificationController.getAllNotifications(),
            child: notificationController.notifications.isEmpty
                ? const Center(child: Text("No notifications"))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notificationController.notifications.length,
              itemBuilder: (context, index) {
                final notif = notificationController.notifications[index];
                bool isUnread = notif.readAt == null;

                return InkWell(
                    onTap: () {
                      final data = notif.data;
                      final String title = (data['title'] ?? '').toString().toLowerCase();

                      String extractedTpNo = '';

                      if (data['tour_plan_no'] != null) {
                        extractedTpNo = data['tour_plan_no'].toString();
                      } else if (title.contains('tp-')) {
                        int tpIndex = title.indexOf('tp-');
                        extractedTpNo = (data['title'] ?? '')
                            .toString()
                            .substring(tpIndex)
                            .replaceAll(')', '')
                            .trim();
                      }

                      // Mark as read
                      if (isUnread) {
                        notificationController.markAsRead(notif.id.toString());
                      }

                      if (title.contains('expense')) {
                        Get.to(() => CheckinsSearch(targetTourId: extractedTpNo));
                      }
                      else if (title.contains('follow')) {
                        // ✅ Follow-up notification
                        Get.to(() => CheckinsSearch(targetTourId: extractedTpNo));
                      }
                      else if (title.contains('tour') || title.contains('tp-')) {
                        Get.to(() => Tours(targetTourId: extractedTpNo));
                      }
                    },
                    // onTap: () {
                  //   final data = notif.data;
                  //   final String title = (data['title'] ?? '').toString().toLowerCase();
                  //
                  //   String extractedTpNo = '';
                  //
                  //   // Title se TP-XXXX nikalne ka logic
                  //   if (data['tour_plan_no'] != null) {
                  //     extractedTpNo = data['tour_plan_no'].toString();
                  //   } else if (title.contains('tp-')) {
                  //     int tpIndex = title.indexOf('tp-');
                  //     extractedTpNo = (data['title'] ?? '').toString().substring(tpIndex).trim();
                  //     extractedTpNo = extractedTpNo.replaceAll(')', '').trim();
                  //   }
                  //   //Mark as Read
                  //   if (isUnread) {
                  //     notificationController.markAsRead(notif.id.toString());
                  //   }
                  //   if (title.contains('expense')) {
                  //     // AB YE ERROR NAHI DEGA ✅
                  //     Get.to(() => CheckinsSearch(targetTourId: extractedTpNo));
                  //   }
                  //   else if (title.contains('follow-up')) {
                  //     Get.to(() => CheckinsSearch(targetTourId: extractedTpNo));
                  //   }
                  //   else if (title.contains('tour') || title.contains('tp-')) {
                  //     Get.to(() => Tours(targetTourId: extractedTpNo));
                  //   }
                  // },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUnread ? Colors.blue.withOpacity(0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isUnread ? Colors.blue : Colors.grey.shade300,
                        width: isUnread ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notif.data['title'] ?? 'Notification',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notif.data['message'] ?? '',
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        if (isUnread)
                          const Icon(Icons.circle, color: Colors.red, size: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}