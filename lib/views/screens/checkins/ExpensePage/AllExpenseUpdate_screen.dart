// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../../../api/ExpenseController/ExpenseUpdateController.dart';
// import '../../../../models/ExpenseUpdateModel.dart';
//
// class ExpenseEditDialog extends StatefulWidget {
//   final int tourPlanId;
//   final int visitId;
//   final UnifiedExpenseModel model;
//
//   const ExpenseEditDialog({
//     super.key,
//     required this.tourPlanId,
//     required this.visitId,
//     required this.model,
//   });
//
//   @override
//   State<ExpenseEditDialog> createState() => _ExpenseEditDialogState();
// }
// class _ExpenseEditDialogState extends State<ExpenseEditDialog> {
//   final ImagePicker _picker = ImagePicker();
//
//   // -------- TEXT CONTROLLERS --------
//   late TextEditingController departureTownCtrl;
//   late TextEditingController departureTimeCtrl;
//   late TextEditingController arrivalTownCtrl;
//   late TextEditingController arrivalTimeCtrl;
//   late TextEditingController modeOfTravelCtrl;
//   late TextEditingController amountCtrl;
//   late TextEditingController commentCtrl;
//
//   // Non-Conveyance controllers
//   late TextEditingController categoryCtrl;
//   late TextEditingController cityCtrl;
//   late TextEditingController expenseTypeCtrl;
//   late TextEditingController allowanceTypeCtrl;
//   late TextEditingController remarksCtrl;
//   late TextEditingController misCommentsCtrl;
//   late TextEditingController flowAmountCtrl;
//
//   List<XFile> pickedImages = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     final m = widget.model;
//
//     // ---- Conveyance ----
//     departureTownCtrl = TextEditingController(text: m.departureTown);
//     departureTimeCtrl = TextEditingController(text: m.departureTime);
//     arrivalTownCtrl = TextEditingController(text: m.arrivalTown);
//     arrivalTimeCtrl = TextEditingController(text: m.arrivalTime);
//     modeOfTravelCtrl = TextEditingController(text: m.modeOfTravel);
//     amountCtrl = TextEditingController(text: m.amount?.toString());
//     commentCtrl = TextEditingController(text: m.comment);
//
//     // ---- Non Conveyance ----
//     categoryCtrl = TextEditingController(text: m.category);
//     cityCtrl = TextEditingController(text: m.city);
//     expenseTypeCtrl = TextEditingController(text: m.expenseType);
//     allowanceTypeCtrl = TextEditingController(text: m.allowanceType);
//     remarksCtrl = TextEditingController(text: m.remarks);
//     misCommentsCtrl = TextEditingController(text: m.mislinisRemarks);
//     flowAmountCtrl = TextEditingController(text: m.flowAmount?.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               header(),
//               const SizedBox(height: 10),
//               ...buildFormFields(),
//               const SizedBox(height: 12),
//               imagePickerButton(),
//               if (pickedImages.isNotEmpty) imagePreviewList(),
//               const SizedBox(height: 24),
//               actionButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER ----------------
//   Widget header() {
//     return Text(
//       widget.model.type == "conveyance"
//           ? "Update Conveyance Expense"
//           : widget.model.type == "non_conveyance"
//           ? "Update Non-Conveyance Expense"
//           : "Update Local Conveyance Expense",
//       style: const TextStyle(
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Colors.black,
//       ),
//     );
//   }
//
//   // ---------------- FORM FIELDS ----------------
//   List<Widget> buildFormFields() {
//     final m = widget.model;
//
//     if (m.type == "conveyance") {
//       return [
//         inputField("Departure Town", departureTownCtrl),
//         inputField("Departure Time", departureTimeCtrl),
//         inputField("Arrival Town", arrivalTownCtrl),
//         inputField("Arrival Time", arrivalTimeCtrl),
//         inputField("Mode of Travel", modeOfTravelCtrl),
//         inputField("Amount", amountCtrl),
//         inputField("Comment", commentCtrl),
//       ];
//     }
//
//     if (m.type == "non_conveyance") {
//       return [
//         inputField("Category", categoryCtrl),
//         inputField("City", cityCtrl),
//         inputField("Expense Type", expenseTypeCtrl),
//         inputField("Allowance Type", allowanceTypeCtrl),
//         inputField("Remarks", remarksCtrl),
//         inputField("Misc Comments", misCommentsCtrl),
//         inputField("Flow Amount", flowAmountCtrl),
//       ];
//     }
//
//     // Local conveyance
//     return [
//       inputField("Travel Type", modeOfTravelCtrl),
//       inputField("Travel Amount", amountCtrl),
//     ];
//   }
//
//   // ---------------- COMMON TEXT FIELD ----------------
//   Widget inputField(String label, TextEditingController controller) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- IMAGE PICKER BUTTON ----------------
//   Widget imagePickerButton() {
//     return InkWell(
//       onTap: pickImageOptions,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black.withAlpha(128)),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: const Row(
//           children: [
//             Icon(Icons.camera_alt, size: 20, color: Colors.black),
//             SizedBox(width: 8),
//             Text("Add Photo", style: TextStyle(fontSize: 16, color: Colors.black)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------- IMAGE PICKER OPTIONS ----------------
//   void pickImageOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
//       builder: (context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: const Icon(Icons.camera_alt),
//             title: const Text("Take Photo"),
//             onTap: () async {
//               final img = await _picker.pickImage(source: ImageSource.camera);
//               if (img != null) setState(() => pickedImages.add(img));
//               Navigator.pop(context);
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.photo_library),
//             title: const Text("Choose From Gallery"),
//             onTap: () async {
//               final imgs = await _picker.pickMultiImage();
//               setState(() => pickedImages.addAll(imgs));
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------- IMAGE PREVIEW ----------------
//   Widget imagePreviewList() {
//     return SizedBox(
//       height: 90,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: pickedImages.length,
//         itemBuilder: (_, i) {
//           return Stack(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: !kIsWeb
//                     ? Image.file(File(pickedImages[i].path),
//                     height: 80, width: 80, fit: BoxFit.cover)
//                     : Image.network(pickedImages[i].path,
//                     height: 80, width: 80, fit: BoxFit.cover),
//               ),
//               Positioned(
//                 right: 0,
//                 child: GestureDetector(
//                   onTap: () => setState(() => pickedImages.removeAt(i)),
//                   child: const CircleAvatar(
//                     radius: 12,
//                     backgroundColor: Colors.black54,
//                     child: Icon(Icons.close, size: 14, color: Colors.white),
//                   ),
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   // ---------------- ACTION BUTTONS ----------------
//   Widget actionButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//         ),
//         const SizedBox(width: 10),
//         ElevatedButton(
//           onPressed: submitUpdate,
//           child: const Text("Submit"),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- SUBMIT API ----------------
//   Future<void> submitUpdate() async {
//     final m = widget.model;
//
//     Map<String, dynamic> body;
//
//     if (m.type == "conveyance") {
//       body = {
//         "expensetype": m.type,
//         "tour_plan_id": widget.tourPlanId,
//         "visit_id": widget.visitId,
//         "departure_town": departureTownCtrl.text,
//         "arrival_town": arrivalTownCtrl.text,
//         "departure_time": departureTimeCtrl.text,
//         "arrival_time": arrivalTimeCtrl.text,
//         "mode_of_travel": modeOfTravelCtrl.text,
//         "amount": amountCtrl.text,
//         "description": commentCtrl.text,
//       };
//     } else if (m.type == "non_conveyance") {
//       body = {
//         "expensetype": m.type,
//         "tour_plan_id": widget.tourPlanId,
//         "visit_id": widget.visitId,
//         "category": categoryCtrl.text,
//         "city": cityCtrl.text,
//         "expense_type": expenseTypeCtrl.text,
//         "allowance_type": allowanceTypeCtrl.text,
//         "remarks": remarksCtrl.text,
//         "misc_comment": misCommentsCtrl.text,
//         "flow_amount": flowAmountCtrl.text,
//       };
//     } else {
//       body = {
//         "travel_type": modeOfTravelCtrl.text,
//         "travel_amount": amountCtrl.text,
//       };
//     }
//
//     final api = ExpenseUpdateController();
//
//     bool success = await api.updateExpense(
//       expenseId: m.id,
//       body: body,
//       images: pickedImages,
//     );
//
//     Navigator.pop(context);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(success ? "Expense Updated!" : "Update Failed!"),
//         backgroundColor: success ? Colors.green : Colors.red,
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/views/components/searchable_dropdown.dart'; // Adjust path
import '../../../../api/ExpenseController/ConveyanceDropdownController.dart'; // Adjust path
import '../../../../api/ExpenseController/LocConveyanceController.dart'; // Adjust path
import '../../../../api/ExpenseController/NonConveyanceFetchController.dart'; // Adjust path
import '../../../../api/ExpenseController/ExpenseUpdateController.dart'; // Adjust path
import '../../../../models/ExpenseUpdateModel.dart'; // Adjust path

