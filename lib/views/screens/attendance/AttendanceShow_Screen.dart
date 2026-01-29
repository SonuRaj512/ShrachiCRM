import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/attendance_controller.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final int attendanceId;

  const AttendanceDetailScreen({
    super.key,
    required this.attendanceId,
  });

  @override
  State<AttendanceDetailScreen> createState() =>
      _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  final AttendanceController controller = Get.find<AttendanceController>();
  String? clockInAddress;
  String? clockOutAddress;

  @override
  void initState() {
    super.initState();

    controller.getAttendanceById(widget.attendanceId).then((_) async {
      final data = controller.attendanceDetail.value;

      if (data != null) {
        clockInAddress = await _getAddressFromLatLng(
          data.clockInLat,
          data.clockInLng,
        );

        clockOutAddress = await _getAddressFromLatLng(
          data.clockOutLat,
          data.clockOutLng,
        );

        setState(() {});
      }
    });
  }

  String formatAddress(String? address) {
    if (address == null || address.isEmpty) return "Loading...";
    return address.replaceAll(", ", ",\n");
  }

  Future<String> _getAddressFromLatLng(String lat, String lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(lat),
        double.parse(lng),
      );

      final place = placemarks.first;

      return "${place.street}, ${place.subLocality}, "
          "${place.locality}, ${place.administrativeArea}, "
          "${place.postalCode}";
    } catch (e) {
      return "Location not found";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
          title: Text("Attendance Details",style: TextStyle(color: Colors.white),),
      ),
      body: Obx(() {
        if (controller.detailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.attendanceDetail.value;

        if (data == null) {
          return const Center(child: Text("No data found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row(
                "Date",
                DateFormat('dd MMM yyyy').format(DateTime.parse(data.createdAt)),
              ),
              const Divider(),

              _row(
                "Clock In",
                DateFormat('hh:mm a').format(DateTime.parse(data.clockIn)),
              ),
              _row(
                "Clock Out",
                DateFormat('hh:mm a').format(DateTime.parse(data.clockOut)),
              ),

              const Divider(),

              _row("Total Time", data.totalTime),
              _row("Break Time", data.breakTime),
              _row("Working Time", data.workingTime),

              const Divider(),

              const Text(
                "Location Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 8),
          Container(
            margin:
            const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              Colors.orange.withOpacity(0.08),
              borderRadius:
              BorderRadius.circular(12),
            ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ClockIn Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                formatAddress(clockInAddress),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "ClockOut Address",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 32.0),
                              child: Text(
                                formatAddress(clockOutAddress),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
              const Divider(),
              const Text(
                "Break Details",
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),

              data.breaks.isEmpty
                  ? const Text("No breaks taken")
                  : Column(
                children: data.breaks.map((brk) {
                  return Container(
                    margin:
                    const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.08),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _row(
                          "Start",
                          DateFormat('hh:mm a')
                              .format(DateTime.parse(
                              brk.breakStart)),
                        ),
                        _row("End", DateFormat('hh:mm a')
                              .format(DateTime.parse(
                              brk.breakEnd)),
                        ),
                        _row(
                          "Duration",
                          "${brk.durationSeconds}",
                        ),
                        _row("Break Reason", brk.breakType),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget _row(String title, String value) {
  //   final bool isLongText = value.split(' ').length > 2;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(title, style: TextStyle(color: Colors.black)),
  //         Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  //       ],
  //     ),
  //   );
  // }

  String _truncateWords(String text, {int limit = 4}) {
    final words = text.split(' ');
    if (words.length <= limit) return text;
    return words.take(limit).join(' ') + '...';
  }

  Widget _row(String title, String value) {
    final bool isLongText = value.split(' ').length > 4;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // FIX: vertical extra space issue
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
          ),

          // FIX: spaceBetween ki jagah Spacer use kiya
          const Spacer(),

          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: isLongText
                  ? () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(title),
                    content: SingleChildScrollView(
                      child: Text(value),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }
                  : null,
              child: Text(
                isLongText ? _truncateWords(value) : value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right, // OPTIONAL: right alignment
              ),
            ),
          ),
        ],
      ),
    );
  }
}
