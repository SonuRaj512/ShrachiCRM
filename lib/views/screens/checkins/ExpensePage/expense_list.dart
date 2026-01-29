import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/checkin_controller.dart';
import 'package:shrachi/api/expense_controller.dart';
import '../../../../models/ExpenseUpdateModel.dart';
import '../../../enums/color_palette.dart';
import '../outcome_page.dart';
import 'AllExpenseUpdate_screen.dart';
import 'create_expense.dart';

class ExpenseList extends StatefulWidget {
  final int tourPlanId;
  final int visitId;
  final DateTime? startDate;

  const ExpenseList({
    super.key,
    required this.tourPlanId,
    required this.visitId,
     this.startDate,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final CheckinController _checkinController = Get.put(CheckinController());
  final ExpenseController _expenseController = Get.put(ExpenseController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expenseController.getExpense(
        tourPlanId: widget.tourPlanId,
        visitId: widget.visitId,
      );
    });
    _checkinController.checkOutcomeStatus(widget.visitId);
    print("Expense CheckIn Date : ${widget.startDate}");
  }
  // ✅ Updated Refresh Function
  Future<void> handleRefresh() async {
    // API Call
    await _expenseController.getExpense(
      tourPlanId: widget.tourPlanId,
      visitId: widget.visitId,
    );
    // Refresh Outcome status as well
    _checkinController.checkOutcomeStatus(widget.visitId);
  }

  void refreshExpenses() {
    handleRefresh();
  }

