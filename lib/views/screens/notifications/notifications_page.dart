import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrachi/api/notification_controller.dart';
import 'package:shrachi/views/enums/responsive.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationController notificationController = Get.put(NotificationController(),);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.getAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Notifications"),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Obx(() {
            return notificationController.isLoading.value
                ? Center(child: CircularProgressIndicator(color: Colors.green))
                : SizedBox(
                  width:
                      Responsive.isSm(context)
                          ? screenWidth
                          : Responsive.isXl(context)
                          ? screenWidth * 0.60
                          : screenWidth * 0.40,
                  child:
                      notificationController.notifications.isEmpty
                          ? Center(
                            child: Text(
                              'No notifications',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            itemCount:
                                notificationController.notifications.length,
                            itemBuilder: (context, index) {
                              final notif =
                                  notificationController.notifications[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notif.data['title'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            notif.data['serial_no'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (notif.readAt == null)
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 10,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                );
          }),
        ),
        backgroundColor: Colors.grey[100],
      ),
    );
  }
}