class ExpenseUpdateScreen extends StatefulWidget {
  final int tourPlanId;
  final int visitId;
  final UnifiedExpenseModel model;
  final status;

  const ExpenseUpdateScreen({
    super.key,
    required this.tourPlanId,
    required this.visitId,
    required this.model,
    required this.status,
  });

  @override
  State<ExpenseUpdateScreen> createState() => _ExpenseUpdateScreenState();
}

class _ExpenseUpdateScreenState extends State<ExpenseUpdateScreen> {
  // Global Keys & Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ExpenseUpdateController _apiController = ExpenseUpdateController();

  // GetX Controllers (Same as CreateExpense)
  final FlowController flow = Get.put(FlowController());
  final ConveyanceController conveyance = Get.put(ConveyanceController());
  final LocalConveyanceController locConveyance = Get.put(LocalConveyanceController());

  // Text Controllers
  final TextEditingController _expenseDateController = TextEditingController();

  // Conveyance & Local Conveyance
  final TextEditingController _departureTownController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTownController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  // Non Conveyance
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _mislinisCommentController = TextEditingController();
  final TextEditingController _flowAmountController = TextEditingController(); // User amount

  // State Variables
  String? selectedMode; // For Conveyance & Local Conveyance
  Map<String, String?> errors = {};
  // Non Conveyance Selectors
  String? nonSelectedCategory;
  String? nonSelectedCity;
  String? nonSelectedExpenseType;
  String? nonSelectedAllowanceType;
  String? amountError;

