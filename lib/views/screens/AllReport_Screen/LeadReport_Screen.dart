import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/ReportController/LeadController.dart';
import '../multicolor_progressbar_screen.dart';

class LeadReportScreen extends StatelessWidget {
  final LeadController controller = Get.put(LeadController());

  Color getTourStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.grey;

    status = status.toLowerCase().trim();

    if (status == 'tour completed') {
      return Colors.green; // ✅ Completed = Green
    }

    if (status == 'tour partially completed') {
      return Colors.orange; // 🟠 Partially = Orange
    }

    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Pending Leads", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
          actions: [
            AnimatedRefreshIcon(
              onTap: () => controller.resetToTotalData(),
            ),
          ],
      ),
      body: Column(
        children: [
          // --- 1. Calendar/Date Picker Part ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _dateWidget("Start Date", controller.startDate, context)),
                const SizedBox(width: 12),
                Expanded(child: _dateWidget("End Date", controller.endDate, context)),
              ],
            ),
          ),

          // --- 2. Lead Data Cards ---
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: MultiColorCircularLoader(size: 40));
              }

              if (controller.leadsList.isEmpty) {
                return const Center(child: Text("No data found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.leadsList.length,
                itemBuilder: (context, index) {
                  final item = controller.leadsList[index];
                  return _tourMainCard(item); // 👈 MAIN CARD
                },
              );

            }),
          ),
        ],
      ),
    );
  }
  Widget _tourMainCard(Map<String, dynamic> item) {
    final tour = item['tour'];
    final List visits = item['visits'] ?? [];

    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔵 TOUR HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tour?['serial_no'] ?? "N/A",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getTourStatusColor(tour?['tour_status']).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tour?['tour_status'] ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: getTourStatusColor(tour?['tour_status']),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(),

            // 🔽 VISITS LIST (multiple cards)
            ...visits.map((visit) {
              return _visitInnerCard(visit, tour);
            }).toList(),
          ],
        ),
      ),
    );
  }
  Widget _visitInnerCard(dynamic visit, dynamic tour) {
    final lead = visit['lead'];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name : ${visit?['name'] ?? 'N/A'}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    lead?['lead_status']?['name']?.toUpperCase() ?? "OPEN",
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            //const SizedBox(height: 2),
            Text(
              "Contact Person : ${lead?['contact_person'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 14),
            ),
            Text("Phone : ${lead?['primary_no'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 12),
            ),
            Text("Type : ${lead?['lead_type'] ?? 'N/A'}",
                style: const TextStyle(fontSize: 12),
            ),
            Text("Address : ${lead?['address'] ?? 'N/A'}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 4),

            Text(
              "Tour Date : ${tour?['start_date'] != null
                  ? DateFormat('dd/MM/yy')
                  .format(DateTime.parse(tour['start_date']))
                  : 'N/A'}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Date Picker UI with Indian Format Display
  Widget _dateWidget(String label, RxString dateObs, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          // API ke liye yyyy-MM-dd format save kar rahe hain
          dateObs.value = DateFormat('yyyy-MM-dd').format(picked);
          controller.fetchLeads();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              // Display format: dd/MM/yy
              String displayText = label;
              if (dateObs.value.isNotEmpty) {
                displayText = DateFormat('dd/MM/yy').format(DateTime.parse(dateObs.value));
              }
              return Text(displayText, style: const TextStyle(fontSize: 13, color: Colors.black87));
            }),
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}