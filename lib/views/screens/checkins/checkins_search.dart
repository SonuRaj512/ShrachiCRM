import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/views/components/tour_plan_widget.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/checkins/visit_list.dart';
import 'package:get/get.dart';
import '../multicolor_progressbar_screen.dart';
import 'ExpeAndOutcome/SendForApproval_Screen.dart';

class CheckinsSearch extends StatefulWidget {
  final targetTourId;
  const CheckinsSearch({super.key, this.targetTourId});

  @override
  State<CheckinsSearch> createState() => _CheckinsSearchState();
}

class _CheckinsSearchState extends State<CheckinsSearch> {
  final _searchController = TextEditingController();
  final ApiController controller = Get.put(ApiController());
  @override
  void initState() {
    print("Approved search Id okkkkkkkkkkkkkkkkkkkkkkkkkkkkkk: ${widget.targetTourId}");

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTourPlans();
      //notification ID
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await controller.fetchTourPlans();
    if (widget.targetTourId != null && widget.targetTourId!.isNotEmpty) {
      String idToSearch = widget.targetTourId!;
      setState(() {
        _searchController.text = idToSearch;
      });

      controller.filterSearchResults(idToSearch);
      print("Filtering for notification ID: $idToSearch");
    }
  }

  Future<void> _handleRefresh() async {
    await controller.fetchTourPlans();
    if (_searchController.text.isNotEmpty) {
      controller.filterSearchResults(_searchController.text);
    }
  }