  // Images
  final ImagePicker _picker = ImagePicker();
  List<XFile> pickedImages = [];
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    final m = widget.model;

    // 1. Conveyance Setup
    if (m.type == 'conveyance') {
      // ... baki code same ...
      selectedMode = m.modeOfTravel;

      // 👇 Yeh line add karein: Pehle clear karein
      conveyance.travelModes.clear();
      conveyance.fetchConTravelModes();
    }

    // 2. Local Conveyance Setup
    else if (m.type == 'local_conveyance') {
      selectedMode = m.modeOfTravel;
      _amountController.text = m.amount?.toString() ?? '';

      // 👇 Yeh line add karein: Pehle clear karein
      locConveyance.travelModes.clear();
      locConveyance.fetchLocalConveyance();
    }

    // Common
    //_expenseDateController.text = m.date ?? DateFormat('dd-MM-yyyy').format(DateTime.now());

    // 1. Conveyance Setup
    if (m.type == 'conveyance') {
      _departureTownController.text = m.departureTown ?? '';
      _arrivalTownController.text = m.arrivalTown ?? '';
      _departureTimeController.text = m.departureTime ?? '';
      _arrivalTimeController.text = m.arrivalTime ?? '';
      _amountController.text = m.amount?.toString() ?? '';
      _commentController.text = m.comment ?? '';
      selectedMode = m.modeOfTravel;

      conveyance.fetchConTravelModes();
    }

