// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shrachi/api/expense_controller.dart';
// import 'package:shrachi/api/profile_controller.dart';
// import 'package:shrachi/views/components/searchable_dropdown.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:get/get.dart';
//
// class CreateExpense extends StatefulWidget {
//   final String type;
//   final int tourPlanId;
//   final int visitId;
//   const CreateExpense({
//     super.key,
//     required this.type,
//     required this.tourPlanId,
//     required this.visitId,
//   });
//   @override
//   State<CreateExpense> createState() => _CreateExpenseState();
// }
//
// class _CreateExpenseState extends State<CreateExpense> {
//   final ProfileController _profileController = Get.put(ProfileController());
//   final ExpenseController _expenseController = Get.put(ExpenseController());
//
//   List<Map<String, dynamic>> expenses = [];
//   Map<String, String> errors = {};
//
//   final _expenseDateController = TextEditingController();
//   final _designationController = TextEditingController();
//   final _departureTownController = TextEditingController();
//   final _departureTimeController = TextEditingController();
//   final _arrivalTownController = TextEditingController();
//   final _arrivalTimeController = TextEditingController();
//   final _commentController = TextEditingController();
//
//   String? selectedMode;
//   String? expenseDateError;
//   String? designationError;
//
//   // ======== Non Conveyance ========
//   final TextEditingController _tourLocationController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();
//
//   String? selectedExpenseType;
//   String? selectedDAType;
//
//   // ======== Local Conveyance ======
//   final TextEditingController _travelAmountController = TextEditingController();
//   String? selectedTravelType;
//
//   final ImagePicker _picker = ImagePicker();
//   List<XFile> pickedImages = [];
//
//   // Future<void> pickImageFromCamera() async {
//   //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//   //   if (image != null) {
//   //     setState(() {
//   //       pickedImages.add(image);
//   //     });
//   //   }
//   // }
//   // -------------- pickImage --------------------
//   Future<void> pickImage(String sourceType) async {
//     try {
//       if (sourceType == 'camera') {
//         final XFile? image = await _picker.pickImage(
//           source: ImageSource.camera,
//         );
//         if (image != null) {
//           setState(() {
//             pickedImages.add(image);
//             errors.remove('photo');
//           });
//         }
//       } else if (sourceType == 'gallery') {
//         final List<XFile> images = await _picker.pickMultiImage();
//         if (images.isNotEmpty) {
//           setState(() {
//             pickedImages.addAll(images);
//             errors.remove('photo');
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//     }
//   }
//   void showPickerOptions(Function(List<XFile>) onImagesPicked) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 width: 40,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 "Select Option",
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(
//                   Icons.camera_alt_rounded,
//                   color: Colors.blue,
//                 ),
//                 title: const Text(
//                   'Take Photo',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () async {
//                   final XFile? img = await _picker.pickImage(
//                     source: ImageSource.camera,
//                   );
//                   if (img != null) {
//                     onImagesPicked([img]);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               const Divider(height: 0),
//               ListTile(
//                 leading: const Icon(
//                   Icons.photo_library_rounded,
//                   color: Colors.green,
//                 ),
//                 title: const Text(
//                   'Choose from Gallery',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () async {
//                   final List<XFile> images = await _picker.pickMultiImage();
//                   if (images.isNotEmpty) {
//                     onImagesPicked(images);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               const Divider(height: 0),
//               ListTile(
//                 leading: const Icon(
//                   Icons.close_rounded,
//                   color: Colors.redAccent,
//                 ),
//                 title: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () => Navigator.pop(context),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   InputDecoration _textDecoration(String label) {
//     return InputDecoration(
//       alignLabelWithHint: true,
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       errorStyle: TextStyle(color: Colors.red),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red.withValues(alpha: 0.42),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       hintText: label,
//     );
//   }
//
//   InputDecoration _dropdownDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       // suffixIcon: Icon(Ionicons.chevron_down),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       errorStyle: TextStyle(color: Colors.red),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red.withValues(alpha: 0.42),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
//
//   void addExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         selectedMode = null;
//         _departureTownController.clear();
//         _departureTimeController.clear();
//         _arrivalTownController.clear();
//         _arrivalTimeController.clear();
//         _commentController.clear();
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//         (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "departureTown": _departureTownController.text,
//         "departureTime": _departureTimeController.text,
//         "arrivalTown": _arrivalTownController.text,
//         "arrivalTime": _arrivalTimeController.text,
//         "modeOfTravel": selectedMode,
//         "amount": _amountController.text,
//         "comment": _commentController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         if (!expenses[existingIndex]["data"].contains(newEntry)) {
//           expenses[existingIndex]["data"].add(newEntry);
//         }
//       }
//
//       _departureTownController.clear();
//       _departureTimeController.clear();
//       _arrivalTownController.clear();
//       _arrivalTimeController.clear();
//       selectedMode = null;
//       _commentController.clear();
//       pickedImages.clear();
//     });
//   }
//
//   void editExpense(
//     int parentIndex,
//     int entryIndex,
//     Map<String, dynamic> updatedEntry,
//   ) {
//     if (parentIndex >= 0 && parentIndex < expenses.length) {
//       var group = expenses[parentIndex];
//
//       var data = group["data"];
//
//       if (data is List) {
//         if (entryIndex >= 0 && entryIndex < data.length) {
//           setState(() {
//             data[entryIndex] = updatedEntry;
//
//             expenses[parentIndex] = {...group, "data": List.from(data)};
//           });
//         }
//       }
//     }
//   }
//
//   void deleteExpense(int index) {
//     if (index >= 0 && index < expenses.length) {
//       setState(() {
//         expenses.removeAt(index);
//       });
//     }
//   }
//
//   // ==== Date picker =========
//   Future<void> pickDateTime(TextEditingController controller) async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//
//     if (date == null) return;
//
//     if (!mounted) return;
//     TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (time == null) return;
//
//     final selectedDateTime = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );
//
//     final formatted = DateFormat(
//       "dd-MMM-yyyy hh:mm a",
//     ).format(selectedDateTime);
//
//     setState(() {
//       controller.text = formatted;
//     });
//   }
//
//   // ======== Add Expense Modal ===============
//   void showAddExpenseModal(
//     BuildContext context, {
//     Map<String, dynamic>? editingEntry,
//     int? parentIndex,
//     int? childIndex,
//   }) {
//     if (_expenseDateController.text.isEmpty ||
//         _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError =
//             _expenseDateController.text.isEmpty
//                 ? 'Please select expense date'
//                 : null;
//         designationError =
//             _designationController.text.isEmpty
//                 ? 'Designation is required'
//                 : null;
//       });
//       return;
//     }
//
//     if (editingEntry != null) {
//       _departureTownController.text = editingEntry['departureTown'] ?? '';
//       _departureTimeController.text = editingEntry['departureTime'] ?? '';
//       _arrivalTownController.text = editingEntry['arrivalTown'] ?? '';
//       _arrivalTimeController.text = editingEntry['arrivalTime'] ?? '';
//       selectedMode = editingEntry['modeOfTravel'] ?? '';
//       _amountController.text = editingEntry['amount'] ?? '';
//       _commentController.text = editingEntry['comment'] ?? '';
//       selectedMode = editingEntry['modeOfTravel'];
//       pickedImages =
//           (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ??
//           [];
//     }
//
//     Map<String, String?> errors = {};
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             void validateAndSubmit() {
//               errors.clear();
//
//               if (_departureTownController.text.trim().isEmpty) {
//                 errors['departureTown'] = 'Enter departure town';
//               }
//               if (_departureTimeController.text.trim().isEmpty) {
//                 errors['departureTime'] = 'Select departure time';
//               }
//               if (_arrivalTownController.text.trim().isEmpty) {
//                 errors['arrivalTown'] = 'Enter arrival town';
//               }
//               if (_arrivalTimeController.text.trim().isEmpty) {
//                 errors['arrivalTime'] = 'Select arrival time';
//               }
//               if (selectedMode!.isEmpty) {
//                 errors['modeOfTravel'] = 'Select mode of travel';
//               }
//               if (_amountController.text.trim().isEmpty) {
//                 errors['amount'] = 'Enter amount amount';
//               } else if (double.tryParse(_amountController.text.trim()) ==
//                   null) {
//                 errors['amount'] = 'Enter valid number';
//               }
//               if (pickedImages.isEmpty) {
//                 errors['photo'] = 'Please add at least one photo';
//               }
//
//               // setModalState(() {});
//
//               if (errors.isEmpty) {
//                 final updatedEntry = {
//                   'departureTown': _departureTownController.text.trim(),
//                   'departureTime': _departureTimeController.text.trim(),
//                   'arrivalTown': _arrivalTownController.text.trim(),
//                   'arrivalTime': _arrivalTimeController.text.trim(),
//                   'modeOfTravel': selectedMode,
//                   'amount': _amountController.text.trim(),
//                   'comment': _commentController.text.trim(),
//                   'images': pickedImages.map((e) => e.path).toList(),
//                 };
//                 if (editingEntry == null) {
//                   addExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, updatedEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         editingEntry == null
//                             ? "Add New Expense"
//                             : "Edit Expense",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: _departureTownController,
//                         decoration: _textDecoration('Departure town').copyWith(
//                           errorText: errors['departureTown'],
//                           errorStyle: TextStyle(
//                             color: Colors.red,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _departureTimeController,
//                         readOnly: true,
//                         decoration: _textDecoration('Departure time').copyWith(
//                           errorText: errors['departureTime'],
//                           errorStyle: TextStyle(
//                             color: Colors.red,
//                             fontSize: 14,
//                           ),
//                         ),
//                         onTap: () => pickDateTime(_departureTimeController),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _arrivalTownController,
//                         decoration: _textDecoration(
//                           'Arrival town',
//                         ).copyWith(errorText: errors['arrivalTown']),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _arrivalTimeController,
//                         readOnly: true,
//                         decoration: _textDecoration(
//                           'Arrival time',
//                         ).copyWith(errorText: errors['arrivalTime']),
//                         onTap: () => pickDateTime(_arrivalTimeController),
//                       ),
//                       const SizedBox(height: 10),
//                       SearchableDropdown(
//                         items: [
//                           'Train (Sleeper)',
//                           'Train (AC 3)',
//                           'Train (AC 2)',
//                           'Air (Economic Class)',
//                         ],
//                         itemLabel: (item) => item,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedMode = value;
//                           });
//                         },
//                         selectedItem: selectedMode,
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _amountController,
//                         keyboardType: TextInputType.number,
//                         decoration: _textDecoration(
//                           'Fare Rs.',
//                         ).copyWith(errorText: errors['fare']),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _commentController,
//                         decoration: _textDecoration('Comment (optional)'),
//                       ),
//                       const SizedBox(height: 10),
//                       InkWell(
//                         // onTap: () async {
//                         //   final img = await _picker.pickImage(
//                         //     source: ImageSource.camera,
//                         //   );
//                         //   if (img != null) {
//                         //     setModalState(() {
//                         //       pickedImages.add(img);
//                         //       errors.remove('photo');
//                         //     });
//                         //   }
//                         // },
//                           //----- inkwell -----------
//                           onTap: () {
//                             showPickerOptions((images) {
//                               setModalState(() {
//                                 pickedImages.addAll(images);
//                                 errors.remove('photo');
//                               });
//                             });
//                           },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black.withValues(alpha: 0.5),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Add Photo",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             errors['photo']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child:
//                                         !kIsWeb
//                                             ? Image.file(
//                                               File(pickedImages[index].path),
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             )
//                                             : Image.network(
//                                               pickedImages[index].path,
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 20,
//                             ),
//                           ),
//                           child: Text(
//                             editingEntry == null
//                                 ? "Add Expense"
//                                 : "Update Expense",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   TextEditingController _mislinisCommentController = TextEditingController();
//
//   void addNonConveyanceExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         _tourLocationController.clear();
//         selectedExpenseType = null;
//         _amountController.clear();
//         selectedDAType = null;
//         _remarksController.clear();
//         _mislinisCommentController.clear(); // clear misc comment
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//             (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "tourLocation": _tourLocationController.text,
//         "expenseType": selectedExpenseType,
//         "amount": _amountController.text,
//         "daType": selectedDAType,
//         // Miscellaneous হলে mislinisComment use হবে
//         "remarks": selectedExpenseType == 'Miscellaneous'
//             ? _mislinisCommentController.text
//             : _remarksController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         expenses[existingIndex]["data"].add(newEntry);
//       }
//
//       // Clear all fields after add
//       _tourLocationController.clear();
//       selectedExpenseType = null;
//       selectedDAType = null;
//       _remarksController.clear();
//       _mislinisCommentController.clear();
//       _amountController.clear();
//       pickedImages.clear();
//     });
//   }
//
//
//   void showAddNonConveyanceModal(
//     BuildContext context, {
//     Map<String, dynamic>? editingEntry,
//     int? parentIndex,
//     int? childIndex,
//   }) {
//     if (_expenseDateController.text.isEmpty ||
//         _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError =
//             _expenseDateController.text.isEmpty
//                 ? 'Please select expense date'
//                 : null;
//         designationError =
//             _designationController.text.isEmpty
//                 ? 'Designation is required'
//                 : null;
//       });
//       return;
//     }
//
//     if (editingEntry != null) {
//       _tourLocationController.text = editingEntry['tourLocation'] ?? '';
//       _amountController.text = editingEntry['amount'] ?? 0;
//       _remarksController.text = editingEntry['remarks'] ?? '';
//       selectedExpenseType = editingEntry['expenseType'];
//       selectedDAType = editingEntry['daType'];
//       pickedImages =
//           (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ??
//           [];
//     }
//
//     Map<String, String?> errors = {};
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             void validateAndSubmit() {
//               errors.clear();
//
//               print("expense$validateAndSubmit");
//               if (_tourLocationController.text.trim().isEmpty) {
//                 errors['tourLocation'] = 'Enter tour location';
//               }
//               if (selectedExpenseType == null || selectedExpenseType!.isEmpty) {
//                 errors['expenseType'] = 'Select expense type';
//               }
//               if (_amountController.text.trim().isEmpty) {
//                 errors['amount'] = 'Enter amount';
//               }
//               // if (selectedDAType == null || selectedDAType!.isEmpty) {
//               //   errors['daType'] = 'Select DA type';
//               // }
//               if (pickedImages.isEmpty) {
//                 errors['photo'] = 'Please add at least one photo';
//               }
//
//               setModalState(() {});
//
//               if (errors.isEmpty) {
//                 if (editingEntry == null) {
//                   addNonConveyanceExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, editingEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         editingEntry == null
//                             ? "Add Non-Conveyance Expense"
//                             : "Edit Non-Conveyance Expense",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // ✅ Tour Location
//                       TextField(
//                         controller: _tourLocationController,
//                         decoration: _textDecoration(
//                           'Tour Location',
//                         ).copyWith(errorText: errors['tourLocation']),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // ✅ Expense Type Dropdown
//                       DropdownButtonFormField<String>(
//                         value: selectedExpenseType,
//                         dropdownColor: Colors.white,
//                         items: ['Hotel', 'Fooding', 'Miscellaneous']
//                             .map(
//                               (e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e == 'Fooding' ? 'DA' : e),
//                           ),
//                         ).toList(),
//                         onChanged: (value) {
//                           setModalState(() {
//                             selectedExpenseType = value;
//                           });
//                         },
//                         decoration: _textDecoration(
//                           'Expense Type',
//                         ).copyWith(errorText: errors['expenseType']),
//                       ),
//
//                       const SizedBox(height: 10),
//
//                       // ✅ Conditional Comment box (for Miscellaneous)
//                       if (selectedExpenseType == 'Miscellaneous') ...[
//                         TextField(
//                           controller: _remarksController,
//                           decoration: _textDecoration('Comment (required)'),
//                         ),
//                         const SizedBox(height: 10),
//                       ],
//                       // ✅ Amount Field
//                       TextField(
//                         controller: _amountController,
//                         decoration: _textDecoration('Amount'),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // ✅ DA Type Dropdown
//                       // DropdownButtonFormField<String>(
//                       //   value: selectedDAType,
//                       //   dropdownColor: Colors.white,
//                       //   items: ['Full Day', 'Half Day']
//                       //       .map(
//                       //         (e) => DropdownMenuItem(
//                       //       value: e,
//                       //       child: Text(e),
//                       //     ),
//                       //   )
//                       //       .toList(),
//                       //   onChanged: (value) {
//                       //     setModalState(() {
//                       //       selectedDAType = value;
//                       //     });
//                       //   },
//                       //   decoration: _textDecoration(
//                       //     'DA Type',
//                       //   ).copyWith(errorText: errors['daType']),
//                       // ),
//                       const SizedBox(height: 10),
//
//                       // ✅ Remarks (optional)
//                       if (selectedExpenseType != 'Miscellaneous')
//                         TextField(
//                           controller: _remarksController,
//                           decoration: _textDecoration('Remarks (optional)'),
//                         ),
//                       const SizedBox(height: 10),
//
//                       // ✅ Add Photo Section
//                       InkWell(
//                         // onTap: () async {
//                         //   final img = await _picker.pickImage(
//                         //     source: ImageSource.camera,
//                         //   );
//                         //   if (img != null) {
//                         //     setModalState(() {
//                         //       pickedImages.add(img);
//                         //       errors.remove('photo');
//                         //     });
//                         //   }
//                         // },
//                         onTap: () {
//                           showPickerOptions((images) {
//                             setModalState(() {
//                               pickedImages.addAll(images);
//                               errors.remove('photo');
//                             });
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black.withValues(alpha: 0.5),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Add Photo",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             errors['photo']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: !kIsWeb
//                                         ? Image.file(
//                                       File(pickedImages[index].path),
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                         : Image.network(
//                                       pickedImages[index].path,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//
//                       const SizedBox(height: 20),
//                       // ✅ Submit Button
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 20,
//                             ),
//                           ),
//
//                           child: Text(
//                             editingEntry == null
//                                 ? "Add Expense"
//                                 : "Update Expense",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//
//   }
//
//   void addLocalConveyanceExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         selectedTravelType = null;
//         _travelAmountController.clear();
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//         (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "travelType": selectedTravelType,
//         "travelAmount": _travelAmountController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         if (!expenses[existingIndex]["data"].contains(newEntry)) {
//           expenses[existingIndex]["data"].add(newEntry);
//         }
//       }
//
//       _tourLocationController.clear();
//       selectedExpenseType = null;
//       selectedDAType = null;
//       _remarksController.clear();
//       _amountController.clear();
//       pickedImages.clear();
//     });
//   }
//
//   void showAddLocalConveyanceModal(
//     BuildContext context, {
//     Map<String, dynamic>? editingEntry,
//     int? parentIndex,
//     int? childIndex,
//   }) {
//     if (_expenseDateController.text.isEmpty ||
//         _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError =
//             _expenseDateController.text.isEmpty
//                 ? 'Please select expense date'
//                 : null;
//         designationError =
//             _designationController.text.isEmpty
//                 ? 'Designation is required'
//                 : null;
//       });
//       return;
//     }
//
//     if (editingEntry != null) {
//       selectedTravelType = editingEntry['travelType'];
//       _travelAmountController.text = editingEntry['travelAmount'] ?? 0;
//       pickedImages =
//           (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ??
//           [];
//     }
//
//     Map<String, String?> errors = {};
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             void validateAndSubmit() {
//               errors.clear();
//
//               if (selectedTravelType == null || selectedTravelType!.isEmpty) {
//                 errors['travelType'] = 'Select travel type';
//               }
//               if (_travelAmountController.text.trim().isEmpty) {
//                 errors['travelAmount'] = 'Enter travel amount';
//               }
//
//               setModalState(() {});
//
//               if (errors.isEmpty) {
//                 if (editingEntry == null) {
//                   addLocalConveyanceExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, editingEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         editingEntry == null
//                             ? "Add Local-Conveyance Expense"
//                             : "Edit Local-Conveyance Expense",
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       DropdownButtonFormField<String>(
//                         value: selectedTravelType,
//                         dropdownColor: Colors.white,
//                         items:
//                             ['Auto', 'Ola/Uber/Taxi', 'Ac Bus']
//                                 .map(
//                                   (e) => DropdownMenuItem(
//                                     value: e,
//                                     child: Text(e),
//                                   ),
//                                 )
//                                 .toList(),
//                         onChanged: (value) {
//                           setModalState(() {
//                             selectedTravelType = value;
//                           });
//                         },
//                         decoration: _dropdownDecoration(
//                           'Travel Type',
//                         ).copyWith(errorText: errors['travelType']),
//                       ),
//                       SizedBox(height: 10),
//                       TextField(
//                         controller: _travelAmountController,
//                         decoration: _textDecoration(
//                           'Travel Amount',
//                         ).copyWith(errorText: errors['travelAmount']),
//                       ),
//                       const SizedBox(height: 10),
//                       InkWell(
//                         // onTap: () async {
//                         //   final img = await _picker.pickImage(
//                         //     source: ImageSource.camera,
//                         //   );
//                         //   if (img != null) {
//                         //     setModalState(() {
//                         //       pickedImages.add(img);
//                         //       errors.remove('photo');
//                         //     });
//                         //   }
//                         // },
//                         onTap: () {
//                           showPickerOptions((images) {
//                             setModalState(() {
//                               pickedImages.addAll(images);
//                               errors.remove('photo');
//                             });
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black.withValues(alpha: 0.5),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Add Photo",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             errors['photo']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child:
//                                         !kIsWeb
//                                             ? Image.file(
//                                               File(pickedImages[index].path),
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             )
//                                             : Image.network(
//                                               pickedImages[index].path,
//                                               width: 80,
//                                               height: 80,
//                                               fit: BoxFit.cover,
//                                             ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 20,
//                             ),
//                           ),
//                           child: Text(
//                             editingEntry == null
//                                 ? "Add Expense"
//                                 : "Update Expense",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _expenseDateController.text = DateFormat(
//         'dd-MM-yyyy',
//       ).format(DateTime.now());
//       _designationController.text =
//           _profileController.user.value?.designation ?? 'N/A';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final filteredEntries =
//         expenses
//             .where(
//               (visit) => visit['expense_date'] == _expenseDateController.text,
//             )
//             .expand((visit) => visit['data'].asMap().entries)
//             .toList();
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Create ${widget.type} expense')),
//         body: Align(
//           alignment: Alignment.center,
//           child: Container(
//             width:
//                 Responsive.isSm(context)
//                     ? screenWidth
//                     : Responsive.isXl(context)
//                     ? screenWidth * 0.60
//                     : screenWidth * 0.40,
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _expenseDateController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 20,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withValues(alpha: 0.42),
//                         width: 1.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withValues(alpha: 0.42),
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red.withValues(alpha: 0.6),
//                         width: 2,
//                       ),
//                     ),
//                     labelText: 'Expense Date',
//                     labelStyle: TextStyle(
//                       color: Colors.black.withValues(alpha: 0.7),
//                     ),
//                     hintText: 'Expense Date',
//                     errorText: expenseDateError,
//                     suffixIcon: const Icon(
//                       Icons.calendar_today,
//                       color: Colors.black,
//                     ),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//
//                       firstDate: DateTime(2000),
//
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         _expenseDateController.text =
//                             "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//                       });
//                     }
//                   },
//                 ),
//                 SizedBox(height: 15),
//                 TextField(
//                   controller: _designationController,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 20,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withValues(alpha: 0.42),
//                         width: 1.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withValues(alpha: 0.42),
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red.withValues(alpha: 0.6),
//                         width: 2,
//                       ),
//                     ),
//                     labelText: 'Designation',
//                     labelStyle: TextStyle(
//                       color: Colors.black.withValues(alpha: 0.7),
//                     ),
//                     hintText: 'Designation',
//                     errorText: designationError,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 if (expenses.isNotEmpty)
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         separatorBuilder:
//                             (context, index) => SizedBox(height: 15.0),
//                         itemCount: filteredEntries.length,
//                         itemBuilder: (context, index) {
//                           final entry = filteredEntries[index];
//                           final entryIndex = entry.key;
//                           final entryValue = entry.value;
//                           return widget.type == 'Conveyance'
//                               ? ExpenseCard(
//                                 entryValue: entryValue,
//                                 parentIndex: index,
//                                 childIndex: entryIndex,
//                                 onEdit: (value, parentIndex, childIndex) {
//                                   showAddExpenseModal(
//                                     context,
//                                     editingEntry: value,
//                                     parentIndex: parentIndex,
//                                     childIndex: childIndex,
//                                   );
//                                 },
//                                 onDelete: (parentIndex, childIndex) {
//                                   setState(() {
//                                     expenses[parentIndex]['data'].removeAt(
//                                       childIndex,
//                                     );
//                                     if (expenses[parentIndex]['data'].isEmpty) {
//                                       expenses.removeAt(parentIndex);
//                                     }
//                                   });
//                                 },
//                               )
//                               : widget.type == 'Non Conveyance'
//                               ? ExpenseNonConveyanceCard(
//                                 entryValue: entryValue,
//                                 parentIndex: index,
//                                 childIndex: entryIndex,
//                                 onEdit: (value, parentIndex, childIndex) {
//                                   showAddNonConveyanceModal(
//                                     context,
//                                     editingEntry: value,
//                                     parentIndex: parentIndex,
//                                     childIndex: childIndex,
//                                   );
//                                 },
//                                 onDelete: (parentIndex, childIndex) {
//                                   setState(() {
//                                     expenses[parentIndex]['data'].removeAt(
//                                       childIndex,
//                                     );
//                                     if (expenses[parentIndex]['data'].isEmpty) {
//                                       expenses.removeAt(parentIndex);
//                                     }
//                                   });
//                                 },
//                               )
//                               : ExpenseLocalConveyanceCard(
//                                 entryValue: entryValue,
//                                 parentIndex: index,
//                                 childIndex: entryIndex,
//                                 onEdit: (value, parentIndex, childIndex) {
//                                   showAddLocalConveyanceModal(
//                                     context,
//                                     editingEntry: value,
//                                     parentIndex: parentIndex,
//                                     childIndex: childIndex,
//                                   );
//                                 },
//                                 onDelete: (parentIndex, childIndex) {
//                                   setState(() {
//                                     expenses[parentIndex]['data'].removeAt(
//                                       childIndex,
//                                     );
//                                     if (expenses[parentIndex]['data'].isEmpty) {
//                                       expenses.removeAt(parentIndex);
//                                     }
//                                   });
//                                 },
//                               );
//                           },
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 15),
//                 if (expenses.isEmpty)
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       foregroundColor: Colors.black,
//                       overlayColor: Colors.transparent,
//                       padding: EdgeInsets.zero,
//                     ),
//                     onPressed:
//                         () =>
//                             widget.type == 'Conveyance'
//                                 ? showAddExpenseModal(context)
//                                 : widget.type == 'Non Conveyance'
//                                 ? showAddNonConveyanceModal(context)
//                                 : showAddLocalConveyanceModal(context),
//                     child: Row(
//                       children: const [
//                         Icon(Ionicons.add_sharp),
//                         SizedBox(width: 5),
//                         Text(
//                           'Add Visit',
//                           style: TextStyle(color: Colors.black, fontSize: 16),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar:
//             expenses.isNotEmpty
//                 ? Obx(() {
//                   final expense =
//                       expenses
//                           .where(
//                             (v) => v["expense_date"] == _expenseDateController.text,
//                           )
//                           .toList();
//                   final firstData =
//                       expense.isNotEmpty ? expense.first['data'][0] : {};
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: ColorPalette.pictonBlue600,
//                     ),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: () async {
//                         await _expenseController.createExpense(
//                           tourPlanId: widget.tourPlanId,
//                           visitId: widget.visitId,
//                           expensetype: firstData["type"] ?? '',
//                           date: DateFormat("yyyy-MM-dd").format(
//                             DateFormat("dd-MM-yyyy").parse(_expenseDateController.text),
//                           ),
//                           departureTown: firstData["departureTown"] ?? '',
//                           departureTime: firstData["departureTime"] != null
//                               ? DateFormat("dd-MMM-yyyy hh:mm a").parse(firstData["departureTime"]).toString()
//                               : '',
//                           arrivalTown: firstData["arrivalTown"] ?? '',
//                           arrivalTime: firstData["arrivalTime"] != null
//                               ? DateFormat("dd-MMM-yyyy hh:mm a").parse(firstData["arrivalTime"]).toString()
//                               : '',
//                           modeOfTravel: firstData["type"] == 'local_conveyance'
//                               ? (firstData["travelType"] ?? '')
//                               : (firstData["modeOfTravel"] ?? ''),
//                           amount: firstData["type"] == 'local_conveyance'
//                               ? double.tryParse(firstData["travelAmount"] ?? '0')
//                               : double.tryParse(firstData["amount"] ?? '0'),
//                           comment: firstData["remarks"] ?? '',
//                           images: firstData['images'] ?? [],
//                           location: firstData["tourLocation"] ?? '',
//                           type: firstData["expenseType"] ?? '',
//                           daType: firstData["daType"] ?? '',
//                         );
//                         print("Submit Expense $firstData");
//                       },
//                       child: _expenseController.isLoading.value
//                               ? SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.white,
//                                   backgroundColor: Colors.transparent,
//                                 ),
//                               )
//                               : Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                     ),
//                   );
//                 })
//                 : null,
//       ),
//     );
//   }
// }
//
// class ExpenseCard extends StatefulWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(int parentIndex, int childIndex) onDelete;
//   final Function(
//     Map<String, dynamic> entryValue,
//     int parentIndex,
//     int childIndex,
//   )
//   onEdit;
//
//   const ExpenseCard({
//     super.key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onDelete,
//     required this.onEdit,
//   });
//
//   @override
//   State<ExpenseCard> createState() => _ExpenseCardState();
// }
//
// class _ExpenseCardState extends State<ExpenseCard> {
//   @override
//   Widget build(BuildContext context) {
//     final entryValue = widget.entryValue;
//     return Card(
//       color: Colors.grey[200],
//       elevation: 6,
//       shadowColor: Colors.black.withValues(alpha: 0.1),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Departure Town: ${entryValue['departureTown']}"),
//                 const SizedBox(height: 15),
//                 Text("Departure Time: ${entryValue['departureTime']}"),
//                 const SizedBox(height: 15),
//                 Text("Arrival Town: ${entryValue['arrivalTown']}"),
//                 const SizedBox(height: 15),
//                 Text("Arrival Time: ${entryValue['arrivalTime']}"),
//                 const SizedBox(height: 15),
//                 Text("Mode Of Travel: ${entryValue['modeOfTravel']}"),
//                 const SizedBox(height: 15),
//                 Text("Fare Rs.: ₹ ${entryValue['amount']}"),
//                 if (entryValue['comment'] != null && entryValue['comment'].toString().isNotEmpty)
//                   const SizedBox(height: 15),
//                 if (entryValue['comment'] != null && entryValue['comment'].toString().isNotEmpty)
//                   Text("Comments: ${entryValue['comment']}"),
//               ],
//             ),
//             const SizedBox(height: 15.0),
//             Row(
//               children: [
//                 TextButton.icon(
//                   icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
//                   label: const Text(
//                     "Edit",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   onPressed: () {
//                     widget.onEdit(
//                       widget.entryValue,
//                       widget.parentIndex,
//                       widget.childIndex,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 TextButton.icon(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   label: const Text(
//                     "Delete",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onPressed: () {
//                     widget.onDelete(widget.parentIndex, widget.childIndex);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExpenseNonConveyanceCard extends StatefulWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(int parentIndex, int childIndex) onDelete;
//   final Function(
//     Map<String, dynamic> entryValue,
//     int parentIndex,
//     int childIndex,
//   )
//   onEdit;
//
//   const ExpenseNonConveyanceCard({
//     super.key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onDelete,
//     required this.onEdit,
//   });
//
//   @override
//   State<ExpenseNonConveyanceCard> createState() => _ExpenseNonConveyanceCardState();
// }
//
// class _ExpenseNonConveyanceCardState extends State<ExpenseNonConveyanceCard> {
//   @override
//   Widget build(BuildContext context) {
//     final entryValue = widget.entryValue;
//
//     return Card(
//       color: Colors.grey[200],
//       elevation: 6,
//       shadowColor: Colors.black.withValues(alpha: 0.1),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Tour Location: ${entryValue['tourLocation']}"),
//                 const SizedBox(height: 15),
//                 Text("Expense Type: ${entryValue['expenseType']}"),
//                 const SizedBox(height: 15),
//                 Text("Amount: ${entryValue['amount']}"),
//                 const SizedBox(height: 15),
//                 Text("DA Type: ${entryValue['daType']}"),
//                 if (entryValue['remarks'] != '') ...[
//                   const SizedBox(height: 15),
//                   Text("Remarks: ${entryValue['remarks']}"),
//                 ],
//               ],
//             ),
//             const SizedBox(height: 15.0),
//             Row(
//               children: [
//                 TextButton.icon(
//                   icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
//                   label: const Text(
//                     "Edit",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   onPressed: () {
//                     widget.onEdit(
//                       widget.entryValue,
//                       widget.parentIndex,
//                       widget.childIndex,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 TextButton.icon(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   label: const Text(
//                     "Delete",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onPressed: () {
//                     widget.onDelete(widget.parentIndex, widget.childIndex);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExpenseLocalConveyanceCard extends StatefulWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(int parentIndex, int childIndex) onDelete;
//   final Function(
//     Map<String, dynamic> entryValue,
//     int parentIndex,
//     int childIndex,
//   )
//   onEdit;
//
//   const ExpenseLocalConveyanceCard({
//     super.key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onDelete,
//     required this.onEdit,
//   });
//
//   @override
//   State<ExpenseLocalConveyanceCard> createState() =>
//       _ExpenseLocalConveyanceCardState();
// }
//
// class _ExpenseLocalConveyanceCardState extends State<ExpenseLocalConveyanceCard> {
//   @override
//   Widget build(BuildContext context) {
//     final entryValue = widget.entryValue;
//
//     return Card(
//       color: Colors.grey[200],
//       elevation: 6,
//       shadowColor: Colors.black.withValues(alpha: 0.1),
//       margin: const EdgeInsets.symmetric(vertical: 5),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Travel Type: ${entryValue['travelType']}"),
//                 const SizedBox(height: 15),
//                 Text("Amount: ${entryValue['travelAmount']}"),
//               ],
//             ),
//             const SizedBox(height: 15.0),
//             Row(
//               children: [
//                 TextButton.icon(
//                   icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
//                   label: const Text(
//                     "Edit",
//                     style: TextStyle(color: Colors.blue),
//                   ),
//                   onPressed: () {
//                     widget.onEdit(
//                       widget.entryValue,
//                       widget.parentIndex,
//                       widget.childIndex,
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//                 TextButton.icon(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   label: const Text(
//                     "Delete",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onPressed: () {
//                     widget.onDelete(widget.parentIndex, widget.childIndex);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/api/expense_controller.dart';
import 'package:shrachi/api/profile_controller.dart';
import 'package:shrachi/views/components/searchable_dropdown.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:get/get.dart';
import '../../../../api/ExpenseController/ConveyanceDropdownController.dart';
import '../../../../api/ExpenseController/LocConveyanceController.dart';
import '../../../../api/ExpenseController/NonConveyanceFetchController.dart';

class CreateExpense extends StatefulWidget {
  final DateTime? startDate;
  final String type;
  final int tourPlanId;
  final int visitId;
   const CreateExpense({super.key,  this.startDate, required this.type, required this.tourPlanId, required this.visitId,});
  @override
  State<CreateExpense> createState() => _CreateExpenseState();
}
class _CreateExpenseState extends State<CreateExpense> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProfileController _profileController = Get.put(ProfileController());
  final ExpenseController _expenseController = Get.put(ExpenseController());
  final FlowController flow = Get.put(FlowController(),); // Initialize FlowController
  final ConveyanceController conveyance = Get.put(ConveyanceController());
  final LocalConveyanceController LocConveyance = Get.put(LocalConveyanceController(),);

  List<Map<String, dynamic>> expenses = [];
  Map<String, String> errors = {};

  final _expenseDateController = TextEditingController();
  final _designationController = TextEditingController();
  final _departureTownController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _arrivalTownController = TextEditingController();
  final _arrivalTimeController = TextEditingController();
  final _commentController = TextEditingController();

  String? selectedMode;
  String? expenseDateError;
  String? designationError;

  // ======== Non Conveyance ========
  final TextEditingController _tourLocationController = TextEditingController();
  final TextEditingController _hotel_PriceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  // Controller for miscellaneous comment
  final TextEditingController _mislinisCommentController = TextEditingController();

  // State variables for the new flow UI
  String? NonSelectedCategory;
  String? NonSelectedCity;
  String? NonSelectedExpenseType;
  String? NonSelectedAllowanceType;
  String? amountError;
  TextEditingController flowAmountController = TextEditingController();  // user amount
  TextEditingController maxAmountController = TextEditingController();   // dynamic limit
  ValueNotifier<bool> isAmountExceeded = ValueNotifier(false);

  String foodAllowance = "0.00";
  String travelAllowance = "0.00";
  String hotelAllowance = "0.00";

  Future<void> fetchAllowance(Function updater, String? selectedCategory, String? selectedDayType,) async {
    if (selectedCategory == null || selectedDayType == null) return;

    String typeParam = selectedDayType == "Full day" ? "full_da" : "half_da";

    //https://btlsalescrm.cloud/api/
    final url = Uri.parse(
      "${baseUrl}expenses-allowance?category=$selectedCategory&type=$typeParam",
    );

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final allowance = data["allowance"] ?? {};

      updater(() {
        if (selectedDayType == "Full day") {
          foodAllowance = (allowance["food_allowance"] ?? "0.00").toString();
          hotelAllowance = (allowance["hotel_allowance"] ?? "0.00").toString();
        } else {
          // Half day
          foodAllowance = (allowance["haf_food_allowence"] ?? "0.00").toString();
          hotelAllowance = "0.00"; // Half day e hotel allowance nai
        }
        travelAllowance = (allowance["travel_allowance"] ?? "0.00").toString();
      });
    }
  }

  // ======== Local Conveyance ======
  final TextEditingController _travelAmountController = TextEditingController();
  String? selectedTravelType;

  final ImagePicker _picker = ImagePicker();
  List<XFile> pickedImages = [];
  // 1 MB limit (in bytes)
  final int maxFileSize = 1024 * 1024;

  void _showImageSizeWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Warning", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: const Text("Selected image is larger than 1 MB. Please select a smaller image.", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  /// -------------- pickImage --------------------
  // Future<void> pickImage(String sourceType) async {
  //   try {
  //     if (sourceType == 'camera') {
  //       final XFile? image = await _picker.pickImage(
  //         source: ImageSource.camera,
  //       );
  //       if (image != null) {
  //         setState(() {
  //           pickedImages.add(image);
  //           errors.remove('photo');
  //         });
  //       }
  //     } else if (sourceType == 'gallery') {
  //       final List<XFile> images = await _picker.pickMultiImage();
  //       if (images.isNotEmpty) {
  //         setState(() {
  //           pickedImages.addAll(images);
  //           errors.remove('photo');
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('Error picking image: $e');
  //   }
  // }
  // void showPickerOptions(Function(List<XFile>) onImagesPicked) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return SafeArea(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 10),
  //             Container(
  //               width: 40,
  //               height: 5,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             const SizedBox(height: 15),
  //             const Text(
  //               "Select Option",
  //               style: TextStyle(
  //                 fontSize: 17,
  //                 fontWeight: FontWeight.w600,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             const Divider(),
  //             ListTile(
  //               leading: const Icon(
  //                 Icons.camera_alt_rounded,
  //                 color: Colors.blue,
  //               ),
  //               title: const Text(
  //                 'Take Photo',
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //               onTap: () async {
  //                 final XFile? img = await _picker.pickImage(
  //                   source: ImageSource.camera,
  //                 );
  //                 if (img != null) {
  //                   onImagesPicked([img]);
  //                 }
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             const Divider(height: 0),
  //             ListTile(
  //               leading: const Icon(
  //                 Icons.photo_library_rounded,
  //                 color: Colors.green,
  //               ),
  //               title: const Text(
  //                 'Choose from Gallery',
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //               onTap: () async {
  //                 final List<XFile> images = await _picker.pickMultiImage();
  //                 if (images.isNotEmpty) {
  //                   onImagesPicked(images);
  //                 }
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             const Divider(height: 0),
  //             ListTile(
  //               leading: const Icon(
  //                 Icons.close_rounded,
  //                 color: Colors.redAccent,
  //               ),
  //               title: const Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.black),
  //               ),
  //               onTap: () => Navigator.pop(context),
  //             ),
  //             const SizedBox(height: 10),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> pickImage(String sourceType) async {
    try {
      if (sourceType == 'camera') {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80, // Optional: thoda compress karne ke liye
        );
        if (image != null) {
          int sizeInBytes = await image.length();
          if (sizeInBytes > maxFileSize) {
            _showImageSizeWarning(); // Show warning if > 1MB
          } else {
            setState(() {
              pickedImages.add(image);
              errors.remove('photo');
            });
          }
        }
      } else if (sourceType == 'gallery') {
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 80,
        );
        if (images.isNotEmpty) {
          List<XFile> validImages = [];
          bool hasLargeImage = false;

          for (var img in images) {
            int sizeInBytes = await img.length();
            if (sizeInBytes > maxFileSize) {
              hasLargeImage = true;
            } else {
              validImages.add(img);
            }
          }

          if (hasLargeImage) {
            _showImageSizeWarning(); // Show warning if any image > 1MB
          }

          if (validImages.isNotEmpty) {
            setState(() {
              pickedImages.addAll(validImages);
              errors.remove('photo');
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }
  void showPickerOptions(Function(List<XFile>) onImagesPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Select Option",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.blue,
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () async {
                  // Pehle Image pick karein
                  final XFile? img = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );

                  // Bottom sheet band karein
                  Navigator.pop(context);

                  if (img != null) {
                    // Size Check
                    int sizeInBytes = await img.length();
                    if (sizeInBytes > maxFileSize) {
                      _showImageSizeWarning();
                    } else {
                      onImagesPicked([img]);
                    }
                  }
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_rounded,
                  color: Colors.green,
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () async {
                  // Pehle Images pick karein
                  final List<XFile> images = await _picker.pickMultiImage(
                    imageQuality: 80,
                  );

                  // Bottom sheet band karein
                  Navigator.pop(context);

                  if (images.isNotEmpty) {
                    List<XFile> validImages = [];
                    bool hasLargeImage = false;

                    // Har image ka size check karein
                    for (var img in images) {
                      int sizeInBytes = await img.length();
                      if (sizeInBytes > maxFileSize) {
                        hasLargeImage = true;
                      } else {
                        validImages.add(img);
                      }
                    }

                    if (hasLargeImage) {
                      _showImageSizeWarning();
                    }

                    // Sirf valid images pass karein
                    if (validImages.isNotEmpty) {
                      onImagesPicked(validImages);
                    }
                  }
                },
              ),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(
                  Icons.close_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
  InputDecoration _textDecoration(String label) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      errorStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: label,
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      errorStyle: TextStyle(color: Colors.red),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.withAlpha(107), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void addExpense({bool isNext = false}) {
    setState(() {
      if (isNext) {
        _expenseDateController.clear();
        _designationController.clear();
        selectedMode = null;
        _departureTownController.clear();
        _departureTimeController.clear();
        _arrivalTownController.clear();
        _arrivalTimeController.clear();
        _commentController.clear();
        return;
      }

      String expenseDate = _expenseDateController.text;
      int existingIndex = expenses.indexWhere(
        (v) => v["expense_date"] == expenseDate,
      );

      Map<String, dynamic> newEntry = {
        "type": widget.type.toLowerCase().replaceAll(' ', '_'),
        "departureTown": _departureTownController.text,
        "departureTime": _departureTimeController.text,
        "arrivalTown": _arrivalTownController.text,
        "arrivalTime": _arrivalTimeController.text,
        "modeOfTravel": selectedMode,
        "amount": _amountController.text,
        "comment": _commentController.text,
        "images": pickedImages.map((img) => img.path).toList(),
      };
      if (existingIndex == -1) {
        expenses.add({
          "expense_date": expenseDate,
          "data": [newEntry],
        });
      } else {
        if (!expenses[existingIndex]["data"].contains(newEntry)) {
          expenses[existingIndex]["data"].add(newEntry);
        }
      }
      _departureTownController.clear();
      _departureTimeController.clear();
      _arrivalTownController.clear();
      _arrivalTimeController.clear();
      selectedMode = null;
      _commentController.clear();
      pickedImages.clear();
    });
  }

  void editExpense(int parentIndex, int entryIndex, Map<String, dynamic> updatedEntry,) {
    if (parentIndex >= 0 && parentIndex < expenses.length) {
      var group = expenses[parentIndex];
      var data = group["data"];

      if (data is List) {
        if (entryIndex >= 0 && entryIndex < data.length) {
          setState(() {
            data[entryIndex] = updatedEntry;
            expenses[parentIndex] = {...group, "data": List.from(data)};
          });
        }
      }
    }
  }

  void deleteExpense(int index) {
    if (index >= 0 && index < expenses.length) {
      setState(() {
        expenses.removeAt(index);
      });
    }
  }

  Future<void> pickDateTime(TextEditingController controller) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    if (!mounted) return;
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final formatted = DateFormat(
      "dd-MMM-yyyy hh:mm a",
    ).format(selectedDateTime);
    setState(() {
      controller.text = formatted;
    });
  }

  void showAddExpenseModal(
    BuildContext context, {
    Map<String, dynamic>? editingEntry,
    int? parentIndex,
    int? childIndex,
  })
  {
    if (_expenseDateController.text.isEmpty ||
        _designationController.text.isEmpty) {
      setState(() {
        expenseDateError =
            _expenseDateController.text.isEmpty
                ? 'Please select expense date'
                : null;
        designationError =
            _designationController.text.isEmpty
                ? 'Designation is required'
                : null;
      });
      return;
    }

    if (editingEntry != null) {
      _departureTownController.text = editingEntry['departureTown'] ?? '';
      _departureTimeController.text = editingEntry['departureTime'] ?? '';
      _arrivalTownController.text = editingEntry['arrivalTown'] ?? '';
      _arrivalTimeController.text = editingEntry['arrivalTime'] ?? '';
      selectedMode = editingEntry['modeOfTravel'] ?? '';
      _amountController.text = editingEntry['amount'] ?? '';
      _commentController.text = editingEntry['comment'] ?? '';
      selectedMode = editingEntry['modeOfTravel'];
      pickedImages =
          (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ??
          [];
    } else {
      _departureTownController.clear();
      _departureTimeController.clear();
      _arrivalTownController.clear();
      _arrivalTimeController.clear();
      _amountController.clear();
      _commentController.clear();
      setState(() {
        selectedMode = null;
      });
      pickedImages.clear();
    }

    Map<String, String?> errors = {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void validateAndSubmit() {
              errors.clear();

              if (_departureTownController.text.trim().isEmpty) {
                errors['departureTown'] = 'Enter departure town';
              }
              if (_departureTimeController.text.trim().isEmpty) {
                errors['departureTime'] = 'Select departure time';
              }
              if (_arrivalTownController.text.trim().isEmpty) {
                errors['arrivalTown'] = 'Enter arrival town';
              }
              if (_arrivalTimeController.text.trim().isEmpty) {
                errors['arrivalTime'] = 'Select arrival time';
              }
              if (selectedMode == null || selectedMode!.isEmpty) {
                errors['modeOfTravel'] = 'Select mode of travel';
              }
              if (_amountController.text.trim().isEmpty) {
                errors['amount'] = 'Enter amount';
              } else if (double.tryParse(_amountController.text.trim()) ==
                  null) {
                errors['amount'] = 'Enter valid number';
              }
              if (pickedImages.isEmpty) {
                errors['photo'] = 'Please add at least one photo';
              }

              setModalState(() {});

              if (errors.isEmpty) {
                final updatedEntry = {
                  'departureTown': _departureTownController.text.trim(),
                  'departureTime': _departureTimeController.text.trim(),
                  'arrivalTown': _arrivalTownController.text.trim(),
                  'arrivalTime': _arrivalTimeController.text.trim(),
                  'modeOfTravel': selectedMode,
                  'amount': _amountController.text.trim(),
                  'comment': _commentController.text.trim(),
                  'images': pickedImages.map((e) => e.path).toList(),
                };
                if (editingEntry == null) {
                  addExpense();
                } else {
                  editExpense(parentIndex!, childIndex!, updatedEntry);
                }
                Navigator.pop(context);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            editingEntry == null
                                ? "Add New Expense"
                                : "Edit Expense",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _departureTownController,
                        decoration: _textDecoration(
                          'Departure town',
                        ).copyWith(errorText: errors['departureTown']),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _departureTimeController,
                        readOnly: true,
                        decoration: _textDecoration(
                          'Departure time',
                        ).copyWith(errorText: errors['departureTime']),
                        onTap: () => pickDateTime(_departureTimeController),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _arrivalTownController,
                        decoration: _textDecoration(
                          'Arrival town',
                        ).copyWith(errorText: errors['arrivalTown']),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _arrivalTimeController,
                        readOnly: true,
                        decoration: _textDecoration(
                          'Arrival time',
                        ).copyWith(errorText: errors['arrivalTime']),
                        onTap: () => pickDateTime(_arrivalTimeController),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {}, // dropdown automatically open hoga
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // ⬅ LEFT SIDE Searchable Dropdown
                                    Expanded(
                                      child: SearchableDropdown(
                                        items: conveyance.travelModes,
                                        itemLabel: (item) => item,
                                        selectedItem: selectedMode,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMode = value;
                                            errors.remove('modeOfTravel');
                                          });
                                        },
                                        hintText:
                                            conveyance.isLoading.value
                                                ? "Loading..."
                                                : "Select Travel Mode",
                                        expand: true,
                                      ),
                                    ),

                                    // ➡ RIGHT SIDE Dropdown Icon
                                    Container(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 26,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ⚠ Error Text
                            if (errors['modeOfTravel'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  errors['modeOfTravel']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: _textDecoration(
                          'Fare Rs.',
                        ).copyWith(errorText: errors['amount']),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _commentController,
                        decoration: _textDecoration('Comment (optional)'),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          showPickerOptions((images) {
                            setModalState(() {
                              pickedImages.addAll(images);
                              errors.remove('photo');
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withAlpha(128),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (errors['photo'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            errors['photo']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (pickedImages.isNotEmpty)
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pickedImages.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:
                                        !kIsWeb
                                            ? Image.file(
                                              File(pickedImages[index].path),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              pickedImages[index].path,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          pickedImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                          child: Text(
                            editingEntry == null
                                ? "Add Expense"
                                : "Update Expense",
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addNonConveyanceExpense({bool isNext = false}) {
    setState(() {
      if (isNext) {
        _expenseDateController.clear();
        _designationController.clear();
        _tourLocationController.clear();
        NonSelectedExpenseType = null;
        flowAmountController.clear();
        NonSelectedAllowanceType = null;
        NonSelectedCategory = null;
        NonSelectedCity = null;
        _remarksController.clear();
        _mislinisCommentController.clear();
        return;
      }

      String expenseDate = _expenseDateController.text;
      int existingIndex = expenses.indexWhere(
        (v) => v["expense_date"] == expenseDate,
      );

      Map<String, dynamic> newEntry = {
        "type": widget.type.toLowerCase().replaceAll(' ', '_'),
        "tourLocation": NonSelectedCity,
        "expenseType": NonSelectedExpenseType,
        "category": NonSelectedCategory,
        "selectday": NonSelectedAllowanceType,
        "amount": flowAmountController.text,
        "daType": NonSelectedAllowanceType,
        "remarks": NonSelectedExpenseType == 'Miscellaneous'
                ? _mislinisCommentController.text
                : _remarksController.text,
        "images": pickedImages.map((img) => img.path).toList(),
      };

      if (existingIndex == -1) {
        expenses.add({
          "expense_date": expenseDate,
          "data": [newEntry],
        });
      } else {
        expenses[existingIndex]["data"].add(newEntry);
      }

      NonSelectedCategory = null;
      NonSelectedCity = null;
      NonSelectedExpenseType = null;
      NonSelectedAllowanceType = null;
      _tourLocationController.clear();
      flowAmountController.clear();
      _remarksController.clear();
      _mislinisCommentController.clear();
      pickedImages.clear();
    });
  }

  void showAddNonConveyanceModal(
    BuildContext context, {
    Map<String, dynamic>? editingEntry,
    int? parentIndex,
    int? childIndex,
  })
  {
    if (_expenseDateController.text.isEmpty || _designationController.text.isEmpty) {
      setState(() {
        expenseDateError =
            _expenseDateController.text.isEmpty
                ? 'Please select expense date'
                : null;
        designationError =
            _designationController.text.isEmpty
                ? 'Designation is required'
                : null;
      });
      return;
    }

    if (editingEntry != null) {
      NonSelectedCategory = editingEntry['category'];
      NonSelectedCity = editingEntry['tourLocation'];
      NonSelectedExpenseType = editingEntry['expenseType'];
      NonSelectedAllowanceType = editingEntry['selectday'];
      flowAmountController.text = editingEntry['amount']?.toString() ?? '';
      _remarksController.text = editingEntry['remarks'] ?? '';
      pickedImages = (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ?? [];
      if (NonSelectedExpenseType == 'Miscellaneous') {
        _mislinisCommentController.text = editingEntry['remarks'] ?? '';
      }
    } else {
      NonSelectedCategory = null;
      NonSelectedCity = null;
      NonSelectedExpenseType = null;
      NonSelectedAllowanceType = null;
      flowAmountController.clear();
      _remarksController.clear();
      _mislinisCommentController.clear();
      pickedImages.clear();
    }

    Map<String, String?> errors = {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {

            // --- 1. STRING FORMATTER HELPER FUNCTION ---
            String formatString(String input) {
              if (input.isEmpty) return input;
              return input
                  .replaceAll('_', ' ') // Underscore ko space se replace karein
                  .split(' ')
                  .map((word) => word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}' // First letter Capital
                  : '')
                  .join(' ');
            }

            void validateBeforeSelect({
              required String? checkValue,
              required String message,
              required Function() onSuccess,
            }) {
              if (checkValue == null) {
                Get.snackbar(
                  "Required",
                  message,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              } else {
                onSuccess();
              }
            }

            // ===================== CUSTOM DROPDOWN =====================
            Widget dropdown({
              required String? value,
              required List<String> items,
              required String hint,
              required bool enabled,
              required Function() onTap,
              required Function(String?) onChanged,
              String Function(String)? itemLabel, // --- 2. ADDED OPTIONAL LABEL FORMATTER ---
            })
            {
              return IgnorePointer(
                ignoring: !enabled,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: enabled ? Colors.white : Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white, // menu white
                      isExpanded: true,
                      value: value,
                      underline: SizedBox(),
                      iconEnabledColor: enabled ? Colors.black : Colors.grey,
                      hint: Text(hint, style: TextStyle(color: Colors.black)),
                      items: items.map((e) => DropdownMenuItem(
                      value: e,
                        child: Text(itemLabel != null ? itemLabel(e) : e),
                      )).toList(),
                      onChanged: onChanged,
                    ),
                  ),
                ),
              );
            }
            //TextStyle get; titleStyle => TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);

             void validateAndSubmit() {
               errors.clear();

              // CATEGORY
              if (NonSelectedCategory == null) {
                errors['category'] = 'Select category';
              }

              // CITY
              if (NonSelectedCity == null || NonSelectedCity!.isEmpty) {
                errors['tourLocation'] = 'Enter or select tour location';
              }

              // EXPENSE TYPE
              if (NonSelectedExpenseType == null || NonSelectedExpenseType!.isEmpty) {
                errors['expenseType'] = 'Select expense type';
              }

              // ALLOWANCE TYPE (Only when NOT Miscellaneous)
              if (NonSelectedExpenseType != "Miscellaneous") {
                if (NonSelectedAllowanceType == null || NonSelectedAllowanceType!.isEmpty) {
                  errors['allowanceType'] = 'Select allowance type';
                }
              }

              // AMOUNT (Skip when Miscellaneous)
              if (NonSelectedExpenseType != "Miscellaneous" &&
                  flowAmountController.text.trim().isEmpty) {
                errors['amount'] = 'Enter amount';
              }

              // MISCELLANEOUS COMMENT REQUIRED
              if (NonSelectedExpenseType == 'Miscellaneous' &&
                  _mislinisCommentController.text.trim().isEmpty) {
                errors['remarks'] = 'Comment is required for Miscellaneous';
              }

              // PHOTO REQUIRED
              if (pickedImages.isEmpty) {
                errors['photo'] = 'Please add at least one photo';
              }

              setModalState(() {});

              // ----- SAFE FORM VALIDATION -----
              if (NonSelectedExpenseType != "Miscellaneous") {
                if (formKey.currentState != null) {
                  if (!formKey.currentState!.validate()) {
                    return;   // stop submit if invalid
                  }
                }
              }


              // FINAL CHECK
              if (errors.isNotEmpty) return;

              // Prepare entry data
              final updatedEntry = {
                "type": widget.type.toLowerCase().replaceAll(' ', '_'),
                "tourLocation": NonSelectedCity,
                "category": NonSelectedCategory,
                "selectday": NonSelectedAllowanceType,
                "expenseType": NonSelectedExpenseType,
                "amount": flowAmountController.text.trim(),
                "daType": NonSelectedAllowanceType,
                "remarks": NonSelectedExpenseType == 'Miscellaneous'
                    ? _mislinisCommentController.text.trim()
                    : _remarksController.text.trim(),
                "images": pickedImages.map((img) => img.path).toList(),
              };

              // SAVE ENTRY
              if (editingEntry == null) {
                addNonConveyanceExpense();
              } else {
                editExpense(parentIndex!, childIndex!, updatedEntry);
              }

              Navigator.pop(context, true);
            }

            // void validateAndSubmit() {
            //   errors.clear();
            //   if (NonSelectedCategory == null) {
            //     errors['category'] = 'Select category';
            //   }
            //   if (NonSelectedCity == null || NonSelectedCity!.isEmpty) {
            //     errors['tourLocation'] = 'Enter or select tour location';
            //   }
            //   if (NonSelectedExpenseType == null || NonSelectedExpenseType!.isEmpty) {
            //     errors['expenseType'] = 'Select expense type';
            //   }
            //   if (NonSelectedAllowanceType == null ||
            //       NonSelectedAllowanceType!.isEmpty) {
            //     errors['allowanceType'] = 'Select allowance type';
            //   }
            //   if (NonSelectedExpenseType != "Miscellaneous" &&
            //       flowAmountController.text.trim().isEmpty) {
            //     errors['amount'] = 'Enter amount';
            //   }
            //
            //   // if (flowAmountController.text.trim().isEmpty) {
            //   //   errors['amount'] = 'Enter amount';
            //   // }
            //   if (pickedImages.isEmpty) {
            //     errors['photo'] = 'Please add at least one photo';
            //   }
            //   if (NonSelectedExpenseType == 'Miscellaneous' && _mislinisCommentController.text.trim().isEmpty) {
            //     errors['remarks'] = 'Comment is required for Miscellaneous';
            //   }
            //
            //   setModalState(() {});
            //
            //   if (errors.isEmpty) {
            //     final updatedEntry = {
            //       "type": widget.type.toLowerCase().replaceAll(' ', '_'),
            //       "tourLocation": NonSelectedCity,
            //       "category": NonSelectedCategory,
            //       "selectday": NonSelectedAllowanceType,
            //       "expenseType": NonSelectedExpenseType,
            //       "amount": flowAmountController.text.trim(),
            //       "daType": NonSelectedAllowanceType,
            //       "remarks": NonSelectedExpenseType == 'Miscellaneous'
            //               ? _mislinisCommentController.text.trim()
            //               : _remarksController.text.trim(),
            //       "images": pickedImages.map((img) => img.path).toList(),
            //     };
            //      //print("Fetch remarksController data-: $_remarksController");
            //     if (editingEntry == null) {
            //       addNonConveyanceExpense();
            //     } else {
            //       editExpense(parentIndex!, childIndex!, updatedEntry);
            //     }
            //     Navigator.pop(context,true);
            //   }
            // }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modal Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            editingEntry == null
                                ? "Add Non-Conveyance Expense"
                                : "Edit Non-Conveyance Expense",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ================= CATEGORY =================
                      Text("Category", style: titleStyle),
                      dropdown(
                        value: NonSelectedCategory,
                        hint: "Select Category",
                        items: ["A", "B"],
                        enabled: true,
                        onTap: () {},
                        onChanged: (v) {
                          setModalState(() {
                            NonSelectedCategory = v;
                            NonSelectedCity = null;
                            NonSelectedExpenseType = null;
                            NonSelectedAllowanceType = null;
                            flow.fetchCities(v!);
                          });
                        },
                      ),
                      if (errors['category'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 12),
                          child: Text(
                            errors['category']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      SizedBox(height: 10),
                      // ================= CITY =================
                      Text("Category wise City", style: titleStyle),
                      if (NonSelectedCategory == "B") ...[
                        TextField(
                          onChanged: (value) {
                            setModalState(() {
                              NonSelectedCity = value;
                            });
                          },
                          decoration: _textDecoration(
                            "Please select your city",
                          ).copyWith(errorText: errors['tourLocation']),
                        ),
                      ] else ...[
                        Obx(() {
                          return dropdown(
                            value: NonSelectedCity,
                            hint: "Select City",
                            items: flow.categoryWiseCityList,
                            enabled: NonSelectedCategory != null,
                            onTap: () {
                              validateBeforeSelect(
                                checkValue: NonSelectedCategory,
                                message: "Please select category first!",
                                onSuccess: () {},
                              );
                            },
                            onChanged: (v) {
                              validateBeforeSelect(
                                checkValue: NonSelectedCategory,
                                message: "Please select category first!",
                                onSuccess: () {
                                  setModalState(() {
                                    NonSelectedCity = v;
                                    NonSelectedExpenseType = null;
                                    NonSelectedAllowanceType = null;
                                  });
                                  flow.fetchExpenseTypes(
                                    NonSelectedCategory!,
                                    "da_full",
                                  ); // Default for now
                                },
                              );
                            },
                          );
                        }),
                      ],
                      if (errors['tourLocation'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 12),
                          child: Text(
                            errors['tourLocation']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      SizedBox(height: 10),

                      // // ================= EXPENSE TYPE ==================
                      // Text("Expense Type", style: titleStyle),
                      // dropdown(
                      //   value: NonSelectedExpenseType,
                      //   hint: "Select Expense Type",
                      //   items: [
                      //     "DA Full Day",
                      //     "DA Half Day",
                      //     "TA",
                      //     "Miscellaneous",
                      //   ],
                      //   enabled: NonSelectedCity != null,
                      //   onTap: () {
                      //     validateBeforeSelect(
                      //       checkValue: NonSelectedCity,
                      //       message: "Please select city first!",
                      //       onSuccess: () {},
                      //     );
                      //   },
                      //   onChanged: (v) {
                      //     validateBeforeSelect(
                      //       checkValue: NonSelectedCity,
                      //       message: "Please select city first!",
                      //       onSuccess: () {
                      //         setModalState(() {
                      //           NonSelectedExpenseType = v;
                      //           NonSelectedAllowanceType = null;
                      //         });
                      //
                      //         String apiValue = "";
                      //         if (v == "DA Full Day") apiValue = "da_full";
                      //         if (v == "DA Half Day") apiValue = "da_half";
                      //         if (v == "TA") apiValue = "ta";
                      //         if (v == "Miscellaneous") apiValue = "misc";
                      //         flow.fetchAllowanceTypes(
                      //           NonSelectedCategory!,
                      //           apiValue,
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // if (errors['expenseType'] != null)
                      //   Padding(
                      //     padding: const EdgeInsets.only(top: 5, left: 12),
                      //     child: Text(
                      //       errors['expenseType']!,
                      //       style: const TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 12,
                      //       ),
                      //     ),
                      //   ),
                      //
                      // SizedBox(height: 10),
                      // // ================= ALLOWANCE TYPE (HIDE WHEN MISC) ==================
                      // if (NonSelectedExpenseType != "Miscellaneous") ...[
                      //   Text("Allowance Type", style: titleStyle),
                      //   Obx(() {
                      //     return dropdown(
                      //       value: NonSelectedAllowanceType,
                      //       hint: "Select Allowance Type",
                      //       items: flow.allowanceTypeList,
                      //       enabled: NonSelectedExpenseType != null,
                      //       onTap: () {
                      //         validateBeforeSelect(
                      //           checkValue: NonSelectedExpenseType,
                      //           message: "Please select expense type first!",
                      //           onSuccess: () {},
                      //         );
                      //       },
                      //       onChanged: (v) {
                      //         setModalState(() {
                      //           NonSelectedAllowanceType = v;
                      //         });
                      //
                      //         String apiExpense =
                      //         NonSelectedExpenseType == "DA Full Day"
                      //             ? "da_full"
                      //             : NonSelectedExpenseType == "DA Half Day"
                      //             ? "da_half"
                      //             : NonSelectedExpenseType == "TA"
                      //             ? "ta"
                      //             : "misc";
                      //
                      //         flow.fetchAllowanceAmount(
                      //           NonSelectedCategory!,
                      //           apiExpense,
                      //           NonSelectedAllowanceType!,
                      //         );
                      //       },
                      //     );
                      //   }),
                      //
                      //   if (errors['allowanceType'] != null)
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 5, left: 12),
                      //       child: Text(
                      //         errors['allowanceType']!,
                      //         style: const TextStyle(color: Colors.red, fontSize: 12),
                      //       ),
                      //     ),
                      //
                      //   SizedBox(height: 10),
                      //
                      //   // ================= AMOUNT (SHOW ONLY WHEN NOT MISC) ==================
                      //   Obx(() {
                      //     final title = flow.allowanceTitle.value;
                      //     final amount = flow.finalAmount.value;
                      //
                      //     final hasTitle = title != null && title.toString().trim().isNotEmpty;
                      //     final hasAmount = amount != null && amount.toString().trim().isNotEmpty;
                      //     final showColon = hasTitle && hasAmount;
                      //
                      //     return Text(
                      //       "${title ?? ""}${showColon ? " : " : ""}${amount ?? ""}",
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //       ),
                      //     );
                      //   }),
                      // ],
                      // SizedBox(height: 7),
                      // // ================= AMOUNT =================
                      // Text("Amount", style: titleStyle),
                      // Form(
                      //   key: formKey,
                      //   child: Column(
                      //     children: [
                      //       TextFormField(
                      //         controller: flowAmountController,
                      //         keyboardType: TextInputType.number,
                      //         onChanged: (value) {
                      //           formKey.currentState!.validate();
                      //         },
                      //         decoration: _textDecoration('Enter Amount'),
                      //         validator: (value) {
                      //           final maxAmount =
                      //               double.tryParse(flow.finalAmount.value.toString()) ?? 0;
                      //           final entered = double.tryParse(value ?? "") ?? 0;
                      //
                      //           if (entered > maxAmount) {
                      //             return "The entered amount exceeds the authorized limit $maxAmount";
                      //           }
                      //           return null;
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // TextFormField(
                      //   controller: flowAmountController,
                      //   keyboardType: TextInputType.number,
                      //   decoration: _textDecoration(
                      //     'Enter Amount',
                      //   ).copyWith(errorText: errors['amount']),
                      // ),
                      // ================= EXPENSE TYPE ==================
                      Text("Expense Type", style: titleStyle),
                      dropdown(
                        value: NonSelectedExpenseType,
                        hint: "Select Expense Type",
                        items: [
                          "DA Full Day",
                          "DA Half Day",
                          "TA",
                          "HOTEL",
                          "Miscellaneous",
                        ],
                        enabled: NonSelectedCity != null,
                        onTap: () {
                          validateBeforeSelect(
                            checkValue: NonSelectedCity,
                            message: "Please select city first!",
                            onSuccess: () {},
                          );
                        },
                        onChanged: (v) {
                          validateBeforeSelect(
                            checkValue: NonSelectedCity,
                            message: "Please select city first!",
                            onSuccess: () {
                              setModalState(() {
                                NonSelectedExpenseType = v;
                                NonSelectedAllowanceType = null;

                                // RESET Allowance & Amount
                                flow.allowanceTitle.value = "";
                                flow.finalAmount.value = "";
                                flowAmountController.clear();
                              });

                              // If Miscellaneous → Skip API
                              if (v == "Miscellaneous") return;

                              // API keys
                              String apiValue = v == "DA Full Day"
                                  ? "da_full"
                                  : v == "DA Half Day"
                                  ? "da_half"
                                  : v == "TA"
                                  ? "ta"
                                  : v == "HOTEL"
                                  ? "hotel"
                                  : "misc";

                              flow.fetchAllowanceTypes(
                                NonSelectedCategory!,
                                apiValue,
                              );
                            },
                          );
                        },
                      ),

                      if (errors['expenseType'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 12),
                          child: Text(
                            errors['expenseType']!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 10),

// ================= ALLOWANCE TYPE (HIDE WHEN MISC) ==================
                      if (NonSelectedExpenseType != "Miscellaneous") ...[
                        Text("Allowance Type", style: titleStyle),
                        Obx(() {
                          return dropdown(
                            value: NonSelectedAllowanceType,
                            hint: "Select Allowance Type",
                            items: flow.allowanceTypeList,
                            enabled: NonSelectedExpenseType != null,
                            // --- 4. PASSING THE FORMAT FUNCTION HERE ---
                            itemLabel: (val) => formatString(val),
                            onTap: () {
                              validateBeforeSelect(
                                checkValue: NonSelectedExpenseType,
                                message: "Please select expense type first!",
                                onSuccess: () {},
                              );
                            },
                            onChanged: (v) {
                              setModalState(() {
                                NonSelectedAllowanceType = v;
                              });
                              String apiExpense = NonSelectedExpenseType == "DA Full Day"
                                  ? "da_full"
                                  : NonSelectedExpenseType == "DA Half Day"
                                  ? "da_half"
                                  : NonSelectedExpenseType == "TA"
                                  ? "ta"
                                  : NonSelectedExpenseType == "HOTEL"
                                  ? "hotel"
                                  : "misc";

                              flow.fetchAllowanceAmount(
                                NonSelectedCategory!,
                                apiExpense,
                                NonSelectedAllowanceType!,
                              );
                            },
                          );
                        }),

                        if (errors['allowanceType'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 12),
                            child: Text(
                              errors['allowanceType']!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        SizedBox(height: 10),

// ================= AMOUNT LABEL (Only Non-Misc) ==================
                        Obx(() {
                          final title = flow.allowanceTitle.value;
                          final amount = flow.finalAmount.value;

                          final hasTitle = title != null && title.toString().trim().isNotEmpty;
                          final hasAmount = amount != null && amount.toString().trim().isNotEmpty;
                          final showColon = hasTitle && hasAmount;

                          return Text(
                            "${title ?? ""}${showColon ? " : " : ""}${amount ?? ""}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        }),
                      ],

                      SizedBox(height: 7),

// ================= AMOUNT FIELD ==================
                      Text("Amount ₹", style: titleStyle),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: flowAmountController,
                              keyboardType: TextInputType.number,
                              decoration: _textDecoration('Enter Amount'),

                              onChanged: (value) {
                                setModalState(() {
                                  if (NonSelectedExpenseType == "Miscellaneous") {
                                    amountError = null;
                                    return;
                                  }

                                  final maxAmount = double.tryParse(flow.finalAmount.value.toString()) ?? 0;
                                  final entered = double.tryParse(value) ?? 0;

                                  if (entered > maxAmount) {
                                    amountError = "The entered amount exceeds the authorized limit $maxAmount";
                                  } else {
                                    amountError = null;
                                  }
                                });
                              },
                            ),
                            if (amountError != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  amountError!,
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              )
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      // Miscellaneous Comment
                      if (NonSelectedExpenseType == 'Miscellaneous') ...[
                        TextField(
                          controller: _mislinisCommentController,
                          decoration: _textDecoration(
                            'Comment (required)',
                          ).copyWith(errorText: errors['remarks']),
                        ),
                      ],
                      SizedBox(height: 10),

                      // Remarks
                      if (NonSelectedExpenseType != 'Miscellaneous')
                        TextField(
                          controller: _remarksController,
                          decoration: _textDecoration('Remarks (optional)'),
                        ),
                      SizedBox(height: 10),

                      // Add Photo
                      InkWell(
                        onTap: () {
                          showPickerOptions((images) {
                            setModalState(() {
                              pickedImages.addAll(images);
                              errors.remove('photo');
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  errors['photo'] != null
                                      ? Colors.red
                                      : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (errors['photo'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 12),
                          child: Text(
                            errors['photo']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      if (pickedImages.isNotEmpty)
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pickedImages.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:
                                        !kIsWeb
                                            ? Image.file(
                                              File(pickedImages[index].path),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              pickedImages[index].path,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          pickedImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Submit Button
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                          child: Text(
                            editingEntry == null
                                ? "Add Expense"
                                : "Update Expense",
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addLocalConveyanceExpense({bool isNext = false}) {
    setState(() {
      if (isNext) {
        _expenseDateController.clear();
        _designationController.clear();
        selectedTravelType = null;
        _travelAmountController.clear();
        return;
      }

      String expenseDate = _expenseDateController.text;
      int existingIndex = expenses.indexWhere(
        (v) => v["expense_date"] == expenseDate,
      );

      Map<String, dynamic> newEntry = {
        "type": widget.type.toLowerCase().replaceAll(' ', '_'),
        "travelType": selectedTravelType,
        "travelAmount": _travelAmountController.text,
        "images": pickedImages.map((img) => img.path).toList(),
      };

      if (existingIndex == -1) {
        expenses.add({
          "expense_date": expenseDate,
          "data": [newEntry],
        });
      } else {
        if (!expenses[existingIndex]["data"].contains(newEntry)) {
          expenses[existingIndex]["data"].add(newEntry);
        }
      }

      _tourLocationController.clear();
      NonSelectedExpenseType = null;
      NonSelectedAllowanceType = null;
      _remarksController.clear();
      flowAmountController.clear();
      pickedImages.clear();
    });
  }

  void showAddLocalConveyanceModal(
    BuildContext context, {
    Map<String, dynamic>? editingEntry,
    int? parentIndex,
    int? childIndex,
  })
  {
    if (_expenseDateController.text.isEmpty ||
        _designationController.text.isEmpty) {
      setState(() {
        expenseDateError =
            _expenseDateController.text.isEmpty
                ? 'Please select expense date'
                : null;
        designationError =
            _designationController.text.isEmpty
                ? 'Designation is required'
                : null;
      });
      return;
    }

    if (editingEntry != null) {
      selectedTravelType = editingEntry['travelType'];
      _travelAmountController.text = editingEntry['travelAmount'] ?? "0";
      pickedImages =
          (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ??
          [];
    } else {
      setState(() {
        selectedTravelType = null;
      });
      _travelAmountController.clear();
      pickedImages.clear();
    }

    Map<String, String?> errors = {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void validateAndSubmit() {
              errors.clear();

              if (selectedTravelType == null || selectedTravelType!.isEmpty) {
                errors['travelType'] = 'Select travel type';
              }
              if (_travelAmountController.text.trim().isEmpty) {
                errors['travelAmount'] = 'Enter travel amount';
              }

              setModalState(() {});

              if (errors.isEmpty) {
                final updatedEntry = {
                  "travelType": selectedTravelType,
                  "travelAmount": _travelAmountController.text,
                  "images": pickedImages.map((img) => img.path).toList(),
                };
                if (editingEntry == null) {
                  addLocalConveyanceExpense();
                } else {
                  editExpense(parentIndex!, childIndex!, updatedEntry);
                }
                Navigator.pop(context, true);
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            editingEntry == null
                                ? "Add Local-Conveyance Expense"
                                : "Edit Local-Conveyance Expense",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // DropdownButtonFormField<String>(
                      //   value: selectedTravelType,
                      //   dropdownColor: Colors.white,
                      //   items: ['Auto', 'Ola/Uber/Taxi', 'Ac Bus']
                      //       .map(
                      //         (e) => DropdownMenuItem(
                      //       value: e,
                      //       child: Text(e),
                      //     ),
                      //   )
                      //       .toList(),
                      //   onChanged: (value) {
                      //     setModalState(() {
                      //       selectedTravelType = value;
                      //       errors.remove('travelType');
                      //     });
                      //   },
                      //   decoration: _dropdownDecoration('Travel Type')
                      //       .copyWith(errorText: errors['travelType']),
                      // ),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // ⬅ LEFT SIDE Searchable Dropdown
                                  Expanded(
                                    child: SearchableDropdown(
                                      items: LocConveyance.travelModes, // API DATA: Bus, Auto
                                      itemLabel: (item) => item,
                                      selectedItem: selectedTravelType,

                                      onChanged: (value) {
                                        setState(() {
                                          selectedTravelType = value;
                                          errors.remove('modeOfTravel');
                                        });
                                      },

                                      hintText: LocConveyance.isLoading.value
                                              ? "Loading..."
                                              : "Select Travel Mode",

                                      expand: true,
                                    ),
                                  ),

                                  // ➡ Right arrow icon
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 26,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),

                            // ⚠️ Validation error
                            if (errors['modeOfTravel'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6, left: 4),
                                child: Text(
                                  errors['modeOfTravel']!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                      SizedBox(height: 10),
                      TextField(
                        controller: _travelAmountController,
                        keyboardType: TextInputType.number,
                        decoration: _textDecoration(
                          'Travel Amount',
                        ).copyWith(errorText: errors['travelAmount']),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          showPickerOptions((images) {
                            setModalState(() {
                              pickedImages.addAll(images);
                              errors.remove('photo');
                            });
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black.withAlpha(128),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (errors['photo'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            errors['photo']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (pickedImages.isNotEmpty)
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: pickedImages.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child:
                                        !kIsWeb
                                            ? Image.file(
                                              File(pickedImages[index].path),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              pickedImages[index].path,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setModalState(() {
                                          pickedImages.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: validateAndSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                          ),
                          child: Text(
                            editingEntry == null
                                ? "Add Expense"
                                : "Update Expense",
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.startDate != null) {
        _expenseDateController.text =
            DateFormat('dd-MM-yyyy').format(widget.startDate!);
      }      //_expenseDateController.text = DateFormat('dd-MM-yyyy',).format(DateTime.now());
      _designationController.text = _profileController.user.value?.designation ?? 'N/A';
    });
    conveyance.fetchConTravelModes(); // <-- API call on screen open
    LocConveyance.fetchLocalConveyance();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final filteredEntries =
        expenses.where(
              (visit) => visit['expense_date'] == _expenseDateController.text,
            )
            .expand((visit) => visit['data'].asMap().entries)
            .toList();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text(
            'Create ${widget.type} expense',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: Responsive.isSm(context)
                    ? screenWidth
                    : Responsive.isXl(context)
                    ? screenWidth * 0.60
                    : screenWidth * 0.40,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Column(
              children: [
                // Text(
                //     "Start Date: ${DateFormat('dd-MM-yyyy').format(widget.startDate!)}"
                // ),
                TextField(
                  controller: _expenseDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(107),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(107),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red.withAlpha(153),
                        width: 2,
                      ),
                    ),
                    labelText: 'Expense Date',
                    labelStyle: TextStyle(color: Colors.black.withAlpha(179)),
                    hintText: 'Expense Date',
                    errorText: expenseDateError,
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.startDate,
                      firstDate: widget.startDate!,
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _expenseDateController.text =
                            "${pickedDate.day.toString().padLeft(2, '0')}-"
                            "${pickedDate.month.toString().padLeft(2, '0')}-"
                            "${pickedDate.year}";
                      });
                    }
                  },
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _designationController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(107),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withAlpha(107),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red.withAlpha(153),
                        width: 2,
                      ),
                    ),
                    labelText: 'Designation',
                    labelStyle: TextStyle(color: Colors.black.withAlpha(179)),
                    hintText: 'Designation',
                    errorText: designationError,
                  ),
                ),
                SizedBox(height: 15),
                if (expenses.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) => SizedBox(height: 15.0),
                        itemCount: filteredEntries.length,
                        itemBuilder: (context, index) {
                          final entry = filteredEntries[index];
                          final entryIndex = entry.key;
                          final entryValue = entry.value;
                          return widget.type == 'Conveyance'
                              ? ExpenseCard(
                                entryValue: entryValue,
                                parentIndex: index,
                                childIndex: entryIndex,
                                onEdit: (value, parentIndex, childIndex) {
                                  showAddExpenseModal(
                                    context,
                                    editingEntry: value,
                                    parentIndex: parentIndex,
                                    childIndex: childIndex,
                                  );
                                },
                                onDelete: (parentIndex, childIndex) {
                                  setState(() {
                                    expenses[parentIndex]['data'].removeAt(
                                      childIndex,
                                    );
                                    if (expenses[parentIndex]['data'].isEmpty) {
                                      expenses.removeAt(parentIndex);
                                    }
                                  });
                                },
                              )
                              : widget.type == 'Non Conveyance'
                              ? ExpenseNonConveyanceCard(
                                entryValue: entryValue,
                                parentIndex: index,
                                childIndex: entryIndex,
                                onEdit: (value, parentIndex, childIndex) {
                                  showAddNonConveyanceModal(
                                    context,
                                    editingEntry: value,
                                    parentIndex: parentIndex,
                                    childIndex: childIndex,
                                  );
                                },
                                onDelete: (parentIndex, childIndex) {
                                  setState(() {
                                    expenses[parentIndex]['data'].removeAt(
                                      childIndex,
                                    );
                                    if (expenses[parentIndex]['data'].isEmpty) {
                                      expenses.removeAt(parentIndex);
                                    }
                                  });
                                },
                              )
                              : ExpenseLocalConveyanceCard(
                                entryValue: entryValue,
                                parentIndex: index,
                                childIndex: entryIndex,
                                onEdit: (value, parentIndex, childIndex) {
                                  showAddLocalConveyanceModal(
                                    context,
                                    editingEntry: value,
                                    parentIndex: parentIndex,
                                    childIndex: childIndex,
                                  );
                                },
                                onDelete: (parentIndex, childIndex) {
                                  setState(() {
                                    expenses[parentIndex]['data'].removeAt(
                                      childIndex,
                                    );
                                    if (expenses[parentIndex]['data'].isEmpty) {
                                      expenses.removeAt(parentIndex);
                                    }
                                  });
                                },
                              );
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        bottomNavigationBar: expenses.isNotEmpty
                ? Obx(() {
                  final expense = expenses.where(
                            (v) => v["expense_date"] ==
                                _expenseDateController.text,
                          ).toList();
                  final firstData = expense.isNotEmpty ? expense.first['data'][0] : {};
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorPalette.pictonBlue600,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await _expenseController.createExpense(
                          tourPlanId: widget.tourPlanId,
                          visitId: widget.visitId,
                          startDate: widget.startDate,
                          expensetype: firstData["type"] ?? '',
                          date: DateFormat("yyyy-MM-dd").format(
                            DateFormat("dd-MM-yyyy",).parse(_expenseDateController.text),
                          ),
                          departureTown: firstData["departureTown"] ?? '',
                          departureTime:
                              firstData["departureTime"] != null
                                  ? DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                    DateFormat(
                                      "dd-MMM-yyyy hh:mm a",
                                    ).parse(firstData["departureTime"]),
                                  )
                                  : '',
                          arrivalTown: firstData["arrivalTown"] ?? '',
                          arrivalTime:
                              firstData["arrivalTime"] != null
                                  ? DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                    DateFormat(
                                      "dd-MMM-yyyy hh:mm a",
                                    ).parse(firstData["arrivalTime"]),
                                  )
                                  : '',
                          modeOfTravel: firstData["type"] == 'local_conveyance'
                                  ? (firstData["travelType"] ?? '')
                                  : (firstData["modeOfTravel"] ?? ''),
                          amount: firstData["type"] == 'local_conveyance'
                                  ? double.tryParse(
                                    firstData["travelAmount"] ?? '0',
                                  )
                                  : double.tryParse(firstData["amount"] ?? '0'),
                          comment: firstData["remarks"] ?? '',
                          images: firstData['images'] ?? [],
                          location: firstData["tourLocation"] ?? '',
                          type: firstData["expenseType"] ?? '',
                          cityCategory: firstData["category"] ?? '',
                          dayType: firstData["selectday"] ?? '',
                        );
                        print("Submit Expense $firstData");
                      },
                      child: _expenseController.isLoading.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                              : Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                    ),
                  );
                })
                : null,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
          child: FloatingActionButton(
            onPressed:
                () =>
                    widget.type == 'Conveyance'
                        ? showAddExpenseModal(context)
                        : widget.type == 'Non Conveyance'
                        ? showAddNonConveyanceModal(context)
                        : showAddLocalConveyanceModal(context),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 4,
            child: const Icon(Icons.add),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
  TextStyle get titleStyle => TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black);
}

class ExpenseCard extends StatefulWidget {
  final Map<String, dynamic> entryValue;
  final int parentIndex;
  final int childIndex;
  final Function(int parentIndex, int childIndex) onDelete;
  final Function(
    Map<String, dynamic> entryValue,
    int parentIndex,
    int childIndex,
  )
  onEdit;

  const ExpenseCard({
    super.key,
    required this.entryValue,
    required this.parentIndex,
    required this.childIndex,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}
class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    final entryValue = widget.entryValue;
    return Card(
      color: Colors.grey[200],
      elevation: 6,
      shadowColor: Colors.black.withAlpha(26),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Departure Town: ${entryValue['departureTown']}"),
                const SizedBox(height: 15),
                Text("Departure Time: ${entryValue['departureTime']}"),
                const SizedBox(height: 15),
                Text("Arrival Town: ${entryValue['arrivalTown']}"),
                const SizedBox(height: 15),
                Text("Arrival Time: ${entryValue['arrivalTime']}"),
                const SizedBox(height: 15),
                Text("Mode Of Travel: ${entryValue['modeOfTravel']}"),
                const SizedBox(height: 15),
                Text("Fare Rs.: ₹ ${entryValue['amount']}"),
                if (entryValue['comment'] != null &&
                    entryValue['comment'].toString().isNotEmpty)
                  const SizedBox(height: 15),
                if (entryValue['comment'] != null &&
                    entryValue['comment'].toString().isNotEmpty)
                  Text("Comments: ${entryValue['comment']}"),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    widget.onEdit(
                      widget.entryValue,
                      widget.parentIndex,
                      widget.childIndex,
                    );
                  },
                ),
                const SizedBox(width: 10),
                // TextButton.icon(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   label: const Text(
                //     "Delete",
                //     style: TextStyle(color: Colors.red),
                //   ),
                //   onPressed: () {
                //     widget.onDelete(widget.parentIndex, widget.childIndex);
                //   },
                // ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Confirm Delete",
                            style: TextStyle(color: Colors.black),
                          ),
                          content: const Text(
                            "Are you sure you want to delete this expense entry?",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                widget.onDelete(
                                  widget.parentIndex,
                                  widget.childIndex,
                                ); // Perform the delete action
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseNonConveyanceCard extends StatefulWidget {
  final Map<String, dynamic> entryValue;
  final int parentIndex;
  final int childIndex;
  final Function(int parentIndex, int childIndex) onDelete;
  final Function(
    Map<String, dynamic> entryValue,
    int parentIndex,
    int childIndex,
  )
  onEdit;

  const ExpenseNonConveyanceCard({
    super.key,
    required this.entryValue,
    required this.parentIndex,
    required this.childIndex,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ExpenseNonConveyanceCard> createState() => _ExpenseNonConveyanceCardState();
}
class _ExpenseNonConveyanceCardState extends State<ExpenseNonConveyanceCard> {
  @override
  Widget build(BuildContext context) {
    final entryValue = widget.entryValue;

    return Card(
      color: Colors.grey[200],
      elevation: 6,
      shadowColor: Colors.black.withAlpha(26),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tour Location: ${entryValue['tourLocation']}"),
                const SizedBox(height: 15),
                Text("Expense Type: ${entryValue['expenseType']}"),
                const SizedBox(height: 15),
                Text("Amount ₹ : ${entryValue['amount']}"),
                SizedBox(height: 15),
                Text("City Category: ${entryValue['category']}"),
                //SizedBox(height: 15),
                //Text("DA Type: ${entryValue['selectday']}"),
                if (entryValue['daType'] != null && entryValue['daType'].isNotEmpty) ...[
                  const SizedBox(height: 15),
                  Text(
                    "DA Type: ${entryValue['daType'].toString().replaceAll('_', ' ').split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ')}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500, // (Optional) अगर बोल्ड करना हो
                    ),
                  ),
                ],
                // if (entryValue['daType'] != null && entryValue['daType'].isNotEmpty) ...[
                //   const SizedBox(height: 15),
                //   Text("DA Type: ${entryValue['daType']}"),
                // ],
                if (entryValue['remarks'] != '') ...[
                  const SizedBox(height: 15),
                  Text("Remarks: ${entryValue['remarks']}"),
                ],
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    widget.onEdit(
                      widget.entryValue,
                      widget.parentIndex,
                      widget.childIndex,
                    );
                  },
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "Confirm Delete",
                            style: TextStyle(color: Colors.black),
                          ),
                          content: const Text(
                            "Are you sure you want to delete this expense?",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                widget.onDelete(
                                  widget.parentIndex,
                                  widget.childIndex,
                                ); // Perform the delete action
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                // TextButton.icon(
                //   icon: const Icon(Icons.delete, color: Colors.red),
                //   label: const Text(
                //     "Delete",
                //     style: TextStyle(color: Colors.red),
                //   ),
                //   onPressed: () {
                //     widget.onDelete(widget.parentIndex, widget.childIndex);
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseLocalConveyanceCard extends StatefulWidget {
  final Map<String, dynamic> entryValue;
  final int parentIndex;
  final int childIndex;
  final Function(int parentIndex, int childIndex) onDelete;
  final Function(
    Map<String, dynamic> entryValue,
    int parentIndex,
    int childIndex,
  )
  onEdit;

  const ExpenseLocalConveyanceCard({
    super.key,
    required this.entryValue,
    required this.parentIndex,
    required this.childIndex,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ExpenseLocalConveyanceCard> createState() =>
      _ExpenseLocalConveyanceCardState();
}
class _ExpenseLocalConveyanceCardState extends State<ExpenseLocalConveyanceCard> {
  @override
  Widget build(BuildContext context) {
    final entryValue = widget.entryValue;

    return Card(
      color: Colors.grey[200],
      elevation: 6,
      shadowColor: Colors.black.withAlpha(26),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Travel Type: ${entryValue['travelType']}"),
                const SizedBox(height: 15),
                Text("Amount ₹ : ${entryValue['travelAmount']}"),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Ionicons.pencil_sharp, color: Colors.blue),
                  label: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    widget.onEdit(
                      widget.entryValue,
                      widget.parentIndex,
                      widget.childIndex,
                    );
                  },
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    widget.onDelete(widget.parentIndex, widget.childIndex);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



// Dummy ExpenseCard, ExpenseNonConveyanceCard, ExpenseLocalConveyanceCard classes for the code to compile.
// You should replace these with your actual implementations.
// class ExpenseCard extends StatelessWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(Map<String, dynamic>, int, int) onEdit;
//   final Function(int, int) onDelete;
//
//   const ExpenseCard({
//     Key? key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Departure: ${entryValue['departureTown']}'),
//             Text('Arrival: ${entryValue['arrivalTown']}'),
//             Text('Mode: ${entryValue['modeOfTravel']}'),
//             Text('Amount: ${entryValue['amount']}'),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => onEdit(entryValue, parentIndex, childIndex),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => onDelete(parentIndex, childIndex),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExpenseNonConveyanceCard extends StatelessWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(Map<String, dynamic>, int, int) onEdit;
//   final Function(int, int) onDelete;
//
//   const ExpenseNonConveyanceCard({
//     Key? key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Location: ${entryValue['tourLocation']}'),
//             Text('Expense Type: ${entryValue['expenseType']}'),
//             Text('Category: ${entryValue['category']}'),
//             Text('Day Type: ${entryValue['selectday']}'),
//             Text('Amount: ${entryValue['amount']}'),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => onEdit(entryValue, parentIndex, childIndex),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => onDelete(parentIndex, childIndex),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ExpenseLocalConveyanceCard extends StatelessWidget {
//   final Map<String, dynamic> entryValue;
//   final int parentIndex;
//   final int childIndex;
//   final Function(Map<String, dynamic>, int, int) onEdit;
//   final Function(int, int) onDelete;
//
//   const ExpenseLocalConveyanceCard({
//     Key? key,
//     required this.entryValue,
//     required this.parentIndex,
//     required this.childIndex,
//     required this.onEdit,
//     required this.onDelete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Travel Type: ${entryValue['travelType']}'),
//             Text('Amount: ${entryValue['travelAmount']}'),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () => onEdit(entryValue, parentIndex, childIndex),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => onDelete(parentIndex, childIndex),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class CreateExpense extends StatefulWidget {
//   final String type;
//   final int tourPlanId;
//   final int visitId;
//   const CreateExpense({
//     super.key,
//     required this.type,
//     required this.tourPlanId,
//     required this.visitId,
//   });
//   @override
//   State<CreateExpense> createState() => _CreateExpenseState();
// }
//
// class _CreateExpenseState extends State<CreateExpense> {
//   final ProfileController _profileController = Get.put(ProfileController());
//   final ExpenseController _expenseController = Get.put(ExpenseController());
//   //final TextEditingController _hotel_PriceController = TextEditingController();
//   //final _expenseController2 = Get.put(ExpenseController());
//
//   List<Map<String, dynamic>> expenses = [];
//   Map<String, String> errors = {};
//
//   final _expenseDateController = TextEditingController();
//   final _designationController = TextEditingController();
//   final _departureTownController = TextEditingController();
//   final _departureTimeController = TextEditingController();
//   final _arrivalTownController = TextEditingController();
//   final _arrivalTimeController = TextEditingController();
//   final _commentController = TextEditingController();
//
//   String? selectedMode;
//   String? expenseDateError;
//   String? designationError;
//
//   // ======== Non Conveyance ========
//   final TextEditingController _tourLocationController = TextEditingController();
//   final TextEditingController _hotel_PriceController = TextEditingController();
//   final TextEditingController _amountController = TextEditingController();
//   final TextEditingController _remarksController = TextEditingController();
//   // Controller for miscellaneous comment
//   final TextEditingController _mislinisCommentController = TextEditingController();
//
//   String? selectedExpenseType;
//   String? selectedDAType;
//   String? selectedCategoryState;
//   String? selectedDayType;
//
//   String foodAllowance = "0.00";
//   String travelAllowance = "0.00";
//   String hotelAllowance = "0.00";
//
//
//   Future<void> fetchAllowance(Function updater, String? selectedCategory, String? selectedDayType) async {
//
//     if (selectedCategory == null || selectedDayType == null) return;
//
//     String typeParam = selectedDayType == "Full day" ? "full_da" : "half_da";
//
//     final url = Uri.parse(
//         "https://btlsalescrm.cloud/api/expenses-allowance?category=$selectedCategory&type=$typeParam");
//
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token') ?? '';
//
//     final response = await http.get(
//       url,
//       headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//
//       final allowance = data["allowance"] ?? {};
//
//       updater(() {
//         if (selectedDayType == "Full day") {
//           foodAllowance = (allowance["food_allowance"] ?? "0.00").toString();
//           hotelAllowance = (allowance["hotel_allowance"] ?? "0.00").toString();
//         } else { // Half day
//           foodAllowance = (allowance["haf_food_allowence"] ?? "0.00").toString();
//           hotelAllowance = "0.00"; // Half day e hotel allowance nai
//         }
//         travelAllowance = (allowance["travel_allowance"] ?? "0.00").toString();
//       });
//
//     }
//   }
//
//
//
//   // ======== Local Conveyance ======
//   final TextEditingController _travelAmountController = TextEditingController();
//   String? selectedTravelType;
//
//   final ImagePicker _picker = ImagePicker();
//   List<XFile> pickedImages = [];
//
//   // -------------- pickImage --------------------
//   Future<void> pickImage(String sourceType) async {
//     try {
//       if (sourceType == 'camera') {
//         final XFile? image = await _picker.pickImage(
//           source: ImageSource.camera,
//         );
//         if (image != null) {
//           setState(() {
//             pickedImages.add(image);
//             errors.remove('photo');
//           });
//         }
//       } else if (sourceType == 'gallery') {
//         final List<XFile> images = await _picker.pickMultiImage();
//         if (images.isNotEmpty) {
//           setState(() {
//             pickedImages.addAll(images);
//             errors.remove('photo');
//           });
//         }
//       }
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//     }
//   }
//
//   void showPickerOptions(Function(List<XFile>) onImagesPicked) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 width: 40,
//                 height: 5,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               const Text(
//                 "Select Option",
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(
//                   Icons.camera_alt_rounded,
//                   color: Colors.blue,
//                 ),
//                 title: const Text(
//                   'Take Photo',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () async {
//                   final XFile? img = await _picker.pickImage(
//                     source: ImageSource.camera,
//                   );
//                   if (img != null) {
//                     onImagesPicked([img]);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               const Divider(height: 0),
//               ListTile(
//                 leading: const Icon(
//                   Icons.photo_library_rounded,
//                   color: Colors.green,
//                 ),
//                 title: const Text(
//                   'Choose from Gallery',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () async {
//                   final List<XFile> images = await _picker.pickMultiImage();
//                   if (images.isNotEmpty) {
//                     onImagesPicked(images);
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               const Divider(height: 0),
//               ListTile(
//                 leading: const Icon(
//                   Icons.close_rounded,
//                   color: Colors.redAccent,
//                 ),
//                 title: const Text(
//                   'Cancel',
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 onTap: () => Navigator.pop(context),
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   InputDecoration _textDecoration(String label) {
//     return InputDecoration(
//       alignLabelWithHint: true,
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       errorStyle: TextStyle(color: Colors.red),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withAlpha(107),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red.withAlpha(107),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withAlpha(107),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       hintText: label,
//     );
//   }
//
//   InputDecoration _dropdownDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       errorStyle: TextStyle(color: Colors.red),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withAlpha(107),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.red.withAlpha(107),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withAlpha(107),
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
//
//   void addExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         selectedMode = null;
//         _departureTownController.clear();
//         _departureTimeController.clear();
//         _arrivalTownController.clear();
//         _arrivalTimeController.clear();
//         _commentController.clear();
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//             (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "departureTown": _departureTownController.text,
//         "departureTime": _departureTimeController.text,
//         "arrivalTown": _arrivalTownController.text,
//         "arrivalTime": _arrivalTimeController.text,
//         "modeOfTravel": selectedMode,
//         "amount": _amountController.text,
//         "comment": _commentController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         if (!expenses[existingIndex]["data"].contains(newEntry)) {
//           expenses[existingIndex]["data"].add(newEntry);
//         }
//       }
//
//       _departureTownController.clear();
//       _departureTimeController.clear();
//       _arrivalTownController.clear();
//       _arrivalTimeController.clear();
//       selectedMode = null;
//       _commentController.clear();
//       pickedImages.clear();
//     });
//   }
//
//   void editExpense(int parentIndex, int entryIndex, Map<String, dynamic> updatedEntry,) {
//     if (parentIndex >= 0 && parentIndex < expenses.length) {
//       var group = expenses[parentIndex];
//       var data = group["data"];
//
//       if (data is List) {
//         if (entryIndex >= 0 && entryIndex < data.length) {
//           setState(() {
//             data[entryIndex] = updatedEntry;
//             expenses[parentIndex] = {...group, "data": List.from(data)};
//           });
//         }
//       }
//     }
//   }
//
//   void deleteExpense(int index) {
//     if (index >= 0 && index < expenses.length) {
//       setState(() {
//         expenses.removeAt(index);
//       });
//     }
//   }
//
//   Future<void> pickDateTime(TextEditingController controller) async {
//     DateTime? date = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (date == null) return;
//
//     if (!mounted) return;
//     TimeOfDay? time = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (time == null) return;
//
//     final selectedDateTime = DateTime(
//       date.year,
//       date.month,
//       date.day,
//       time.hour,
//       time.minute,
//     );
//
//     final formatted = DateFormat("dd-MMM-yyyy hh:mm a").format(selectedDateTime);
//     setState(() {
//       controller.text = formatted;
//     });
//   }
//
//   void showAddExpenseModal(BuildContext context, {Map<String, dynamic>? editingEntry, int? parentIndex, int? childIndex,}) {
//     if (_expenseDateController.text.isEmpty ||
//         _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError =
//         _expenseDateController.text.isEmpty ? 'Please select expense date' : null;
//         designationError =
//         _designationController.text.isEmpty ? 'Designation is required' : null;
//       });
//       return;
//     }
//
//     if (editingEntry != null) {
//       _departureTownController.text = editingEntry['departureTown'] ?? '';
//       _departureTimeController.text = editingEntry['departureTime'] ?? '';
//       _arrivalTownController.text = editingEntry['arrivalTown'] ?? '';
//       _arrivalTimeController.text = editingEntry['arrivalTime'] ?? '';
//       selectedMode = editingEntry['modeOfTravel'] ?? '';
//       _amountController.text = editingEntry['amount'] ?? '';
//       _commentController.text = editingEntry['comment'] ?? '';
//       selectedMode = editingEntry['modeOfTravel'];
//       pickedImages =
//           (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ?? [];
//     } else {
//       _departureTownController.clear();
//       _departureTimeController.clear();
//       _arrivalTownController.clear();
//       _arrivalTimeController.clear();
//       _amountController.clear();
//       _commentController.clear();
//       setState(() {
//         selectedMode = null;
//       });
//       pickedImages.clear();
//     }
//
//     Map<String, String?> errors = {};
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             void validateAndSubmit() {
//               errors.clear();
//
//               if (_departureTownController.text.trim().isEmpty) {
//                 errors['departureTown'] = 'Enter departure town';
//               }
//               if (_departureTimeController.text.trim().isEmpty) {
//                 errors['departureTime'] = 'Select departure time';
//               }
//               if (_arrivalTownController.text.trim().isEmpty) {
//                 errors['arrivalTown'] = 'Enter arrival town';
//               }
//               if (_arrivalTimeController.text.trim().isEmpty) {
//                 errors['arrivalTime'] = 'Select arrival time';
//               }
//               if (selectedMode == null || selectedMode!.isEmpty) {
//                 errors['modeOfTravel'] = 'Select mode of travel';
//               }
//               if (_amountController.text.trim().isEmpty) {
//                 errors['amount'] = 'Enter amount';
//               } else if (double.tryParse(_amountController.text.trim()) == null) {
//                 errors['amount'] = 'Enter valid number';
//               }
//               if (pickedImages.isEmpty) {
//                 errors['photo'] = 'Please add at least one photo';
//               }
//
//               setModalState(() {});
//
//               if (errors.isEmpty) {
//                 final updatedEntry = {
//                   'departureTown': _departureTownController.text.trim(),
//                   'departureTime': _departureTimeController.text.trim(),
//                   'arrivalTown': _arrivalTownController.text.trim(),
//                   'arrivalTime': _arrivalTimeController.text.trim(),
//                   'modeOfTravel': selectedMode,
//                   'amount': _amountController.text.trim(),
//                   'comment': _commentController.text.trim(),
//                   'images': pickedImages.map((e) => e.path).toList(),
//                 };
//                 if (editingEntry == null) {
//                   addExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, updatedEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             editingEntry == null ? "Add New Expense" : "Edit Expense",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.close, color: Colors.red, size: 20,),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: _departureTownController,
//                         decoration: _textDecoration('Departure town').copyWith(
//                           errorText: errors['departureTown'],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _departureTimeController,
//                         readOnly: true,
//                         decoration: _textDecoration('Departure time').copyWith(
//                           errorText: errors['departureTime'],
//                         ),
//                         onTap: () => pickDateTime(_departureTimeController),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _arrivalTownController,
//                         decoration: _textDecoration('Arrival town').copyWith(
//                           errorText: errors['arrivalTown'],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _arrivalTimeController,
//                         readOnly: true,
//                         decoration: _textDecoration('Arrival time').copyWith(
//                           errorText: errors['arrivalTime'],
//                         ),
//                         onTap: () => pickDateTime(_arrivalTimeController),
//                       ),
//                       const SizedBox(height: 10),
//                       SearchableDropdown(
//                         items: [
//                           'Train (Sleeper)',
//                           'Train (AC 3)',
//                           'Train (AC 2)',
//                           'Air (Economic Class)',
//                         ],
//                         itemLabel: (item) => item,
//                         onChanged: (value) {
//                           setModalState(() {
//                             selectedMode = value;
//                             errors.remove('modeOfTravel');
//                           });
//                         },
//                         selectedItem: selectedMode,
//                         hintText: "Select Travel Mode",
//                       ),
//                       if (errors['modeOfTravel'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 12),
//                           child: Text(
//                             errors['modeOfTravel']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _amountController,
//                         keyboardType: TextInputType.number,
//                         decoration: _textDecoration('Fare Rs.').copyWith(
//                           errorText: errors['amount'],
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TextField(
//                         controller: _commentController,
//                         decoration: _textDecoration('Comment (optional)'),
//                       ),
//                       const SizedBox(height: 10),
//                       InkWell(
//                         onTap: () {
//                           showPickerOptions((images) {
//                             setModalState(() {
//                               pickedImages.addAll(images);
//                               errors.remove('photo');
//                             });
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black.withAlpha(128),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Add Photo",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             errors['photo']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: !kIsWeb
//                                         ? Image.file(
//                                       File(pickedImages[index].path),
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                         : Image.network(
//                                       pickedImages[index].path,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 20,
//                             ),
//                           ),
//                           child: Text(
//                             editingEntry == null ? "Add Expense" : "Update Expense",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   // void addNonConveyanceExpense({bool isNext = false}) {
//   //   setState(() {
//   //     if (isNext) {
//   //       _expenseDateController.clear();
//   //       _designationController.clear();
//   //       _tourLocationController.clear();
//   //       selectedExpenseType = null;
//   //       _amountController.clear();
//   //       selectedDAType = null;
//   //       selectedCategoryState = null;
//   //       selectedDayType = null;
//   //       _remarksController.clear();
//   //       _mislinisCommentController.clear(); // clear misc comment
//   //       return;
//   //     }
//   //
//   //     String expenseDate = _expenseDateController.text;
//   //     int existingIndex = expenses.indexWhere(
//   //           (v) => v["expense_date"] == expenseDate,
//   //     );
//   //
//   //     Map<String, dynamic> newEntry = {
//   //       "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//   //       "tourLocation": _tourLocationController.text,
//   //       "expenseType": selectedExpenseType,
//   //       "category": selectedCategoryState,
//   //       "selectday":selectedDayType,
//   //       "amount": _amountController.text,
//   //       "daType": selectedDAType,
//   //       "remarks": selectedExpenseType == 'Miscellaneous'
//   //           ? _mislinisCommentController.text
//   //           : _remarksController.text,
//   //       "images": pickedImages.map((img) => img.path).toList(),
//   //     };
//   //     print("City Category data 1: ${newEntry["category"]}");
//   //
//   //     if (existingIndex == -1) {
//   //       expenses.add({
//   //         "expense_date": expenseDate,
//   //         "data": [newEntry],
//   //       });
//   //     } else {
//   //       expenses[existingIndex]["data"].add(newEntry);
//   //     }
//   //
//   //     // Clear all fields after add
//   //     _tourLocationController.clear();
//   //     selectedExpenseType = null;
//   //     selectedDAType = null;
//   //     selectedDayType = null;
//   //     _remarksController.clear();
//   //     _mislinisCommentController.clear();
//   //     _amountController.clear();
//   //     pickedImages.clear();
//   //   });
//   // }
//   void addNonConveyanceExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         _tourLocationController.clear();
//         selectedExpenseType = null;
//         _amountController.clear();
//         selectedDAType = null;
//         selectedCategoryState = null;
//         selectedDayType = null;
//         _remarksController.clear();
//         _mislinisCommentController.clear();
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//             (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "tourLocation": _tourLocationController.text,
//         "expenseType": selectedExpenseType,
//         "category": selectedCategoryState,     // <-- FIXED
//         "selectday": selectedDayType,          // <-- FIXED
//         "amount": _amountController.text,
//         "daType": selectedDAType,
//         "remarks": selectedExpenseType == 'Miscellaneous'
//             ? _mislinisCommentController.text
//             : _remarksController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         expenses[existingIndex]["data"].add(newEntry);
//       }
//
//       _tourLocationController.clear();
//       selectedExpenseType = null;
//       selectedDAType = null;
//       selectedCategoryState = null;
//       selectedDayType = null;
//       _remarksController.clear();
//       _mislinisCommentController.clear();
//       _amountController.clear();
//       pickedImages.clear();
//     });
//   }
//
//   /// =================================================================
//   /// =============== THIS IS THE CORRECTED FUNCTION ==================
//   /// =================================================================
//   // void showAddNonConveyanceModal(BuildContext context, {Map<String, dynamic>? editingEntry, int? parentIndex, int? childIndex,}) {
//   //   if (_expenseDateController.text.isEmpty || _designationController.text.isEmpty) {
//   //     setState(() {
//   //       expenseDateError =
//   //       _expenseDateController.text.isEmpty ? 'Please select expense date' : null;
//   //       designationError = _designationController.text.isEmpty ? 'Designation is required' : null;
//   //     });
//   //     return;
//   //   }
//   //   if (editingEntry != null) {
//   //     // If editing, fill fields with existing data
//   //     _tourLocationController.text = editingEntry['tourLocation'] ?? '';
//   //     _amountController.text = editingEntry['amount']?.toString() ?? '';
//   //     _remarksController.text = editingEntry['remarks'] ?? '';
//   //     selectedExpenseType = editingEntry['expenseType'];
//   //     selectedDAType = editingEntry['daType'];
//   //     pickedImages =
//   //         (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ?? [];
//   //     if (selectedExpenseType == 'Miscellaneous') {
//   //       _mislinisCommentController.text = editingEntry['remarks'] ?? '';
//   //     }
//   //   } else {
//   //     // **[FIX]** If adding a new entry, clear all previous state
//   //     _tourLocationController.clear();
//   //     _amountController.clear();
//   //     _remarksController.clear();
//   //     _mislinisCommentController.clear();
//   //     setState(() {
//   //       selectedExpenseType = null;
//   //       selectedDAType = null;
//   //     });
//   //     pickedImages.clear();
//   //   }
//   //   void _showCitySelectionModal(BuildContext context, TextEditingController controller) {
//   //     final expenseController = Get.find<ExpenseController>();
//   //     List<dynamic> cities = [];
//   //     bool isLoading = false;
//   //     int page = 1;
//   //     bool hasMore = true;
//   //     String searchQuery = "";
//   //
//   //     ScrollController scrollController = ScrollController();
//   //
//   //     Future<void> fetchCities({String query = "", bool loadMore = false}) async {
//   //       if (isLoading || (!hasMore && loadMore)) return;
//   //       isLoading = true;
//   //
//   //       List<dynamic> fetchedCities = [];
//   //       if (query.isEmpty) {
//   //         fetchedCities = await expenseController.fetchCities(page: page);
//   //       } else {
//   //         fetchedCities = await expenseController.searchCities(query);
//   //       }
//   //
//   //       if (loadMore) {
//   //         cities.addAll(fetchedCities);
//   //       } else {
//   //         cities = fetchedCities;
//   //       }
//   //
//   //       if (fetchedCities.length < 10) {
//   //         hasMore = false;
//   //       } else {
//   //         page++;
//   //       }
//   //
//   //       isLoading = false;
//   //     }
//   //
//   //     showModalBottomSheet(
//   //       context: context,
//   //       isScrollControlled: true,
//   //       backgroundColor: Colors.white,
//   //       shape: const RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //       ),
//   //       builder: (context) {
//   //         return StatefulBuilder(
//   //           builder: (context, setModalState) {
//   //             scrollController.addListener(() {
//   //               if (scrollController.position.pixels ==
//   //                   scrollController.position.maxScrollExtent &&
//   //                   hasMore &&
//   //                   !isLoading) {
//   //                 fetchCities(query: searchQuery, loadMore: true)
//   //                     .then((_) => setModalState(() {}));
//   //               }
//   //             });
//   //
//   //             // Initial fetch
//   //             if (cities.isEmpty && !isLoading) {
//   //               fetchCities().then((_) => setModalState(() {}));
//   //             }
//   //
//   //             return Padding(
//   //               padding: EdgeInsets.only(
//   //                 bottom: MediaQuery.of(context).viewInsets.bottom,
//   //                 top: 10,
//   //               ),
//   //               child: Column(
//   //                 mainAxisSize: MainAxisSize.min,
//   //                 children: [
//   //                   Padding(
//   //                     padding: const EdgeInsets.symmetric(horizontal: 15),
//   //                     child: TextField(
//   //                       decoration: InputDecoration(
//   //                         hintText: "Search city...",
//   //                         prefixIcon: const Icon(Icons.search),
//   //                         border: OutlineInputBorder(
//   //                             borderRadius: BorderRadius.circular(10)),
//   //                       ),
//   //                       onChanged: (val) {
//   //                         searchQuery = val;
//   //                         page = 1;
//   //                         hasMore = true;
//   //                         fetchCities(query: searchQuery, loadMore: false)
//   //                             .then((_) => setModalState(() {}));
//   //                       },
//   //                     ),
//   //                   ),
//   //                   const SizedBox(height: 10),
//   //                   Expanded(
//   //                     child: isLoading && cities.isEmpty
//   //                         ? const Center(child: CircularProgressIndicator())
//   //                         : ListView.builder(
//   //                       controller: scrollController,
//   //                       itemCount: cities.length + (hasMore ? 1 : 0),
//   //                       itemBuilder: (context, index) {
//   //                         if (index == cities.length) {
//   //                           return const Padding(
//   //                             padding: EdgeInsets.all(8.0),
//   //                             child: Center(
//   //                               child: CircularProgressIndicator(),
//   //                             ),
//   //                           );
//   //                         }
//   //                         final city = cities[index];
//   //                         return ListTile(
//   //                           title: Text(city['city_name'],style: TextStyle(color: Colors.black),),
//   //                           subtitle: Text(city['state_description'] ?? "",style: TextStyle(color: Colors.black),),
//   //                           onTap: () {
//   //                             controller.text = city['city_name'];
//   //                             Navigator.pop(context);
//   //                           },
//   //                         );
//   //                       },
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             );
//   //           },
//   //         );
//   //       },
//   //     );
//   //   }
//   //   /// es se kuval city name hi ui me show hoga ok
//   //   // void _showCitySelectionModal(BuildContext context, TextEditingController controller) {
//   //   //   final expenseController = Get.find<ExpenseController>();
//   //   //   List<dynamic> cities = [];
//   //   //   bool isLoading = false;
//   //   //   int page = 1;
//   //   //   bool hasMore = true;
//   //   //   String searchQuery = "";
//   //   //
//   //   //   ScrollController scrollController = ScrollController();
//   //   //
//   //   //   Future<void> fetchCities({String query = "", bool loadMore = false}) async {
//   //   //     if (isLoading || (!hasMore && loadMore)) return;
//   //   //     isLoading = true;
//   //   //
//   //   //     List<dynamic> fetchedCities = [];
//   //   //     if (query.isEmpty) {
//   //   //       fetchedCities = await expenseController.fetchCities(page: page);
//   //   //     } else {
//   //   //       fetchedCities = await expenseController.searchCities(query);
//   //   //     }
//   //   //
//   //   //     if (loadMore) {
//   //   //       cities.addAll(fetchedCities);
//   //   //     } else {
//   //   //       cities = fetchedCities;
//   //   //     }
//   //   //
//   //   //     if (fetchedCities.length < 10) {
//   //   //       hasMore = false;
//   //   //     } else {
//   //   //       page++;
//   //   //     }
//   //   //
//   //   //     isLoading = false;
//   //   //   }
//   //   //
//   //   //   showModalBottomSheet(
//   //   //     context: context,
//   //   //     isScrollControlled: true,
//   //   //     backgroundColor: Colors.white,
//   //   //     shape: const RoundedRectangleBorder(
//   //   //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //   //     ),
//   //   //     builder: (context) {
//   //   //       return StatefulBuilder(
//   //   //         builder: (context, setModalState) {
//   //   //           scrollController.addListener(() {
//   //   //             if (scrollController.position.pixels ==
//   //   //                 scrollController.position.maxScrollExtent &&
//   //   //                 hasMore &&
//   //   //                 !isLoading) {
//   //   //               fetchCities(query: searchQuery, loadMore: true)
//   //   //                   .then((_) => setModalState(() {}));
//   //   //             }
//   //   //           });
//   //   //
//   //   //           // Initial fetch
//   //   //           if (cities.isEmpty && !isLoading) {
//   //   //             fetchCities().then((_) => setModalState(() {}));
//   //   //           }
//   //   //
//   //   //           return Padding(
//   //   //             padding: EdgeInsets.only(
//   //   //               bottom: MediaQuery.of(context).viewInsets.bottom,
//   //   //               top: 10,
//   //   //             ),
//   //   //             child: Column(
//   //   //               mainAxisSize: MainAxisSize.min,
//   //   //               children: [
//   //   //                 Padding(
//   //   //                   padding: const EdgeInsets.symmetric(horizontal: 15),
//   //   //                   child: TextField(
//   //   //                     decoration: InputDecoration(
//   //   //                       hintText: "Search city...",
//   //   //                       prefixIcon: const Icon(Icons.search),
//   //   //                       border: OutlineInputBorder(
//   //   //                         borderRadius: BorderRadius.circular(10),
//   //   //                       ),
//   //   //                     ),
//   //   //                     onChanged: (val) {
//   //   //                       searchQuery = val;
//   //   //                       page = 1;
//   //   //                       hasMore = true;
//   //   //                       fetchCities(query: searchQuery, loadMore: false)
//   //   //                           .then((_) => setModalState(() {}));
//   //   //                     },
//   //   //                   ),
//   //   //                 ),
//   //   //                 const SizedBox(height: 10),
//   //   //                 Expanded(
//   //   //                   child: isLoading && cities.isEmpty
//   //   //                       ? const Center(child: CircularProgressIndicator())
//   //   //                       : ListView.builder(
//   //   //                     controller: scrollController,
//   //   //                     itemCount: cities.length + (hasMore ? 1 : 0),
//   //   //                     itemBuilder: (context, index) {
//   //   //                       if (index == cities.length) {
//   //   //                         return const Padding(
//   //   //                           padding: EdgeInsets.all(8.0),
//   //   //                           child: Center(
//   //   //                             child: CircularProgressIndicator(),
//   //   //                           ),
//   //   //                         );
//   //   //                       }
//   //   //                       final city = cities[index];
//   //   //                       return ListTile(
//   //   //                         title: Text(city['city_name'] ?? ""), // ✅ Only city_name
//   //   //                         onTap: () {
//   //   //                           controller.text = city['city_name'] ?? "";
//   //   //                           Navigator.pop(context);
//   //   //                         },
//   //   //                       );
//   //   //                     },
//   //   //                   ),
//   //   //                 ),
//   //   //               ],
//   //   //             ),
//   //   //           );
//   //   //         },
//   //   //       );
//   //   //     },
//   //   //   );
//   //   // }
//   //   String? selectedCategory;
//   //   final _hotel_PriceController = TextEditingController();
//   //
//   //   DropdownButtonFormField<String>(
//   //     value: selectedCategory,
//   //     decoration: InputDecoration(
//   //       labelText: "Category",
//   //       labelStyle: TextStyle(color: Colors.black),
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //       filled: true,
//   //       fillColor: Colors.white,
//   //     ),
//   //     dropdownColor: Colors.white,
//   //     style: const TextStyle(color: Colors.black, fontSize: 16),
//   //     items: ['A', 'B', 'C']
//   //         .map((e) => DropdownMenuItem(
//   //       value: e,
//   //       child: Text('Category -> $e'),
//   //     )).toList(),
//   //     onChanged: (value) async {
//   //       selectedCategory = value;
//   //       if (selectedCategory != null) {
//   //         final expenseController = Get.find<ExpenseController>();
//   //         final hotelAmount =
//   //         await expenseController.fetchAllowanceByCategory(selectedCategory!);
//   //         _hotel_PriceController.text = hotelAmount?.toStringAsFixed(2) ?? '0.00';
//   //       }
//   //     },
//   //   );
//   //
//   //   Map<String, String?> errors = {};
//   //   //String? selectedCategory; // state variable to hold selected value
//   //
//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     backgroundColor: Colors.white,
//   //     shape: const RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//   //     ),
//   //     builder: (BuildContext context) {
//   //       return StatefulBuilder(
//   //         builder: (context, setModalState) {
//   //           void validateAndSubmit() {
//   //             errors.clear();
//   //
//   //             if (_tourLocationController.text.trim().isEmpty) {
//   //               errors['tourLocation'] = 'Enter tour location';
//   //             }
//   //             if (selectedExpenseType == null || selectedExpenseType!.isEmpty) {
//   //               errors['expenseType'] = 'Select expense type';
//   //             }
//   //             if (_amountController.text.trim().isEmpty) {
//   //               errors['amount'] = 'Enter amount';
//   //             }
//   //             if (pickedImages.isEmpty) {
//   //               errors['photo'] = 'Please add at least one photo';
//   //             }
//   //             if (selectedExpenseType == 'Miscellaneous' &&
//   //                 _mislinisCommentController.text.trim().isEmpty) {
//   //               errors['remarks'] = 'Comment is required for Miscellaneous';
//   //             }
//   //
//   //             setModalState(() {});
//   //
//   //             if (errors.isEmpty) {
//   //               final updatedEntry = {
//   //                 "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//   //                 "tourLocation": _tourLocationController.text.trim(),
//   //                 "expenseType": selectedExpenseType,
//   //                 "amount": _amountController.text.trim(),
//   //                 "daType": selectedDAType,
//   //                 "remarks": selectedExpenseType == 'Miscellaneous'
//   //                     ? _mislinisCommentController.text.trim()
//   //                     : _remarksController.text.trim(),
//   //                 "images": pickedImages.map((img) => img.path).toList(),
//   //               };
//   //
//   //               if (editingEntry == null) {
//   //                 addNonConveyanceExpense();
//   //               } else {
//   //                 editExpense(parentIndex!, childIndex!, updatedEntry);
//   //               }
//   //               Navigator.pop(context);
//   //             }
//   //           }
//   //
//   //           return Padding(
//   //             padding: EdgeInsets.only(
//   //               bottom: MediaQuery.of(context).viewInsets.bottom,
//   //             ),
//   //             child: SingleChildScrollView(
//   //               physics: const BouncingScrollPhysics(),
//   //               child: Padding(
//   //                 padding: const EdgeInsets.all(15),
//   //                 child: Column(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   crossAxisAlignment: CrossAxisAlignment.start,
//   //                   children: [
//   //                     Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Text(
//   //                           editingEntry == null
//   //                               ? "Add Non-Conveyance Expense"
//   //                               : "Edit Non-Conveyance Expense",
//   //                           style: const TextStyle(
//   //                             fontSize: 18,
//   //                             fontWeight: FontWeight.bold,
//   //                           ),
//   //                         ),
//   //                         IconButton(
//   //                             onPressed: (){
//   //                               Navigator.pop(context);
//   //                             }, icon: Icon(Icons.close, color: Colors.red, size: 20,),
//   //                         )
//   //                       ],
//   //                     ),
//   //                     const SizedBox(height: 20),
//   //                     TextField(
//   //                       controller: _tourLocationController,
//   //                       decoration: _textDecoration('Tour Location')
//   //                           .copyWith(errorText: errors['tourLocation']),
//   //                     ),
//   //                     const SizedBox(height: 10),
//   //                     DropdownButtonFormField<String>(
//   //                       value: selectedCategory,
//   //                       decoration: InputDecoration(
//   //                         labelText: "Category",
//   //                         labelStyle: TextStyle(color: Colors.black),
//   //                         border: OutlineInputBorder(
//   //                           borderRadius: BorderRadius.circular(10,),
//   //                         ),
//   //                         filled: true, // ✅ fill background
//   //                         fillColor: Colors.white, // ✅ white background
//   //                       ),
//   //                       dropdownColor: Colors.white, // ✅ dropdown list background color
//   //                       style: const TextStyle(
//   //                         color: Colors.black, // ✅ text color
//   //                         fontSize: 16,
//   //                       ),
//   //                       items: ['Category-> A', 'Category -> B', 'Category-> C']
//   //                           .map((e) => DropdownMenuItem(
//   //                         value: e,
//   //                         child: Text(e),
//   //                       ))
//   //                           .toList(),
//   //                       onChanged: (value) {
//   //                         selectedCategory = value;
//   //                         // agar stateful widget me ho to setState((){}) call karein
//   //                       },
//   //                     ),
//   //                     const SizedBox(height: 10),
//   //                     TextField(
//   //                       controller: _hotel_PriceController,
//   //                       readOnly: true, // ✅ user cannot edit
//   //                       decoration: _textDecoration('Fix Hotel Amount')
//   //                           .copyWith(errorText: errors['FixHotelAmount']),
//   //                     ),
//   //
//   //                     // const SizedBox(height: 10),
//   //                     // TextField(
//   //                     //   controller: _tourLocationController,
//   //                     //   readOnly: true, // Important to prevent keyboard
//   //                     //   decoration: _textDecoration('Tour Location')
//   //                     //       .copyWith(errorText: errors['tourLocation']),cursorColor: Colors.black,
//   //                     //   onTap: () {
//   //                     //     _showCitySelectionModal(context, _tourLocationController);
//   //                     //   },
//   //                     // ),
//   //
//   //                     const SizedBox(height: 10),
//   //                     DropdownButtonFormField<String>(
//   //                       value: selectedExpenseType,
//   //                       dropdownColor: Colors.white,
//   //                       items: ['Hotel', 'DA', 'Miscellaneous']
//   //                           .map(
//   //                             (e) => DropdownMenuItem(
//   //                           value: e,
//   //                           child: Text(e)
//   //                         ),
//   //                       ).toList(),
//   //                       onChanged: (value) {
//   //                         setModalState(() {
//   //                           selectedExpenseType = value;
//   //                           errors.remove('expenseType');
//   //                         });
//   //                       },
//   //                       decoration: _textDecoration('Expense Type')
//   //                           .copyWith(errorText: errors['expenseType']),
//   //                     ),
//   //                     const SizedBox(height: 10),
//   //                     if (selectedExpenseType == 'Miscellaneous') ...[
//   //                       TextField(
//   //                         controller: _mislinisCommentController,
//   //                         decoration: _textDecoration('Comment (required)')
//   //                             .copyWith(errorText: errors['remarks']),
//   //                       ),
//   //                       const SizedBox(height: 10),
//   //                     ],
//   //                     TextField(
//   //                       controller: _amountController,
//   //                       keyboardType: TextInputType.number,
//   //                       decoration: _textDecoration('Amount')
//   //                           .copyWith(errorText: errors['amount']),
//   //                     ),
//   //                     const SizedBox(height: 10),
//   //                     if (selectedExpenseType != 'Miscellaneous')
//   //                       TextField(
//   //                         controller: _remarksController,
//   //                         decoration: _textDecoration('Remarks (optional)'),
//   //                       ),
//   //                     const SizedBox(height: 10),
//   //                     InkWell(
//   //                       onTap: () {
//   //                         showPickerOptions((images) {
//   //                           setModalState(() {
//   //                             pickedImages.addAll(images);
//   //                             errors.remove('photo');
//   //                           });
//   //                         });
//   //                       },
//   //                       child: Container(
//   //                         padding: const EdgeInsets.symmetric(
//   //                           horizontal: 12,
//   //                           vertical: 14,
//   //                         ),
//   //                         decoration: BoxDecoration(
//   //                           border: Border.all(
//   //                             color: errors['photo'] != null
//   //                                 ? Colors.red
//   //                                 : Colors.black.withAlpha(128),
//   //                           ),
//   //                           borderRadius: BorderRadius.circular(6),
//   //                         ),
//   //                         child: const Row(
//   //                           children: [
//   //                             Icon(
//   //                               Icons.camera_alt,
//   //                               size: 20,
//   //                               color: Colors.grey,
//   //                             ),
//   //                             SizedBox(width: 8),
//   //                             Text(
//   //                               "Add Photo",
//   //                               style: TextStyle(
//   //                                 fontSize: 16,
//   //                                 color: Colors.grey,
//   //                               ),
//   //                             ),
//   //                           ],
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     if (errors['photo'] != null)
//   //                       Padding(
//   //                         padding: const EdgeInsets.only(top: 5, left: 12),
//   //                         child: Text(
//   //                           errors['photo']!,
//   //                           style: const TextStyle(
//   //                             color: Colors.red,
//   //                             fontSize: 12,
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     if (pickedImages.isNotEmpty)
//   //                       SizedBox(
//   //                         height: 90,
//   //                         child: ListView.builder(
//   //                           scrollDirection: Axis.horizontal,
//   //                           itemCount: pickedImages.length,
//   //                           itemBuilder: (context, index) {
//   //                             return Stack(
//   //                               clipBehavior: Clip.none,
//   //                               children: [
//   //                                 Padding(
//   //                                   padding: const EdgeInsets.all(5.0),
//   //                                   child: !kIsWeb
//   //                                       ? Image.file(
//   //                                     File(pickedImages[index].path),
//   //                                     width: 80,
//   //                                     height: 80,
//   //                                     fit: BoxFit.cover,
//   //                                   )
//   //                                       : Image.network(
//   //                                     pickedImages[index].path,
//   //                                     width: 80,
//   //                                     height: 80,
//   //                                     fit: BoxFit.cover,
//   //                                   ),
//   //                                 ),
//   //                                 Positioned(
//   //                                   top: 0,
//   //                                   right: 0,
//   //                                   child: GestureDetector(
//   //                                     onTap: () {
//   //                                       setModalState(() {
//   //                                         pickedImages.removeAt(index);
//   //                                       });
//   //                                     },
//   //                                     child: Container(
//   //                                       decoration: const BoxDecoration(
//   //                                         color: Colors.black54,
//   //                                         shape: BoxShape.circle,
//   //                                       ),
//   //                                       padding: const EdgeInsets.all(2),
//   //                                       child: const Icon(
//   //                                         Icons.close,
//   //                                         size: 16,
//   //                                         color: Colors.white,
//   //                                       ),
//   //                                     ),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             );
//   //                           },
//   //                         ),
//   //                       ),
//   //                     const SizedBox(height: 20),
//   //                     Align(
//   //                       alignment: Alignment.bottomRight,
//   //                       child: ElevatedButton(
//   //                         onPressed: validateAndSubmit,
//   //                         style: ElevatedButton.styleFrom(
//   //                           backgroundColor: Colors.black,
//   //                           foregroundColor: Colors.white,
//   //                           padding: const EdgeInsets.symmetric(
//   //                             vertical: 15,
//   //                             horizontal: 20,
//   //                           ),
//   //                         ),
//   //                         child: Text(
//   //                           editingEntry == null ? "Add Expense" : "Update Expense",
//   //                         ),
//   //                       ),
//   //                     ),
//   //                     const SizedBox(height: 25),
//   //                   ],
//   //                 ),
//   //               ),
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//   void showAddNonConveyanceModal(BuildContext context, {Map<String, dynamic>? editingEntry, int? parentIndex, int? childIndex,}) {
//     if (_expenseDateController.text.isEmpty || _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError = _expenseDateController.text.isEmpty ? 'Please select expense date' : null;
//         designationError = _designationController.text.isEmpty ? 'Designation is required' : null;
//       });
//       return;
//     }
//
//     // if (editingEntry != null) {
//     //   _tourLocationController.text = editingEntry['tourLocation'] ?? '';
//     //   _amountController.text = editingEntry['amount']?.toString() ?? '';
//     //   _remarksController.text = editingEntry['remarks'] ?? '';
//     //   selectedExpenseType = editingEntry['expenseType'];
//     //   selectedDAType = editingEntry['daType'];
//     //   pickedImages = (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ?? [];
//     //   if (selectedExpenseType == 'Miscellaneous') {
//     //     _mislinisCommentController.text = editingEntry['remarks'] ?? '';
//     //   }
//     // }
//     if (editingEntry != null) {
//       _tourLocationController.text = editingEntry['tourLocation'] ?? '';
//       _amountController.text = editingEntry['amount']?.toString() ?? '';
//       _remarksController.text = editingEntry['remarks'] ?? '';
//       selectedExpenseType = editingEntry['expenseType'];
//       selectedDAType = editingEntry['daType'];
//       pickedImages = (editingEntry['images'] as List?)
//           ?.map((e) => XFile(e))
//           .toList() ??
//           [];
//
//       selectedCategoryState = editingEntry['category'];   // <-- IMPORTANT
//       selectedDayType = editingEntry['selectday'];        // <-- IMPORTANT
//
//       if (selectedExpenseType == 'Miscellaneous') {
//         _mislinisCommentController.text = editingEntry['remarks'] ?? '';
//       }
//     }
//     else {
//       _tourLocationController.clear();
//       _amountController.clear();
//       _remarksController.clear();
//       _mislinisCommentController.clear();
//       pickedImages.clear();
//       setState(() {
//         selectedExpenseType = null;
//       });
//     }
//
//     String? selectedCategory;
//     final _hotel_PriceController = TextEditingController();
//
//     Map<String, String?> errors = {};
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//
//             void validateAndSubmit() {
//               errors.clear();
//
//               if (_tourLocationController.text.trim().isEmpty) {
//                 errors['tourLocation'] = 'Enter tour location';
//               }
//               if (selectedExpenseType == null || selectedExpenseType!.isEmpty) {
//                 errors['expenseType'] = 'Select expense type';
//               }
//               if (_amountController.text.trim().isEmpty) {
//                 errors['amount'] = 'Enter amount';
//               }
//               if (pickedImages.isEmpty) {
//                 errors['photo'] = 'Please add at least one photo';
//               }
//               if (selectedExpenseType == 'Miscellaneous' &&
//                   _mislinisCommentController.text.trim().isEmpty) {
//                 errors['remarks'] = 'Comment is required for Miscellaneous';
//               }
//
//               setModalState(() {});
//
//               if (errors.isEmpty) {
//                 final updatedEntry = {
//                   "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//                   "tourLocation": _tourLocationController.text.trim(),
//                   "category": selectedCategoryState,    // <-- ALWAYS CORRECT NOW
//                   "selectday": selectedDayType,
//                   "expenseType": selectedExpenseType,
//                   "amount": _amountController.text.trim(),
//                   "daType": selectedDAType,
//                   "remarks": selectedExpenseType == 'Miscellaneous'
//                       ? _mislinisCommentController.text.trim()
//                       : _remarksController.text.trim(),
//                   "images": pickedImages.map((img) => img.path).toList(),
//                 };
//                 print("City Category data 2: ${updatedEntry["category"]}");
//                 if (editingEntry == null) {
//                   addNonConveyanceExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, updatedEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Modal Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             editingEntry == null
//                                 ? "Add Non-Conveyance Expense"
//                                 : "Edit Non-Conveyance Expense",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             icon: Icon(Icons.close, color: Colors.red, size: 20),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Tour Location
//                       TextField(
//                         controller: _tourLocationController,
//                         decoration: _textDecoration('Tour Location')
//                             .copyWith(errorText: errors['tourLocation']),
//
//                        ),
//                       const SizedBox(height: 10),
//
//                       // Category Dropdown
//                       // DropdownButtonFormField<String>(
//                       //   value: selectedCategory,
//                       //   decoration: InputDecoration(
//                       //     labelText: "City Category",
//                       //     labelStyle: TextStyle(color: Colors.black),
//                       //     border: OutlineInputBorder(
//                       //       borderRadius: BorderRadius.circular(10),
//                       //     ),
//                       //     filled: true,
//                       //     fillColor: Colors.white,
//                       //     suffixIcon: const Icon(
//                       //       Icons.arrow_drop_down, // ✅ right side icon
//                       //       color: Colors.black54,
//                       //     ),
//                       //   ),
//                       //   dropdownColor: Colors.white,
//                       //   style: const TextStyle(color: Colors.black, fontSize: 16),
//                       //   items: ['A', 'B'].map((e) => DropdownMenuItem(
//                       //     value: e,
//                       //     child: Text('Category -> $e'),
//                       //   )).toList(),
//                       //   onChanged: (value) async {
//                       //     selectedCategory = value;
//                       //     if (selectedCategory != null) {
//                       //       final expenseController = Get.find<ExpenseController>();
//                       //       final hotelAmount = await expenseController.fetchAllowanceByCategory(selectedCategory!);
//                       //       setModalState(() {
//                       //         _hotel_PriceController.text = hotelAmount?.toStringAsFixed(2) ?? '0.00';
//                       //       });
//                       //     }
//                       //   },
//                       // ),
//                       //const SizedBox(height: 10),
//                       // Category Dropdown
//                       // DropdownButtonFormField<String>(
//                       //   value: selectedCategory,
//                       //   decoration: InputDecoration(
//                       //     labelText: "Select day",
//                       //     labelStyle: TextStyle(color: Colors.black),
//                       //     border: OutlineInputBorder(
//                       //       borderRadius: BorderRadius.circular(10),
//                       //     ),
//                       //     filled: true,
//                       //     fillColor: Colors.white,
//                       //     suffixIcon: const Icon(
//                       //       Icons.arrow_drop_down, // ✅ right side icon
//                       //       color: Colors.black54,
//                       //     ),
//                       //   ),
//                       //   dropdownColor: Colors.white,
//                       //   style: const TextStyle(color: Colors.black, fontSize: 16),
//                       //   items: ['Full day', 'Half day'].map((e) => DropdownMenuItem(
//                       //     value: e,
//                       //     child: Text('DA-> $e'),
//                       //   )).toList(),
//                       //   onChanged: (value) async {
//                       //     selectedCategory = value;
//                       //     if (selectedCategory != null) {
//                       //       final expenseController = Get.find<ExpenseController>();
//                       //       final hotelAmount = await expenseController.fetchAllowanceByCategory(selectedCategory!);
//                       //       setModalState(() {
//                       //         _hotel_PriceController.text = hotelAmount?.toStringAsFixed(2) ?? '0.00';
//                       //       });
//                       //     }
//                       //   },
//                       // ),
//                       DropdownButtonFormField<String>(
//                       dropdownColor: Colors.white,
//                       value: selectedCategoryState,
//                       decoration: InputDecoration(
//                         labelText: "City Category",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         labelStyle: TextStyle(color: Colors.black),
//                         filled: true,
//                         fillColor: Colors.white,
//                         suffixIcon: Icon(Icons.arrow_drop_down),
//                       ),
//                       items: ['A', 'B'].map((e) {
//                         return DropdownMenuItem(
//                           value: e,
//                           child: Text('Category → $e'),
//                         );
//                       }).toList(),
//
//                       onChanged: (value) {
//                         // FIX: allow selecting the same value again
//                         if (value == selectedCategoryState) {
//                           setModalState(() {
//                             selectedCategoryState = null;
//                           });
//
//                           Future.delayed(const Duration(milliseconds: 10), () {
//                             setModalState(() {
//                               selectedCategoryState = value;
//
//                               // Your existing resets
//                               selectedDayType = null;
//                               foodAllowance = "0.00";
//                               travelAllowance = "0.00";
//                               hotelAllowance = "0.00";
//                             });
//                           });
//                         } else {
//                           setModalState(() {
//                             selectedCategoryState = value;
//
//                             // Your existing resets
//                             selectedDayType = null;
//                             foodAllowance = "0.00";
//                             travelAllowance = "0.00";
//                             hotelAllowance = "0.00";
//                           });
//                         }
//                       },
//                     ),
//                       const SizedBox(height: 10),
//                       // Expense Type
//                       DropdownButtonFormField<String>(
//                         value: selectedExpenseType,
//                         dropdownColor: Colors.white,
//                         items: ['Hotel', 'DA', 'Miscellaneous']
//                             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//                             .toList(),
//                         onChanged: (value) {
//                           setModalState(() {
//                             selectedExpenseType = value;
//                             errors.remove('expenseType');
//                           });
//                         },
//                         decoration: InputDecoration(
//                           labelText: "ExpenseType",
//                           labelStyle: TextStyle(color: Colors.black),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           suffixIcon: const Icon(
//                             Icons.arrow_drop_down, // ✅ right side icon
//                             color: Colors.black54,
//                           ),
//                         ),
//                         // decoration: _textDecoration('Expense Type')
//                         //     .copyWith(errorText: errors['expenseType']),
//                       ),
//                       SizedBox(height: 10),
//                       DropdownButtonFormField<String>(
//                         dropdownColor: Colors.white,
//                         value: selectedDayType,
//                         decoration: InputDecoration(
//                           labelText: "Select day",
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           labelStyle: TextStyle(color: Colors.black),
//                           filled: true,
//                           fillColor: Colors.white,
//                           suffixIcon: Icon(Icons.arrow_drop_down),
//                         ),
//                         items: selectedCategoryState == null
//                             ? []
//                             : ['Full day', 'Half day'].map((e) {
//                           return DropdownMenuItem(
//                             value: e,
//                             child: Text('DA → $e'),
//                           );
//                         }).toList(),
//                         onChanged: selectedCategoryState == null
//                             ? null
//                             : (value) async {
//                           setModalState(() {
//                             selectedDayType = value;
//                           });
//
//                           await fetchAllowance(
//                               setModalState, selectedCategoryState, selectedDayType);
//                         },
//                       ),
//
//                       const SizedBox(height: 4),
//
//
//                       // 🔥 Show allowance ONLY when values are available
//                       // === ALLOWANCE SECTION (Dynamically Show/Hide) ===
//                       // Show allowance based on day type
//                       if (selectedDayType != null && [foodAllowance, travelAllowance, hotelAllowance].any((a) => a != "0.00"))
//                         Container(
//                           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               if (foodAllowance != "0.00")
//                                 Text(
//                                   "Food Allowance: ₹$foodAllowance",
//                                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                                 ),
//                               if ( hotelAllowance != "0.00")
//                                 Text(
//                                   "Hotel Allowance: ₹$hotelAllowance",
//                                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                                 ),
//                               if (travelAllowance != "0.00")
//                                 Text(
//                                   "Travel Allowance: ₹$travelAllowance",
//                                   style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       // const SizedBox(height: 4),
//                       // Container(
//                       //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 7),
//                       //   child: Row(
//                       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       //     children: [
//                       //       const Text(
//                       //         'Hotel Allowance',
//                       //         style: TextStyle(
//                       //           fontSize: 14,
//                       //           color: Colors.black,
//                       //           fontWeight: FontWeight.bold
//                       //         ),
//                       //       ),
//                       //       Text(
//                       //         _hotel_PriceController.text.isEmpty ? '0.00' : _hotel_PriceController.text,
//                       //         style: const TextStyle(
//                       //           fontSize: 16,
//                       //           color: Colors.black,
//                       //           fontWeight: FontWeight.bold,
//                       //         ),
//                       //       ),
//                       //     ],
//                       //   ),
//                       // ),
//                       const SizedBox(height: 4),
//                       // Amount
//                       TextField(
//                         controller: _amountController,
//                         keyboardType: TextInputType.number,
//                         decoration: _textDecoration('Amount')
//                             .copyWith(errorText: errors['amount']),
//                       ),
//                       const SizedBox(height: 10),
//
//                       // Miscellaneous Comment
//                       if (selectedExpenseType == 'Miscellaneous') ...[
//                         TextField(
//                           controller: _mislinisCommentController,
//                           decoration: _textDecoration('Comment (required)')
//                               .copyWith(errorText: errors['remarks']),
//                         ),
//                       ],
//                      // const SizedBox(height: 10),
//                       // Remarks
//                       if (selectedExpenseType != 'Miscellaneous')
//                         TextField(
//                           controller: _remarksController,
//                           decoration: _textDecoration('Remarks (optional)'),
//                         ),
//                       const SizedBox(height: 10),
//
//                       // Add Photo
//                       InkWell(
//                         onTap: () {
//                           showPickerOptions((images) {
//                             setModalState(() {
//                               pickedImages.addAll(images);
//                               errors.remove('photo');
//                             });
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: errors['photo'] != null
//                                   ? Colors.red
//                                   : Colors.black.withAlpha(128),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.camera_alt, size: 20, color: Colors.grey),
//                               SizedBox(width: 8),
//                               Text("Add Photo", style: TextStyle(fontSize: 16, color: Colors.grey)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 12),
//                           child: Text(errors['photo']!, style: const TextStyle(color: Colors.red, fontSize: 12)),
//                         ),
//
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: !kIsWeb
//                                         ? Image.file(
//                                       File(pickedImages[index].path),
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                         : Image.network(
//                                       pickedImages[index].path,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(Icons.close, size: 16, color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//
//                       // Submit Button
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                           ),
//                           child: Text(editingEntry == null ? "Add Expense" : "Update Expense"),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void addLocalConveyanceExpense({bool isNext = false}) {
//     setState(() {
//       if (isNext) {
//         _expenseDateController.clear();
//         _designationController.clear();
//         selectedTravelType = null;
//         _travelAmountController.clear();
//         return;
//       }
//
//       String expenseDate = _expenseDateController.text;
//       int existingIndex = expenses.indexWhere(
//             (v) => v["expense_date"] == expenseDate,
//       );
//
//       Map<String, dynamic> newEntry = {
//         "type": widget.type.toLowerCase().replaceAll(' ', '_'),
//         "travelType": selectedTravelType,
//         "travelAmount": _travelAmountController.text,
//         "images": pickedImages.map((img) => img.path).toList(),
//       };
//
//       if (existingIndex == -1) {
//         expenses.add({
//           "expense_date": expenseDate,
//           "data": [newEntry],
//         });
//       } else {
//         if (!expenses[existingIndex]["data"].contains(newEntry)) {
//           expenses[existingIndex]["data"].add(newEntry);
//         }
//       }
//
//       _tourLocationController.clear();
//       selectedExpenseType = null;
//       selectedDAType = null;
//       _remarksController.clear();
//       _amountController.clear();
//       pickedImages.clear();
//     });
//   }
//
//   void showAddLocalConveyanceModal(BuildContext context, {Map<String, dynamic>? editingEntry, int? parentIndex, int? childIndex,}) {
//     if (_expenseDateController.text.isEmpty ||
//         _designationController.text.isEmpty) {
//       setState(() {
//         expenseDateError =
//         _expenseDateController.text.isEmpty ? 'Please select expense date' : null;
//         designationError =
//         _designationController.text.isEmpty ? 'Designation is required' : null;
//       });
//       return;
//     }
//
//     if (editingEntry != null) {
//       selectedTravelType = editingEntry['travelType'];
//       _travelAmountController.text = editingEntry['travelAmount'] ?? "0";
//       pickedImages =
//           (editingEntry['images'] as List?)?.map((e) => XFile(e)).toList() ?? [];
//     } else {
//       setState(() {
//         selectedTravelType = null;
//       });
//       _travelAmountController.clear();
//       pickedImages.clear();
//     }
//
//     Map<String, String?> errors = {};
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setModalState) {
//             void validateAndSubmit() {
//               errors.clear();
//
//               if (selectedTravelType == null || selectedTravelType!.isEmpty) {
//                 errors['travelType'] = 'Select travel type';
//               }
//               if (_travelAmountController.text.trim().isEmpty) {
//                 errors['travelAmount'] = 'Enter travel amount';
//               }
//
//               setModalState(() {});
//
//               if (errors.isEmpty) {
//                 final updatedEntry = {
//                   "travelType": selectedTravelType,
//                   "travelAmount": _travelAmountController.text,
//                   "images": pickedImages.map((img) => img.path).toList(),
//                 };
//                 if (editingEntry == null) {
//                   addLocalConveyanceExpense();
//                 } else {
//                   editExpense(parentIndex!, childIndex!, updatedEntry);
//                 }
//                 Navigator.pop(context);
//               }
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             editingEntry == null
//                                 ? "Add Local-Conveyance Expense"
//                                 : "Edit Local-Conveyance Expense",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: (){
//                               Navigator.pop(context);
//                             }, icon: Icon(Icons.close, color: Colors.red, size: 20,),
//                           )
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                       DropdownButtonFormField<String>(
//                         value: selectedTravelType,
//                         dropdownColor: Colors.white,
//                         items: ['Auto', 'Ola/Uber/Taxi', 'Ac Bus']
//                             .map(
//                               (e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ),
//                         )
//                             .toList(),
//                         onChanged: (value) {
//                           setModalState(() {
//                             selectedTravelType = value;
//                             errors.remove('travelType');
//                           });
//                         },
//                         decoration: _dropdownDecoration('Travel Type')
//                             .copyWith(errorText: errors['travelType']),
//                       ),
//                       SizedBox(height: 10),
//                       TextField(
//                         controller: _travelAmountController,
//                         keyboardType: TextInputType.number,
//                         decoration: _textDecoration('Travel Amount')
//                             .copyWith(errorText: errors['travelAmount']),
//                       ),
//                       const SizedBox(height: 10),
//                       InkWell(
//                         onTap: () {
//                           showPickerOptions((images) {
//                             setModalState(() {
//                               pickedImages.addAll(images);
//                               errors.remove('photo');
//                             });
//                           });
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 14,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.black.withAlpha(128),
//                             ),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: const Row(
//                             children: [
//                               Icon(
//                                 Icons.camera_alt,
//                                 size: 20,
//                                 color: Colors.grey,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Add Photo",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       if (errors['photo'] != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 5, left: 5),
//                           child: Text(
//                             errors['photo']!,
//                             style: const TextStyle(
//                               color: Colors.red,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ),
//                       if (pickedImages.isNotEmpty)
//                         SizedBox(
//                           height: 90,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: pickedImages.length,
//                             itemBuilder: (context, index) {
//                               return Stack(
//                                 clipBehavior: Clip.none,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: !kIsWeb
//                                         ? Image.file(
//                                       File(pickedImages[index].path),
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     )
//                                         : Image.network(
//                                       pickedImages[index].path,
//                                       width: 80,
//                                       height: 80,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Positioned(
//                                     top: 0,
//                                     right: 0,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setModalState(() {
//                                           pickedImages.removeAt(index);
//                                         });
//                                       },
//                                       child: Container(
//                                         decoration: const BoxDecoration(
//                                           color: Colors.black54,
//                                           shape: BoxShape.circle,
//                                         ),
//                                         padding: const EdgeInsets.all(2),
//                                         child: const Icon(
//                                           Icons.close,
//                                           size: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                         ),
//                       const SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: ElevatedButton(
//                           onPressed: validateAndSubmit,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 20,
//                             ),
//                           ),
//                           child: Text(
//                             editingEntry == null ? "Add Expense" : "Update Expense",
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       _expenseDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
//       _designationController.text =
//           _profileController.user.value?.designation ?? 'N/A';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final filteredEntries = expenses.where(
//           (visit) => visit['expense_date'] == _expenseDateController.text,
//     ).expand((visit) => visit['data'].asMap().entries).toList();
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: Text('Create ${widget.type} expense')),
//         body: Align(
//           alignment: Alignment.center,
//           child: Container(
//             width: Responsive.isSm(context)
//                 ? screenWidth
//                 : Responsive.isXl(context)
//                 ? screenWidth * 0.60
//                 : screenWidth * 0.40,
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _expenseDateController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 20,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withAlpha(107),
//                         width: 1.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withAlpha(107),
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red.withAlpha(153),
//                         width: 2,
//                       ),
//                     ),
//                     labelText: 'Expense Date',
//                     labelStyle: TextStyle(
//                       color: Colors.black.withAlpha(179),
//                     ),
//                     hintText: 'Expense Date',
//                     errorText: expenseDateError,
//                     suffixIcon: const Icon(
//                       Icons.calendar_today,
//                       color: Colors.black,
//                     ),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       setState(() {
//                         _expenseDateController.text =
//                         "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//                       });
//                     }
//                   },
//                 ),
//                 SizedBox(height: 15),
//                 TextField(
//                   controller: _designationController,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 20,
//                     ),
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withAlpha(107),
//                         width: 1.5,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.black.withAlpha(107),
//                         width: 2,
//                       ),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.red.withAlpha(153),
//                         width: 2,
//                       ),
//                     ),
//                     labelText: 'Designation',
//                     labelStyle: TextStyle(
//                       color: Colors.black.withAlpha(179),
//                     ),
//                     hintText: 'Designation',
//                     errorText: designationError,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 if (expenses.isNotEmpty)
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         separatorBuilder: (context, index) =>
//                             SizedBox(height: 15.0),
//                         itemCount: filteredEntries.length,
//                         itemBuilder: (context, index) {
//                           final entry = filteredEntries[index];
//                           final entryIndex = entry.key;
//                           final entryValue = entry.value;
//                           return widget.type == 'Conveyance'
//                               ? ExpenseCard(
//                             entryValue: entryValue,
//                             parentIndex: index,
//                             childIndex: entryIndex,
//                             onEdit: (value, parentIndex, childIndex) {
//                               showAddExpenseModal(
//                                 context,
//                                 editingEntry: value,
//                                 parentIndex: parentIndex,
//                                 childIndex: childIndex,
//                               );
//                             },
//                             onDelete: (parentIndex, childIndex) {
//                               setState(() {
//                                 expenses[parentIndex]['data']
//                                     .removeAt(childIndex);
//                                 if (expenses[parentIndex]['data'].isEmpty) {
//                                   expenses.removeAt(parentIndex);
//                                 }
//                               });
//                             },
//                           )
//                               : widget.type == 'Non Conveyance'
//                               ? ExpenseNonConveyanceCard(
//                             entryValue: entryValue,
//                             parentIndex: index,
//                             childIndex: entryIndex,
//                             onEdit: (value, parentIndex, childIndex) {
//                               showAddNonConveyanceModal(
//                                 context,
//                                 editingEntry: value,
//                                 parentIndex: parentIndex,
//                                 childIndex: childIndex,
//                               );
//                             },
//                             onDelete: (parentIndex, childIndex) {
//                               setState(() {
//                                 expenses[parentIndex]['data']
//                                     .removeAt(childIndex);
//                                 if (expenses[parentIndex]['data']
//                                     .isEmpty) {
//                                   expenses.removeAt(parentIndex);
//                                 }
//                               });
//                             },
//                           )
//                               : ExpenseLocalConveyanceCard(
//                             entryValue: entryValue,
//                             parentIndex: index,
//                             childIndex: entryIndex,
//                             onEdit: (value, parentIndex, childIndex) {
//                               showAddLocalConveyanceModal(
//                                 context,
//                                 editingEntry: value,
//                                 parentIndex: parentIndex,
//                                 childIndex: childIndex,
//                               );
//                             },
//                             onDelete: (parentIndex, childIndex) {
//                               setState(() {
//                                 expenses[parentIndex]['data']
//                                     .removeAt(childIndex);
//                                 if (expenses[parentIndex]['data']
//                                     .isEmpty) {
//                                   expenses.removeAt(parentIndex);
//                                 }
//                               });
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 15),
//                 // ElevatedButton(
//                 //   style: ElevatedButton.styleFrom(
//                 //     backgroundColor: Colors.transparent,
//                 //     foregroundColor: Colors.black,
//                 //     shadowColor: Colors.transparent,
//                 //     padding: EdgeInsets.zero,
//                 //   ),
//                 //   onPressed: () => widget.type == 'Conveyance'
//                 //       ? showAddExpenseModal(context)
//                 //       : widget.type == 'Non Conveyance'
//                 //       ? showAddNonConveyanceModal(context)
//                 //       : showAddLocalConveyanceModal(context),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.center,
//                 //     children: [
//                 //       const Icon(Ionicons.add_sharp),
//                 //       const SizedBox(width: 5),
//                 //       Text(
//                 //         'Add ${widget.type} Entry',
//                 //         style: TextStyle(color: Colors.black, fontSize: 16),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: expenses.isNotEmpty
//             ? Obx(() {
//           final expense = expenses
//               .where(
//                 (v) => v["expense_date"] == _expenseDateController.text,
//           )
//               .toList();
//           final firstData = expense.isNotEmpty ? expense.first['data'][0] : {};
//           return Container(
//             decoration: BoxDecoration(
//               color: ColorPalette.pictonBlue600,
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () async {
//                 await _expenseController.createExpense(
//                   tourPlanId: widget.tourPlanId,
//                   visitId: widget.visitId,
//                   expensetype: firstData["type"] ?? '',
//                   date: DateFormat("yyyy-MM-dd").format(
//                     DateFormat("dd-MM-yyyy").parse(_expenseDateController.text),
//                   ),
//                   departureTown: firstData["departureTown"] ?? '',
//                   departureTime: firstData["departureTime"] != null
//                       ? DateFormat("yyyy-MM-dd HH:mm:ss").format(
//                       DateFormat("dd-MMM-yyyy hh:mm a")
//                           .parse(firstData["departureTime"]))
//                       : '',
//                   arrivalTown: firstData["arrivalTown"] ?? '',
//                   arrivalTime: firstData["arrivalTime"] != null
//                       ? DateFormat("yyyy-MM-dd HH:mm:ss").format(
//                       DateFormat("dd-MMM-yyyy hh:mm a")
//                           .parse(firstData["arrivalTime"]))
//                       : '',
//                   modeOfTravel: firstData["type"] == 'local_conveyance'
//                       ? (firstData["travelType"] ?? '')
//                       : (firstData["modeOfTravel"] ?? ''),
//                   amount: firstData["type"] == 'local_conveyance'
//                       ? double.tryParse(firstData["travelAmount"] ?? '0')
//                       : double.tryParse(firstData["amount"] ?? '0'),
//                   comment: firstData["remarks"] ?? '',
//                   images: firstData['images'] ?? [],
//                   location: firstData["tourLocation"] ?? '',
//                   type: firstData["expenseType"] ?? '',
//                   //daType: firstData["daType"] ?? '',
//
//                   // NEW FIELDS From UI 👇
//                   cityCategory: firstData["category"] ?? '',
//                   dayType: firstData["selectday"] ?? '',
//
//                   // cityCategory: selectedCategoryState ?? '',
//                   // dayType: selectedDayType ?? '',
//                 );
//                 print("Submit Expense $firstData");
//               },
//               child: _expenseController.isLoading.value
//                   ? SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   backgroundColor: Colors.transparent,
//                 ),
//               )
//                   : Text(
//                 'Submit',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           );
//         })
//             : null,
//         floatingActionButton: Padding(
//           padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
//           child: FloatingActionButton(
//             onPressed: () => widget.type == 'Conveyance'
//                 ? showAddExpenseModal(context)
//                 : widget.type == 'Non Conveyance'
//                 ? showAddNonConveyanceModal(context)
//                 : showAddLocalConveyanceModal(context),
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//             elevation: 4,
//             child: const Icon(Icons.add),
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//
//       ),
//     );
//   }
// }