  /// ✅ FINAL SEND FOR APPROVAL VALIDATION
  bool _allVisitsCheckedOut(dynamic tourItem) {
    if (tourItem.visits == null || tourItem.visits.isEmpty) {
      return false;
    }

    /// 🔥 STEP 1: Count ONLY Approved visits
    final approvedVisits = tourItem.visits.where((visit) {
      return visit.isApproved == 1; // ✅ Approved only
    }).toList();

    /// 🔥 STEP 2: Agar ek bhi approved visit nahi → button nahi
    if (approvedVisits.isEmpty) return false;

    /// 🔥 STEP 3: Sab approved visits checked-out hone chahiye
    return approvedVisits.every((visit) => visit.hasCheckin == true);
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Alert",style: TextStyle(color: Colors.red),),
        content: Text(msg),
        actions: [
          TextButton(
            child: Text("OK",style: TextStyle(color: Colors.black),),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
  Color _expenseStatusColor(String? status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "partial":
        return Colors.orange;
      case "pending":
        return Colors.blue;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  ///Alert dialog lock screen
  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Ionicons.lock_closed, color: Colors.red),
            SizedBox(width: 10),
            Text("Access Denied"),
          ],
        ),
        content: Text(
          "This Check-In Visit is locked and cannot be accessed because the expenses have been fully approved.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// ✅ Converts "2026-01-10 05:30:00.000" → "10 Jan, 2026"
  String formatApiDateNoTime(String date) {
    final DateTime parsed = DateTime.parse(date);
    // ⛔ Time ignore, only date used
    final DateTime onlyDate = DateTime(parsed.year, parsed.month, parsed.day);
    return DateFormat('d MMM, yyyy').format(onlyDate);
  }

  /// ✅ Removes time & returns pure date
  DateTime onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          ///title: const Text('Check In (New)'),
          title: Center(child: Text('Approved Tour Summary',style: TextStyle(color: Colors.white),)),
          leading: Navigator.canPop(context)
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ) : null,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMd(context) ? 5 : 25,
                ),
                child: Align(
                  alignment: Responsive.isMd(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: SizedBox(
                    width: Responsive.isMd(context)
                        ? screenWidth
                        : screenWidth / 4,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        controller.filterSearchResults(value.trim());
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Ionicons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        hintText: 'Search by Tour ID',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              // 🟢 Tour List
              Expanded(
                child: RefreshIndicator.noSpinner(
                  //color: ColorPalette.seaGreen600,
                  onRefresh: _handleRefresh,
                  // color: Colors.white,
                  // backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      /// ✅ TOUR FILTER (CONFIRMED + PARTIAL APPROVED)
                      final tourPlan = controller.tourPlanList.where((plan) {
                        return plan.status == 'confirmed' || plan.status == 'partially approved';
                      }).toList();

                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: MultiColorCircularLoader(size: 40)
                            //CircularProgressIndicator(color: Colors.green),
                          ),
                        );
                      }
                      final today = DateTime.now();
                      return Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(tourPlan.length, (index) {
                          final item = tourPlan[index];
                          // ✅ API date converted to local DateTime
                          final start = onlyDate(DateTime.parse(item.startDate));
                          final end = onlyDate(DateTime.parse(item.endDate));
                          final today = onlyDate(DateTime.now());

                          final totalDays = end.difference(start).inDays + 1;
                          final dayText = totalDays == 1 ? "Day" : "Days";
                          // 1. Logic to check if locked
                          bool isLocked = item.expenseOverallStatus?.status.toLowerCase() == 'confirmed';

                          bool isPast = end.isBefore(today);
                          bool isCurrent = today.isAtSameMomentAs(start) ||
                                  today.isAfter(start) && today.isBefore(end) ||
                                  today.isAtSameMomentAs(end);
                          VoidCallback onTapFunction;
                          if (isCurrent || isPast) {
                            onTapFunction = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VisitList(tourPlanId: item.id),
                                ),
                              );
                            };
                          }
                          else {
                            onTapFunction = () {
                              _showAlert(
                                  context,
                                  "This tour has not started yet. Please wait until the start date.",
                              );
                            };
                          }
                          return Opacity(
                            opacity: isCurrent
                                ? 1.0
                                : (isPast ? 1.0 : 0.5), // 🔥 PAST = 1.0 (visible), FUTURE = 0.5
                            child: Card(
                              color: isLocked ? const Color(0xFFD6D6D6) : Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 🔵 Tour Plan Details
                                  TourPlanWidget(
                                   title: '${item.serial_no} ($totalDays $dayText)',
                                    isLocked: isLocked, // 👈 Passing lock status to widget
                                    onTap: () {
                                      // 3. Hijacking onTap if locked
                                      if (isLocked) {
                                        _showLockedDialog(context);
                                      } else {
                                        onTapFunction!(); // Purana tap function
                                      }
                                    },
                                    //onTap: onTapFunction,
                                    intervalBackgroundColor: ColorPalette.pictonBlue100,
                                    intervalIcon: Ionicons.time_outline,
                                    intervalIconColor: ColorPalette.pictonBlue500,
                                    intervalText: '${formatApiDateNoTime(item.startDate)} - ${formatApiDateNoTime(item.endDate)}',

                                    // intervalText: '${DateFormat('dd MMM, yyyy').format(start)} - ${DateFormat('dd MMM, yyyy').format(end)}',
                                    intervalTextColor: ColorPalette.pictonBlue500,
                                    tour_status: item.toure_status,
                                    // 👇 Expense Status
                                    expenseStatusLabel: item.expenseOverallStatus?.label,
                                    expenseStatusKey: item.expenseOverallStatus?.status,
                                    //Expense_status: item.expenseOverallStatus?.label,
                                  ),

                                  /// 🟢 Send For Approval (only current)
                                  if (_allVisitsCheckedOut(item))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          // icon: const Icon(
                                          //   Ionicons.paper_plane_outline,
                                          //   size: 18,
                                          //   color: Colors.white,
                                          // ),
                                          label: const Text(
                                            "View Expense Details",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    SendForApproval_Screen(
                                                      tourPlanId: item.id,
                                                      startdate: start,
                                                      ExpenseFullyApproved: item.expenseOverallStatus?.status,
                                                    )
                                              ),
                                            );
                                            print("CheckIn_Screen 0.0 :$start");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///Es code ke under date ke uper exptra logic laga hai
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/views/components/tour_plan_widget.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/checkins/visit_list.dart';
import 'package:get/get.dart';
import 'ExpeAndOutcome/SendForApproval_Screen.dart';

class CheckinsSearch extends StatefulWidget {
  final targetTourId;
  const CheckinsSearch({super.key, this.targetTourId});

  @override
  State<CheckinsSearch> createState() => _CheckinsSearchState();
}

class _CheckinsSearchState extends State<CheckinsSearch> {
  final _searchController = TextEditingController();
  final ApiController controller = Get.put(ApiController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTourPlans();
      //notification ID
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await controller.fetchTourPlans();
    if (widget.targetTourId != null && widget.targetTourId!.isNotEmpty) {
      String idToSearch = widget.targetTourId!;
      setState(() {
        _searchController.text = idToSearch;
      });

      controller.filterSearchResults(idToSearch);
      print("Filtering for notification ID: $idToSearch");
    }
  }

  Future<void> _handleRefresh() async {
    await controller.fetchTourPlans();
    if (_searchController.text.isNotEmpty) {
      controller.filterSearchResults(_searchController.text);
    }
  }

  /// ✅ FINAL SEND FOR APPROVAL VALIDATION
  bool _allVisitsCheckedOut(dynamic tourItem) {
    if (tourItem.visits == null || tourItem.visits.isEmpty) {
      return false;
    }

    /// 🔥 STEP 1: Count ONLY Approved visits
    final approvedVisits = tourItem.visits.where((visit) {
      return visit.isApproved == 1; // ✅ Approved only
    }).toList();

    /// 🔥 STEP 2: Agar ek bhi approved visit nahi → button nahi
    if (approvedVisits.isEmpty) return false;

    /// 🔥 STEP 3: Sab approved visits checked-out hone chahiye
    return approvedVisits.every((visit) => visit.hasCheckin == true);
  }

  void _showAlert(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Alert",style: TextStyle(color: Colors.red),),
        content: Text(msg),
        actions: [
          TextButton(
            child: Text("OK",style: TextStyle(color: Colors.black),),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
  Color _expenseStatusColor(String? status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "partial":
        return Colors.orange;
      case "pending":
        return Colors.blue;
      case "rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  ///Alert dialog lock screen
  void _showLockedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Ionicons.lock_closed, color: Colors.red),
            SizedBox(width: 10),
            Text("Access Denied"),
          ],
        ),
        content: Text(
          "This Check-In Visit is locked and cannot be accessed because the expenses have been fully approved.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// ✅ Converts "2026-01-10 05:30:00.000" → "10 Jan, 2026"
  String formatApiDateNoTime(String date) {
    final DateTime parsed = DateTime.parse(date);
    // ⛔ Time ignore, only date used
    final DateTime onlyDate = DateTime(parsed.year, parsed.month, parsed.day);
    return DateFormat('d MMM, yyyy').format(onlyDate);
  }

  /// ✅ Removes time & returns pure date
  DateTime onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? getLastCheckedOutVisitDate(dynamic tourItem) {
    final visits = tourItem.visits
        .where((v) => v.hasCheckin == true && v.visitDate != null)
        .toList();

    if (visits.isEmpty) return null;

    visits.sort(
          (a, b) => DateTime.parse(a.visitDate)
          .compareTo(DateTime.parse(b.visitDate)),
    );

    return DateTime.parse(visits.last.visitDate);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          ///title: const Text('Check In (New)'),
          title: Center(child: Text('Approved Tour Summary',style: TextStyle(color: Colors.white),)),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMd(context) ? 5 : 25,
                ),
                child: Align(
                  alignment: Responsive.isMd(context)
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: SizedBox(
                    width: Responsive.isMd(context)
                        ? screenWidth
                        : screenWidth / 4,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        controller.filterSearchResults(value.trim());
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Ionicons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        hintText: 'Search by Tour ID',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              // 🟢 Tour List
              Expanded(
                child: RefreshIndicator.noSpinner(
                  //color: ColorPalette.seaGreen600,
                  onRefresh: _handleRefresh,
                  // color: Colors.white,
                  // backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Obx(() {
                      /// ✅ TOUR FILTER (CONFIRMED + PARTIAL APPROVED)
                      final tourPlan = controller.tourPlanList.where((plan) {
                        return plan.status == 'confirmed' || plan.status == 'partially approved';
                      }).toList();

                      if (controller.isLoading.value) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.green),
                          ),
                        );
                      }
                      final today = DateTime.now();
                      return Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(tourPlan.length, (index) {

                          final item = tourPlan[index];
                          // ✅ API date converted to local DateTime
                          final start = onlyDate(DateTime.parse(item.startDate));
                          final end = onlyDate(DateTime.parse(item.endDate));
                          final today = onlyDate(DateTime.now());

                          final totalDays = end.difference(start).inDays + 1;
                          final dayText = totalDays == 1 ? "Day" : "Days";
                          // 1. Logic to check if locked
                          bool isLocked = item.expenseOverallStatus?.status.toLowerCase() == 'confirmed';

                          bool isPast = end.isBefore(today);
                          bool isCurrent = today.isAtSameMomentAs(start) ||
                                  today.isAfter(start) && today.isBefore(end) ||
                                  today.isAtSameMomentAs(end);
                          VoidCallback onTapFunction;
                          if (isCurrent || isPast) {
                            onTapFunction = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VisitList(tourPlanId: item.id),
                                ),
                              );
                            };
                          }
                          else {
                            onTapFunction = () {
                              _showAlert(
                                  context,
                                  "This tour has not started yet. Please wait until the start date.",
                              );
                            };
                          }
                          return Opacity(
                            opacity: isCurrent
                                ? 1.0
                                : (isPast ? 1.0 : 0.5), // 🔥 PAST = 1.0 (visible), FUTURE = 0.5
                            child: Card(
                              color: isLocked ? const Color(0xFFD6D6D6) : Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// 🔵 Tour Plan Details
                                  TourPlanWidget(
                                   title: '${item.serial_no} ($totalDays $dayText)',
                                    isLocked: isLocked, // 👈 Passing lock status to widget
                                    onTap: () {
                                      // 3. Hijacking onTap if locked
                                      if (isLocked) {
                                        _showLockedDialog(context);
                                      } else {
                                        onTapFunction!(); // Purana tap function
                                      }
                                    },
                                    //onTap: onTapFunction,
                                    intervalBackgroundColor: ColorPalette.pictonBlue100,
                                    intervalIcon: Ionicons.time_outline,
                                    intervalIconColor: ColorPalette.pictonBlue500,
                                    intervalText: '${formatApiDateNoTime(item.startDate)} - ${formatApiDateNoTime(item.endDate)}',

                                    // intervalText: '${DateFormat('dd MMM, yyyy').format(start)} - ${DateFormat('dd MMM, yyyy').format(end)}',
                                    intervalTextColor: ColorPalette.pictonBlue500,
                                    tour_status: item.toure_status,
                                    // 👇 Expense Status
                                    expenseStatusLabel: item.expenseOverallStatus?.label,
                                    expenseStatusKey: item.expenseOverallStatus?.status,
                                    //Expense_status: item.expenseOverallStatus?.label,
                                  ),

                                  /// 🟢 Send For Approval (only current)
                                  if (_allVisitsCheckedOut(item))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2.0, right: 2),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          // icon: const Icon(
                                          //   Ionicons.paper_plane_outline,
                                          //   size: 18,
                                          //   color: Colors.white,
                                          // ),
                                          label: const Text(
                                            "View Expense Details",
                                            style: TextStyle(fontSize: 12, color: Colors.white),
                                          ),
                                          onPressed: () {
                                            final DateTime? visitDate = getLastCheckedOutVisitDate(item);

                                            if (visitDate == null) {
                                              _showAlert(context, "No completed visit found.");
                                              return;
                                            }

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => SendForApproval_Screen(
                                                  tourPlanId: item.id,
                                                  startdate: visitDate, // ✅ ACTUAL VISIT DATE
                                                  ExpenseFullyApproved: item.expenseOverallStatus?.status,
                                                ),
                                              ),
                                            );
                                            print("View Expense Details VisitDate : $visitDate");
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */