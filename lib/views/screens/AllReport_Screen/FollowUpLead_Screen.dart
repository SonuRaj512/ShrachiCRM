import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/ReportController/LeadController.dart';
import '../multicolor_progressbar_screen.dart';

class FollowupLeadScreen extends StatelessWidget {
  final LeadController controller = Get.put(LeadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Followup Leads", style: TextStyle(color: Colors.white)),
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
          // Calendar Selection Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _buildDatePicker("Start Date", controller.startDate, context)),
                const SizedBox(width: 12),
                Expanded(child: _buildDatePicker("End Date", controller.endDate, context)),
              ],
            ),
          ),

          // Data List Section
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const Center(child: MultiColorCircularLoader(size: 40));
              if (controller.followupList.isEmpty) return const Center(child: Text("No Data Found"));

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.followupList.length,
                itemBuilder: (context, index) {
                  return _buildFollowupCard(controller.followupList[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Date Picker with logic to call API only when both dates are picked
  Widget _buildDatePicker(String label, RxString dateObs, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          // Store API compatible format internally
          dateObs.value = DateFormat('yyyy-MM-dd').format(picked);

          // Only trigger API fetch when user has selected both Start and End dates
          if (controller.startDate.value.isNotEmpty && controller.endDate.value.isNotEmpty) {
            controller.fetchFollowupLeads();
          }
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
              // Display Indian format (dd/MM/yy) to the user
              String textToShow = label;
              if (dateObs.value.isNotEmpty) {
                textToShow = DateFormat('dd/MM/yy').format(DateTime.parse(dateObs.value));
              }
              return Text(textToShow, style: const TextStyle(fontSize: 13, color: Colors.black87));
            }),
            const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  // UI for the individual cards fetching from nested JSON
  Widget _buildFollowupCard(dynamic item) {
    var tour = item['tour'];
    var visitsList = item['visits'] as List?;
    var lead = (visitsList != null && visitsList.isNotEmpty) ? visitsList[0]['lead'] : null;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display Serial Number from 'tour' object
                Text("${tour?['serial_no'] ?? 'N/A'}",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 15)),

                // Display Status from 'lead' object
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(lead?['lead_status']?['name']?.toUpperCase() ?? "OPEN",
                      style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(height: 20),

            _infoRow(Icons.person, "Contact Person: ", lead?['contact_person'] ?? "N/A"),
            _infoRow(Icons.phone, "Contact: ", lead?['primary_no'] ?? "N/A"),
            _infoRow(Icons.location_on, "Address: ", lead?['address'] ?? "No address"),

            // Display Tour Date in Indian format (dd/MM/yy)
            _infoRow(Icons.event, "Tour Date: ",
                tour?['start_date'] != null
                    ? DateFormat('dd/MM/yy').format(DateTime.parse(tour['start_date']))
                    : "N/A"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Colors.black54))),
        ],
      ),
    );
  }
}