    // 2. Local Conveyance Setup
    else if (m.type == 'local_conveyance') {
      selectedMode = m.modeOfTravel; // In local, this maps to travelType
      _amountController.text = m.amount?.toString() ?? '';

      locConveyance.fetchLocalConveyance();
    }

    // 3. Non-Conveyance Setup
    else if (m.type == 'non_conveyance') {
      nonSelectedCategory = m.category;
      nonSelectedCity = m.city;
      nonSelectedExpenseType = m.expenseType;
      nonSelectedAllowanceType = m.allowanceType;
      _flowAmountController.text = m.flowAmount?.toString() ?? m.amount?.toString() ?? '';

      if (m.expenseType == 'Miscellaneous') {
        _mislinisCommentController.text = m.mislinisRemarks ?? m.remarks ?? '';
      } else {
        _remarksController.text = m.remarks ?? '';
      }

      // Pre-load Dropdown Data using FlowController
      if (nonSelectedCategory != null) {
        flow.fetchCities(nonSelectedCategory!);

        // Slight delay to allow city list to populate before fetching types
        if (nonSelectedCity != null && nonSelectedExpenseType != null) {
          String apiValue = _getApiExpenseType(nonSelectedExpenseType!);
          // We don't necessarily need to re-fetch *types* if we just want to validate
          // But to populate the UI correctly:
          flow.fetchExpenseTypes(nonSelectedCategory!, "da_full"); // Dummy call to populate list if needed
        }
      }
    }
  }

  // Helper to map UI string to API key
  String _getApiExpenseType(String uiType) {
    if (uiType == "DA Full Day") return "da_full";
    if (uiType == "DA Half Day") return "da_half";
    if (uiType == "TA") return "ta";
    if (uiType == "HOTEL") return "hotel";
    return "misc";
  }
  bool get isExpenseLocked {
    final s = widget.status.toString().toLowerCase();
    return s == "confirmed" || s == "approval";
  }

  bool get canUpdateExpense {
    final s = widget.status.toString().toLowerCase();
    return s == "pending" || s == "cancelled";
  }
  void showUpdateNotAllowedPopup() {
    final rawStatus = widget.status.toString().toLowerCase();

    String statusText = rawStatus;
    if (rawStatus == "approval") {
      statusText = "Sent For Approval";
    } else if (rawStatus == "confirmed") {
      statusText = "Approved";
    }

    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: "Update Not Allowed",

      // 🔥 Custom middle widget instead of middleText
      content: Column(
        children: [
          const Text(
            "You cannot update this expense because it has already been",
            textAlign: TextAlign.center,
          ),
         // const SizedBox(height: 6),

          // ✅ Only status text in blue
          Text(
            "$statusText .",
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      textConfirm: "OK",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () => Get.back(),
    );
  }


  // ================== UI BUILDER ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("Update ${getAppBarTitle()}",style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Date Field (ReadOnly for update usually, or editable)
            // TextField(
            //   controller: _expenseDateController,
            //   readOnly: true, // Assuming date isn't changed during update often
            //   decoration: _textDecoration('Expense Date'),
            // ),
            // const SizedBox(height: 15),

            // Render specific form based on Type
            if (widget.model.type == 'conveyance') _buildConveyanceForm(),
            if (widget.model.type == 'local_conveyance') _buildLocalConveyanceForm(),
            if (widget.model.type == 'non_conveyance') _buildNonConveyanceForm(),

            const SizedBox(height: 20),
            // Image Picker Section
            _buildImageSection(),

            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpenseLocked
                      ? Colors.blue.shade200 // 🔒 Deep color
                      : Colors.blue,        // ✅ Normal
                  foregroundColor: Colors.white,
                ),
                onPressed: isSubmitting
                    ? null
                    : () {
                  if (isExpenseLocked) {
                    showUpdateNotAllowedPopup(); // ❌ Block update
                  } else {
                    validateAndSubmit(); // ✅ Allow update
                  }
                },
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Update Expense",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.black,
            //       foregroundColor: Colors.white,
            //     ),
            //     onPressed: isSubmitting ? null : validateAndSubmit,
            //     child: isSubmitting
            //         ? const CircularProgressIndicator(color: Colors.white)
            //         : const Text("Update Expense", style: TextStyle(fontSize: 16)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  String getAppBarTitle() {
    if (widget.model.type == "conveyance") return "Conveyance";
    if (widget.model.type == "non_conveyance") return "Non-Conveyance";
    return "Local Conveyance";
  }

  // ================== CONVEYANCE FORM ==================
  Widget _buildConveyanceForm() {
    return Column(
      children: [
        TextField(
          controller: _departureTownController,
          decoration: _textDecoration('Departure Town'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _departureTimeController,
          readOnly: true,
          decoration: _textDecoration('Departure Time',),
          onTap: () => pickDateTime(_departureTimeController),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _arrivalTownController,
          decoration: _textDecoration('Arrival Town'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _arrivalTimeController,
          readOnly: true,
          decoration: _textDecoration('Arrival Time'),
          onTap: () => pickDateTime(_arrivalTimeController),
        ),
        const SizedBox(height: 10),

        // Mode of Travel Dropdown
// Mode of Travel Dropdown (Updated)
        Obx(() {
          final List<String> dropdownItems = conveyance.travelModes.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchableDropdown(
                        // 👇 YE LINE MAGIC KAREGI: Jab list change hogi, Dropdown naya banega
                        key: ValueKey(dropdownItems.length),

                        items: dropdownItems,
                        itemLabel: (item) => item,
                        selectedItem: selectedMode,
                        onChanged: (value) {
                          setState(() {
                            selectedMode = value;
                            errors.remove('modeOfTravel');
                          });
                        },
                        hintText: conveyance.isLoading.value
                            ? "Loading..."
                            : (dropdownItems.isEmpty ? "No Modes Found" : "Select Travel Mode"),
                        expand: true,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: Colors.grey.shade700),
                  ],
                ),
              ),
              // Error Text Code same as before...
            ],
          );
        }),        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: _textDecoration('Fare Rs.'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          decoration: _textDecoration('Comment (Optional)'),
        ),
      ],
    );
  }
  // Widget _buildConveyanceForm() {
  //   return Column(
  //     children: [
  //       TextField(
  //         controller: _departureTownController,
  //         decoration: _textDecoration('Departure Town'),
  //       ),
  //       const SizedBox(height: 10),
  //       TextField(
  //         controller: _departureTimeController,
  //         readOnly: true,
  //         decoration: _textDecoration('Departure Time',),
  //         onTap: () => pickDateTime(_departureTimeController),
  //       ),
  //       const SizedBox(height: 10),
  //       TextField(
  //         controller: _arrivalTownController,
  //         decoration: _textDecoration('Arrival Town'),
  //       ),
  //       const SizedBox(height: 10),
  //       TextField(
  //         controller: _arrivalTimeController,
  //         readOnly: true,
  //         decoration: _textDecoration('Arrival Time'),
  //         onTap: () => pickDateTime(_arrivalTimeController),
  //       ),
  //       const SizedBox(height: 10),
  //
  //       // Mode of Travel Dropdown (Removed Obx from here)
  //       Obx(() {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             GestureDetector(
  //               onTap: () {}, // dropdown automatically open hoga
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: 14,
  //                   vertical: 4,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10),
  //                   border: Border.all(
  //                     color: Colors.grey.shade400,
  //                     width: 1,
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black12,
  //                       blurRadius: 3,
  //                       offset: Offset(0, 1),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     // ⬅ LEFT SIDE Searchable Dropdown
  //                     Expanded(
  //                       child: SearchableDropdown(
  //                         items: conveyance.travelModes,
  //                         itemLabel: (item) => item,
  //                         selectedItem: selectedMode,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             selectedMode = value;
  //                             errors.remove('modeOfTravel');
  //                           });
  //                         },
  //                         hintText:
  //                         conveyance.isLoading.value
  //                             ? "Loading..."
  //                             : "Select Travel Mode",
  //                         expand: true,
  //                       ),
  //                     ),
  //
  //                     // ➡ RIGHT SIDE Dropdown Icon
  //                     Container(
  //                       padding: const EdgeInsets.only(left: 6),
  //                       child: Icon(
  //                         Icons.keyboard_arrow_down_rounded,
  //                         size: 26,
  //                         color: Colors.grey.shade700,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //
  //             // ⚠ Error Text
  //             if (errors['modeOfTravel'] != null)
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 6, left: 4),
  //                 child: Text(
  //                   errors['modeOfTravel']!,
  //                   style: const TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //               ),
  //           ],
  //         );
  //       }),
  //       const SizedBox(height: 10),
  //       TextField(
  //         controller: _amountController,
  //         keyboardType: TextInputType.number,
  //         decoration: _textDecoration('Fare Rs.'),
  //       ),
  //       const SizedBox(height: 10),
  //       TextField(
  //         controller: _commentController,
  //         decoration: _textDecoration('Comment (Optional)'),
  //       ),
  //     ],
  //   );
  // }

  // ================== LOCAL CONVEYANCE FORM ==================
