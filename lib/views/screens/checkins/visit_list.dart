import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/api/checkin_controller.dart';
import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:get/get.dart';
import 'package:shrachi/views/screens/checkins/ExpensePage/expense_list.dart';

class VisitList extends StatefulWidget {
  final int tourPlanId;

  const VisitList({super.key, required this.tourPlanId});

  @override
  State<VisitList> createState() => _VisitListState();
}

class _VisitListState extends State<VisitList> {
  Visit? selectedVisit;
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final CheckinController _checkinController = Get.put(CheckinController());
  final ApiController apiController = Get.put(ApiController());


  Future<void> _pickDate({DateTime? startDate, DateTime? endDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: startDate ?? DateTime(2020),
      lastDate: endDate ?? DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiController.fetchTourPlans();
    });
  }
  void _showPendingRemarkDialog(Visit visit) {
    final TextEditingController remarkController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Pending Visit Cancel Reason",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: remarkController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enter your remarks here...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🔹 Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 🔹 Submit Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _checkinController.isLoading.value
                            ? null
                            : () async {
                          final remark = remarkController.text.trim();

                          if (remark.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a remark."),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context); // Close dialog
                          // Call API and refresh data
                          bool success =
                          await _checkinController.submitVisitRemark(
                            visitId: visit.id,
                            reason: remark,
                          );

                          if (success) {
                            // Refresh the tour plans to update UI
                             apiController.fetchTourPlans();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                Text("Remark submitted successfully."),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Failed to submit remark. Try again."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _checkinController.isLoading.value
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ): const Text("Submit"),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Obx(() {
            // ✅ Safely find tourPlan by ID
            final tour = apiController.tourPlanList.firstWhereOrNull(
              (tp) => tp.id == widget.tourPlanId,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tour != null)
                  Text(
                    "TOUR ID : ${tour.serial_no}",
                    style: const TextStyle(
                      color: Colors.white,
                      //fontSize: 16,
                    ),
                  ),
              ],
            );
          }),
        ),
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width:
                Responsive.isSm(context)
                    ? screenWidth
                    : Responsive.isXl(context)
                    ? screenWidth * 0.60
                    : screenWidth * 0.50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(() {
                final tour = apiController.tourPlanList.firstWhere(
                  (tp) => tp.id == widget.tourPlanId,
                );
                if (tour == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_dateController.text.isEmpty && tour.visits.isNotEmpty) {
                  _dateController.text = DateFormat(
                    'dd-MM-yyyy',
                  ).format(DateTime.parse(tour.visits.first.visitDate));
                }
                // ---------------- STEP 1: FILTER BY DATE ----------------
                final List<Visit> allVisits = tour.visits.where((visit) {
                  final visitDate =
                  DateFormat('dd-MM-yyyy').format(DateTime.parse(visit.visitDate));
                  return visitDate == _dateController.text;
                }).toList();

                // ---------------- STEP 2: COUNT STATUS ----------------
                final int pendingCount =
                    allVisits.where((v) => v.isApproved == 0).length;

                final int rejectCount =
                    allVisits.where((v) => v.isApproved == 2).length;

                // ---------------- STEP 3: CONDITION ----------------
                final bool hidePendingReject =
                    pendingCount > 0 || rejectCount > 0;

                // ---------------- STEP 4: FINAL VISITS ----------------
                final List<Visit> visits = hidePendingReject
                    ? allVisits
                    .where((v) => v.isApproved == 1 || v.isApproved == 3)
                    .toList()
                    : allVisits;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("Visit Summary",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: _dateController,
                      style: const TextStyle(color: Colors.black),
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: DateFormat('dd-MM-yyyy').format(
                          selectedDate ?? DateTime.parse(tour.startDate),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed:
                              () => _pickDate(
                                startDate: DateTime.parse(tour.startDate),
                                endDate: DateTime.parse(tour.endDate),
                              ),
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Select Visit",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    apiController.isLoading.value
                        ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        )
                        : Expanded(
                          child: visits.isEmpty
                                  ? Center(child: Text("No visits found"))
                                  : ListView.separated(
                                    itemCount: visits.length,
                                    separatorBuilder: (context, index) =>
                                    SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final visit = visits[index];

                                // 🔍 Show warning icon condition
                                final bool showWarningIcon = !visit.isCheckin &&
                                    !visit.hasCheckin &&
                                    (visit.Reject_reason == null || visit.Reject_reason!.isEmpty);

                                // 🔍 Check if visit has cancel reason
                                final bool hasCancelReason =
                                    visit.Reject_reason != null && visit.Reject_reason!.isNotEmpty;

                                return Card(
                                  color: Colors.grey[200],
                                  elevation: 6,
                                  shadowColor: Colors.black.withValues(alpha: 0.2),
                                  margin: const EdgeInsets.symmetric(vertical: 2),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // ⚠️ Warning icon for pending visits with no remark
                                      if (showWarningIcon)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.black,
                                            ),
                                            onPressed: () {
                                              _showPendingRemarkDialog(visit);
                                            },
                                          ),
                                        ),

                                      // 🟢 If visit is NOT canceled → show RadioListTile
                                      if (!hasCancelReason)
                                        RadioListTile(
                                          fillColor: WidgetStateProperty.all(Colors.red),
                                          value: visit,
                                          groupValue: selectedVisit,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedVisit = value;
                                            });
                                          },
                                          title: Column(
                                            spacing: 1,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name : ${visit.name}",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              Text(
                                                "Type : ${visit.type.replaceAll('_', ' ').toUpperCase()}",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              if (visit.type != 'new_lead' &&
                                                  visit.type != "followup_lead")
                                                Text(
                                                  "Purpose of Visit : ${visit.visitPurpose}",
                                                  style: const TextStyle(color: Colors.black),
                                                ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Status : ",
                                                    style: TextStyle(color: Colors.black),
                                                  ),

                                                  Text(
                                                    // ---- PRIORITY-BASED STATUS LOGIC ----
                                                    visit.hasCheckin == true
                                                        ? "CheckedOut"         // Priority 1
                                                        : visit.islatestcheck == true
                                                        ? "CheckedIn"       // Priority 2
                                                        : visit.isjourney == true
                                                        ? "Pending" // Priority 3
                                                        : visit.isCheckin == true
                                                        ? ""          // Priority 4
                                                        : "Pending",  // Priority 5

                                                    // ---- COLOR LOGIC ----
                                                    style: TextStyle(
                                                      color: visit.hasCheckin == true
                                                          ? Colors.green
                                                          : visit.islatestcheck == true
                                                          ? Colors.blue
                                                          : visit.isjourney == true
                                                          ? Colors.red
                                                          : Colors.red,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ) ,
                                            ],
                                          ),
                                          controlAffinity: ListTileControlAffinity.trailing,
                                        ),

                                      // 🔴 If visit has cancel reason → show remark text only (no radio)
                                      if (hasCancelReason)
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name : ${visit.name}",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              Text(
                                                "Type : ${visit.type.replaceAll('_', ' ').toUpperCase()}",
                                                style: const TextStyle(color: Colors.black),
                                              ),
                                              if (visit.type != 'new_lead' &&
                                                  visit.type != "followup_lead")
                                                Text(
                                                  "Purpose of Visit : ${visit.visitPurpose}",
                                                  style: const TextStyle(color: Colors.black),
                                                ),
                                              const SizedBox(height: 5),
                                              Text(
                                                "Cancel Reason: ${visit.Reject_reason}",
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }
                          ),
                        ),
                  ],
                );
              }),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          width: double.infinity,
          height: kBottomNavigationBarHeight,
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width:
                  Responsive.isMd(context) ? screenWidth : screenWidth * 0.40,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Prev"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed:
                        selectedVisit == null
                            ? null
                            : () async {
                              print("SelectVisit${selectedVisit!.islatestcheck}");
                              if (selectedVisit!.isCheckin == false) {
                                // CheckIn
                                await _checkinController.checkInVisit(
                                  Type: selectedVisit!.type,
                                  lat: selectedVisit?.lat ?? 0.0,
                                  lng: selectedVisit?.lng ?? 0.0,
                                  tourPlanId: widget.tourPlanId,
                                  visitId: selectedVisit!.id,
                                  hasCheckin: selectedVisit!.hasCheckin,
                                  islatestcheck: selectedVisit!.islatestcheck,
                                  startDate: DateFormat("dd-MM-yyyy").parse(_dateController.text),
                                );
                              } else if (selectedVisit!.isCheckin == true && selectedVisit!.hasCheckin == false) {
                                // OutCome
                                await _checkinController.checkInVisit(
                                  Type: selectedVisit!.type,
                                  lat: selectedVisit?.lat ?? 0.0,
                                  lng: selectedVisit?.lng ?? 0.0,
                                  tourPlanId: widget.tourPlanId,
                                  visitId: selectedVisit!.id,
                                  hasCheckin: selectedVisit!.hasCheckin,
                                  islatestcheck: selectedVisit!.islatestcheck,
                                  startDate: DateFormat("dd-MM-yyyy").parse(_dateController.text),
                                );
                              } else if (selectedVisit!.hasCheckin == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ExpenseList(
                                          tourPlanId: widget.tourPlanId,
                                          visitId: selectedVisit!.id,
                                          startDate: DateFormat("dd-MM-yyyy").parse(_dateController.text),
                                          //startDate: DateTime.parse(_dateController.text),
                                        ),
                                  ),
                                );
                              }
                            },
                    icon: Obx(() {
                      return _checkinController.isLoading.value
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          //: Text("Start Journey");
                         : const Icon(Icons.check, color: Colors.white);
                    }),
                    label: Text(
                      selectedVisit == null
                          ? "Select Visit"
                          : selectedVisit!.isjourney == false
                          ? "Start journey"
                          : !selectedVisit!.islatestcheck
                           ? "CheckIn"
                          //? ""
                          : selectedVisit!.isCheckin && !selectedVisit!.hasCheckin
                          ? "CheckOut"
                          : "Expense"
                          // ? ""
                          // : "Start journey",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedVisit == null
                              ? Colors.red
                              : selectedVisit!.isCheckin == false
                              ? Colors.blue
                              : selectedVisit!.isCheckin == true &&
                                  selectedVisit!.hasCheckin == false
                              ? Colors.orange
                              : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
