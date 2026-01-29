import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrachi/api/api_const.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/WharehouseModel.dart';
import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/tours/tours_list.dart';
import '../../../api/TourPlaneUpdateController.dart';
import '../../../models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
import '../../components/searchable_dropdown.dart';
import 'create_plan.dart';

class UpdatePlan extends StatefulWidget {
  final TourPlan tourPlan;

  const UpdatePlan({super.key, required this.tourPlan});

  @override
  State<UpdatePlan> createState() => _UpdatePlanState();
}

class _UpdatePlanState extends State<UpdatePlan> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _leadNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _currentBusinessController = TextEditingController();
  final TextEditingController _leadTypeOtherController = TextEditingController();
  final TextEditingController _leadSourceOtherController = TextEditingController();

  InputDecoration _textDecoration(String label) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.42),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 2),
          borderRadius: BorderRadius.circular(8)      ),
      hintText: label,
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      suffixIcon: Icon(Ionicons.chevron_down),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.42),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  final List<TextEditingController> _controllers = [];
  final ApiController controller = Get.put(ApiController());


  LeadTypeModel? selectedLeadType;
  LeadSourceModel? selectedLeadSource;
  WarehouseModel? selectedWarehouse;
  String? selectedModel;
  String? selectedVariant;
  String? HOselectedValue;
  String? startDateError;
  String? endDateError;
  Visit? followLeadVisit;
  LeadBusinessModel? selectedBusiness;
  bool isGstRegistered = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing visit dates
    for (int i = 0; i < widget.tourPlan.visits.length; i++) {
      final visit = widget.tourPlan.visits[i];
      _controllers.add(
        TextEditingController(text: DateFormat('dd-MM-yyyy',).format(DateTime.parse(visit.visitDate)),),
      );
    }
    _startDateController.text = DateFormat('dd-MM-y',).format(DateTime.parse(widget.tourPlan.startDate));
    _endDateController.text = DateFormat('dd-MM-y',).format(DateTime.parse(widget.tourPlan.endDate));
    // 🔹 Initialize lead/follow data safely after build (fix for setState during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (var visit in widget.tourPlan.visits) {
        if (visit.type == 'new_lead') {
          _leadNameController.text = visit.name;
          _phoneController.text = visit.lead?.primaryNo ?? '';
          _stateController.text = visit.lead?.state ?? '';
          _contactPersonController.text = visit.lead?.contactPerson ?? '';
          _addressController.text = visit.lead?.address ?? '';
          _cityController.text = visit.lead?.city ?? '';
          selectedBusiness = controller.leadbusiness.firstWhere(
                (b) => b.id.toString() == visit.lead?.currentBusiness,
            orElse: () => controller.leadbusiness.isNotEmpty ? controller.leadbusiness.first : LeadBusinessModel(id: 0, name: ''),
          );
          selectedLeadType = controller.leadTypes.firstWhere(
                (lt) => lt.name == visit.lead?.type,
            orElse: () => controller.leadTypes.isNotEmpty ? controller.leadTypes.first : LeadTypeModel(id: 0, name: ''),
          );
          selectedLeadSource = controller.leadSource.firstWhere(
                (ls) => ls.name == visit.lead?.leadSource,
            orElse: () => controller.leadSource.isNotEmpty ? controller.leadSource.first : LeadSourceModel(id: 0, name: ''),
          );
        }

        // if (visit.type == 'followup_lead') {
        //   followLeadVisit = controller.leads.firstWhere(
        //         (ld) => ld.name == visit.name,
        //     orElse: () => Visit(id: 0, tourPlanId: 0, type: '', name: '', visitDate: '', hasCheckin: false,
        //         isCheckin:false, createdAt: widget.tourPlan.createdAt, updatedAt: widget.tourPlan.updatedAt, isApproved: 1),
        //   );
        // }
      }

      setState(() {}); // safe update after build
    });
    print("Parameter ka data fetch ${widget.tourPlan}");
  }
  @override
  void dispose() {
    // 🔥 Date controllers clear
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();

    // 🔥 Other controllers
    _startDateController.dispose();
    _endDateController.dispose();
    _leadNameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _contactPersonController.dispose();
    _addressController.dispose();
    _cityController.dispose();

    // 🔥 Selected models reset
    selectedBusiness = null;
    selectedLeadType = null;
    selectedLeadSource = null;
    followLeadVisit = null;

    debugPrint("✅ UpdatePlan dispose ho gaya – state cleared");

    super.dispose();
  }

  List<Map<String, dynamic>> visits = [];
  Set<int> getSelectedDealerIds({int? excludeId}) {
    final Set<int> selectedIds = {};
    for (var visitDay in visits) {
      if (visitDay['data'] != null) {
        for (var visitData in visitDay['data']) {
          final int? currentDealerId = visitData['customer_id'];
          if (currentDealerId != null && currentDealerId != excludeId) {
            selectedIds.add(currentDealerId);
          }
        }
      }
    }
    return selectedIds;
  }
  Future<void> _pickDate(int index) async {
    final visit = widget.tourPlan.visits[index];

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(visit.visitDate),
      firstDate: DateTime.parse(widget.tourPlan.startDate),
      lastDate: DateTime.parse(widget.tourPlan.endDate),
    );

    if (pickedDate != null) {
      setState(() {
        _controllers[index].text = DateFormat('dd-MM-yyyy').format(pickedDate);
        visit.visitDate = pickedDate.toString();
      });
    }
  }
  void _showDeleteDialog(BuildContext context, controller, int visitId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Confirm Deletion",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete this visit?",
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Obx(() => TextButton(
              onPressed: controller.isDeleting.value
                  ? null
                  : () async {
                bool success = await controller.deleteVisit(visitId);
                if (success) {
                  Navigator.of(context).pop(); // close dialog

                  setState(() {
                    widget.tourPlan.visits.removeWhere((v) => v.id == visitId);
                  });
                }
                // if (success) {
                //   // ✅ Close the dialog
                //   Navigator.pop(context);
                //
                //   // ✅ Go back to previous screen and trigger refresh
                //   Navigator.pop(context, true);
                // }
              },
              child: controller.isDeleting.value
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
                  : const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TourPlanUpdateController visitDetailController = Get.put(TourPlanUpdateController());
    final List<Visit> pendingRejectedVisits = widget.tourPlan.visits.where((visit) {
      final status = visit.isApproved;

      return status == 2 || status == 0 || status == '2' || status == '0';
    }).toList();

    for (var v in widget.tourPlan.visits) {
      print("VISIT ${v.name} → isApproved = ${v.isApproved}");
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Tours()),
                    );
                  },
                  child: Icon(Icons.arrow_back, size: 26, color: Colors.black),
                ),
                SizedBox(width: 12),
                Text(
                  "Edit Tour Plan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        // appBar: AppBar(title: Text('Edit Tour Plan')),
        body: SingleChildScrollView(
          child: Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width:
                  Responsive.isMd(context)
                      ? screenWidth
                      : Responsive.isXl(context)
                      ? screenWidth * 0.60
                      : screenWidth * 0.40,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('TourPlan Id :', style: TextStyle(fontSize: 18)),
                          Text(
                            widget.tourPlan.serial_no.toString().padLeft(8, '0',),
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      ///Add the Start Date
                      TextField(
                        controller: _startDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.42),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.42),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          hintText: 'Start Date',
                          label: Text('Start Date'),
                          errorText: startDateError,
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () async {
                          DateTime tourPlanStartDate = DateTime.parse(
                            widget.tourPlan.startDate,
                          );

                          DateTime initialDate = tourPlanStartDate;
                          if (_startDateController.text.isNotEmpty) {
                            try {
                              initialDate = DateFormat('dd-MM-yyyy').parse(_startDateController.text);
                            } catch (e) {
                              initialDate = tourPlanStartDate;
                            }
                          }

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: tourPlanStartDate,
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            _startDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                          }
                        },
                      ),
                      SizedBox(height: 15.0),
                      ///Add the End Date
                      TextField(
                        controller: _endDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.42),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.42),
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          hintText: 'End Date',
                          label: Text('End Date'),
                          errorText: endDateError,
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        onTap: () async {
                          DateTime tourPlanStartDate = DateTime.parse(
                            widget.tourPlan.startDate,
                          );

                          DateTime initialDate = tourPlanStartDate;
                          if (_endDateController.text.isNotEmpty) {
                            try {
                              initialDate = DateFormat('dd-MM-yyyy').parse(_endDateController.text);
                            } catch (e) {
                              initialDate = tourPlanStartDate;
                            }
                          }

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: tourPlanStartDate,
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            _endDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: Responsive.isMd(context)
                      ? screenWidth
                      : Responsive.isXl(context)
                      ? screenWidth * 0.60
                      : screenWidth * 0.40,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    // ✅ FIX 1: correct itemCount
                    itemCount: pendingRejectedVisits.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      // ✅ FIX 2: correct visit source
                      final visit = pendingRejectedVisits[index];

                      // ✅ STATUS LOGIC
                      final bool isRejected = visit.isApproved == 2;
                      final String statusText = isRejected ? "Rejected" : "Pending";
                      final Color statusColor = isRejected ? Colors.red : Colors.orange;

                      return Card(
                        color: Colors.grey[300],
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.1),
                        margin: const EdgeInsets.symmetric(vertical: 1),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //Text("data${visit.isApproved}"),
                              Row(
                                children: [
                                  const Text(
                                    'TourPlaneId : ',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    widget.tourPlan.serial_no.toString().padLeft(8, '0'),
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),

                              Text(
                                "Name: ${visit.name}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Type: ${visit.type}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              if (visit.visitPurpose != null && visit.visitPurpose!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  "Purpose: ${visit.visitPurpose}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],

                              // ✅ FIX 3: STATUS TEXT
                              Text(
                                "Status: $statusText",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),

                              if (visit.type == 'new_lead') ...[
                                const SizedBox(height: 2),
                                Text(
                                  "Phone No.: ${_phoneController.text}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Lead Type: ${selectedLeadType?.name ?? 'N/A'}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Lead Source: ${selectedLeadSource?.name ?? 'N/A'}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "State: ${_stateController.text}",
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  if (visit.type != 'ho')
                                    TextButton.icon(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      label: const Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        _showEditModal(context, visit);
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
                                      _showDeleteDialog(context, visitDetailController, visit.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// es ke under tour ke base par sabhi visit show ho raha hai
                // SizedBox(
                //   width:
                //   Responsive.isMd(context)
                //       ? screenWidth
                //       : Responsive.isXl(context)
                //       ? screenWidth * 0.60
                //       : screenWidth * 0.40,
                //   child: ListView.separated(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemCount: pendingRejectedVisits.length,
                //     separatorBuilder: (_, __) => SizedBox(height: 15),
                //     itemBuilder: (context, index) {
                //       final visit = widget.tourPlan.visits[index];
                //       //final visit = rejectedVisits[index];
                //       return Card(
                //         color: Colors.grey[300],
                //         elevation: 6,
                //         shadowColor: Colors.black.withOpacity(0.1),
                //         margin: const EdgeInsets.symmetric(vertical: 1),
                //         child: Padding(
                //           padding: const EdgeInsets.all(10),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 children: [
                //                   Text('TourPlaneId :',style: const TextStyle(fontWeight: FontWeight.w500)),
                //                   Text(widget.tourPlan.serial_no.toString().padLeft(8, '0'), style: TextStyle(fontWeight: FontWeight.w500)),
                //                 ],
                //               ),
                //               Text("Name: ${visit.name}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //               Text("Type: ${visit.type}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //               //Text("Status: ${statusText}", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red,)),
                //               if (visit.visitPurpose != null && visit.visitPurpose!.isNotEmpty) ...{
                //                 SizedBox(height: 2),
                //                 Text("Purpose: ${visit.visitPurpose}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //               },
                //               if (visit.type == 'new_lead') ...[
                //                 SizedBox(height: 2),
                //                 Text("Phone No.: ${_phoneController.text}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //                 SizedBox(height: 5),
                //                 Text("Lead Type: ${selectedLeadType?.name ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //                 SizedBox(height: 5),
                //                 Text("Lead Source: ${selectedLeadSource?.name ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //                 SizedBox(height: 5),
                //                 Text("State: ${_stateController.text}", style: const TextStyle(fontWeight: FontWeight.w500)),
                //                 SizedBox(height: 5),
                //               ],
                //               SizedBox(height: 5.0),
                //               Row(
                //                 children: [
                //                   if (visit.type != 'ho')
                //                     TextButton.icon(
                //                       icon: const Icon(Icons.edit, color: Colors.blue),
                //                       label: const Text(
                //                         "Edit",
                //                         style: TextStyle(color: Colors.blue),
                //                       ),
                //                       onPressed: () {
                //                         _showEditModal(context, visit);
                //                       },
                //                     ),
                //                   const SizedBox(width: 10),
                //                   TextButton.icon(
                //                     icon: const Icon(Icons.delete, color: Colors.red),
                //                     label: const Text(
                //                       "Delete",
                //                       style: TextStyle(color: Colors.red),
                //                     ),
                //                     onPressed: () {
                //                       _showDeleteDialog(context, visitDetailController, visit.id);
                //                     },
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //     // separatorBuilder: (context, index) => SizedBox(height: 15),
                //     // itemCount: widget.tourPlan.visits.length,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("TourPlaneId oky :${widget.tourPlan.id.toString()}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatePlan(
                      tourid: widget.tourPlan.id.toString(),
                      startDate: _startDateController.text,
                      endDate: _endDateController.text,
                  ),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.pictonBlue500,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _updateTourPlan(context),
                child: Text("Update Plan"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _deleteTourPlan(context),
                child: Text("Delete Plan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showEditModal(BuildContext context, Visit visit) {
    // --- Local controllers and state ---
    final nameController = TextEditingController(text: visit.name);
    final purposeController = TextEditingController(text: visit.visitPurpose ?? '');

    // Controllers for 'new_lead'
    final phoneController = TextEditingController(text: _phoneController.text);
    final contactPersonController = TextEditingController(text: _contactPersonController.text);
    final stateController = TextEditingController(text: _stateController.text);
    final cityController = TextEditingController(text: _cityController.text);
    final addressController = TextEditingController(text: _addressController.text);

    LeadBusinessModel? modalSelectedBusiness = selectedBusiness;
    LeadTypeModel? modalSelectedLeadType = selectedLeadType;
    LeadSourceModel? modalSelectedLeadSource = selectedLeadSource;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (modalContext) {
        return FractionallySizedBox(
          heightFactor: 0.55,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              final selectedDealerIds = getSelectedDealerIds();
              // Available dealers excluding already used ones
              final availableDealers = controller.dealers
                  .where((dealer) => !selectedDealerIds.contains(dealer.id))
                  .toList();

              // currently selected dealer (if any)
              Dealer? currentDealer = controller.dealers.firstWhereOrNull(
                    (dealer) => dealer.id == dealer.id,
              );

              return Padding(
                padding: EdgeInsets.only(
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Header ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edit Visit Details",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.red, size: 26),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // --- CONDITION START ---
                      if (visit.type == 'dealer') ...[
                        // --- Dealer Section ---
                        if (currentDealer != null) ...[
                          Text(
                            "Current Dealer: ${currentDealer.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // --- Dealer Dropdown ---
                        SearchableDropdown<Dealer>(
                          items: availableDealers,
                          hintText: "Search Dealer",
                          selectedItem: currentDealer,
                          itemLabel: (item) =>
                          "${item.name} - ${item.state} - ${item.city}",
                          onChanged: (value) {
                            setModalState(() {
                              //visit.dealerId = value?.id;
                              visit.name = value.name ?? '';
                              currentDealer = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),

                        // --- Purpose of Visit ---
                        TextField(
                          controller: purposeController,
                          decoration: _textDecoration("Purpose of Visit"),
                        ),
                        const SizedBox(height: 20),
                      ] else if (visit.type == 'new_lead') ...[
                        // --- If 'new_lead', show all lead fields ---
                        TextField(
                          controller: nameController,
                          decoration: _textDecoration("Lead Name*"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: phoneController,
                          decoration: _textDecoration("Phone No*"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: contactPersonController,
                          decoration: _textDecoration("Contact Person"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: stateController,
                          decoration: _textDecoration("State"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: cityController,
                          decoration: _textDecoration("City/Village"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: addressController,
                          decoration: _textDecoration("Address"),
                        ),
                        const SizedBox(height: 15),

                        // --- Business Dropdown ---
                        Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownMenuTheme: const DropdownMenuThemeData(
                              menuStyle: MenuStyle(
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                          child: DropdownButtonFormField<LeadBusinessModel>(
                            decoration: _dropdownDecoration('Business').copyWith(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: modalSelectedBusiness,
                            items: controller.leadbusiness
                                .map(
                                  (leadB) => DropdownMenuItem(
                                value: leadB,
                                child: Text(
                                  leadB.name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) => setModalState(() => modalSelectedBusiness = value),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // --- Lead Type Dropdown ---
                        Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownMenuTheme: const DropdownMenuThemeData(
                              menuStyle: MenuStyle(
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                          child: DropdownButtonFormField<LeadTypeModel>(
                            decoration: _dropdownDecoration('Lead Type').copyWith(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: modalSelectedLeadType,
                            items: controller.leadTypes
                                .map(
                                  (lt) => DropdownMenuItem(
                                value: lt,
                                child: Text(
                                  lt.name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) =>
                                setModalState(() => modalSelectedLeadType = value),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // --- Lead Source Dropdown ---
                        Theme(
                          data: Theme.of(context).copyWith(
                            inputDecorationTheme: const InputDecorationTheme(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownMenuTheme: const DropdownMenuThemeData(
                              menuStyle: MenuStyle(
                                backgroundColor:
                                MaterialStatePropertyAll(Colors.white),
                              ),
                            ),
                          ),
                          child: DropdownButtonFormField<LeadSourceModel>(
                            decoration: _dropdownDecoration('Lead Source').copyWith(
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            value: modalSelectedLeadSource,
                            items: controller.leadSource
                                .map(
                                  (ls) => DropdownMenuItem(
                                value: ls,
                                child: Text(
                                  ls.name,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) =>
                                setModalState(() => modalSelectedLeadSource = value),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ] else ...[
                        // --- For other visit types ---
                        TextField(
                          controller: nameController,
                          decoration: _textDecoration("Visit Name*"),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: purposeController,
                          decoration: _textDecoration("Purpose of Visit"),
                        ),
                        const SizedBox(height: 20),
                      ],
                      // --- CONDITION END ---

                      // --- Update Button ---
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Update"),
                        onPressed: () {
                          setState(() {
                            // Always update visit.visitPurpose
                            visit.visitPurpose = purposeController.text;
                            if (visit.type == 'dealer') {
                              visit.name = visit.name; // updated from dropdown
                            } else if (visit.type == 'new_lead') {
                              _leadNameController.text = nameController.text;
                              _phoneController.text = phoneController.text;
                              _contactPersonController.text = contactPersonController.text;
                              _stateController.text = stateController.text;
                              _cityController.text = cityController.text;
                              _addressController.text = addressController.text;
                              selectedBusiness = modalSelectedBusiness;
                              selectedLeadType = modalSelectedLeadType;
                              selectedLeadSource = modalSelectedLeadSource;
                            } else {
                              visit.name = nameController.text;
                            }
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
  Future<void> _updateTourPlan(BuildContext context) async {
    final url = Uri.parse("$baseUrl$updatetourplans/${widget.tourPlan.id}");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      String apiStartDate = DateFormat("yyyy-MM-dd")
          .format(DateFormat("dd-MM-y").parse(_startDateController.text));
      String apiEndDate = DateFormat("yyyy-MM-dd")
          .format(DateFormat("dd-MM-y").parse(_endDateController.text));

      // ✅ Step 1: Group visits by visit_date
      Map<String, List<Map<String, dynamic>>> groupedVisits = {};

      for (var visit in widget.tourPlan.visits) {
        String formattedDate =
        DateFormat("yyyy-MM-dd").format(DateTime.parse(visit.visitDate));

        Map<String, dynamic> visitMap = {
          "id": visit.id,
          "type": visit.type,
          "name": visit.name,
          "visit_purpose": visit.visitPurpose,
          "lat": visit.lat ?? "",
          "lng": visit.lng ?? "",
        };

        if (visit.type == 'dealer') {
          visitMap["customer_id"] = visit.customerId;
        } else if (visit.type == 'new_lead' && visit.lead != null) {
          visitMap["lead"] = {
            "lead_type": visit.lead!.type,
            "primary_no": visit.lead!.primaryNo,
            "lead_source": visit.lead!.leadSource,
            "contact_person": visit.lead!.contactPerson,
            "state": visit.lead!.state,
            "city": visit.lead!.city,
            "address": visit.lead!.address,
            "current_busniess": visit.lead!.currentBusiness,
            "current_balance": visit.lead!.currentBalance,
            "varient_code": visit.lead!.varientCode,
            "item_model_code": visit.lead!.itemModelCode,
            "category_code": visit.lead!.categoryCode,
            "products": visit.lead!.products,
            "lead_status_id": visit.lead!.leadStatusId,
          };
        }

        groupedVisits.putIfAbsent(formattedDate, () => []);
        groupedVisits[formattedDate]!.add(visitMap);
      }

      // ✅ Step 2: Convert grouped data into required format
      final visitsData = groupedVisits.entries.map((entry) {
        return {
          "visit_date": entry.key,
          "data": entry.value,
        };
      }).toList();

      // ✅ Step 3: Create final body
      final body = {
        "start_date": apiStartDate,
        "end_date": apiEndDate,
        "visits": visitsData,
      };

      print("🚀 Sending Update Body: ${jsonEncode(body)}");

      // ✅ Step 4: Send API request
      final response = await http.put(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      print("👉 Update Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Tour plan updated successfully!",
            backgroundColor: Colors.green, colorText: Colors.white);
        Navigator.pop(context);
      } else {
        Get.snackbar("Error", "Failed to update: ${response.body}",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _deleteTourPlan(BuildContext context) async {
    final url = Uri.parse("$baseUrl$updatetourplans/${widget.tourPlan.id}");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final response = await http.delete(
          url,
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }
      );
      print("👉 Delete Response: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Tour plan deleted successfully!", backgroundColor: Colors.green, colorText: Colors.white);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Tours()));
        // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Tours()),
        );
      } else {
        Get.snackbar("Error", "Failed to delete: ${response.body}", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shrachi/api/api_const.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
// import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:shrachi/views/screens/tours/tours_list.dart';
// import '../../../api/TourPlaneUpdateController.dart';
// import '../../../models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
// import '../../components/searchable_dropdown.dart';
// import 'create_plan.dart';
//
// class UpdatePlan extends StatefulWidget {
//   final TourPlan tourPlan;
//
//   const UpdatePlan({super.key, required this.tourPlan});
//
//   @override
//   State<UpdatePlan> createState() => _UpdatePlanState();
// }
//
// class _UpdatePlanState extends State<UpdatePlan> {
//   // API & State Variables
//   bool _isLoading = true;
//   TourPlan? _fetchedTourPlan;
//
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _leadNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _contactPersonController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   final List<TextEditingController> _controllers = [];
//   final ApiController controller = Get.put(ApiController());
//   final TourPlanUpdateController visitDetailController = Get.put(TourPlanUpdateController());
//
//   LeadTypeModel? selectedLeadType;
//   LeadSourceModel? selectedLeadSource;
//   LeadBusinessModel? selectedBusiness;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchTourPlanFromServer();
//   }
//
//   // --- API Fetch Logic ---
//   Future<void> _fetchTourPlanFromServer() async {
//     setState(() => _isLoading = true);
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token') ?? '';
//
//     // Note: base_url + end_point + /ID
//     final url = Uri.parse("$baseUrl$fetchtourplans/${widget.tourPlan.id}");
//
//     try {
//       final response = await http.get(url, headers: {
//         "Accept": "application/json",
//         "Authorization": "Bearer $token",
//       });
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         if (responseData.containsKey('tourPlans')) {
//           _fetchedTourPlan = TourPlan.fromJson(responseData['tourPlans']);
//           _initializeControllersWithData(_fetchedTourPlan!);
//         }
//       } else {
//         Get.snackbar("Error", "Failed to load data", backgroundColor: Colors.red, colorText: Colors.white);
//       }
//     } catch (e) {
//       debugPrint("Fetch Error: $e");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   void _initializeControllersWithData(TourPlan plan) {
//     _startDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.startDate));
//     _endDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(plan.endDate));
//
//     _controllers.clear();
//     for (var visit in plan.visits) {
//       _controllers.add(
//         TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.parse(visit.visitDate))),
//       );
//
//       if (visit.type == 'new_lead' && visit.leads != null && visit.leads!.isNotEmpty) {
//         var lead = visit.leads![0];
//         _leadNameController.text = visit.name;
//         _phoneController.text = lead.primaryNo ?? '';
//         _stateController.text = lead.state ?? '';
//         _contactPersonController.text = lead.contactPerson ?? '';
//         _addressController.text = lead.address ?? '';
//         _cityController.text = lead.city ?? '';
//
//         selectedBusiness = controller.leadbusiness.firstWhereOrNull((b) => b.id.toString() == lead.currentBusiness);
//         selectedLeadType = controller.leadTypes.firstWhereOrNull((lt) => lt.name == lead.type);
//         selectedLeadSource = controller.leadSource.firstWhereOrNull((ls) => ls.name == lead.leadSource);
//       }
//     }
//   }
//
//   // --- UI Decoration Helpers ---
//   InputDecoration _textDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 1.5), borderRadius: BorderRadius.circular(8)),
//       focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 2), borderRadius: BorderRadius.circular(8)),
//     );
//   }
//
//   InputDecoration _dropdownDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       suffixIcon: const Icon(Ionicons.chevron_down),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       filled: true,
//       fillColor: Colors.white,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.blue)));
//     }
//
//     final plan = _fetchedTourPlan!;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: _buildAppBar(context),
//         body: SingleChildScrollView(
//           child: Container(
//             width: screenWidth,
//             padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             child: Column(
//               children: [
//                 _buildHeaderSection(plan, screenWidth),
//                 const SizedBox(height: 12),
//                 _buildVisitsList(plan, screenWidth),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreatePlan(tourid: plan.id.toString(), startDate: _startDateController.text, endDate: _endDateController.text))),
//           backgroundColor: Colors.blue,
//           child: const Icon(Icons.add),
//         ),
//         bottomNavigationBar: _buildBottomNav(plan.id),
//       ),
//     );
//   }
//
//   // --- Sub Widgets ---
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(60),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         alignment: Alignment.centerLeft,
//         decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
//         child: Row(
//           children: [
//             GestureDetector(onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Tours())), child: const Icon(Icons.arrow_back, size: 26, color: Colors.black)),
//             const SizedBox(width: 12),
//             const Text("Edit Tour Plan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection(TourPlan plan, double screenWidth) {
//     return SizedBox(
//       width: Responsive.isMd(context) ? screenWidth : screenWidth * 0.60,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('TourPlan Id :', style: TextStyle(fontSize: 18)),
//               Text(plan.serial_no ?? 'N/A', style: const TextStyle(fontSize: 18)),
//             ],
//           ),
//           const SizedBox(height: 15),
//           TextField(controller: _startDateController, readOnly: true, decoration: _textDecoration("Start Date").copyWith(suffixIcon: const Icon(Icons.calendar_today))),
//           const SizedBox(height: 15),
//           TextField(controller: _endDateController, readOnly: true, decoration: _textDecoration("End Date").copyWith(suffixIcon: const Icon(Icons.calendar_today))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildVisitsList(TourPlan plan, double screenWidth) {
//     return SizedBox(
//       width: Responsive.isMd(context) ? screenWidth : screenWidth * 0.60,
//       child: ListView.separated(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: plan.visits.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 15),
//         itemBuilder: (context, index) {
//           final visit = plan.visits[index];
//           final bool isRejected = visit.isApproved == 2;
//           final String statusText = isRejected ? "Rejected" : (visit.isApproved == 1 ? "Approved" : "Pending");
//           final Color statusColor = isRejected ? Colors.red : (visit.isApproved == 1 ? Colors.green : Colors.orange);
//
//           return Card(
//             color: Colors.grey[300],
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Name: ${visit.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
//                   Text("Type: ${visit.type}"),
//                   if (visit.visitPurpose != null) Text("Purpose: ${visit.visitPurpose}"),
//                   Text("Status: $statusText", style: TextStyle(fontWeight: FontWeight.bold, color: statusColor)),
//                   Row(
//                     children: [
//                       if (visit.type != 'ho') TextButton.icon(icon: const Icon(Icons.edit, color: Colors.blue), label: const Text("Edit"), onPressed: () => _showEditModal(context, visit)),
//                       TextButton.icon(icon: const Icon(Icons.delete, color: Colors.red), label: const Text("Delete"), onPressed: () => _showDeleteDialog(context, visitDetailController, visit.id)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   // --- Edit Modal (The complex logic from original code) ---
//   void _showEditModal(BuildContext context, Visit visit) {
//     final nameController = TextEditingController(text: visit.name);
//     final purposeController = TextEditingController(text: visit.visitPurpose ?? '');
//
//     // Lead Fields
//     final phoneController = TextEditingController(text: _phoneController.text);
//     final contactController = TextEditingController(text: _contactPersonController.text);
//     final stateController = TextEditingController(text: _stateController.text);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) {
//           return Padding(
//             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text("Edit ${visit.type.toUpperCase()}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 15),
//                   if (visit.type == 'dealer') ...[
//                     SearchableDropdown<Dealer>(
//                       items: controller.dealers,
//                       hintText: "Search Dealer",
//                       itemLabel: (d) => "${d.name} - ${d.city}",
//                       onChanged: (val) {
//                         setModalState(() {
//                           visit.name = val?.name ?? '';
//                           visit.customerId = val?.id;
//                         });
//                       },
//                     ),
//                   ] else if (visit.type == 'new_lead') ...[
//                     TextField(controller: nameController, decoration: _textDecoration("Lead Name")),
//                     const SizedBox(height: 10),
//                     TextField(controller: phoneController, decoration: _textDecoration("Phone")),
//                     const SizedBox(height: 10),
//                     TextField(controller: stateController, decoration: _textDecoration("State")),
//                   ] else ...[
//                     TextField(controller: nameController, decoration: _textDecoration("Name")),
//                   ],
//                   const SizedBox(height: 10),
//                   TextField(controller: purposeController, decoration: _textDecoration("Purpose")),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         visit.name = nameController.text;
//                         visit.visitPurpose = purposeController.text;
//                       });
//                       Navigator.pop(context);
//                     },
//                     child: const Text("Update Visit"),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showDeleteDialog(BuildContext context, dynamic ctrl, int visitId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Visit?"),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//           TextButton(onPressed: () async {
//             bool success = await ctrl.deleteVisit(visitId);
//             if (success) {
//               setState(() => _fetchedTourPlan!.visits.removeWhere((v) => v.id == visitId));
//               Navigator.pop(context);
//             }
//           }, child: const Text("Delete", style: TextStyle(color: Colors.red))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomNav(int id) {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ElevatedButton(onPressed: () => _updateTourPlan(context), style: ElevatedButton.styleFrom(backgroundColor: ColorPalette.pictonBlue500), child: const Text("Update Plan", style: TextStyle(color: Colors.white))),
//           ElevatedButton(onPressed: () => _deleteTourPlan(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text("Delete Plan", style: TextStyle(color: Colors.white))),
//         ],
//       ),
//     );
//   }
//
//   // --- API Update/Delete Methods ---
//   Future<void> _updateTourPlan(BuildContext context) async {
//     final url = Uri.parse("$baseUrl$updatetourplans/${_fetchedTourPlan!.id}");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token') ?? '';
//
//     try {
//       String apiStart = DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(_startDateController.text));
//       String apiEnd = DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(_endDateController.text));
//
//       Map<String, List<Map<String, dynamic>>> grouped = {};
//       for (var v in _fetchedTourPlan!.visits) {
//         String d = DateFormat("yyyy-MM-dd").format(DateTime.parse(v.visitDate));
//         grouped.putIfAbsent(d, () => []);
//         grouped[d]!.add({"id": v.id, "type": v.type, "name": v.name, "visit_purpose": v.visitPurpose, "customer_id": v.customerId});
//       }
//
//       final body = {"start_date": apiStart, "end_date": apiEnd, "visits": grouped.entries.map((e) => {"visit_date": e.key, "data": e.value}).toList()};
//
//       final res = await http.put(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonEncode(body));
//       if (res.statusCode == 200) {
//         Get.snackbar("Success", "Updated");
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Update failed");
//     }
//   }
//
//   Future<void> _deleteTourPlan(BuildContext context) async {
//     final url = Uri.parse("$baseUrl$updatetourplans/${_fetchedTourPlan!.id}");
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token') ?? '';
//     try {
//       final res = await http.delete(url, headers: {"Authorization": "Bearer $token"});
//       if (res.statusCode == 200) {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Tours()));
//       }
//     } catch (e) {}
//   }
//
//   @override
//   void dispose() {
//     for (var c in _controllers) c.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
//   }
// }