// ================== LOCAL CONVEYANCE FORM ==================
  Widget _buildLocalConveyanceForm() {
    return Column(
      children: [
        // Travel Type Dropdown
// Travel Type Dropdown (Updated)
        Obx(() {
          final List<String> dropdownItems = locConveyance.travelModes.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchableDropdown(
                        // 👇 YE KEY ADD KAREIN
                        key: ValueKey("local_${dropdownItems.length}"),

                        items: dropdownItems,
                        itemLabel: (item) => item,
                        selectedItem: selectedMode,
                        onChanged: (value) {
                          setState(() {
                            selectedMode = value;
                            errors.remove('modeOfTravel');
                          });
                        },
                        hintText: locConveyance.isLoading.value
                            ? "Loading..."
                            : (dropdownItems.isEmpty ? "No Modes Found" : "Select Travel Mode"),
                        expand: true,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: Colors.grey.shade700),
                  ],
                ),
              ),
              // Error Text Code same as before...
            ],
          );
        }),        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: _textDecoration('Travel Amount'),
        ),
      ],
    );
  }  // ================== NON-CONVEYANCE FORM ==================
  Widget _buildNonConveyanceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category
        const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
        _dropdown(
          value: nonSelectedCategory,
          items: ["A", "B"],
          hint: "Select Category",
          onChanged: (v) {
            setState(() {
              nonSelectedCategory = v;
              nonSelectedCity = null;
              nonSelectedExpenseType = null;
              nonSelectedAllowanceType = null;
            });
            if (v != null) flow.fetchCities(v);
          },
        ),
        const SizedBox(height: 10),

        // City
        const Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
        if (nonSelectedCategory == "B")
          TextField(
            controller: TextEditingController(text: nonSelectedCity),
            onChanged: (val) => nonSelectedCity = val,
            decoration: _textDecoration("Enter City"),
          )
        else
          Obx(() => _dropdown(
            value: nonSelectedCity,
            items: flow.categoryWiseCityList,
            hint: "Select City",
            onChanged: (v) {
              setState(() {
                nonSelectedCity = v;
                nonSelectedExpenseType = null;
                nonSelectedAllowanceType = null;
              });
              // Fetch types Logic
              if(nonSelectedCategory != null) {
                flow.fetchExpenseTypes(nonSelectedCategory!, "da_full");
              }
            },
          )),
        const SizedBox(height: 10),

        // Expense Type
        const Text("Expense Type", style: TextStyle(fontWeight: FontWeight.bold)),
        _dropdown(
          value: nonSelectedExpenseType,
          items: ["DA Full Day", "DA Half Day", "TA", "HOTEL", "Miscellaneous"],
          hint: "Select Expense Type",
          onChanged: (v) {
            setState(() {
              nonSelectedExpenseType = v;
              nonSelectedAllowanceType = null;
              flow.allowanceTitle.value = "";
              flow.finalAmount.value = "";
              _flowAmountController.clear();
            });

            if (v != "Miscellaneous" && v != null) {
              flow.fetchAllowanceTypes(nonSelectedCategory!, _getApiExpenseType(v));
            }
          },
        ),
        const SizedBox(height: 10),

        // Allowance Type (Hide if Misc)
        if (nonSelectedExpenseType != "Miscellaneous" && nonSelectedExpenseType != null) ...[
          const Text("Allowance Type", style: TextStyle(fontWeight: FontWeight.bold)),
          Obx(() => _dropdown(
            value: nonSelectedAllowanceType,
            items: flow.allowanceTypeList,
            hint: "Select Allowance Type",
            onChanged: (v) {
              setState(() => nonSelectedAllowanceType = v);
              if(v != null) {
                flow.fetchAllowanceAmount(
                    nonSelectedCategory!,
                    _getApiExpenseType(nonSelectedExpenseType!),
                    v
                );
              }
            },
          )),
          const SizedBox(height: 5),
          Obx(() {
            final title = flow.allowanceTitle.value;
            final amount = flow.finalAmount.value;
            return (title != null && title.isNotEmpty)
                ? Text("$title : $amount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))
                : const SizedBox();
          }),
        ],
        const SizedBox(height: 10),

        // Amount
        TextField(
          controller: _flowAmountController,
          keyboardType: TextInputType.number,
          decoration: _textDecoration('Enter Amount').copyWith(errorText: amountError),
          onChanged: (value) {
            if (nonSelectedExpenseType == "Miscellaneous") {
              setState(() => amountError = null);
              return;
            }
            final maxAmount = double.tryParse(flow.finalAmount.value.toString()) ?? 0;
            final entered = double.tryParse(value) ?? 0;

            if (maxAmount > 0 && entered > maxAmount) {
              setState(() => amountError = "Exceeds limit $maxAmount");
            } else {
              setState(() => amountError = null);
            }
          },
        ),
        const SizedBox(height: 10),

        // Comments/Remarks
        if (nonSelectedExpenseType == 'Miscellaneous')
          TextField(
            controller: _mislinisCommentController,
            decoration: _textDecoration('Comment (Required)'),
          )
        else
          TextField(
            controller: _remarksController,
            decoration: _textDecoration('Remarks (Optional)'),
          ),
      ],
    );
  }

  // ================== HELPER WIDGETS ==================

  Widget _dropdown({required String? value, required List<String> items, required String hint, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: Text(hint),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showPickerOptions((images) {
              setState(() {
                pickedImages.addAll(images);
              });
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              children: [
                Icon(Icons.camera_alt, color: Colors.grey),
                SizedBox(width: 8),
                Text("Add Photo", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (pickedImages.isNotEmpty)
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pickedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.file(
                        File(pickedImages[index].path),
                        width: 80, height: 80, fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => pickedImages.removeAt(index)),
                        child: const CircleAvatar(
                          radius: 10, backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  InputDecoration _textDecoration(String label) {
    return InputDecoration(
      labelStyle: TextStyle(color: Colors.black),
      labelText: label,
      border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
    );
  }

  // ================== LOGIC METHODS ==================
  Future<void> pickDateTime(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    if (!mounted) return;
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final formatted = DateFormat("dd-MMM-yyyy hh:mm a").format(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
    setState(() => controller.text = formatted);
  }

  void showPickerOptions(Function(List<XFile>) onImagesPicked) {
    // Reuse your existing modal logic here for Camera/Gallery
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt), title: const Text('Camera'),
                onTap: () async {
                  final img = await _picker.pickImage(source: ImageSource.camera);
                  if (img != null) onImagesPicked([img]);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library), title: const Text('Gallery'),
                onTap: () async {
                  final imgs = await _picker.pickMultiImage();
                  if (imgs.isNotEmpty) onImagesPicked(imgs);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================== SUBMIT LOGIC ==================
  Future<void> validateAndSubmit() async {
    if (amountError != null) return;

    setState(() => isSubmitting = true);

    final m = widget.model;
    Map<String, dynamic> body = {};

    try {
      // 1. Prepare Body based on Type
      if (m.type == "conveyance") {
        if (_departureTownController.text.isEmpty || _amountController.text.isEmpty) {
          throw "Please fill required fields";
        }

        body = {
          "expensetype": "conveyance",
          "tour_plan_id": widget.tourPlanId,
          "visit_id": widget.visitId,
          "departure_town": _departureTownController.text,
          "arrival_town": _arrivalTownController.text,
          "departure_time": _formatDateForApi(_departureTimeController.text),
          "arrival_time": _formatDateForApi(_arrivalTimeController.text),
          "mode_of_travel": selectedMode ?? '',
          "amount": _amountController.text,
          "description": _commentController.text,
        };
        print("expense response $body");
      }
      else if (m.type == "non_conveyance") {
        if (nonSelectedCategory == null || _flowAmountController.text.isEmpty) {
          throw "Please fill required fields";
        }

        body = {
          "expensetype": "non_conveyance",
          "tour_plan_id": widget.tourPlanId,
          "visit_id": widget.visitId,
          "category": nonSelectedCategory,
          "city": nonSelectedCity,
          "expense_type": nonSelectedExpenseType,
          "allowance_type": nonSelectedAllowanceType ?? '',
          "remarks": _remarksController.text,
          "misc_comment": _mislinisCommentController.text,
          "amount": _flowAmountController.text, // Use standard 'amount' key often used in API, or 'flow_amount' if specific
        };
      }
      else if (m.type == "local_conveyance") {
        if (selectedMode == null || _amountController.text.isEmpty) {
          throw "Please fill required fields";
        }

        body = {
          "expensetype": "local_conveyance",
          "tour_plan_id": widget.tourPlanId,
          "visit_id": widget.visitId,
          "mode_of_travel": selectedMode, // In local conveyance, travel_type is the mode
          "amount": _amountController.text,
        };
      }

      // 2. Call the Controller
      bool success = await _apiController.updateExpense(
        expenseId: m.id,
        body: body,
        images: pickedImages,
      );

      if (success) {
        Get.snackbar("Success", "Expense updated successfully", backgroundColor: Colors.green, colorText: Colors.white);
        Navigator.pop(context, true); // Return true to refresh list
      } else {
        Get.snackbar("Error", "Failed to update expense", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Required", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if(mounted) setState(() => isSubmitting = false);
    }
  }

  // Helper to convert UI Date (dd-MMM-yyyy hh:mm a) to API Date (yyyy-MM-dd HH:mm:ss)
  String _formatDateForApi(String uiDate) {
    if (uiDate.isEmpty) return "";
    try {
      DateTime dt = DateFormat("dd-MMM-yyyy hh:mm a").parse(uiDate);
      return DateFormat("yyyy-MM-dd HH:mm:ss").format(dt);
    } catch (e) {
      return uiDate; // Fallback
    }
  }
}