  /// Modern horizontal status indicator
  Widget buildExpenseStatus(String status) {
    // Mapping backend status to display
    final Map<String, String> displayStatus = {
      "pending": "New",
      "confirmed": "Approved",
      "approval": "Send For Approval",
      "cancelled": "Rejected",
    };

    final Map<String, Color> statusColors = {
      "pending": Colors.orange,
      "confirmed": Colors.green,
      "approval": Colors.blue,
      "cancelled": Colors.red,
    };

    String currentStatus = displayStatus[status.toLowerCase()] ?? "Unknown";
    Color currentColor = statusColors[status.toLowerCase()] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: currentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        currentStatus,
        style: TextStyle(
          color: currentColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Single button builder
  Widget buildButton({required IconData icon, required String label, required VoidCallback onTap,}) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorPalette.pictonBlue500,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }

  Future<void> showExpenseTypeBottomSheet() async {
    String? selectedType = 'Conveyance';

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.55, // 👈 Auto adjust – bigger/smaller screens me perfect
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Select Expense Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView(
                        children: [
                          ...['Conveyance', 'Non Conveyance', 'Local Conveyance']
                              .map(
                                (type) => RadioListTile(
                              value: type,
                              groupValue: selectedType,
                              activeColor: ColorPalette.pictonBlue500,
                              title: Text(type,style: TextStyle(color: Colors.black),),
                              onChanged: (value) {
                                setState(() => selectedType = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, selectedType,),
                            child: Text(
                              'Continue',
                              style: TextStyle(color: ColorPalette.pictonBlue500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CreateExpense(
            type: result,
            tourPlanId: widget.tourPlanId,
            visitId: widget.visitId,
            startDate: widget.startDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final ExpenseController controller = Get.put(ExpenseController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('All Expenses Summary'),
              // ElevatedButton(
              //  onPressed: (){
              //    Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ExpenseReportScreen(tourId : widget.tourPlanId.toString())),
              //   );
              //  },
              //  child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     //Icon(Icons.report),
              //      SizedBox(width: 10,),
              //      Text("Expense Report")
              //   ],
              //  )
              // ),
            ],
          ),
          backgroundColor: ColorPalette.pictonBlue500,
          elevation: 2,
          titleTextStyle: const TextStyle(
            color: Colors.white, // ✅ text color white
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ), // ✅ back button icon color
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              /// Top Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildButton(
                    icon: Ionicons.card_outline,
                    label: 'Create Expense',
                    onTap: showExpenseTypeBottomSheet
                  ),
                  Column(
                    children: [
                      Obx(() {
                        // Assuming you have controller with expenses list
                        final expense = _expenseController.expenses.isNotEmpty
                            ? _expenseController.expenses[0] // first expense
                            : null;
                        bool isOutcomeSubmitted = expense?.visit?.checkins?.outcome != null;
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isOutcomeSubmitted
                                ? Colors.blue.shade200 // Light blue if already submitted
                                : ColorPalette.pictonBlue500, // Normal blue if not submitted
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (!isOutcomeSubmitted) {
                              // Navigate if outcome not submitted
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OutcomePage(
                                    tourPlanId: widget.tourPlanId,
                                    visitId: widget.visitId,
                                    startDate: widget.startDate,
                                  ),
                                ),
                              );
                            } else {
                              Get.snackbar(
                                "Alert",                     // Title
                                "Outcome already submitted.", // Message
                                snackPosition: SnackPosition.TOP, // Popup comes from top
                                backgroundColor: Colors.green,      // Optional: background color
                                colorText: Colors.white,          // Text color
                                //margin: const EdgeInsets.all(12), // Margin from edges
                                duration: const Duration(seconds: 2),
                                borderRadius: 8,                  // Rounded corners
                              );
                            }
                          },
                          child: Icon(Icons.send, size: 30),
                        );
                      }),
                      const SizedBox(height: 8),
                      Obx(() {
                        final outcome = _expenseController.expenses.isNotEmpty
                            ? _expenseController.expenses[0].visit?.checkins?.outcome
                            : null;
                        return Text(
                          outcome == null ? "Create Outcome" : "Submitted Outcome",
                          textAlign: TextAlign.center,
                        );
                      }),
                    ],
                  ),
                  ///ye hai all send for approval ka code
                  // ✅ Conditional visibility
                  // Obx(() {
                  //   return _checkinController.isCheckedOut.value
                  //       ? buildButton(
                  //     icon: Ionicons.paper_plane_outline,
                  //     label: 'Send For All Approval',
                  //     onTap: () {
                  //       _expenseController.sendAllExpensesForApproval(widget.visitId);
                  //     },
                  //   ) : buildButton(
                  //     icon: Ionicons.paper_plane_outline,
                  //     label: 'Send For All Approval',
                  //     onTap: () {
                  //       Get.snackbar(
                  //         "No Outcome",
                  //         ":Please fill up outcome page before sending approval",
                  //         //"Please complete Outcome before sending for approval",
                  //         backgroundColor: Colors.red,
                  //         colorText: Colors.white,
                  //       );
                  //     },
                  //    );
                  // }),
                  // buildButton(
                  //   icon: Ionicons.paper_plane_outline,
                  //   label: 'Send For All Approval',
                  //   onTap: () {
                  //     // 🔹 Call the bulk approval API
                  //     _expenseController.sendAllExpensesForApproval(widget.visitId);
                  //   },
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              ///Tour Info Card
              // Card(
              //   elevation: 2,
              //   shadowColor: Colors.black.withOpacity(0.1),
              //   color: Colors.white,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(12),
              //     child: Table(
              //       columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
              //       children: [
              //         TableRow(children: [
              //           const Text(
              //             'Plan Name',
              //             style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 13),
              //           ),
              //           Text('${widget.tourPlanId}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              //         ]),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),

              // Expense List
              Expanded(
                child: Obx(() {
                  if (_expenseController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return RefreshIndicator(
                    onRefresh: handleRefresh,
                    child: ListView.separated(
                      itemCount: _expenseController.expenses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final expense = _expenseController.expenses[index];
                        return Card(
                          elevation: 2,
                          shadowColor: Colors.black.withOpacity(0.15),
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expense Type
                                Text(
                                  expense.expenseType
                                          ?.replaceAll('_', ' ')
                                          .toUpperCase() ?? '',
                                  style: TextStyle(
                                    color: ColorPalette.pictonBlue500,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, // boro kore dilam
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Status Indicator
                                buildExpenseStatus(expense.expenseStatus ?? "pending",),
                                const SizedBox(height: 10),
                                // Expense Details
                                if (expense.expenseType == "conveyance") ...[
                                  Text(
                                    "Departure: ${expense.departureTown}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Departure Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(expense.departureTime!)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Arrival: ${expense.arrivalTown}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Arrival Time: ${DateFormat('dd-MM-yyyy hh:mm a').format(expense.arrivalTime!)}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Mode: ${expense.modeOfTravel}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Fare: ₹ ${expense.amount}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                                if (expense.expenseType == "non_conveyance") ...[
                                  Text(
                                    "Location: ${expense.location}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Type: ${expense.type}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Amount: ₹ ${expense.amount}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  //Text("DA type: ${expense.daType}", style: const TextStyle(fontSize: 14)),
                                ],
                                if (expense.expenseType == "local_conveyance") ...[
                                  Text(
                                    "Travel Type: ${expense.modeOfTravel}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Amount: ₹ ${expense.amount}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                                if (expense.remarks != null)
                                  Text(
                                    "Comments: ${expense.remarks}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        UnifiedExpenseModel editModel = UnifiedExpenseModel(
                                          type: expense.expenseType,  // conveyance / non_conveyance / local_conveyance

                                          // ------- FOR CONVEYANCE -------
                                          departureTown: expense.departureTown,
                                          departureTime: expense.departureTime?.toString(),
                                          arrivalTown: expense.arrivalTown,
                                          arrivalTime: expense.arrivalTime?.toString(),
                                          modeOfTravel: expense.modeOfTravel,
                                          amount: expense.amount.toString(),
                                          comment: expense.remarks,

                                          // ------- FOR NON CONVEYANCE -------
                                          category: expense.type,
                                          city: expense.location,
                                          expenseType: expense.type,
                                          allowanceType: expense.daType,
                                          remarks: expense.remarks,
                                          //mislinisRemarks: expense.miscComments ?? '',
                                          flowAmount: expense.amount.toString(),

                                          // ------- FOR LOCAL CONVEYANCE -------
                                          id: expense.id,
                                          travelType: expense.modeOfTravel,
                                          travelAmount: expense.amount.toString(),
                                        );
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (_) => ExpenseEditDialog(
                                        //     visitId: widget.visitId,
                                        //     tourPlanId: widget.tourPlanId,
                                        //     model: editModel,
                                        //   ),
                                        // );
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseUpdateScreen(tourPlanId: widget.tourPlanId, visitId: widget.visitId, model: editModel, status: expense.expenseStatus)));
                                        // ExpenseDialog.show(
                                        //   context: context,
                                        //   model: editModel,
                                        //   onSubmit: (data, files) {
                                        //     print("UPDATED DATA => ${data.toMap()}");
                                        //     print("Selected Files: $files");
                                        //   },
                                        //   tourPlanId: widget.tourPlanId,
                                        //   VisitId: widget.visitId,
                                        // );
                                        refreshExpenses();
                                      },
                                      icon: const Icon(Icons.edit,color: Colors.blue,),
                                    ),
                                    // IconButton(
                                    //   onPressed: () {
                                    //     ExpenseDialog.show(
                                    //       context: context,
                                    //       model: UnifiedExpenseModel(
                                    //         type: expense.expenseType.toString(),
                                    //       ),
                                    //       onSubmit: (data, files) {
                                    //         print(data.toMap());
                                    //         print("Selected Files: $files");
                                    //       },
                                    //     );
                                    //   },
                                    //   icon: const Icon(Icons.edit),
                                    // ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              title: const Text("Delete Expense"),
                                              content: const Text(
                                                "Are you sure you want to delete this expense?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel",style: TextStyle(color: Colors.black),),
                                                ),

                                                // DELETE BUTTON
                                                TextButton(
                                                  onPressed: () async {
                                                    await _expenseController.deleteExpense(expense.id, context);
                                                    Navigator.pop(context,); // close dialog
                                                    // refresh the current screen
                                                    refreshExpenses();
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete,color: Colors.red,),
                                    ),
                                  ],
                                ),
                                // Modern Icon Only Send For Approval Button
                                // if ((expense.expenseStatus ?? "pending") == "pending" || (expense.expenseStatus ?? "") == "cancelled")
                                //   Align(
                                //     alignment: Alignment.centerRight,
                                //     child: ElevatedButton(
                                //       onPressed: () {
                                //         //_expenseController.sendForApproval(expense.id, index);
                                //       },
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: ColorPalette.pictonBlue500,
                                //         foregroundColor: Colors.white,
                                //         padding: const EdgeInsets.all(12),
                                //         shape: const CircleBorder(),
                                //         elevation: 3,
                                //       ),
                                //       child: const Icon(
                                //         Ionicons.paper_plane_outline,
                                //         size: 20,
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================= Non Conveyance UI SCREEN ==============================
// class FlowDropdownScreen extends StatefulWidget {
//   @override
//   _FlowDropdownScreenState createState() => _FlowDropdownScreenState();
// }
//
// class _FlowDropdownScreenState extends State<FlowDropdownScreen> {
//   final FlowController flow = Get.put(FlowController());
//
//   String? NonSelectedCategory;
//   String? NonSelectedCity;
//   String? NonSelectedExpenseType;
//   String? NonSelectedAllowanceType;
//
//   TextEditingController amountController = TextEditingController();
//
//   List<String> categoryList = ["A", "B"];
//
//   // ⛔ Validate before selecting next dropdown
//   void validateBeforeSelect({required String? checkValue, required String message, required Function() onSuccess,}) {
//     if (checkValue == null) {
//       Get.snackbar("Required", message,
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white);
//     } else {
//       onSuccess();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flow Based UI")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // ================= CATEGORY =================
//               Text("Category", style: titleStyle),
//               dropdown(
//                 value: NonSelectedCategory,
//                 hint: "Select Category",
//                 items: categoryList,
//                 enabled: true,
//                 onTap: () {},
//                 onChanged: (v) {
//                   setState(() {
//                     NonSelectedCategory = v;
//                     NonSelectedCity = null;
//                     NonSelectedExpenseType = null;
//                     NonSelectedAllowanceType = null;
//                   });
//                   flow.fetchCities(v!);
//                   // For Category A → fetch cities
//                   if (v == "A") {
//                     flow.fetchCities(v);
//                   }
//                   // For Category B → DO NOT CALL API
//                 },
//               ),
//
//               SizedBox(height: 10),
//
//               // ================= CITY =================
//
//               Text("Category wise City", style: titleStyle),
//               if (NonSelectedCategory == "B") ...[
//                 // For Category B → Show Input Box Instead of Dropdown
//                 TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       NonSelectedCity = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Please select your city",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ] else ...[
//                 // For Category A → Show Dropdown with API Cities
//                 Obx(() {
//                   return dropdown(
//                     value: NonSelectedCity,
//                     hint: "Select City",
//                     items: flow.categoryWiseCityList,
//                     enabled: NonSelectedCategory != null,
//                     onTap: () {
//                       validateBeforeSelect(
//                         checkValue: NonSelectedCategory,
//                         message: "Please select category first!",
//                         onSuccess: () {},
//                       );
//                     },
//                     onChanged: (v) {
//                       validateBeforeSelect(
//                         checkValue: NonSelectedCategory,
//                         message: "Please select category first!",
//                         onSuccess: () {
//                           setState(() {
//                             NonSelectedCity = v;
//                             NonSelectedExpenseType = null;
//                             NonSelectedAllowanceType = null;
//                           });
//
//                           flow.fetchExpenseTypes(NonSelectedCategory!, "da_full");
//                         },
//                       );
//                     },
//                   );
//                 }),
//               ],
//               SizedBox(height: 10),
//               // ================= EXPENSE TYPE ==================
//               Text("Expense Type", style: titleStyle),
//               dropdown(
//                 value: NonSelectedExpenseType,
//                 hint: "Select Expense Type",
//
//                 items: ["DA Full Day", "DA Half Day", "TA", "Miscellaneous"],
//
//                 enabled: NonSelectedCity != null,
//
//                 onTap: () {
//                   validateBeforeSelect(
//                     checkValue: NonSelectedCity,
//                     message: "Please select city first!",
//                     onSuccess: () {},
//                   );
//                 },
//                 onChanged: (v) {
//                   validateBeforeSelect(
//                     checkValue: NonSelectedCity,
//                     message: "Please select city first!",
//                     onSuccess: () {
//                       setState(() {
//                         NonSelectedExpenseType = v;
//                         NonSelectedAllowanceType = null;
//                       });
//
//                       // Convert UI text → API keys
//                       String apiValue = "";
//                       if (v == "DA Full Day") apiValue = "da_full";
//                       if (v == "DA Half Day") apiValue = "da_half";
//                       if (v == "TA") apiValue = "ta";
//                       if (v == "Miscellaneous") apiValue = "misc";
//                       // CALL API
//                       flow.fetchAllowanceTypes(
//                         NonSelectedCategory!,
//                         apiValue,
//                        //"allownace_type",
//                       );
//                     },
//                   );
//                 },
//               ),
//               SizedBox(height: 10),
//
// // ================= ALLOWANCE TYPE ==================
//               // ================= ALLOWANCE TYPE ==================
//               Text("Allowance Type", style: titleStyle),
//               Obx(() {
//                 return dropdown(
//                   value: NonSelectedAllowanceType,
//                   hint: "Select Allowance Type",
//                   items: flow.allowanceTypeList,
//                   enabled: NonSelectedExpenseType != null,
//
//                   onTap: () {
//                     validateBeforeSelect(
//                       checkValue: NonSelectedExpenseType,
//                       message: "Please select expense type first!",
//                       onSuccess: () {},
//                     );
//                   },
//
//                   onChanged: (v) {
//                     setState(() {
//                       NonSelectedAllowanceType = v;
//                     });
//
//                     //IMPORTANT: NOW FETCH THE AMOUNT
//                     String apiExpense = NonSelectedExpenseType == "DA Full Day"
//                         ? "da_full"
//                         : NonSelectedExpenseType == "DA Half Day"
//                         ? "da_half"
//                         : NonSelectedExpenseType == "TA"
//                         ? "ta"
//                         : "misc";
//
//                     flow.fetchAllowanceAmount(
//                       NonSelectedCategory!,
//                       apiExpense,
//                       NonSelectedAllowanceType!,
//                     );
//                   },
//                 );
//               }),
//               SizedBox(height: 10),
//               Obx(() {
//                 amountController.text = flow.finalAmount.value;
//
//                 return Text(
//                   "${flow.allowanceTitle.value} : ${flow.finalAmount.value}",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 );
//               }),
//               SizedBox(height: 7,),
//
//               // ================= AMOUNT =================
//               Text("Amount", style: titleStyle),
//               TextFormField(
//                 controller: amountController,
//                 keyboardType:  TextInputType.number,
//                 decoration: InputDecoration(
//                   hintText: "Enter Amount",
//                 ),
//               ),
//               SizedBox(height: 30),
//
//               ElevatedButton(
//                 onPressed: () {
//                   print("Category: $NonSelectedCategory");
//                   print("City: $NonSelectedCity");
//                   print("Expense: $NonSelectedExpenseType");
//                   print("Allowance: $NonSelectedAllowanceType");
//                   print("Amount: ${amountController.text}");
//                 },
//                 child: Text("Submit"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ===================== CUSTOM DROPDOWN =====================
//   Widget dropdown({
//     required String? value,
//     required List<String> items,
//     required String hint,
//     required bool enabled,
//     required Function() onTap,
//     required Function(String?) onChanged,
//   })
//   {
//     return IgnorePointer(
//       ignoring: !enabled,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: enabled ? Colors.white : Colors.grey.shade300,
//             border: Border.all(color: Colors.black45),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButton<String>(
//             dropdownColor: Colors.white, // menu white
//             isExpanded: true,
//             value: value,
//             underline: SizedBox(),
//             iconEnabledColor: enabled ? Colors.black : Colors.grey,
//             hint: Text(hint),
//             items: items
//                 .map((e) => DropdownMenuItem(
//               value: e,
//               child: Text(e),
//             ))
//                 .toList(),
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     );
//   }
//
//   TextStyle get titleStyle => TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
//
// }
