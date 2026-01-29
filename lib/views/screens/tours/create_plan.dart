import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/api/tour_plan_controller.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/WharehouseModel.dart';
import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
import 'package:shrachi/views/components/horizontal_stepper.dart';
import 'package:shrachi/views/components/searchable_dropdown.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:get/get.dart';

import '../CustomErrorMessage/CustomeErrorMessage.dart';

class CreatePlan extends StatefulWidget {
  final String? tourid;
  final String? startDate;
  final String? endDate;
  const CreatePlan({this.tourid,this.startDate, this.endDate, super.key});

  @override
  State<CreatePlan> createState() => _CreatePlanState();
}

class _CreatePlanState extends State<CreatePlan> {
  final _noScreenshot = NoScreenshot.instance;
  final FocusNode _addressFocusNode = FocusNode();
  void disableScreenshot() async {
    await _noScreenshot.screenshotOff();
  }

  void enableScreenshot() async {
    await _noScreenshot.screenshotOn();
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      disableScreenshot();
    }
    // EXPLANATION: CODE ADDED
    // If the startDate and endDate are passed as parameters, set them to the text controllers.
    if (widget.startDate != null) {
      _startDateController.text = widget.startDate!;
    }
    if (widget.endDate != null) {
      _endDateController.text = widget.endDate!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      apiController.fetchDealers();
      apiController.fetchLeadTypes();
      apiController.fetchLeadSource();
      apiController.fetchBusinesses();
      apiController.fetchLeadsForSearch();
    });
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      enableScreenshot();
    }
    _addressFocusNode.dispose();
    super.dispose();
  }

  int _currentStep = 0;

  final ApiController apiController = Get.put(ApiController());
  final TourPlanController tourPlanController = Get.put(TourPlanController());

  // Text controllers
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _visitDateController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _leadNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // final TextEditingController _currentBusinessController TextEditingController();
  final TextEditingController _leadTypeOtherController = TextEditingController();
  final TextEditingController _leadSourceOtherController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _warehouseController = TextEditingController();
  final TextEditingController _transitController = TextEditingController();
  final TextEditingController _otherActivityController = TextEditingController();
  final TextEditingController _otherServiceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // select type

  final List<String> options = [
    'Dealer',
    'FollowUp Leads',
    'New lead',
    'Department',
    'Service',
    'Activity',
    'Others',
    'HO',
    'Warehouse/Branch',
    'Transit',
  ];

  bool isNextVisitSelected = false;
  String optionError = '';
  String? startDateError;
  String? endDateError;
  String? visitDateError;

  // Dropdown selected values
  String? selectedValue;
  int? dealerId;
  String? selectedDealer;
  LeadTypeModel? selectedLeadType;
  LeadSourceModel? selectedLeadSource;
  LeadBusinessModel? selectedBusiness;
  int? warehouseId;
  String? selectedWarehouse;
  String? selectedModel;
  String? selectedVariant;
  int? leadId;
  String? selectedLead;
  LeadStatus? leadStatus;
  String? selectedService;
  String? selectedActivity;
  String? selectedOthers;
  String? selectedLeadStatus;
  Visit? followLeadVisit;

  bool isGstRegistered = false;

  void _clearForm() {
    setState(() {
      dealerId = null;
      selectedDealer = null;
      warehouseId = null;
      selectedWarehouse = null;
      _departmentController.clear();
      _transitController.clear();
      _purposeController.clear();
      _leadNameController.clear();
      _phoneController.clear();
      _contactPersonController.clear();
      _stateController.clear();
      _cityController.clear();
      _addressController.clear();
      selectedBusiness = null;
      selectedLeadType = null;
      selectedLeadSource = null;
      isGstRegistered = false;
      followLeadVisit = null;
    });
  }

  // decoration
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
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.42),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: label,
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      // suffixIcon: Icon(Ionicons.chevron_down),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.42),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.42),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: Colors.white,
    );
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
  // void addVisitData({bool isNextVisit = false}) {
  //   setState(() {
  //     if (isNextVisit) {
  //       // 🧹 Clear all controllers and reset state for next visit
  //       _visitDateController.clear();
  //       selectedDealer = null;
  //       _departmentController.clear();
  //       _warehouseController.clear();
  //       _transitController.clear();
  //       _purposeController.clear();
  //       selectedActivity = null;
  //       selectedService = null;
  //       _otherServiceController.clear();
  //       _otherActivityController.clear();
  //       _currentStep = 1;
  //       selectedValue = null;
  //       isGstRegistered = false;
  //       _leadNameController.clear();
  //       return;
  //     }
  //
  //     String visitDate = _visitDateController.text.trim();
  //     if (visitDate.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select a visit date")),
  //       );
  //       return;
  //     }
  //
  //     int existingIndex = visits.indexWhere((v) => v["visit_date"] == visitDate);
  //     Map<String, dynamic> newEntry = {};
  //
  //     // 🧩 Build visit data based on type
  //     if (selectedValue == "Dealer") {
  //       newEntry = {
  //         "customer_id": dealerId,
  //         "name": selectedDealer,
  //         "type": "dealer",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "New lead") {
  //       newEntry = {
  //         "name": _leadNameController.text,
  //         "primary_no": _phoneController.text,
  //         "contact_person": _contactPersonController.text,
  //         "state": _stateController.text,
  //         "city": _cityController.text,
  //         "lead_type": selectedLeadType?.name,
  //         "lead_source": selectedLeadSource?.name,
  //         "address": _addressController.text,
  //         "current_business": selectedBusiness?.id,
  //         "type": "new_lead",
  //         "is_gst_registered": isGstRegistered,
  //       };
  //     } else if (selectedValue == "FollowUp Leads") {
  //       newEntry = {
  //         "visit_id": followLeadVisit?.id,
  //         "type": "followup_lead",
  //       };
  //     } else if (selectedValue == "Department") {
  //       newEntry = {
  //         "name": _departmentController.text,
  //         "type": "department",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "Service") {
  //       newEntry = {
  //         "name": selectedService,
  //         "customer_id": dealerId,
  //         "dealerName": selectedDealer,
  //         "type": "service",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "Activity") {
  //       newEntry = {
  //         "name": selectedActivity,
  //         "type": "activity",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "Others") {
  //       newEntry = {
  //         "name": selectedOthers,
  //         "customer_id": dealerId,
  //         "dealerName": selectedDealer,
  //         "type": "others",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "Warehouse/Branch") {
  //       newEntry = {
  //         "location_id": warehouseId,
  //         "name": selectedWarehouse,
  //         "type": "warehouse",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     } else if (selectedValue == "HO") {
  //       // 🏢 Head Office (handled separately)
  //       newEntry = {
  //         "name": "Kolkata (Head Office)",
  //         "type": "ho",
  //         "visit_purpose": _purposeController.text.isNotEmpty
  //             ? _purposeController.text
  //             : "Official Visit",
  //       };
  //
  //       visits.add({
  //         "visit_date": visitDate,
  //         "data": [newEntry],
  //       });
  //       return;
  //     } else if (selectedValue == "Transit") {
  //       newEntry = {
  //         "name": _transitController.text,
  //         "type": "transit",
  //         "visit_purpose": _purposeController.text,
  //       };
  //     }
  //
  //     // 🧠 Validation: prevent blank visit addition
  //     final hasName = (newEntry["name"]?.toString().trim().isNotEmpty ?? false);
  //     final hasPurpose = (newEntry["visit_purpose"]?.toString().trim().isNotEmpty ?? false);
  //
  //     if (!hasName && !hasPurpose) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please fill visit name or purpose before saving")),
  //       );
  //       return;
  //     }
  //
  //     // ✅ Add to visits list properly
  //     if (existingIndex == -1) {
  //       visits.add({
  //         "visit_date": visitDate,
  //         "data": [newEntry],
  //       });
  //     } else {
  //       visits[existingIndex]["data"].add(newEntry);
  //     }
  //   });
  // }\
  bool _sameStr(a, b) {
    return (a?.toString().trim() ?? "") == (b?.toString().trim() ?? "");
  }

  bool _isSameEntry(Map a, Map b) {
    if (!_sameStr(a["type"], b["type"])) return false;

    final name1 = a["name"]?.toString().trim() ?? "";
    final name2 = b["name"]?.toString().trim() ?? "";

    final p1 = (a["visit_purpose"]?.toString().trim().isEmpty ?? true)
        ? "Nil"
        : a["visit_purpose"].toString().trim();

    final p2 = (b["visit_purpose"]?.toString().trim().isEmpty ?? true)
        ? "Nil"
        : b["visit_purpose"].toString().trim();

    return name1 == name2 && p1 == p2;
  }

  void addVisitData({bool isNextVisit = false}) {
    setState(() {
      if (isNextVisit) {
        _visitDateController.clear();
        selectedDealer = null;
        _departmentController.clear();
        _warehouseController.clear();
        _transitController.clear();
        _purposeController.clear();
        selectedActivity = null;
        selectedService = null;
        _otherServiceController.clear();
        _otherActivityController.clear();
        _currentStep = 1;
        selectedValue = null;
        isGstRegistered = false;
        _leadNameController.clear();
        return;
      }

      String visitDate = _visitDateController.text.trim();
      if (visitDate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a visit date")),
        );
        return;
      }

      Map<String, dynamic> newEntry = {};
      String purposeText = _purposeController.text.trim();

      // 🔥 Same switch-case (untouched)
      switch (selectedValue) {
        case "Dealer":
          newEntry = {
            "customer_id": dealerId,
            "name": (selectedDealer ?? "").toString().trim(),
            "type": "dealer",
            "visit_purpose": purposeText,
          };
          break;
        case "New lead":
          newEntry = {
            "name": _leadNameController.text.trim(),
            "primary_no": _phoneController.text.trim(),
            "contact_person": _contactPersonController.text.trim(),
            "state": _stateController.text.trim(),
            "city": _cityController.text.trim(),
            "lead_type": selectedLeadType?.name,
            "lead_source": selectedLeadSource?.name,
            "address": _addressController.text.trim(),
            "current_business": selectedBusiness?.id,
            "type": "new_lead",
            "is_gst_registered": isGstRegistered,
          };
          break;
        case "FollowUp Leads":
          newEntry = {
            "visit_id": followLeadVisit?.id,
            "type": "followup_lead",
          };
          break;
        case "Department":
          newEntry = {
            "name": _departmentController.text.trim(),
            "type": "department",
            "visit_purpose": purposeText,
          };
          break;
        case "Service":
          newEntry = {
            "name": (selectedService ?? "").toString().trim(),
            "customer_id": dealerId,
            "dealerName": (selectedDealer ?? "").toString().trim(),
            "type": "service",
            "visit_purpose": purposeText,
          };
          break;
        case "Activity":
          newEntry = {
            "name": (selectedActivity ?? "").toString().trim(),
            "type": "activity",
            "visit_purpose": purposeText,
          };
          break;
        case "Others":
          newEntry = {
            "name": (selectedOthers ?? "").toString().trim(),
            "customer_id": dealerId,
            "dealerName": (selectedDealer ?? "").toString().trim(),
            "type": "others",
            "visit_purpose": purposeText,
          };
          break;
        case "Warehouse/Branch":
          newEntry = {
            "location_id": warehouseId,
            "name": (selectedWarehouse ?? "").toString().trim(),
            "type": "warehouse",
            "visit_purpose": purposeText,
          };
          break;
        case "HO":
          newEntry = {
            "name": "Kolkata (Head Office)",
            "type": "ho",
            "visit_purpose":
            purposeText.isNotEmpty ? purposeText : "Official Visit",
          };
          break;
        case "Transit":
          newEntry = {
            "name": _transitController.text.trim(),
            "type": "transit",
            "visit_purpose": purposeText,
          };
          break;

        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a visit type")),
          );
          return;
      }

      // Auto-default purpose
      // if ((newEntry["visit_purpose"] == null ||
      //     newEntry["visit_purpose"].toString().trim().isEmpty)) {
      //   newEntry["visit_purpose"] = "Nil;
      // }

      // Must have name or purpose
      if (["service", "activity", "others", "transit"]
          .contains(newEntry["type"])) {
        final n = (newEntry["name"] ?? "").toString().trim();
        final p = (newEntry["visit_purpose"] ?? "").toString().trim();

        if (n.isEmpty && p.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Name or Purpose required")),
          );
          return;
        }
      }

      bool requiresNameOrPurpose = newEntry["type"] != "followup_lead";
      if (requiresNameOrPurpose) {
        final n = (newEntry["name"] ?? "").toString().trim();
        final p = (newEntry["visit_purpose"] ?? "").toString().trim();
        if (n.isEmpty && p.isEmpty) return;
      }

      // Find row for same date
      int existingIndex =
      visits.indexWhere((v) => _sameStr(v["visit_date"], visitDate));

      // NEW FIX: Check duplicate BEFORE adding row
      if (existingIndex != -1) {
        List row = visits[existingIndex]["data"];
        if (row.any((e) => _isSameEntry(e, newEntry))) {
          return; // STOP DUPLICATE
        }
      }

      // If no row found → before making new row also check duplicates globally
      if (existingIndex == -1) {
        // SAFETY: check across whole list also
        for (var v in visits) {
          for (var e in (v["data"] ?? [])) {
            if (_isSameEntry(e, newEntry)) return;
          }
        }

        visits.add({
          "visit_date": visitDate,
          "data": [newEntry],
        });
        return;
      }

      // Otherwise add inside existing row
      visits[existingIndex]["data"].add(newEntry);
    });
  }

  // void addVisitData({bool isNextVisit = false}) {
  //   setState(() {
  //     if (isNextVisit) {
  //       _visitDateController.clear();
  //       selectedDealer = null;
  //       _departmentController.clear();
  //       _warehouseController.clear();
  //       _transitController.clear();
  //       _purposeController.clear();
  //       selectedActivity = null;
  //       selectedService = null;
  //       _otherServiceController.clear();
  //       _otherActivityController.clear();
  //       _currentStep = 1;
  //       selectedValue = null;
  //       isGstRegistered = false;
  //       _leadNameController.clear();
  //       return;
  //     }
  //
  //     // 1) Visit date required
  //     String visitDate = _visitDateController.text.trim();
  //     if (visitDate.isEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select a visit date")),
  //       );
  //       return;
  //     }
  //
  //     // 2) Build newEntry based on selectedValue (normalize values)
  //     Map<String, dynamic> newEntry = {};
  //
  //     String purposeText = _purposeController.text.trim();
  //     switch (selectedValue) {
  //       case "Dealer":
  //         newEntry = {
  //           "customer_id": dealerId,
  //           "name": (selectedDealer ?? "").toString().trim(),
  //           "type": "dealer",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "New lead":
  //         newEntry = {
  //           "name": _leadNameController.text.trim(),
  //           "primary_no": _phoneController.text.trim(),
  //           "contact_person": _contactPersonController.text.trim(),
  //           "state": _stateController.text.trim(),
  //           "city": _cityController.text.trim(),
  //           "lead_type": selectedLeadType?.name,
  //           "lead_source": selectedLeadSource?.name,
  //           "address": _addressController.text.trim(),
  //           "current_business": selectedBusiness?.id,
  //           "type": "new_lead",
  //           "is_gst_registered": isGstRegistered,
  //         };
  //         break;
  //
  //       case "FollowUp Leads":
  //         newEntry = {
  //           "visit_id": followLeadVisit?.id,
  //           "type": "followup_lead",
  //         };
  //         break;
  //
  //       case "Department":
  //         newEntry = {
  //           "name": _departmentController.text.trim(),
  //           "type": "department",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "Service":
  //         newEntry = {
  //           "name": (selectedService ?? "").toString().trim(),
  //           "customer_id": dealerId,
  //           "dealerName": (selectedDealer ?? "").toString().trim(),
  //           "type": "service",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "Activity":
  //         newEntry = {
  //           "name": (selectedActivity ?? "").toString().trim(),
  //           "type": "activity",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "Others":
  //         newEntry = {
  //           "name": (selectedOthers ?? "").toString().trim(),
  //           "customer_id": dealerId,
  //           "dealerName": (selectedDealer ?? "").toString().trim(),
  //           "type": "others",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "Warehouse/Branch":
  //         newEntry = {
  //           "location_id": warehouseId,
  //           "name": (selectedWarehouse ?? "").toString().trim(),
  //           "type": "warehouse",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       case "HO":
  //       // Use the same key "visit_date" to keep consistency
  //         newEntry = {
  //           "name": "Kolkata (Head Office)",
  //           "type": "ho",
  //           "visit_purpose": purposeText.isNotEmpty ? purposeText : "Official Visit",
  //         };
  //         break;
  //
  //       case "Transit":
  //         newEntry = {
  //           "name": _transitController.text.trim(),
  //           "type": "transit",
  //           "visit_purpose": purposeText,
  //         };
  //         break;
  //
  //       default:
  //       // if no type selected, reject
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text("Please select a visit type")),
  //         );
  //         return;
  //     }
  //     // 3) Basic validation for cases where name/purpose required
  //     // For followup_lead, we may not require name/purpose; skip validation for that type.
  //     final requiresNameOrPurpose = newEntry["type"] != "followup_lead";
  //     if (requiresNameOrPurpose) {
  //       final nameStr = (newEntry["name"]?.toString().trim() ?? "");
  //       final purposeStr = (newEntry["visit_purpose"]?.toString().trim() ?? "");
  //       if (nameStr.isEmpty && purposeStr.isEmpty) {
  //         return;
  //       }
  //     }
  //     // 4) Find existing index (visit_date row)
  //     int existingIndex = visits.indexWhere((v) => (v["visit_date"]?.toString() ?? "") == visitDate);
  //
  //     // Helper: value-based duplicate check
  //     bool isDuplicateInRow(List existingData, Map<String, dynamic> newMap) {
  //       return existingData.any((item) {
  //         if (item is Map) {
  //           final itemType = item["type"]?.toString();
  //           final newType = newMap["type"]?.toString();
  //           if (itemType != newType) return false;
  //
  //           // Compare by most relevant keys depending on type
  //           switch (newType) {
  //             case "dealer":
  //             case "service":
  //             case "others":
  //             case "activity":
  //             case "department":
  //             case "transit":
  //               return (item["name"]?.toString().trim() ?? "") == (newMap["name"]?.toString().trim() ?? "") &&
  //                   (item["customer_id"]?.toString() ?? "") == (newMap["customer_id"]?.toString() ?? "") &&
  //                   (item["visit_purpose"]?.toString().trim() ?? "") == (newMap["visit_purpose"]?.toString().trim() ?? "");
  //             case "warehouse":
  //               return (item["location_id"]?.toString() ?? "") == (newMap["location_id"]?.toString() ?? "");
  //             case "new_lead":
  //               return (item["name"]?.toString().trim() ?? "") == (newMap["name"]?.toString().trim() ?? "") &&
  //                   (item["primary_no"]?.toString() ?? "") == (newMap["primary_no"]?.toString() ?? "");
  //             case "followup_lead":
  //               return (item["visit_id"]?.toString() ?? "") == (newMap["visit_id"]?.toString() ?? "");
  //             case "ho":
  //               return item["type"] == "ho";
  //             default:
  //             // fallback: compare name + type + purpose
  //               return (item["name"]?.toString().trim() ?? "") == (newMap["name"]?.toString().trim() ?? "") &&
  //                   (item["visit_purpose"]?.toString().trim() ?? "") == (newMap["visit_purpose"]?.toString().trim() ?? "");
  //           }
  //         }
  //         return false;
  //       });
  //     }
  //
  //     // 5) Add or merge into visits
  //     if (existingIndex == -1) {
  //       visits.add({
  //         "visit_date": visitDate,
  //         "data": [newEntry],
  //       });
  //     } else {
  //       final dataList = visits[existingIndex]["data"] as List;
  //       final already = isDuplicateInRow(dataList, newEntry);
  //       if (!already) {
  //         dataList.add(newEntry);
  //       } // else duplicate -> ignore
  //     }
  //   });
  // }

  void editVisitData(String visitDate, int dataIndex, Map<String, dynamic> updatedEntry,){
    int existingIndex = visits.indexWhere((v) => v["visit_date"] == visitDate);
    if (existingIndex != -1 &&
        dataIndex >= 0 &&
        dataIndex < visits[existingIndex]["data"].length) {
      visits[existingIndex]["data"][dataIndex] = updatedEntry;
    }
  }

  void deleteVisitData(String visitDate, int dataIndex) {
    int existingIndex = visits.indexWhere((v) => v["visit_date"] == visitDate);
    if (existingIndex != -1 &&
        dataIndex >= 0 &&
        dataIndex < visits[existingIndex]["data"].length) {
      setState(() {
        visits[existingIndex]["data"].removeAt(dataIndex);

        if (visits[existingIndex]["data"].isEmpty) {
          visits.removeAt(existingIndex);
        }
      });
    }
  }

  Widget _buildDealerSection(int? dealerId, String dealerName, Function(int, String) onChanged, {List<Dealer>? items}) {
    return SearchableDropdown<Dealer>(
      items: items ?? apiController.dealers, // Usa la lista proporcionada o la predeterminada
      itemLabel: (item) => item.name,
      selectedItem:
      dealerId != null
          ? (items ?? apiController.dealers).firstWhere(
            (d) => d.id == dealerId,
        orElse: () => Dealer(id: dealerId, name: dealerName),
      )
          : null,
      onChanged: (value) {
        onChanged(value.id, value.name);
      },
    );
  }

  Widget _buildWarehouseSection(int? warehouseId, String warehouseName, Function(int, String) onChanged,) {
    return SearchableDropdown<WarehouseModel>(
      items: apiController.Warehouse,
      itemLabel: (item) => item.name,
      selectedItem:
      warehouseId != null
          ? WarehouseModel(id: warehouseId, name: warehouseName)
          : null,
      onChanged: (value) {
        onChanged(value.id, value.name);
      },
    );
  }

  // Department section (only name)
  Widget _buildDepartmentSection(String name, TextEditingController controller,) {
    controller.text = name;
    return TextField(
      controller: controller,
      decoration: _textDecoration('Department name'),
    );
  }

  // Transit section (only name)
  Widget _buildTransitSection(String name, TextEditingController controller) {
    controller.text = name;
    return TextField(
      controller: controller,
      decoration: _textDecoration('Transit name'),
    );
  }

  // EXPLICACIÓN: CÓDIGO MODIFICADO
  // También he modificado esta función para aceptar una lista opcional de `availableDealers`.
  // Esto asegura que la lógica de filtrado se aplique también aquí cuando se edita.
  Widget _buildServiceSection(
      String? selectedService,
      Function(String?) onServiceChanged,
      TextEditingController purposeController,
      int? dealerId,
      String? dealerName,
      Function(int?, String?) onDealerChanged, {
        List<Dealer>? availableDealers,
      }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedService,
              hint: const Text("Select Service"),
              decoration: _dropdownDecoration('Select Service'),
              dropdownColor: Colors.white,
              items:
              [
                'Service/Repair/Assembly',
                'Spare Parts Order Colletion',
              ].map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                  onServiceChanged(value);
                  if (value != 'Service/Repair/Assembly') {
                    purposeController.clear();
                  } else {
                    dealerId = null;
                    dealerName = null;
                    onDealerChanged(null, null);
                  }
                });
              },
            ),
            if (selectedService != null &&
                selectedService != 'Service/Repair/Assembly') ...[
              const SizedBox(height: 10),
              SearchableDropdown<Dealer>(
                items: availableDealers ?? apiController.dealers, // Usa la lista filtrada
                itemLabel: (item) => item.name,
                selectedItem:
                dealerId != null
                    ? (availableDealers ?? apiController.dealers).firstWhere(
                      (d) => d.id == dealerId,
                  orElse: () => Dealer(id: dealerId!, name: dealerName ?? ''),
                )
                    : null,
                onChanged: (value) {
                  setState(() {
                    dealerId = value.id;
                    dealerName = value.name;
                    onDealerChanged(dealerId, dealerName);
                  });
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildActivitySection(String? selectedActivity, Function(String?) onActivityChanged,) {
    return DropdownButtonFormField<String>(
      value: selectedActivity,
      hint: const Text("Select Activity"),
      decoration: _dropdownDecoration('Select Activity'),
      dropdownColor: Colors.white,
      items: ['Sales-Marketing', 'Service', 'Others'].map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: (value) {
        onActivityChanged(value);
      },
    );
  }

  // EXPLICACIÓN: CÓDIGO MODIFICADO
  // Al igual que las otras funciones, esta ahora acepta `availableDealers` para filtrar
  // la lista de concesionarios al editar una visita de tipo 'Others'.
  Widget _buildOthersSection(
      String? selectedOthers,
      Function(String?) onOthersChanged,
      TextEditingController purposeController,
      int? dealerId,
      String? dealerName,
      Function(int?, String?) onDealerChanged, {
        List<Dealer>? availableDealers,
      }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedOthers,
              hint: const Text("Select Others"),
              decoration: _dropdownDecoration('Select Others'),
              dropdownColor: Colors.white,
              items:
              // ['Vendor Visit', 'Dealer Visit', 'Others'].map((item) {
              ['Dealer Visit', 'Others'].map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOthers = value;
                  onOthersChanged(value);
                  if (value != 'Others') {
                    purposeController.clear();
                  } else {
                    dealerId = null;
                    dealerName = null;
                    onDealerChanged(null, null);
                  }
                });
              },
            ),
            if (selectedOthers != null && selectedOthers == 'Dealer Visit') ...[
              const SizedBox(height: 10),
              SearchableDropdown<Dealer>(
                items: availableDealers ?? apiController.dealers, // Usa la lista filtrada
                itemLabel: (item) => item.name,
                selectedItem: dealerId != null
                    ? (availableDealers ?? apiController.dealers).firstWhere(
                      (d) => d.id == dealerId,
                  orElse: () => Dealer(id: dealerId!, name: dealerName ?? ''),
                )
                    : null,
                onChanged: (value) {
                  setState(() {
                    dealerId = value.id;
                    dealerName = value.name;
                    onDealerChanged(dealerId, dealerName);
                  });
                },
              ),
            ],
          ],
        );
      },
    );
  }

  String getValue(String selectedValue) {
    switch (selectedValue) {
      case "Dealer":return "dealer";
      case "FollowUp Leads":return "followup_lead";
      case "New lead":return "new_lead";
      case "Department":return "department";
      case "HO":return "ho";
      case "Service":return "service";
      case "Activity":return "activity";
      case "Others":return "others";
      case "Transit":return "transit";
      case "Warehouse/Branch":return "warehouse";
      default:return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEntries = visits
        .where((visit) => visit['visit_date'] == _visitDateController.text)
        .expand((visit) {
      final List<dynamic> data = (visit['data'] ?? []) as List<dynamic>;

      final filtered =
      (selectedValue != null)
          ? data
          .where((d) => d['type'] == getValue(selectedValue!))
          .toList()
          : data;

      return filtered.asMap().entries;
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.grey,
          title: Text('Create Tour Plan'),
          centerTitle: !Responsive.isSm(context),
        ),
        body: HorizontalStepper(
          steps: [
            // Column(
            //   children: [
            //     //Start Date
            //     TextField(
            //       controller: _startDateController,
            //       readOnly: true,
            //       decoration: InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(
            //           vertical: 16,
            //           horizontal: 20,
            //         ),
            //         border: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.black.withOpacity(0.42),
            //             // Use withOpacity for clarity
            //             width: 1.5,
            //           ),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.black.withOpacity(0.42),
            //             width: 2,
            //           ),
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.red.withOpacity(0.6),
            //             width: 2,
            //           ),
            //         ),
            //         hintText: 'Select Date',
            //         // Changed hint text
            //         labelText: 'StartDate',
            //         // Added a label for better UX
            //         errorText: startDateError,
            //         suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
            //       ),
            //       onTap: () async {
            //         final ApiController apiController = Get.find<ApiController>(); // Use Get.find for existing controller
            //
            //         // Ensure tourPlanList is not empty before trying to access elements
            //         if (apiController.tourPlanList.isNotEmpty) {
            //           // Get the first tour plan from the list for setting date range
            //           // You might want to select a specific tour plan based on your logic
            //           final TourPlan selectedTourPlan = apiController.tourPlanList.first;
            //
            //           // Parse the startDate and endDate from the TourPlan model
            //           // Assuming startDate and endDate in TourPlan are in "yyyy-MM-dd" format
            //           DateTime initialDate = DateTime.now();
            //           DateTime firstPickableDate = DateTime.now(); // Default to today
            //           DateTime lastPickableDate = DateTime(2101,); // Default to a far future date
            //
            //           try {
            //             firstPickableDate = DateTime.parse(selectedTourPlan.endDate,);
            //             //lastPickableDate = DateTime.parse(selectedTourPlan.endDate);
            //
            //             // Step 2: Pehli chuni ja sakne wali date ko end date ke EK DIN BAAD set karein
            //             firstPickableDate = firstPickableDate.add(Duration(days: 1));
            //
            //             // Shuruaati date (initialDate) ko firstPickableDate par set karein
            //             initialDate = firstPickableDate;
            //             // Set initial date to current value in controller if valid, otherwise use firstPickableDate
            //             if (_startDateController.text.isNotEmpty) {
            //               try {
            //                 initialDate = DateFormat('dd-MM-yyyy',).parse(_startDateController.text);
            //               } catch (e) {
            //                 initialDate = firstPickableDate; // Fallback if controller text is not in expected format
            //               }
            //             } else {
            //               initialDate = firstPickableDate; // If controller is empty, start from the first pickable date
            //             }
            //
            //             // Ensure initialDate is within the firstPickableDate and lastPickableDate range
            //             if (initialDate.isBefore(firstPickableDate)) {
            //               initialDate = firstPickableDate;
            //             }
            //             if (initialDate.isAfter(lastPickableDate)) {
            //               initialDate = lastPickableDate;
            //             }
            //           } catch (e) {
            //             print("Error parsing tour plan dates: $e");
            //             // Fallback to default dates if parsing fails
            //           }
            //
            //           DateTime? pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: initialDate,
            //             firstDate: firstPickableDate,
            //             lastDate: lastPickableDate,
            //           );
            //
            //           if (pickedDate != null) {
            //             _startDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            //           }
            //         } else {
            //           // Handle case where tourPlanList is empty
            //           Get.snackbar(
            //             "Info",
            //             "No tour plans available to set date range.",
            //             backgroundColor: Colors.blueAccent,
            //             colorText: Colors.white,
            //           );
            //           // Optionally, allow selecting from a default range if no tour plans
            //           DateTime? pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: DateTime.now(),
            //             firstDate: DateTime.now(),
            //             lastDate: DateTime(2101),
            //           );
            //           if (pickedDate != null) {
            //             _startDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            //           }
            //         }
            //       },
            //     ),
            //     SizedBox(height: 30.0),
            //     //End Date
            //     TextField(
            //       controller: _endDateController,
            //       readOnly: true,
            //       decoration: InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(
            //           vertical: 16,
            //           horizontal: 20,
            //         ),
            //         border: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.black.withOpacity(0.42),
            //             width: 1.5,
            //           ),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.black.withOpacity(0.42),
            //             width: 2,
            //           ),
            //         ),
            //         errorBorder: OutlineInputBorder(
            //           borderSide: BorderSide(
            //             color: Colors.red.withOpacity(0.6),
            //             width: 2,
            //           ),
            //         ),
            //         hintText: 'End Date',
            //         errorText: endDateError,
            //         suffixIcon: Icon(
            //           Icons.calendar_today,
            //           color: Colors.black.withOpacity(0.6),
            //         ),
            //       ),
            //
            //       ///end now show date
            //       // onTap: () async {
            //       //   DateTime? pickedDate = await showDatePicker(
            //       //     context: context,
            //       //     initialDate: DateTime.now(),
            //       //     firstDate: DateTime.now(),
            //       //     lastDate: DateTime(2101),
            //       //   );
            //       //   if (pickedDate != null) {
            //       //     _endDateController.text =
            //       //        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            //       //   }
            //       // },
            //       onTap: () async {
            //         final ApiController apiController = Get.find<ApiController>(); // Use Get.find for existing controller
            //
            //         // Ensure tourPlanList is not empty before trying to access elements
            //         if (apiController.tourPlanList.isNotEmpty) {
            //           // Get the first tour plan from the list for setting date range
            //           // You might want to select a specific tour plan based on your logic
            //           final TourPlan selectedTourPlan = apiController.tourPlanList.first;
            //
            //           // Parse the startDate and endDate from the TourPlan model
            //           // Assuming startDate and endDate in TourPlan are in "yyyy-MM-dd" format
            //           DateTime initialDate = DateTime.now();
            //           DateTime tourEndDate = DateTime.now(); // Default to today
            //           DateTime lastPickableDate = DateTime(2101,); // Default to a far future date
            //
            //           try {
            //             tourEndDate = DateTime.parse(selectedTourPlan.endDate,);
            //             //lastPickableDate = DateTime.parse(selectedTourPlan.endDate);
            //
            //             //Step 2: Pehli chuni ja sakne wali date ko end date ke EK DIN BAAD set karein
            //             tourEndDate = tourEndDate.add(Duration(days: 1));
            //
            //             // Shuruaati date (initialDate) ko firstPickableDate par set karein
            //             initialDate = tourEndDate;
            //
            //             // Set initial date to current value in controller if valid, otherwise use firstPickableDate
            //             if (_endDateController.text.isNotEmpty) {
            //               try {
            //                 initialDate = DateFormat('dd-MM-yyyy',).parse(_endDateController.text);
            //               } catch (e) {
            //                 initialDate = tourEndDate; // Fallback if controller text is not in expected format
            //               }
            //             } else {
            //               initialDate = tourEndDate; // If controller is empty, start from the first pickable date
            //             }
            //
            //             // Ensure initialDate is within the firstPickableDate and lastPickableDate range
            //             if (initialDate.isBefore(tourEndDate)) {
            //               initialDate = tourEndDate;
            //             }
            //             if (initialDate.isAfter(lastPickableDate)) {
            //               initialDate = lastPickableDate;
            //             }
            //           } catch (e) {
            //             print("Error parsing tour plan dates: $e");
            //             // Fallback to default dates if parsing fails
            //           }
            //
            //           DateTime? pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: initialDate,
            //             firstDate: DateTime.now(),
            //             // firstDate: tourEndDate,
            //             lastDate: lastPickableDate,
            //           );
            //
            //           if (pickedDate != null) {
            //             _endDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            //           }
            //         } else {
            //           print("No tour plans available to set date range.");
            //           /// Handle case where tourPlanList is empty
            //           // Get.snackbar(
            //           //   "Info",
            //           //   "No tour plans available to set date range.",
            //           //   backgroundColor: Colors.blueAccent,
            //           //   colorText: Colors.white,
            //           // );
            //           // Optionally, allow selecting from a default range if no tour plans
            //           DateTime? pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: DateTime.now(),
            //             firstDate: DateTime.now(),
            //             lastDate: DateTime(2101),
            //           );
            //           if (pickedDate != null) {
            //             _endDateController.text =
            //             "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
            //           }
            //         }
            //       },
            //     ),
            //   ],
            // ),
            // Column(
            //   children: [
            //     //Start Date
            //     TextField(
            //         controller: _startDateController,
            //         // EXPLANATION: MODIFIED CODE
            //         // If a start date is passed as a parameter, the text field will be read-only.
            //         readOnly: widget.startDate != null,
            //         decoration: InputDecoration(
            //           contentPadding: EdgeInsets.symmetric(
            //             vertical: 16,
            //             horizontal: 20,
            //           ),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.black.withOpacity(0.42),
            //               // Use withOpacity for clarity
            //               width: 1.5,
            //             ),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.black.withOpacity(0.42),
            //               width: 2,
            //             ),
            //           ),
            //           errorBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.red.withOpacity(0.6),
            //               width: 2,
            //             ),
            //           ),
            //           hintText: 'Select Date',
            //           // Changed hint text
            //           labelText: 'Start Date',
            //           // Added a label for better UX
            //           errorText: startDateError,
            //           suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
            //         ),
            //         // onTap: () async {
            //         //   if (widget.startDate != null) return;
            //         //
            //         //   final ApiController apiController = Get.find<ApiController>();
            //         //
            //         //   if (apiController.tourPlanList.isEmpty) {
            //         //     Get.snackbar(
            //         //       "Info",
            //         //       "No tour plans available to set date range.",
            //         //       backgroundColor: Colors.blueAccent,
            //         //       colorText: Colors.white,
            //         //     );
            //         //     return;
            //         //   }
            //         //
            //         //   final TourPlan selectedTourPlan = apiController.tourPlanList.first;
            //         //
            //         //   DateTime firstPickableDate;
            //         //   DateTime lastPickableDate = DateTime(2101);
            //         //   DateTime initialDate;
            //         //
            //         //   try {
            //         //     // 🔹 End date + 1 day
            //         //     firstPickableDate =
            //         //         DateTime.parse(selectedTourPlan.endDate).add(const Duration(days: 1));
            //         //
            //         //     initialDate = firstPickableDate;
            //         //
            //         //     if (_startDateController.text.isNotEmpty) {
            //         //       DateTime parsed =
            //         //       DateFormat('dd-MM-yyyy').parse(_startDateController.text);
            //         //
            //         //       if (parsed.isBefore(firstPickableDate)) {
            //         //         initialDate = firstPickableDate;
            //         //       } else if (parsed.isAfter(lastPickableDate)) {
            //         //         initialDate = lastPickableDate;
            //         //       } else {
            //         //         initialDate = parsed;
            //         //       }
            //         //     }
            //         //   } catch (e) {
            //         //     firstPickableDate = DateTime.now();
            //         //     initialDate = firstPickableDate;
            //         //   }
            //         //
            //         //   DateTime? pickedDate = await showDatePicker(
            //         //     context: context,
            //         //     initialDate: initialDate,      // ✅ always valid
            //         //     firstDate: firstPickableDate,  // ✅ SAME reference
            //         //     lastDate: lastPickableDate,
            //         //   );
            //         //
            //         //   if (pickedDate != null) {
            //         //     _startDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
            //         //   }
            //         // },
            //         onTap: () async {
            //           if (widget.startDate != null) return;
            //
            //           final ApiController apiController = Get.find<ApiController>();
            //
            //           if (apiController.tourPlanList.isEmpty) {
            //             Get.snackbar("Info", "No tour plans available");
            //             return;
            //           }
            //
            //           final TourPlan selectedTourPlan = apiController.tourPlanList.first;
            //
            //           DateTime firstPickableDate;
            //           DateTime lastPickableDate = DateTime(2101);
            //           DateTime initialDate;
            //
            //           try {
            //             firstPickableDate =
            //                 DateTime.parse(selectedTourPlan.endDate).add(const Duration(days: 1));
            //
            //             if (_startDateController.text.isNotEmpty) {
            //               initialDate =
            //                   DateFormat('dd-MM-yyyy').parse(_startDateController.text);
            //             } else {
            //               initialDate = firstPickableDate;
            //             }
            //
            //             if (initialDate.isBefore(firstPickableDate)) {
            //               initialDate = firstPickableDate;
            //             }
            //           } catch (e) {
            //             firstPickableDate = DateTime.now();
            //             initialDate = firstPickableDate;
            //           }
            //
            //           final pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: initialDate,      // ✅ VALID
            //             firstDate: firstPickableDate,  // ✅ SAME BASE
            //             lastDate: lastPickableDate,
            //           );
            //
            //           if (pickedDate != null) {
            //             _startDateController.text =
            //                 DateFormat('dd-MM-yyyy').format(pickedDate);
            //           }
            //         }
            //     ),
            //     SizedBox(height: 30.0),
            //     //End Date
            //     TextField(
            //         controller: _endDateController,
            //         // EXPLANATION: MODIFIED CODE
            //         // If an end date is passed as a parameter, the text field will be read-only.
            //         readOnly: widget.endDate != null,
            //         decoration: InputDecoration(
            //           contentPadding: EdgeInsets.symmetric(
            //             vertical: 16,
            //             horizontal: 20,
            //           ),
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.black.withOpacity(0.42),
            //               width: 1.5,
            //             ),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.black.withOpacity(0.42),
            //               width: 2,
            //             ),
            //           ),
            //           errorBorder: OutlineInputBorder(
            //             borderSide: BorderSide(
            //               color: Colors.red.withOpacity(0.6),
            //               width: 2,
            //             ),
            //           ),
            //           hintText: 'End Date',
            //           errorText: endDateError,
            //           suffixIcon: Icon(
            //             Icons.calendar_today,
            //             color: Colors.black.withOpacity(0.6),
            //           ),
            //         ),
            //         onTap: () async {
            //           if (widget.endDate != null) return;
            //
            //           final ApiController apiController = Get.find<ApiController>();
            //
            //           if (apiController.tourPlanList.isEmpty) return;
            //
            //           final TourPlan selectedTourPlan = apiController.tourPlanList.first;
            //
            //           DateTime firstPickableDate;
            //           DateTime lastPickableDate = DateTime(2101);
            //           DateTime initialDate;
            //
            //           try {
            //             firstPickableDate =
            //                 DateTime.parse(selectedTourPlan.endDate).add(const Duration(days: 1));
            //
            //             if (_endDateController.text.isNotEmpty) {
            //               initialDate =
            //                   DateFormat('dd-MM-yyyy').parse(_endDateController.text);
            //             } else {
            //               initialDate = firstPickableDate;
            //             }
            //
            //             if (initialDate.isBefore(firstPickableDate)) {
            //               initialDate = firstPickableDate;
            //             }
            //           } catch (e) {
            //             firstPickableDate = DateTime.now();
            //             initialDate = firstPickableDate;
            //           }
            //
            //           final pickedDate = await showDatePicker(
            //             context: context,
            //             initialDate: initialDate,
            //             firstDate: firstPickableDate,
            //             lastDate: lastPickableDate,
            //           );
            //
            //           if (pickedDate != null) {
            //             _endDateController.text =
            //                 DateFormat('dd-MM-yyyy').format(pickedDate);
            //           }
            //         }
            //
            //     ),
            //   ],
            // ),
            Column(
              children: [
                //Start Date
                TextField(
                  controller: _startDateController,
                  // EXPLANATION: MODIFIED CODE
                  // If a start date is passed as a parameter, the text field will be read-only.
                  readOnly: widget.startDate != null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.42),
                        // Use withOpacity for clarity
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
                    hintText: 'Select Date',
                    // Changed hint text
                    labelText: 'Start Date',
                    // Added a label for better UX
                    errorText: startDateError,
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
                  ),
                  // onTap: () async {
                  //   if (widget.startDate != null) return;
                  //
                  //   final ApiController apiController = Get.find<ApiController>();
                  //
                  //   if (apiController.tourPlanList.isEmpty) {
                  //     Get.snackbar(
                  //       "Info",
                  //       "No tour plans available to set date range.",
                  //       backgroundColor: Colors.blueAccent,
                  //       colorText: Colors.white,
                  //     );
                  //     return;
                  //   }
                  //
                  //   final TourPlan selectedTourPlan = apiController.tourPlanList.first;
                  //
                  //   DateTime firstPickableDate;
                  //   DateTime lastPickableDate = DateTime(2101);
                  //   DateTime initialDate;
                  //
                  //   try {
                  //     // 🔹 End date + 1 day
                  //     firstPickableDate =
                  //         DateTime.parse(selectedTourPlan.endDate).add(const Duration(days: 1));
                  //
                  //     initialDate = firstPickableDate;
                  //
                  //     if (_startDateController.text.isNotEmpty) {
                  //       DateTime parsed =
                  //       DateFormat('dd-MM-yyyy').parse(_startDateController.text);
                  //
                  //       if (parsed.isBefore(firstPickableDate)) {
                  //         initialDate = firstPickableDate;
                  //       } else if (parsed.isAfter(lastPickableDate)) {
                  //         initialDate = lastPickableDate;
                  //       } else {
                  //         initialDate = parsed;
                  //       }
                  //     }
                  //   } catch (e) {
                  //     firstPickableDate = DateTime.now();
                  //     initialDate = firstPickableDate;
                  //   }
                  //
                  //   DateTime? pickedDate = await showDatePicker(
                  //     context: context,
                  //     initialDate: initialDate,      // ✅ always valid
                  //     firstDate: firstPickableDate,  // ✅ SAME reference
                  //     lastDate: lastPickableDate,
                  //   );
                  //
                  //   if (pickedDate != null) {
                  //     _startDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                  //   }
                  // },
                  onTap: () async {
                    // EXPLANATION: MODIFIED CODE
                    // If a start date is passed as a parameter, the onTap function will not be executed.
                    if (widget.startDate != null) return;
                    final ApiController apiController = Get.find<ApiController>(); // Use Get.find for existing controller

                    // Ensure tourPlanList is not empty before trying to access elements
                    if (apiController.tourPlanList.isNotEmpty) {
                      // Get the first tour plan from the list for setting date range
                      // You might want to select a specific tour plan based on your logic
                      final TourPlan selectedTourPlan = apiController.tourPlanList.first;

                      // Parse the startDate and endDate from the TourPlan model
                      // Assuming startDate and endDate in TourPlan are in "yyyy-MM-dd" format
                      DateTime initialDate = DateTime.now();
                      DateTime firstPickableDate = DateTime.now(); // Default to today
                      DateTime lastPickableDate = DateTime(2101,); // Default to a far future date

                      try {
                        firstPickableDate = DateTime.parse(selectedTourPlan.endDate,);
                        //lastPickableDate = DateTime.parse(selectedTourPlan.endDate);

                        // Step 2: Set the first pickable date to ONE DAY AFTER the end date
                        firstPickableDate = firstPickableDate.add(Duration(days: 1));

                        // Set the initial date (initialDate) to the firstPickableDate
                        initialDate = firstPickableDate;
                        // Set initial date to current value in controller if valid, otherwise use firstPickableDate
                        if (_startDateController.text.isNotEmpty) {
                          try {
                            initialDate = DateFormat('dd-MM-yyyy',).parse(_startDateController.text);
                          } catch (e) {
                            initialDate = firstPickableDate; // Fallback if controller text is not in expected format
                          }
                        } else {
                          initialDate = firstPickableDate; // If controller is empty, start from the first pickable date
                        }

                        // Ensure initialDate is within the firstPickableDate and lastPickableDate range
                        if (initialDate.isBefore(firstPickableDate)) {
                          initialDate = firstPickableDate;
                        }
                        if (initialDate.isAfter(lastPickableDate)) {
                          initialDate = lastPickableDate;
                        }
                      } catch (e) {
                        print("Error parsing tour plan dates: $e");
                        // Fallback to default dates if parsing fails
                      }
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        ///firstDate: firstPickableDate,
                        firstDate:DateTime.now(),
                        lastDate: lastPickableDate,
                      );
                      if (pickedDate != null) {
                        _startDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      }
                    } else {
                      // Handle case where tourPlanList is empty
                      Get.snackbar(
                        "Info",
                        "No tour plans available to set date range.",
                        backgroundColor: Colors.blueAccent,
                        colorText: Colors.white,
                      );
                      // Optionally, allow selecting from a default range if no tour plans
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _startDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      }
                    }
                  },
                ),
                SizedBox(height: 30.0),
                //End Date
                TextField(
                  controller: _endDateController,
                  // EXPLANATION: MODIFIED CODE
                  // If an end date is passed as a parameter, the text field will be read-only.
                  readOnly: widget.endDate != null,
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
                    errorText: endDateError,
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  onTap: () async {
                    // EXPLANATION: MODIFIED CODE
                    // If an end date is passed as a parameter, the onTap function will not be executed.
                    if (widget.endDate != null) return;
                    final ApiController apiController = Get.find<ApiController>(); // Use Get.find for existing controller

                    // Ensure tourPlanList is not empty before trying to access elements
                    if (apiController.tourPlanList.isNotEmpty) {
                      // Get the first tour plan from the list for setting date range
                      // You might want to select a specific tour plan based on your logic
                      final TourPlan selectedTourPlan = apiController.tourPlanList.first;

                      // Parse the startDate and endDate from the TourPlan model
                      // Assuming startDate and endDate in TourPlan are in "yyyy-MM-dd" format
                      DateTime initialDate = DateTime.now();
                      DateTime tourEndDate = DateTime.now(); // Default to today
                      DateTime lastPickableDate = DateTime(2101,); // Default to a far future date

                      try {
                        tourEndDate = DateTime.parse(selectedTourPlan.endDate,);
                        //lastPickableDate = DateTime.parse(selectedTourPlan.endDate);

                        //Step 2: Set the first pickable date to ONE DAY AFTER the end date
                        tourEndDate = tourEndDate.add(Duration(days: 1));

                        // Set the initial date (initialDate) to the firstPickableDate
                        initialDate = tourEndDate;

                        // Set initial date to current value in controller if valid, otherwise use firstPickableDate
                        if (_endDateController.text.isNotEmpty) {
                          try {
                            initialDate = DateFormat('dd-MM-yyyy',).parse(_endDateController.text);
                          } catch (e) {
                            initialDate = tourEndDate; // Fallback if controller text is not in expected format
                          }
                        } else {
                          initialDate = tourEndDate; // If controller is empty, start from the first pickable date
                        }

                        // Ensure initialDate is within the firstPickableDate and lastPickableDate range
                        if (initialDate.isBefore(tourEndDate)) {
                          initialDate = tourEndDate;
                        }
                        if (initialDate.isAfter(lastPickableDate)) {
                          initialDate = lastPickableDate;
                        }
                      } catch (e) {
                        print("Error parsing tour plan dates: $e");
                        // Fallback to default dates if parsing fails
                      }

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        //firstDate: tourEndDate,
                        firstDate:DateTime.now(),
                        lastDate: lastPickableDate,
                      );

                      if (pickedDate != null) {
                        _endDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      }
                    } else {
                      print("No tour plans available to set date range.");
                      // Handle case where tourPlanList is empty
                      // Get.snackbar(
                      //   "Info",
                      //   "No tour plans available to set date range.",
                      //   backgroundColor: Colors.blueAccent,
                      //   colorText: Colors.white,
                      // );
                      // Optionally, allow selecting from a default range if no tour plans
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        _endDateController.text =
                        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                      }
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text("Tour Plan Visit With Repeater",style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                //s SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Start Date :",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[400],
                          ),
                        ),
                        Text(
                          " ${_startDateController.text}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "End Date :",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[400],
                          ),
                        ),
                        Text(
                          " ${_endDateController.text}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 10),
                Column(
                  children: options.map((option) {
                    return RadioListTile<String>(
                      title: Text(
                        option,
                        style: TextStyle(color: Colors.black),
                      ),
                      activeColor: Colors.black,
                      fillColor: MaterialStateProperty.all(Colors.black),
                      value: option,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      groupValue: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    );
                  }).toList(),
                ),
                if (optionError.isNotEmpty) SizedBox(height: 15),
                if (optionError.isNotEmpty)
                  Text(optionError, style: TextStyle(color: Colors.red)),
              ],
            ),
            Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Start Date :",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[400],
                              ),
                            ),
                            Text(
                              " ${_startDateController.text}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "End Date :",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[400],
                              ),
                            ),
                            Text(
                              " ${_endDateController.text}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if(selectedValue !="HO")
                      TextField(
                        controller: _visitDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
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
                          hintText: 'Visit Date',
                          errorText: visitDateError,
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                            _visitDateController.text.isNotEmpty
                                ? DateFormat(
                              'dd-MM-yyyy',
                            ).parse(_visitDateController.text)
                                : DateFormat(
                              'dd-MM-yyyy',
                            ).parse(_startDateController.text),

                            firstDate:
                            _startDateController.text.isNotEmpty
                                ? DateFormat(
                              'dd-MM-yyyy',
                            ).parse(_startDateController.text)
                                : DateTime(2000),

                            lastDate:
                            _endDateController.text.isNotEmpty
                                ? DateFormat(
                              'dd-MM-yyyy',
                            ).parse(_endDateController.text)
                                : DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _visitDateController.text =
                              "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
                            });
                          }
                        },
                      ),
                    const SizedBox(height: 15.0),
                    if (visits.isNotEmpty) visitsList(filteredEntries),

                    SizedBox(height: 15.0),
                    if(selectedValue != 'HO')
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: ColorPalette.seaGreen600,
                            overlayColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // minimumSize: const Size(0, 40), // ensures consistent height
                          ),
                          onPressed: () {
                            if (_visitDateController.text.isEmpty) {
                              setState(() {
                                visitDateError = 'Please select visit date';
                              });
                            } else {
                              visitDateError = null;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (
                                        BuildContext context,
                                        StateSetter setState,
                                        ) {
                                      // EXPLICACIÓN: CÓDIGO AÑADIDO Y MODIFICADO
                                      // 1. Obtenemos la lista de IDs de concesionarios ya seleccionados.
                                      final selectedDealerIds = getSelectedDealerIds();
                                      // 2. Filtramos la lista principal de concesionarios para obtener solo los disponibles.
                                      final availableDealers = apiController.dealers
                                          .where((dealer) => !selectedDealerIds.contains(dealer.id))
                                          .toList();

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom:
                                          MediaQuery.of(
                                            context,
                                          ).viewInsets.bottom,
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
                                                    const Text(
                                                      "Add Visit",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(Icons.close, color: Colors.red, size: 26),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                // Dealer Dropdown
                                                if (selectedValue == 'Dealer')
                                                  SearchableDropdown<Dealer>(
                                                    // 3. Usamos la lista filtrada `availableDealers` en lugar de la lista completa.
                                                    items: availableDealers,
                                                    hintText: "Search Dealer",
                                                    itemLabel: (item) => "${item.name} - ${item.state} - ${item.city}",
                                                    onChanged: (value) {
                                                      setState(() {
                                                        dealerId = value.id;
                                                        selectedDealer = value.name;
                                                      });
                                                    },
                                                  ),
                                                if (selectedValue == 'Department')
                                                  TextField(
                                                    controller: _departmentController,
                                                    decoration: _textDecoration(
                                                      'Department name',
                                                    ),
                                                  ),

                                                if (selectedValue == 'Warehouse/Branch')
                                                  SearchableDropdown<WarehouseModel>(
                                                    items: apiController.Warehouse,
                                                    hintText: "Search Warehouse/Branch",
                                                    itemLabel: (item) => item.name,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        warehouseId = value.id;
                                                        selectedWarehouse =
                                                            value.name;
                                                      });
                                                    },
                                                  ),

                                                if (selectedValue == 'Transit')
                                                  TextField(
                                                    controller: _transitController,
                                                    decoration: _textDecoration(
                                                      'Transit name',
                                                    ),
                                                  ),

                                                if (selectedValue == 'Service') ...[
                                                  DropdownButtonFormField<String>(
                                                    value: selectedService,
                                                    hint: Text("Select Service"),
                                                    decoration: _dropdownDecoration('Select Service',),
                                                    dropdownColor: Colors.white,
                                                    items:
                                                    [
                                                      'Service/Repair/Assembly',
                                                      'Spare Parts Order Colletion',
                                                    ].map((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedService = value!;
                                                        if (selectedService != 'Service/Repair/Assembly') {
                                                          _purposeController.clear();
                                                        } else {
                                                          dealerId = null;
                                                          selectedDealer = null;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  if (selectedService != null && selectedService != 'Service/Repair/Assembly') ...[
                                                    const SizedBox(height: 10),
                                                    SearchableDropdown<Dealer>(
                                                      // 4. También usamos la lista filtrada aquí.
                                                      items: availableDealers,
                                                      hintText: "Search Service/Repair/Assembly",
                                                      itemLabel: (item) => item.name,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dealerId = value.id;
                                                          selectedDealer =
                                                              value.name;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ],

                                                if (selectedValue == 'Activity') ...[
                                                  const SizedBox(height: 10),
                                                  DropdownButtonFormField<String>(
                                                    value: selectedActivity,
                                                    hint: Text("Select Activity"),
                                                    decoration: _dropdownDecoration('Select Activity',),
                                                    dropdownColor: Colors.white,
                                                    items:
                                                    [
                                                      'Sales-Marketing',
                                                      'Service',
                                                      'Others',
                                                    ].map((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedActivity = value!;
                                                      });
                                                    },
                                                  ),
                                                ],
                                                if (selectedValue == 'Others') ...[
                                                  const SizedBox(height: 10),
                                                  DropdownButtonFormField<String>(
                                                    value: selectedOthers,
                                                    hint: Text("Select Others"),
                                                    decoration: _dropdownDecoration(
                                                      'Select Others',
                                                    ),
                                                    dropdownColor: Colors.white,
                                                    items: [
                                                      // 'Vendor Visit',
                                                      'Dealer Visit',
                                                      'Others',
                                                    ].map((item) {
                                                      return DropdownMenuItem<String>(
                                                        value: item,
                                                        child: Text(item),
                                                      );
                                                    }).toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedOthers = value!;
                                                      });
                                                    },
                                                  ),
                                                  if (selectedOthers != null && selectedOthers == 'Dealer Visit') ...[
                                                    const SizedBox(height: 10),
                                                    SearchableDropdown<Dealer>(
                                                      hintText: "Dealer Name",
                                                      // 5. Y finalmente, también usamos la lista filtrada aquí.
                                                      items: availableDealers,
                                                      itemLabel: (item) => item.name,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          dealerId = value.id;
                                                          selectedDealer = value.name;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ],
                                                if (selectedValue == 'Service' && selectedService != null && selectedService == 'Service/Repair/Assembly') ...{
                                                  const SizedBox(height: 15),
                                                  TextField(
                                                    controller: _purposeController,
                                                    decoration: _textDecoration('Purpose of Visit',),
                                                    maxLines: 3,
                                                    textAlignVertical: TextAlignVertical.top,
                                                  ),
                                                },

                                                if (selectedValue == 'Others' &&
                                                    selectedOthers != null &&
                                                    selectedOthers == 'Others') ...{
                                                  const SizedBox(height: 15),
                                                  TextField(
                                                    controller: _purposeController,
                                                    decoration: _textDecoration('Purpose of Visit',),
                                                    maxLines: 3,
                                                    textAlignVertical: TextAlignVertical.top,
                                                  ),
                                                },

                                                if (selectedValue != 'Service' &&
                                                    selectedValue != 'Others' &&
                                                    selectedValue != 'New lead' &&
                                                    selectedValue != 'FollowUp Leads') ...{
                                                  const SizedBox(height: 15),
                                                  TextField(
                                                    controller: _purposeController,
                                                    decoration: _textDecoration('Purpose of Visit',),
                                                    maxLines: 3,
                                                    textAlignVertical: TextAlignVertical.top,
                                                  ),
                                                },
                                                SizedBox(height: 15),
                                                // Save Button
                                                if (selectedValue == 'New lead')
                                                  newLead(context, setState),
                                                if (selectedValue == 'FollowUp Leads')followLeads(context),
                                                //SizedBox(height: 15),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        addVisitData();
                                                      });
                                                      _clearForm();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      Colors.black,
                                                      foregroundColor:
                                                      Colors.white,
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 20,
                                                      ),
                                                    ),
                                                    child: const Text("Save"),
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
                          },
                          child: Row(
                            children: const [
                              Icon(Ionicons.add_sharp),
                              SizedBox(width: 4),
                              Text('Add'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                if (selectedValue == 'HO') ...[
                  headOffice(context),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      shadowColor: Colors.black.withOpacity(0.4),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        child: Text('Kolkata (Head Office)'),
                      ),
                    ),
                  ),
                ],
                // ============ Follow Leads =======================
                // if (selectedValue == 'FollowUp Leads')
                // ===================== NEW LEAD =====================
                // if (selectedValue == 'New lead')
              ],
            ),
          ],
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              if (_currentStep < 2) {
                if ((selectedValue == null || selectedValue!.isEmpty) && _currentStep == 1) {
                  optionError = 'Please select an option';
                  return;
                } else if (_startDateController.text.isEmpty ||
                    _endDateController.text.isEmpty) {
                  if (_startDateController.text.isEmpty) {
                    startDateError = 'Please select start date';
                  }

                  if (_endDateController.text.isEmpty) {
                    endDateError = 'Please select end date';
                  }
                } else {
                  startDateError = null;
                  endDateError = null;
                  optionError = '';
                  _currentStep++;
                }
                optionError = '';
              } else {
                // 7439000924 if (selectedValue != 'FollowUp Leads' &&
                //     selectedValue != 'New lead') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  useSafeArea: true,
                  builder: (BuildContext context) {
                    int? selectedButton;
                    return FractionallySizedBox(
                      //heightFactor: 30,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: MediaQuery.of(context).padding.bottom + 30, // <<< FIX
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Select An Option",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red, size: 26),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                                //const SizedBox(height: 20),
                                Column(
                                  children: [
                                    RadioListTile<int>(
                                      activeColor: Colors.black,
                                      value: 0,
                                      groupValue: selectedButton,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedButton = value!;
                                        });
                                      },
                                      title: const Text(
                                        "Add Visit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    RadioListTile<int>(
                                      value: 1,
                                      groupValue: selectedButton,
                                      activeColor: Colors.black,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedButton = value!;
                                        });
                                      },
                                      title: const Text(
                                        "Confirm Visit",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                ///ye code finash ke time ka hai desing hai
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: GestureDetector(
                                //         onTap: () {
                                //           setState(() {
                                //             selectedButton = 0;
                                //           });
                                //         },
                                //         child: Container(
                                //           height: 140,
                                //           decoration: BoxDecoration(
                                //             // color: Colors.grey.withOpacity(
                                //             //   alpha: 0.1,
                                //             // ),
                                //             color: Colors.grey,
                                //             border: Border.all(
                                //               color:
                                //                   selectedButton == 0
                                //                       ? Colors.black
                                //                       : Colors.transparent,
                                //               width: 2,
                                //             ),
                                //             borderRadius: BorderRadius.circular(
                                //               8,
                                //             ),
                                //           ),
                                //           child: Column(
                                //             mainAxisAlignment: MainAxisAlignment.center,
                                //             children: const [
                                //               Icon(
                                //                 Ionicons.calendar_outline,
                                //                 size: 28,
                                //                 color: Colors.black,
                                //               ),
                                //               SizedBox(height: 8),
                                //               Text(
                                //                 "Add Visit",
                                //                 style: TextStyle(fontSize: 14),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //     const SizedBox(width: 10),
                                //     Obx(() {
                                //       return Expanded(
                                //         child: GestureDetector(
                                //           onTap: () {
                                //             setState(() {
                                //               selectedButton = 1;
                                //             });
                                //           },
                                //           child: Container(
                                //             height: 140,
                                //             decoration: BoxDecoration(
                                //               // color: Colors.grey.withOpacity(
                                //               //   alpha: 0.1,
                                //               // ),
                                //               color: Colors.green,
                                //               border: Border.all(
                                //                 color: selectedButton == 1
                                //                         ? Colors.black
                                //                         : Colors.transparent,
                                //                 width: 2,
                                //               ),
                                //               borderRadius: BorderRadius.circular(
                                //                 8,
                                //               ),
                                //             ),
                                //             child: Column(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.center,
                                //               children: [
                                //                 const Icon(
                                //                   Ionicons.paper_plane_outline,
                                //                   size: 28,
                                //                   color: Colors.black,
                                //                 ),
                                //                 const SizedBox(height: 8),
                                //                 tourPlanController.isLoading.value
                                //                     ? CircularProgressIndicator(
                                //                       color: Colors.white,
                                //                     )
                                //                     : const Text(
                                //                       "End Plan",
                                //                       style: TextStyle(
                                //                         fontSize: 14,
                                //                       ),
                                //                     ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     }),
                                //   ],
                                // ),
                                //const SizedBox(height: 30),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (selectedButton == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Please select an option")),
                                        );
                                        return;
                                      }

                                      try {
                                        if (selectedButton == 0) {
                                          addVisitData(isNextVisit: true);
                                          Navigator.pop(context);
                                        } else {
                                          // ✅ Always add current visit before saving
                                          addVisitData();

                                          if (widget.tourid != null) {
                                            await tourPlanController.updateTourPlan(
                                              tourPlanId: widget.tourid!,
                                              startDate: _startDateController.text,
                                              endDate: _endDateController.text,
                                              visits: visits,
                                            );
                                          } else {
                                            await tourPlanController.addNewVisits(
                                              startDate: _startDateController.text,
                                              endDate: _endDateController.text,
                                              visits: visits,
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Error: $e")),
                                        );
                                      }
                                    },

                                    // onPressed: () async {
                                    //   if (selectedButton == null) {
                                    //     ScaffoldMessenger.of(context).showSnackBar(
                                    //       const SnackBar(content: Text("Please select an option")),
                                    //     );
                                    //     return;
                                    //   }
                                    //   try {
                                    //     if (selectedButton == 0) {
                                    //       // Existing behavior
                                    //       addVisitData(isNextVisit: true);
                                    //       Navigator.pop(context);
                                    //     } else {
                                    //       if (widget.tourid != null) {
                                    //         //Update existing tour plan
                                    //         await tourPlanController.updateTourPlan(
                                    //           //context: context,
                                    //           tourPlanId: widget.tourid!,
                                    //           startDate: _startDateController.text,
                                    //           endDate: _endDateController.text,
                                    //           visits: visits,
                                    //         );
                                    //         //Navigator.pop(context);
                                    //       } else {
                                    //         //Create new tour plan
                                    //         await tourPlanController.addNewVisits(
                                    //           startDate: _startDateController.text,
                                    //           endDate: _endDateController.text,
                                    //           visits: visits,
                                    //         );
                                    //         //Navigator.pop(context);
                                    //       }
                                    //     }
                                    //   } catch (e) {
                                    //     ScaffoldMessenger.of(context).showSnackBar(
                                    //       SnackBar(content: Text("Error: $e")),
                                    //     );
                                    //   }
                                    // },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      //padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                    ),
                                    child: Text((widget.tourid != null) ? "Update" : "Save"),
                                  ),
                                ),
                                // Align(
                                //   alignment: Alignment.bottomRight,
                                //   child: ElevatedButton(
                                //     onPressed: () async {
                                //       if (selectedButton == null) {
                                //         ScaffoldMessenger.of(
                                //           context,
                                //         ).showSnackBar(
                                //           const SnackBar(
                                //             content: Text(
                                //               "Please select an option",
                                //             ),
                                //           ),
                                //         );
                                //         return;
                                //       }
                                //       if (selectedButton == 0) {
                                //         addVisitData(isNextVisit: true);
                                //         Navigator.pop(context);
                                //         // print("visits : ${visits.toString()}");
                                //       } else {
                                //         // if (selectedValue == 'New lead' &&
                                //         //     selectedValue == 'FollowUp Leads') {
                                //         //   addVisitData();
                                //         // }
                                //         await tourPlanController.addNewVisits(
                                //           startDate: _startDateController.text,
                                //           endDate: _endDateController.text,
                                //           visits: visits,
                                //         );
                                //       }
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: Colors.black,
                                //       foregroundColor: Colors.white,
                                //       padding: const EdgeInsets.symmetric(
                                //         vertical: 15,
                                //         horizontal: 20,
                                //       ),
                                //     ),
                                //     child: const Text("Save"),
                                //   ),
                                // ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (_currentStep != 0) {
                visits = [];
                _clearForm();
                _visitDateController.clear();
                _currentStep--;
              }
            });
          },
        ),
      ),
    );
  }

  Widget visitsList(List<dynamic> filteredEntries) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 15.0),
      itemCount: filteredEntries.length,
      itemBuilder: (context, index) {
        final entry = filteredEntries[index];
        final entryIndex = entry.key;
        final entryValue = entry.value;
        final name = entryValue['name'] ?? '';
        final purpose = entryValue['visit_purpose'] ?? '';
        return Card(
          key: ValueKey(entry),
          color: Colors.grey[200],
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (name != '')
                      Text(
                        "Name: $name",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    SizedBox(height: 7),
                    if (entryValue['type'] == 'service') ...{
                      if (entryValue['dealerName'] != null) ...{
                        Text(
                          "Dealer Name: ${entryValue['dealerName']}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15),
                      },
                    },
                    if (entryValue['type'] == 'others') ...{
                      if (entryValue['dealerName'] != null) ...{
                        Text(
                          "Dealer Name: ${entryValue['dealerName']}",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15),
                      },
                    },
                    if (entryValue['type'] == 'new_lead') ...{
                      Text(
                        "Phone no: ${entryValue['primary_no']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15,),
                      Text(
                        "Contact Person: ${entryValue['contact_person']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "State: ${entryValue['state']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "City: ${entryValue['city']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Address: ${entryValue['address']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Lead Type: ${entryValue['lead_type']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Lead Source: ${entryValue['lead_source']}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    },
                    if (entryValue['type'] == 'followup_lead') ...{
                      Text(
                        "Previous Visit Date: ${
                            DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(
                                    apiController.leads.firstWhere((ld) => ld.id ==
                                        entryValue['visit_id']).visitDate
                                )
                            )
                        }",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Lead Name: ${apiController.leads.firstWhere((ld) => ld.id == entryValue['visit_id']).name}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    },
                    if (purpose != '') Text("Purpose: $purpose"),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(
                        Ionicons.pencil_sharp,
                        color: Colors.blue,
                      ),
                      label: const Text(
                        "Edit",
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        final departmentController = TextEditingController(
                          text: name,
                        );
                        final transitController = TextEditingController(
                          text: name,
                        );
                        final purposeController = TextEditingController(
                          text: purpose,
                        );

                        int? dealerId = entryValue['customer_id'];
                        String? dealerName = name;

                        int? warehouseId = entryValue['location_id'];
                        String warehouseName = name;

                        String? selectedService = name;
                        String? selectedActivity = name;
                        String? selectedOthers = name;

                        if (selectedValue == 'New lead') {
                          _leadNameController.text = name;
                          _phoneController.text = entryValue['primary_no'];
                          _contactPersonController.text = entryValue['contact_person'];
                          _stateController.text = entryValue['state'];
                          _cityController.text = entryValue['city'];
                          _addressController.text = entryValue['address'];
                          selectedBusiness = apiController.leadbusiness
                              .firstWhere(
                                (b) => b.id == entryValue['current_business'],
                          );
                          selectedLeadType = apiController.leadTypes.firstWhere(
                                (lt) => lt.name == entryValue['lead_type'],
                          );
                          selectedLeadSource = apiController.leadSource
                              .firstWhere(
                                (ls) => ls.name == entryValue['lead_source'],
                          );
                          isGstRegistered = entryValue['is_gst_registered'];
                        }

                        if (selectedValue == 'FollowUp Leads') {
                          followLeadVisit = apiController.leads.firstWhere(
                                (ld) => ld.id == entryValue['visit_id'],
                          );
                        }

                        print(entryValue['visit_id']);
                        print(followLeadVisit?.id);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder: (context, setModalState) {

                                // EXPLICACIÓN: CÓDIGO AÑADIDO Y MODIFICADO
                                // 1. Obtenemos el ID del concesionario actual que se está editando.
                                final int? currentEditingDealerId = entryValue['customer_id'];
                                // 2. Obtenemos los IDs de los otros concesionarios seleccionados, excluyendo el actual.
                                final selectedDealerIds = getSelectedDealerIds(excludeId: currentEditingDealerId);
                                // 3. Filtramos la lista de concesionarios para mostrar solo los disponibles Y el actual.
                                final availableDealers = apiController.dealers
                                    .where((dealer) => !selectedDealerIds.contains(dealer.id))
                                    .toList();


                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    top: 15,
                                    bottom:
                                    MediaQuery.of(
                                      context,
                                    ).viewInsets.bottom,
                                  ),
                                  child: Container(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Edit Visit",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close, color: Colors.red, size: 20,),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 20),
                                          if (selectedValue == 'Dealer')
                                            _buildDealerSection(
                                              dealerId,
                                              dealerName!,
                                                  (id, name) {
                                                setModalState(() {
                                                  dealerId = id;
                                                  dealerName = name;
                                                });
                                              },
                                              // 4. Pasamos la lista filtrada a la función de construcción.
                                              items: availableDealers,
                                            ),
                                          if (selectedValue == 'Department')
                                            _buildDepartmentSection(
                                              name,
                                              departmentController,
                                            ),
                                          if (selectedValue ==
                                              'Warehouse/Branch')
                                            _buildWarehouseSection(
                                              warehouseId,
                                              warehouseName,
                                                  (id, name) {
                                                setModalState(() {
                                                  warehouseId = id;
                                                  warehouseName = name;
                                                });
                                              },
                                            ),
                                          if (selectedValue == 'Service')
                                            _buildServiceSection(
                                              selectedService,
                                                  (value) => setModalState(() {
                                                selectedService = value;
                                              }),
                                              purposeController,
                                              dealerId,
                                              dealerName,
                                                  (id, name) => setModalState(() {
                                                dealerId = id;
                                                dealerName = name;
                                              }),
                                              // 5. Pasamos la lista filtrada aquí también.
                                              availableDealers: availableDealers,
                                            ),
                                          if (selectedValue == 'Activity')
                                            _buildActivitySection(
                                              selectedActivity,
                                                  (value) {
                                                setState(() {
                                                  selectedActivity = value;
                                                });
                                              },
                                            ),
                                          if (selectedValue == 'Others')
                                            _buildOthersSection(
                                              selectedOthers,
                                                  (value) => setModalState(() {
                                                selectedOthers = value;
                                              }),
                                              purposeController,
                                              dealerId,
                                              dealerName,
                                                  (id, name) => setModalState(() {
                                                dealerId = id;
                                                dealerName = name;
                                              }),
                                              // 6. Y aquí también.
                                              availableDealers: availableDealers,
                                            ),
                                          if (selectedValue == 'Transit')
                                            _buildTransitSection(
                                              name,
                                              transitController,
                                            ),
                                          if (selectedValue == 'New lead')
                                            newLead(context, setModalState),
                                          if (selectedValue == 'FollowUp Leads')
                                            followLeads(context),
                                          if ((selectedValue == 'Service' && selectedService == 'Service/Repair/Assembly') ||
                                              (selectedValue == 'Others' && selectedOthers == 'Others')) ...[
                                            const SizedBox(height: 15),
                                            TextField(
                                              controller: purposeController,
                                              decoration: _textDecoration(
                                                'Purpose of Visit',
                                              ),
                                              maxLines: 3,
                                              textAlignVertical:
                                              TextAlignVertical.top,
                                            ),
                                          ],
                                          if (selectedValue != 'Service' &&
                                              selectedValue != 'Others' &&
                                              selectedValue != 'New lead' &&
                                              selectedValue != 'FollowUp Leads') ...{
                                            const SizedBox(height: 15),
                                            TextField(
                                              controller: purposeController,
                                              decoration: _textDecoration(
                                                'Purpose of Visit',
                                              ),
                                              maxLines: 3,
                                              textAlignVertical: TextAlignVertical.top,
                                            ),
                                          },
                                          const SizedBox(height: 20),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  final visit = visits.firstWhere((v) =>
                                                  v['visit_date'] ==
                                                        _visitDateController.text,
                                                    orElse: () =>
                                                    <String, dynamic>{},
                                                  );

                                                  // visit['data'][entryIndex] = {
                                                  //   'type': entryValue['type'],
                                                  //   if (selectedValue == 'Dealer') ...{
                                                  //     'customer_id': dealerId,
                                                  //     'name': dealerName,
                                                  //   },
                                                  //   if (selectedValue == 'Warehouse/Branch') ...{
                                                  //     'location_id': warehouseId,
                                                  //     'name': warehouseName,
                                                  //   },
                                                  //   if (selectedValue == 'Service') ...{
                                                  //     'name': selectedService,
                                                  //     "customer_id": dealerId,
                                                  //     "dealerName": dealerName,
                                                  //   },
                                                  //   if (selectedValue == 'Others') ...{
                                                  //     'name': selectedOthers,
                                                  //     "customer_id": dealerId,
                                                  //     "dealerName": dealerName,
                                                  //   },
                                                  //   if (selectedValue == 'New lead') ...{
                                                  //     "name": _leadNameController.text,
                                                  //     "primary_no": _phoneController.text,
                                                  //     "state": _stateController.text,
                                                  //     "city": _cityController.text,
                                                  //     "lead_type": selectedLeadType?.name,
                                                  //     "lead_source": selectedLeadSource?.name,
                                                  //     "address": _addressController.text,
                                                  //     "current_business": selectedBusiness?.id,
                                                  //     "type": "new_lead",
                                                  //     "is_gst_registered": isGstRegistered,
                                                  //   },
                                                  //   if (selectedValue == 'Department')'department_name': departmentController.text,
                                                  //   if (selectedValue == 'Transit')'transit_name': transitController.text,
                                                  //   if (selectedValue != 'Service' && selectedValue != 'Others')'visit_purpose': purposeController.text,
                                                  //   if ((selectedValue == 'Service' && entryValue['visit_purpose'] != '') ||
                                                  //       (selectedValue == 'Others' && entryValue['visit_purpose'] != ''))'visit_purpose': purposeController.text,
                                                  // };
                                                  /// visit Update Code ok
                                                  visit['data'][entryIndex] = {
                                                    'type': entryValue['type'],
                                                    if (selectedValue == 'Dealer') ...{
                                                      'customer_id': dealerId,
                                                      'name': dealerName,
                                                    },
                                                    if (selectedValue == 'Warehouse/Branch') ...{
                                                      'location_id': warehouseId,
                                                      'name': warehouseName,
                                                    },
                                                    if (selectedValue == 'Service') ...{
                                                      'name': selectedService,
                                                      if (selectedService != "Service/Repair/Assembly") ...{
                                                        "customer_id": dealerId,
                                                        "dealerName": dealerName,
                                                      },
                                                    },
                                                    if (selectedValue == 'Others') ...{
                                                      'name': selectedOthers,
                                                      "customer_id": dealerId,
                                                      "dealerName": dealerName,
                                                    },
                                                    if (selectedValue == 'Activity') ...{
                                                      'name': selectedActivity,
                                                    },
                                                    if (selectedValue == 'New lead') ...{
                                                      "name": _leadNameController.text,
                                                      "primary_no": _phoneController.text,
                                                      "contact_person":_contactPersonController.text,
                                                      "state": _stateController.text,
                                                      "city": _cityController.text,
                                                      "lead_type": selectedLeadType?.name,
                                                      "lead_source": selectedLeadSource?.name,
                                                      "address": _addressController.text,
                                                      "current_business": selectedBusiness?.id,
                                                      "type": "new_lead",
                                                      "is_gst_registered":
                                                      isGstRegistered,
                                                    },
                                                    if (selectedValue == 'FollowUp Leads') ...{
                                                      "visit_id":
                                                      followLeadVisit?.id,
                                                      "type": "followup_lead",
                                                    },
                                                    if (selectedValue == 'Department')
                                                      'name':
                                                      departmentController.text,
                                                    if (selectedValue == 'Transit')
                                                      'name': transitController.text,
                                                    if (purposeController.text != 'Transit') ...{
                                                      'visit_purpose': purposeController.text,
                                                    },
                                                  };
                                                });
                                                _clearForm();
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                                padding:
                                                const EdgeInsets.symmetric(
                                                  //vertical: 15,
                                                  horizontal: 20,
                                                ),
                                              ),
                                              child: const Text("Update"),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).then((_) {
                          _clearForm();
                        });
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
                        deleteVisitData(_visitDateController.text, entryIndex);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column headOffice(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _visitDateController,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
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
            hintText: 'Visit Date',
            errorText: visitDateError,
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
          ),
          onTap: () async {
            // print("🟡 Current Visit Date: ${_visitDateController.text}");
            // print("🟢 Start Date: ${_startDateController.text}");
            ///print("🔵 End Date: ${_endDateController.text}");

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate:_visitDateController.text.isNotEmpty
                  ? DateFormat(
                'dd-MM-yyyy',
              ).parse(_visitDateController.text)
                  : DateFormat(
                'dd-MM-yyyy',
              ).parse(_startDateController.text),

              firstDate:_startDateController.text.isNotEmpty
                  ? DateFormat(
                'dd-MM-yyyy',
              ).parse(_startDateController.text)
                  : DateTime(2000),

              lastDate:_endDateController.text.isNotEmpty
                  ? DateFormat('dd-MM-yyyy').parse(_endDateController.text)
                  : DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                _visitDateController.text =
                "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
              });
              print("✅ Visit Date Selected oksexdrfgvyhbujnikmmjnihuygtf : ${_visitDateController.text}");
            }
          },
        ),
      ],
    );
  }

  Column newLead(BuildContext context, setState) {
    return Column(
      children: [
        TextField(
          controller: _leadNameController,
          decoration: _textDecoration('Lead name'),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _phoneController,
          decoration: _textDecoration('Phone no'),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _contactPersonController,
          decoration: _textDecoration('Contact person'),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _stateController,
          decoration: _textDecoration('State'),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _cityController,
          decoration: _textDecoration('City/Village'),
        ),
        const SizedBox(height: 15),
        // TextField(
        //   controller: _addressController,
        //   decoration: _textDecoration('Address'),
        // ),
        GooglePlaceAutoCompleteTextField(
          textEditingController: _addressController,
          googleAPIKey: "AIzaSyDPbGzcvHYuIK2boIPD8VVuzWf8_g3tDs0",
          inputDecoration: _textDecoration('Address'),
          focusNode: _addressFocusNode,
          debounceTime: 600,
          countries: ["in"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("Selected: ${prediction.description}");
            print("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
          },
          itemClick: (Prediction prediction) {
            _addressController.text = prediction.description ?? "";
            _addressController.selection = TextSelection.fromPosition(
              TextPosition(offset: _addressController.text.length),
            );
            FocusScope.of(context).unfocus();
          },
          itemBuilder: (context, index, Prediction prediction) {
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(prediction.description ?? ""),
            );
          },
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<LeadBusinessModel>(
          decoration: _dropdownDecoration('Business'),
          value: selectedBusiness,
          dropdownColor: Colors.white,
          isExpanded: true,
          items:
          apiController.leadbusiness.map((leadB) {
            return DropdownMenuItem(
              value: leadB,
              child: Text(leadB.name, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedBusiness = value;
            });
          },
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<LeadTypeModel>(
          decoration: _dropdownDecoration('Lead Type'),
          value: selectedLeadType,
          dropdownColor: Colors.white,
          items:
          apiController.leadTypes.map((leadType) {
            return DropdownMenuItem(
              value: leadType,
              child: Text(leadType.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedLeadType = value;
            });
          },
        ),

        if (selectedLeadType?.name.toLowerCase() == 'others') ...[
          const SizedBox(height: 15),
          TextField(
            controller: _leadTypeOtherController,
            decoration: _textDecoration('Please specify'),
          ),
        ],

        const SizedBox(height: 15),

        DropdownButtonFormField<LeadSourceModel>(
          decoration: _dropdownDecoration('Lead Source'),
          value: selectedLeadSource,
          dropdownColor: Colors.white,
          items:
          apiController.leadSource.map((leadSource) {
            return DropdownMenuItem(
              value: leadSource,
              child: Text(leadSource.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedLeadSource = value;
            });
          },
        ),

        if (selectedLeadSource?.name.toLowerCase() == 'others') ...[
          const SizedBox(height: 15),
          TextField(
            controller: _leadSourceOtherController,
            decoration: _textDecoration('Please specify'),
          ),
        ],
        CheckboxListTile(
          value: isGstRegistered,
          fillColor: MaterialStateProperty.all(Colors.white),
          side: BorderSide(color: Colors.black, width: 2),
          onChanged: (v) {
            if (v == null) return;
            setState(() => isGstRegistered = v);
          },
          title: Text(
            'Is this business GST registered?',
            style: TextStyle(color: Colors.black.withOpacity(0.8)),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  Column followLeads(BuildContext context) {
    return Column(
      children: [
        SearchableDropdown<Visit>(
          items: apiController.leads,
          hintText: "Sarch FollowUp Leads",
          itemLabel: (item) => item.name,
          onChanged: (value) {
            var st = apiController.leadStatuses.where(
                  (status) => status.id == value.lead?.leadStatusId,
            );
            setState(() {
              followLeadVisit = value;
            });
          },
          selectedItem: followLeadVisit,
        ),
        // const SizedBox(height: 15),
        // DropdownButtonFormField<LeadStatus>(
        //   decoration: _dropdownDecoration('Lead status'),
        //   value: leadStatus,
        //   dropdownColor: Colors.white,
        //   items:
        //       apiController.leadStatuses
        //           .map(
        //             (status) => DropdownMenuItem(
        //               value: status,
        //               child: Text(status.name),
        //             ),
        //           )
        //           .toList(),
        //   onChanged: (value) {
        //     setState(() => leadStatus = value);
        //   },
        // ),
        // if (selectedLeadSource == 'others') ...[
        //   const SizedBox(height: 15),
        //   TextField(
        //     controller: _leadSourceOtherController,
        //     decoration: _textDecoration('Please specify'),
        //   ),
        // ],
      ],
    );
  }
}


/// ye code uper wala sab sahi ho to hi delete kare ok
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:no_screenshot/no_screenshot.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/api/tour_plan_controller.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/DealerModel/DealerModel.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadSources.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/LeadModel/LeadTypeModel.dart';
// import 'package:shrachi/models/TourPlanModel/CreateTourPlanModel/WharehouseModel.dart';
// import 'package:shrachi/models/TourPlanModel/FetchTourPlanModel/FetchTourPlaneModel.dart';
// import 'package:shrachi/models/TourPlanModel/lead_status_model.dart';
// import 'package:shrachi/views/components/horizontal_stepper.dart';
// import 'package:shrachi/views/components/searchable_dropdown.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:get/get.dart';
//
// class CreatePlan extends StatefulWidget {
//   const CreatePlan({super.key});
//
//   @override
//   State<CreatePlan> createState() => _CreatePlanState();
// }
//
// class _CreatePlanState extends State<CreatePlan> {
//   final _noScreenshot = NoScreenshot.instance;
//   void disableScreenshot() async {
//     await _noScreenshot.screenshotOff();
//   }
//
//   void enableScreenshot() async {
//     await _noScreenshot.screenshotOn();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (!kIsWeb) {
//       disableScreenshot();
//     }
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       apiController.fetchDealers();
//       apiController.fetchLeadTypes();
//       apiController.fetchLeadSource();
//       apiController.fetchBusinesses();
//       apiController.fetchLeadsForSearch();
//     });
//   }
//
//   @override
//   void dispose() {
//     if (!kIsWeb) {
//       enableScreenshot();
//     }
//     super.dispose();
//   }
//
//   int _currentStep = 0;
//
//   final ApiController apiController = Get.put(ApiController());
//   final TourPlanController tourPlanController = Get.put(TourPlanController());
//   // Text controllers
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _visitDateController = TextEditingController();
//   final TextEditingController _purposeController = TextEditingController();
//   final TextEditingController _leadNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _contactPersonController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   // final TextEditingController _currentBusinessController =
//   //     TextEditingController();
//   final TextEditingController _leadTypeOtherController = TextEditingController();
//   final TextEditingController _leadSourceOtherController = TextEditingController();
//   final TextEditingController _departmentController = TextEditingController();
//   final TextEditingController _warehouseController = TextEditingController();
//   final TextEditingController _transitController = TextEditingController();
//   final TextEditingController _otherActivityController = TextEditingController();
//   final TextEditingController _otherServiceController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//
//   // select type
//
//   final List<String> options = [
//     'Dealer',
//     'FollowUp Leads',
//     'New lead',
//     'Department',
//     'Service',
//     'Activity',
//     'Others',
//     'HO',
//     'Warehouse/Branch',
//     'Transit',
//   ];
//
//   bool isNextVisitSelected = false;
//   String optionError = '';
//   String? startDateError;
//   String? endDateError;
//   String? visitDateError;
//
//   // Dropdown selected values
//   String? selectedValue;
//   int? dealerId;
//   String? selectedDealer;
//   LeadTypeModel? selectedLeadType;
//   LeadSourceModel? selectedLeadSource;
//   LeadBusinessModel? selectedBusiness;
//   int? warehouseId;
//   String? selectedWarehouse;
//   String? selectedModel;
//   String? selectedVariant;
//   int? leadId;
//   String? selectedLead;
//   LeadStatus? leadStatus;
//   String? selectedService;
//   String? selectedActivity;
//   String? selectedOthers;
//   String? selectedLeadStatus;
//   Visit? followLeadVisit;
//
//   bool isGstRegistered = false;
//
//   void _clearForm() {
//     setState(() {
//       dealerId = null;
//       selectedDealer = null;
//       warehouseId = null;
//       selectedWarehouse = null;
//       _departmentController.clear();
//       _transitController.clear();
//       _purposeController.clear();
//       _leadNameController.clear();
//       _phoneController.clear();
//       _contactPersonController.clear();
//       _stateController.clear();
//       _cityController.clear();
//       _addressController.clear();
//       selectedBusiness = null;
//       selectedLeadType = null;
//       selectedLeadSource = null;
//       isGstRegistered = false;
//       followLeadVisit = null;
//     });
//   }
//
//   // decoration
//   InputDecoration _textDecoration(String label) {
//     return InputDecoration(
//       alignLabelWithHint: true,
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
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
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withValues(alpha: 0.42),
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
//   List<Map<String, dynamic>> visits = [];
//
//   void addVisitData({bool isNextVisit = false}) {
//     setState(() {
//       if (isNextVisit) {
//         _visitDateController.clear();
//         selectedDealer = null;
//         _departmentController.clear();
//         _warehouseController.clear();
//         _transitController.clear();
//         _purposeController.clear();
//         selectedActivity = null;
//         selectedService = null;
//         _otherServiceController.clear();
//         _otherActivityController.clear();
//         _currentStep = 1;
//         selectedValue = null;
//         isGstRegistered = false;
//         _leadNameController.clear();
//         return;
//       }
//
//       String visitDate = _visitDateController.text;
//       int existingIndex = visits.indexWhere(
//         (v) => v["visit_date"] == visitDate,
//       );
//
//       Map<String, dynamic> newEntry = {};
//
//       if (selectedValue == "Dealer") {
//         newEntry = {
//           "customer_id": dealerId,
//           "name": selectedDealer,
//           "type": "dealer",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "New lead") {
//         newEntry = {
//           "name": _leadNameController.text,
//           "primary_no": _phoneController.text,
//           "state": _stateController.text,
//           "city": _cityController.text,
//           "lead_type": selectedLeadType?.name,
//           "lead_source": selectedLeadSource?.name,
//           "address": _addressController.text,
//           // "lead_status_id": selectedLeadStatus?.id,
//           "current_business": selectedBusiness?.id,
//           "type": "new_lead",
//           "is_gst_registered": isGstRegistered,
//         };
//       } else if (selectedValue == "FollowUp Leads") {
//         newEntry = {"visit_id": followLeadVisit?.id, "type": "followup_lead"};
//       } else if (selectedValue == "Department") {
//         newEntry = {
//           "name": _departmentController.text,
//           "type": "department",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "Service") {
//         newEntry = {
//           "name": selectedService,
//           "customer_id": dealerId,
//           "dealerName": selectedDealer,
//           "type": "service",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "Activity") {
//         newEntry = {
//           "name": selectedActivity,
//           "type": "activity",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "Others") {
//         newEntry = {
//           "name": selectedOthers,
//           "customer_id": dealerId,
//           "dealerName": selectedDealer,
//           "type": "others",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "Warehouse/Branch") {
//         newEntry = {
//           "location_id": warehouseId,
//           "name": selectedWarehouse,
//           "type": "warehouse",
//           "visit_purpose": _purposeController.text,
//         };
//       } else if (selectedValue == "HO") {
//         newEntry = {"name": apiController.hoDetails.value?.name, "type": "ho"};
//       } else if (selectedValue == "Transit") {
//         newEntry = {
//           "name": _transitController.text,
//           "type": "transit",
//           "visit_purpose": _purposeController.text,
//         };
//       }
//       if (existingIndex == -1) {
//         visits.add({
//           "visit_date": visitDate,
//           "data": [newEntry],
//         });
//       } else {
//         if (!visits[existingIndex]["data"].contains(newEntry)) {
//           visits[existingIndex]["data"].add(newEntry);
//         }
//       }
//     });
//   }
//
//   void editVisitData(
//     String visitDate,
//     int dataIndex,
//     Map<String, dynamic> updatedEntry,
//   ) {
//     int existingIndex = visits.indexWhere((v) => v["visit_date"] == visitDate);
//     if (existingIndex != -1 &&
//         dataIndex >= 0 &&
//         dataIndex < visits[existingIndex]["data"].length) {
//       visits[existingIndex]["data"][dataIndex] = updatedEntry;
//     }
//   }
//
//   void deleteVisitData(String visitDate, int dataIndex) {
//     int existingIndex = visits.indexWhere((v) => v["visit_date"] == visitDate);
//     if (existingIndex != -1 &&
//         dataIndex >= 0 &&
//         dataIndex < visits[existingIndex]["data"].length) {
//       setState(() {
//         visits[existingIndex]["data"].removeAt(dataIndex);
//
//         if (visits[existingIndex]["data"].isEmpty) {
//           visits.removeAt(existingIndex);
//         }
//       });
//     }
//   }
//
//   // Dealer section
//   Widget _buildDealerSection(
//     int? dealerId,
//     String dealerName,
//     Function(int, String) onChanged,
//   ) {
//     return SearchableDropdown<Dealer>(
//       items: apiController.dealers,
//       itemLabel: (item) => item.name,
//       selectedItem:
//           dealerId != null
//               ? apiController.dealers.firstWhere(
//                 (d) => d.id == dealerId,
//                 orElse: () => Dealer(id: dealerId, name: dealerName),
//               )
//               : null,
//       onChanged: (value) {
//         onChanged(value.id, value.name);
//       },
//     );
//   }
//
//   Widget _buildWarehouseSection(
//     int? warehouseId,
//     String warehouseName,
//     Function(int, String) onChanged,
//   ) {
//     return SearchableDropdown<WarehouseModel>(
//       items: apiController.Warehouse,
//       itemLabel: (item) => item.name,
//       selectedItem:
//           warehouseId != null
//               ? WarehouseModel(id: warehouseId, name: warehouseName)
//               : null,
//       onChanged: (value) {
//         onChanged(value.id, value.name);
//       },
//     );
//   }
//
//   // Department section (only name)
//   Widget _buildDepartmentSection(
//     String name,
//     TextEditingController controller,
//   ) {
//     controller.text = name;
//     return TextField(
//       controller: controller,
//       decoration: _textDecoration('Department name'),
//     );
//   }
//
//   // Transit section (only name)
//   Widget _buildTransitSection(String name, TextEditingController controller) {
//     controller.text = name;
//     return TextField(
//       controller: controller,
//       decoration: _textDecoration('Transit name'),
//     );
//   }
//
//   Widget _buildServiceSection(
//     String? selectedService,
//     Function(String?) onServiceChanged,
//     TextEditingController purposeController,
//     int? dealerId,
//     String? dealerName,
//     Function(int?, String?) onDealerChanged,
//   ) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedService,
//               hint: const Text("Select Service"),
//               decoration: _dropdownDecoration('Select Service'),
//               dropdownColor: Colors.white,
//               items:
//                   [
//                     'Service/Repair/Assembly',
//                     'Spare Parts Order Colletion',
//                   ].map((item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedService = value;
//                   onServiceChanged(value);
//                   if (value != 'Service/Repair/Assembly') {
//                     purposeController.clear();
//                   } else {
//                     dealerId = null;
//                     dealerName = null;
//                     onDealerChanged(null, null);
//                   }
//                 });
//               },
//             ),
//             if (selectedService != null &&
//                 selectedService != 'Service/Repair/Assembly') ...[
//               const SizedBox(height: 10),
//               SearchableDropdown<Dealer>(
//                 items: apiController.dealers,
//                 itemLabel: (item) => item.name,
//                 selectedItem:
//                     dealerId != null
//                         ? apiController.dealers.firstWhere(
//                           (d) => d.id == dealerId,
//                           orElse:
//                               () =>
//                                   Dealer(id: dealerId!, name: dealerName ?? ''),
//                         )
//                         : null,
//                 onChanged: (value) {
//                   setState(() {
//                     dealerId = value.id;
//                     dealerName = value.name;
//                     onDealerChanged(dealerId, dealerName);
//                   });
//                 },
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildActivitySection(
//     String? selectedActivity,
//     Function(String?) onActivityChanged,
//   ) {
//     return DropdownButtonFormField<String>(
//       value: selectedActivity,
//       hint: const Text("Select Activity"),
//       decoration: _dropdownDecoration('Select Activity'),
//       dropdownColor: Colors.white,
//       items:
//           ['Sales-Marketing', 'Service', 'Others'].map((item) {
//             return DropdownMenuItem<String>(value: item, child: Text(item));
//           }).toList(),
//       onChanged: (value) {
//         onActivityChanged(value);
//       },
//     );
//   }
//
//   Widget _buildOthersSection(
//     String? selectedOthers,
//     Function(String?) onOthersChanged,
//     TextEditingController purposeController,
//     int? dealerId,
//     String? dealerName,
//     Function(int?, String?) onDealerChanged,
//   ) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: selectedOthers,
//               hint: const Text("Select Others"),
//               decoration: _dropdownDecoration('Select Others'),
//               dropdownColor: Colors.white,
//               items:
//                   // ['Vendor Visit', 'Dealer Visit', 'Others'].map((item) {
//                   ['Dealer Visit', 'Others'].map((item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedOthers = value;
//                   onOthersChanged(value);
//                   if (value != 'Others') {
//                     purposeController.clear();
//                   } else {
//                     dealerId = null;
//                     dealerName = null;
//                     onDealerChanged(null, null);
//                   }
//                 });
//               },
//             ),
//             if (selectedOthers != null && selectedOthers == 'Dealer Visit') ...[
//               const SizedBox(height: 10),
//               SearchableDropdown<Dealer>(
//                 items: apiController.dealers,
//                 itemLabel: (item) => item.name,
//                 selectedItem:
//                     dealerId != null
//                         ? apiController.dealers.firstWhere(
//                           (d) => d.id == dealerId,
//                           orElse:
//                               () =>
//                                   Dealer(id: dealerId!, name: dealerName ?? ''),
//                         )
//                         : null,
//                 onChanged: (value) {
//                   setState(() {
//                     dealerId = value.id;
//                     dealerName = value.name;
//                     onDealerChanged(dealerId, dealerName);
//                   });
//                 },
//               ),
//             ],
//           ],
//         );
//       },
//     );
//   }
//
//   String getValue(String selectedValue) {
//     switch (selectedValue) {
//       case "Dealer":
//         return "dealer";
//       case "FollowUp Leads":
//         return "followup_lead";
//       case "New lead":
//         return "new_lead";
//       case "Department":
//         return "department";
//       case "HO":
//         return "ho";
//       case "Service":
//         return "service";
//       case "Activity":
//         return "activity";
//       case "Others":
//         return "others";
//       case "Transit":
//         return "transit";
//       case "Warehouse/Branch":
//         return "warehouse";
//       default:
//         return "Unknown";
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredEntries = visits
//             .where((visit) => visit['visit_date'] == _visitDateController.text)
//             .expand((visit) {
//               final List<dynamic> data = (visit['data'] ?? []) as List<dynamic>;
//
//               final filtered =
//                   (selectedValue != null)
//                       ? data
//                           .where((d) => d['type'] == getValue(selectedValue!))
//                           .toList()
//                       : data;
//
//               return filtered.asMap().entries;
//             })
//             .toList();
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Create Tour Plan'),
//           centerTitle: !Responsive.isSm(context),
//         ),
//         body: HorizontalStepper(
//           steps: [
//             Column(
//               children: [
//                 TextField(
//                   controller: _startDateController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
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
//                     hintText: 'Start Date',
//                     errorText: startDateError,
//                     suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       _startDateController.text =
//                           "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//                     }
//                   },
//                 ),
//                 SizedBox(height: 30.0),
//                 TextField(
//                   controller: _endDateController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(
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
//                     hintText: 'End Date',
//                     errorText: endDateError,
//                     suffixIcon: Icon(
//                       Icons.calendar_today,
//                       color: Colors.black.withValues(alpha: 0.6),
//                     ),
//                   ),
//                   onTap: () async {
//                     DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2101),
//                     );
//                     if (pickedDate != null) {
//                       _endDateController.text =
//                           "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//                     }
//                   },
//                 ),
//               ],
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   children:
//                       options.map((option) {
//                         return RadioListTile<String>(
//                           title: Text(
//                             option,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                           activeColor: Colors.black,
//                           fillColor: WidgetStateProperty.all(Colors.black),
//                           value: option,
//                           visualDensity: VisualDensity.compact,
//                           contentPadding: EdgeInsets.zero,
//                           groupValue: selectedValue,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedValue = value;
//                             });
//                           },
//                         );
//                       }).toList(),
//                 ),
//                 if (optionError.isNotEmpty) SizedBox(height: 15),
//                 if (optionError.isNotEmpty)
//                   Text(optionError, style: TextStyle(color: Colors.red)),
//               ],
//             ),
//             Column(
//               children: [
//                 Column(
//                   children: [
//                     TextField(
//                       controller: _visitDateController,
//                       readOnly: true,
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 20,
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.black.withValues(alpha: 0.42),
//                             width: 1.5,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.black.withValues(alpha: 0.42),
//                             width: 2,
//                           ),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.red.withValues(alpha: 0.6),
//                             width: 2,
//                           ),
//                         ),
//                         hintText: 'Visit Date',
//                         errorText: visitDateError,
//                         suffixIcon: const Icon(
//                           Icons.calendar_today,
//                           color: Colors.black,
//                         ),
//                       ),
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate:
//                               _visitDateController.text.isNotEmpty
//                                   ? DateFormat(
//                                     'dd-MM-yyyy',
//                                   ).parse(_visitDateController.text)
//                                   : DateFormat(
//                                     'dd-MM-yyyy',
//                                   ).parse(_startDateController.text),
//
//                           firstDate:
//                               _startDateController.text.isNotEmpty
//                                   ? DateFormat(
//                                     'dd-MM-yyyy',
//                                   ).parse(_startDateController.text)
//                                   : DateTime(2000),
//
//                           lastDate:
//                               _endDateController.text.isNotEmpty
//                                   ? DateFormat(
//                                     'dd-MM-yyyy',
//                                   ).parse(_endDateController.text)
//                                   : DateTime(2101),
//                         );
//                         if (pickedDate != null) {
//                           setState(() {
//                             _visitDateController.text = "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 15.0),
//                     if (visits.isNotEmpty) visitsList(filteredEntries),
//
//                     SizedBox(height: 15.0),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         foregroundColor: ColorPalette.seaGreen600,
//                         overlayColor: Colors.transparent,
//                         padding: EdgeInsets.zero,
//                       ),
//                       onPressed: () {
//                         if (_visitDateController.text.isEmpty) {
//                           setState(() {
//                             visitDateError = 'Please select visit date';
//                           });
//                         } else {
//                           visitDateError = null;
//                           showModalBottomSheet(
//                             context: context,
//                             isScrollControlled: true,
//                             backgroundColor: Colors.white,
//                             shape: const RoundedRectangleBorder(
//                               borderRadius: BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                             ),
//                             builder: (BuildContext context) {
//                               return StatefulBuilder(
//                                 builder: (
//                                   BuildContext context,
//                                   StateSetter setState,
//                                 ) {
//                                   return Padding(
//                                     padding: EdgeInsets.only(
//                                       bottom: MediaQuery.of(context,).viewInsets.bottom,
//                                     ),
//                                     child: SingleChildScrollView(
//                                       physics: const BouncingScrollPhysics(),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(15),
//                                         child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             const Text(
//                                               "Add Visit",
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 20),
//                                             // Dealer Dropdown
//                                             if (selectedValue == 'Dealer')
//                                               SearchableDropdown<Dealer>(
//                                                 items: apiController.dealers,
//                                                 itemLabel: (item) => "${item.name} - ${item.state} - ${item.city}",
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     dealerId = value.id;
//                                                     selectedDealer = value.name;
//                                                   });
//                                                 },
//                                               ),
//                                             if (selectedValue == 'Department')
//                                               TextField(
//                                                 controller:
//                                                     _departmentController,
//                                                 decoration: _textDecoration(
//                                                   'Department name',
//                                                 ),
//                                               ),
//
//                                             if (selectedValue == 'Warehouse/Branch')
//                                               SearchableDropdown<WarehouseModel>(
//                                                 items: apiController.Warehouse,
//                                                 itemLabel: (item) => item.name,
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     warehouseId = value.id;
//                                                     selectedWarehouse =
//                                                         value.name;
//                                                   });
//                                                 },
//                                               ),
//
//                                             if (selectedValue == 'Transit')
//                                               TextField(
//                                                 controller: _transitController,
//                                                 decoration: _textDecoration(
//                                                   'Transit name',
//                                                 ),
//                                               ),
//
//                                             if (selectedValue == 'Service') ...[
//                                               DropdownButtonFormField<String>(
//                                                 value: selectedService,
//                                                 hint: Text("Select Service"),
//                                                 decoration: _dropdownDecoration(
//                                                   'Select Service',
//                                                 ),
//                                                 dropdownColor: Colors.white,
//                                                 items:
//                                                     [
//                                                       'Service/Repair/Assembly',
//                                                       'Spare Parts Order Colletion',
//                                                     ].map((item) {
//                                                       return DropdownMenuItem<
//                                                         String
//                                                       >(
//                                                         value: item,
//                                                         child: Text(item),
//                                                       );
//                                                     }).toList(),
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     selectedService = value!;
//                                                     if (selectedService != 'Service/Repair/Assembly') {
//                                                       _purposeController
//                                                           .clear();
//                                                     } else {
//                                                       dealerId = null;
//                                                       selectedDealer = null;
//                                                     }
//                                                   });
//                                                 },
//                                               ),
//                                               if (selectedService != null &&
//                                                   selectedService != 'Service/Repair/Assembly') ...[
//                                                 const SizedBox(height: 10),
//                                                 SearchableDropdown<Dealer>(
//                                                   items: apiController.dealers,
//                                                   itemLabel:
//                                                       (item) => item.name,
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       dealerId = value.id;
//                                                       selectedDealer =
//                                                           value.name;
//                                                     });
//                                                   },
//                                                 ),
//                                               ],
//                                             ],
//
//                                             if (selectedValue == 'Activity') ...[
//                                               const SizedBox(height: 10),
//                                               DropdownButtonFormField<String>(
//                                                 value: selectedActivity,
//                                                 hint: Text("Select Activity"),
//                                                 decoration: _dropdownDecoration(
//                                                   'Select Activity',
//                                                 ),
//                                                 dropdownColor: Colors.white,
//                                                 items:
//                                                     [
//                                                       'Sales-Marketing',
//                                                       'Service',
//                                                       'Others',
//                                                     ].map((item) {
//                                                       return DropdownMenuItem<
//                                                         String
//                                                       >(
//                                                         value: item,
//                                                         child: Text(item),
//                                                       );
//                                                     }).toList(),
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     selectedActivity = value!;
//                                                   });
//                                                 },
//                                               ),
//                                             ],
//                                             if (selectedValue == 'Others') ...[
//                                               const SizedBox(height: 10),
//                                               DropdownButtonFormField<String>(
//                                                 value: selectedActivity,
//                                                 hint: Text("Select Others"),
//                                                 decoration: _dropdownDecoration(
//                                                   'Select Others',
//                                                 ),
//                                                 dropdownColor: Colors.white,
//                                                 items:
//                                                     [
//                                                       'Vendor Visit',
//                                                       'Dealer Visit',
//                                                       'Others',
//                                                     ].map((item) {
//                                                       return DropdownMenuItem<
//                                                         String
//                                                       >(
//                                                         value: item,
//                                                         child: Text(item),
//                                                       );
//                                                     }).toList(),
//                                                 onChanged: (value) {
//                                                   setState(() {
//                                                     selectedOthers = value!;
//                                                   });
//                                                 },
//                                               ),
//                                               if (selectedOthers != null &&
//                                                   selectedOthers ==
//                                                       'Dealer Visit') ...[
//                                                 const SizedBox(height: 10),
//                                                 SearchableDropdown<Dealer>(
//                                                   items: apiController.dealers,
//                                                   itemLabel:
//                                                       (item) => item.name,
//                                                   onChanged: (value) {
//                                                     setState(() {
//                                                       dealerId = value.id;
//                                                       selectedDealer =
//                                                           value.name;
//                                                     });
//                                                   },
//                                                 ),
//                                               ],
//                                             ],
//                                             if (selectedValue == 'Service' &&
//                                                 selectedService != null &&
//                                                 selectedService ==
//                                                     'Service/Repair/Assembly') ...{
//                                               const SizedBox(height: 15),
//                                               TextField(
//                                                 controller: _purposeController,
//                                                 decoration: _textDecoration(
//                                                   'Purpose of Visit',
//                                                 ),
//                                                 maxLines: 3,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.top,
//                                               ),
//                                             },
//
//                                             if (selectedValue == 'Others' &&
//                                                 selectedOthers != null &&
//                                                 selectedOthers == 'Others') ...{
//                                               const SizedBox(height: 15),
//                                               TextField(
//                                                 controller: _purposeController,
//                                                 decoration: _textDecoration(
//                                                   'Purpose of Visit',
//                                                 ),
//                                                 maxLines: 3,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.top,
//                                               ),
//                                             },
//
//                                             if (selectedValue != 'Service' &&
//                                                 selectedValue != 'Others' &&
//                                                 selectedValue != 'New lead' &&
//                                                 selectedValue !=
//                                                     'FollowUp Leads') ...{
//                                               const SizedBox(height: 15),
//                                               TextField(
//                                                 controller: _purposeController,
//                                                 decoration: _textDecoration(
//                                                   'Purpose of Visit',
//                                                 ),
//                                                 maxLines: 3,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.top,
//                                               ),
//                                             },
//                                             SizedBox(height: 15),
//                                             // Save Button
//                                             if (selectedValue == 'New lead')
//                                               newLead(context, setState),
//                                             if (selectedValue ==
//                                                 'FollowUp Leads')
//                                               followLeads(context),
//                                             SizedBox(height: 15),
//                                             Align(
//                                               alignment: Alignment.bottomRight,
//                                               child: ElevatedButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     addVisitData();
//                                                   });
//                                                   _clearForm();
//                                                   Navigator.pop(context);
//                                                 },
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: Colors.black,
//                                                   foregroundColor: Colors.white,
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 15,
//                                                         horizontal: 20,
//                                                       ),
//                                                 ),
//                                                 child: const Text("Save"),
//                                               ),
//                                             ),
//                                             const SizedBox(height: 25),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           );
//                         }
//                       },
//                       child: Row(
//                         children: const [
//                           Icon(Ionicons.add_sharp),
//                           SizedBox(width: 5),
//                           Text('Add Visit'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (selectedValue == 'HO') ...[
//                   headOffice(context),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Card(
//                       elevation: 4,
//                       color: Colors.white,
//                       shadowColor: Colors.black.withValues(alpha: 0.4),
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 20.0,
//                           vertical: 15.0,
//                         ),
//                         child: Text('Kolkata (Head Office)'),
//                       ),
//                     ),
//                   ),
//                 ],
//
//                 // ============ Follow Leads =======================
//                 // if (selectedValue == 'FollowUp Leads')
//                 // ===================== NEW LEAD =====================
//                 // if (selectedValue == 'New lead')
//               ],
//             ),
//           ],
//           currentStep: _currentStep,
//           onStepContinue: () {
//             setState(() {
//               if (_currentStep < 2) {
//                 if ((selectedValue == null || selectedValue!.isEmpty) &&
//                     _currentStep == 1) {
//                   optionError = 'Please select an option';
//                   return;
//                 } else if (_startDateController.text.isEmpty ||
//                     _endDateController.text.isEmpty) {
//                   if (_startDateController.text.isEmpty) {
//                     startDateError = 'Please select start date';
//                   }
//
//                   if (_endDateController.text.isEmpty) {
//                     endDateError = 'Please select end date';
//                   }
//                 } else {
//                   startDateError = null;
//                   endDateError = null;
//                   optionError = '';
//                   _currentStep++;
//                 }
//                 optionError = '';
//               } else {
//                 // if (selectedValue != 'FollowUp Leads' &&
//                 //     selectedValue != 'New lead') {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   backgroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(20),
//                     ),
//                   ),
//                   useSafeArea: true,
//                   builder: (BuildContext context) {
//                     int? selectedButton;
//                     return StatefulBuilder(
//                       builder: (context, setState) {
//                         return Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 "Select An Option",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           selectedButton = 0;
//                                         });
//                                       },
//                                       child: Container(
//                                         height: 140,
//                                         decoration: BoxDecoration(
//                                           // color: Colors.grey.withValues(
//                                           //   alpha: 0.1,
//                                           // ),
//                                           color: Colors.grey,
//                                           border: Border.all(
//                                             color:
//                                                 selectedButton == 0
//                                                     ? Colors.black
//                                                     : Colors.transparent,
//                                             width: 2,
//                                           ),
//                                           borderRadius: BorderRadius.circular(
//                                             8,
//                                           ),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.center,
//                                           children: const [
//                                             Icon(
//                                               Ionicons.calendar_outline,
//                                               size: 28,
//                                               color: Colors.black,
//                                             ),
//                                             SizedBox(height: 8),
//                                             Text(
//                                               "Next Day",
//                                               style: TextStyle(fontSize: 14),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Obx(() {
//                                     return Expanded(
//                                       child: GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedButton = 1;
//                                           });
//                                         },
//                                         child: Container(
//                                           height: 140,
//                                           decoration: BoxDecoration(
//                                             // color: Colors.grey.withValues(
//                                             //   alpha: 0.1,
//                                             // ),
//                                             color: Colors.green,
//                                             border: Border.all(
//                                               color: selectedButton == 1
//                                                       ? Colors.black
//                                                       : Colors.transparent,
//                                               width: 2,
//                                             ),
//                                             borderRadius: BorderRadius.circular(
//                                               8,
//                                             ),
//                                           ),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               const Icon(
//                                                 Ionicons.paper_plane_outline,
//                                                 size: 28,
//                                                 color: Colors.black,
//                                               ),
//                                               const SizedBox(height: 8),
//                                               tourPlanController.isLoading.value
//                                                   ? CircularProgressIndicator(
//                                                     color: Colors.white,
//                                                   )
//                                                   : const Text(
//                                                     "End Plan",
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                               ),
//                               const SizedBox(height: 30),
//                               Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: ElevatedButton(
//                                   onPressed: () async {
//                                     if (selectedButton == null) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         const SnackBar(
//                                           content: Text(
//                                             "Please select an option",
//                                           ),
//                                         ),
//                                       );
//                                       return;
//                                     }
//                                     if (selectedButton == 0) {
//                                       addVisitData(isNextVisit: true);
//                                       Navigator.pop(context);
//                                       // print("visits : ${visits.toString()}");
//                                     } else {
//                                       // if (selectedValue == 'New lead' &&
//                                       //     selectedValue == 'FollowUp Leads') {
//                                       //   addVisitData();
//                                       // }
//                                       await tourPlanController.addNewVisits(
//                                         startDate: _startDateController.text,
//                                         endDate: _endDateController.text,
//                                         visits: visits,
//                                       );
//                                     }
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.black,
//                                     foregroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(
//                                       vertical: 15,
//                                       horizontal: 20,
//                                     ),
//                                   ),
//                                   child: const Text("Save"),
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 );
//                 // } else {
//                 //   // print(selectedValue);
//                 //   addVisitData();
//                 //   Future.microtask(() async {
//                 //     await tourPlanController.addNewVisits(
//                 //       startDate: _startDateController.text,
//                 //       endDate: _endDateController.text,
//                 //       visits: visits,
//                 //     );
//                 //   });
//                 //   // print("visits : ${visits.toString()}");
//                 // }
//               }
//             });
//           },
//           onStepCancel: () {
//             setState(() {
//               if (_currentStep != 0) {
//                 visits = [];
//                 _clearForm();
//                 _visitDateController.clear();
//                 _currentStep--;
//               }
//             });
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget visitsList(List<dynamic> filteredEntries) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => SizedBox(height: 15.0),
//       itemCount: filteredEntries.length,
//       itemBuilder: (context, index) {
//         final entry = filteredEntries[index];
//         final entryIndex = entry.key;
//         final entryValue = entry.value;
//         final name = entryValue['name'] ?? '';
//         final purpose = entryValue['visit_purpose'] ?? '';
//         return Card(
//           key: ValueKey(entry),
//           color: Colors.white,
//           elevation: 6,
//           shadowColor: Colors.black.withValues(alpha: 0.1),
//           margin: const EdgeInsets.symmetric(vertical: 5),
//           child: Padding(
//             padding: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (name != '')
//                       Text(
//                         "Name: $name",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                     SizedBox(height: 15),
//                     if (entryValue['type'] == 'service') ...{
//                       if (entryValue['dealerName'] != null) ...{
//                         Text(
//                           "Dealer Name: ${entryValue['dealerName']}",
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(height: 15),
//                       },
//                     },
//                     if (entryValue['type'] == 'others') ...{
//                       if (entryValue['dealerName'] != null) ...{
//                         Text(
//                           "Dealer Name: ${entryValue['dealerName']}",
//                           style: const TextStyle(fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(height: 15),
//                       },
//                     },
//                     if (entryValue['type'] == 'new_lead') ...{
//                       Text(
//                         "Phone no: ${entryValue['primary_no']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "State: ${entryValue['state']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "City: ${entryValue['city']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Address: ${entryValue['address']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Lead Type: ${entryValue['lead_type']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Lead Source: ${entryValue['lead_source']}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                     },
//                     if (entryValue['type'] == 'followup_lead') ...{
//                       Text(
//                         "Previous Visit Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(apiController.leads.firstWhere((ld) => ld.id == entryValue['visit_id']).visitDate))}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                       SizedBox(height: 15),
//                       Text(
//                         "Lead Name: ${apiController.leads.firstWhere((ld) => ld.id == entryValue['visit_id']).name}",
//                         style: const TextStyle(fontWeight: FontWeight.w500),
//                       ),
//                     },
//                     if (purpose != '') Text("Purpose: $purpose"),
//                   ],
//                 ),
//                 SizedBox(height: 15.0),
//                 Row(
//                   children: [
//                     TextButton.icon(
//                       icon: const Icon(
//                         Ionicons.pencil_sharp,
//                         color: Colors.blue,
//                       ),
//                       label: const Text(
//                         "Edit",
//                         style: TextStyle(color: Colors.blue),
//                       ),
//                       onPressed: () {
//                         final departmentController = TextEditingController(
//                           text: name,
//                         );
//                         final transitController = TextEditingController(
//                           text: name,
//                         );
//                         final purposeController = TextEditingController(
//                           text: purpose,
//                         );
//
//                         int? dealerId = entryValue['customer_id'];
//                         String? dealerName = name;
//
//                         int? warehouseId = entryValue['location_id'];
//                         String warehouseName = name;
//
//                         String? selectedService = name;
//                         String? selectedActivity = name;
//                         String? selectedOthers = name;
//
//                         if (selectedValue == 'New lead') {
//                           _leadNameController.text = name;
//                           _phoneController.text = entryValue['primary_no'];
//                           _stateController.text = entryValue['state'];
//                           _cityController.text = entryValue['city'];
//                           _addressController.text = entryValue['address'];
//                           selectedBusiness = apiController.leadbusiness
//                               .firstWhere(
//                                 (b) => b.id == entryValue['current_business'],
//                               );
//                           selectedLeadType = apiController.leadTypes.firstWhere(
//                             (lt) => lt.name == entryValue['lead_type'],
//                           );
//                           selectedLeadSource = apiController.leadSource
//                               .firstWhere(
//                                 (ls) => ls.name == entryValue['lead_source'],
//                               );
//                           isGstRegistered = entryValue['is_gst_registered'];
//                         }
//
//                         if (selectedValue == 'FollowUp Leads') {
//                           followLeadVisit = apiController.leads.firstWhere(
//                             (ld) => ld.id == entryValue['visit_id'],
//                           );
//                         }
//
//                         print(entryValue['visit_id']);
//                         print(followLeadVisit?.id);
//                         showModalBottomSheet(
//                           context: context,
//                           isScrollControlled: true,
//                           backgroundColor: Colors.white,
//                           shape: const RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(20),
//                             ),
//                           ),
//                           builder: (BuildContext context) {
//                             return StatefulBuilder(
//                               builder: (context, setModalState) {
//                                 return Padding(
//                                   padding: EdgeInsets.only(
//                                     left: 15,
//                                     right: 15,
//                                     top: 15,
//                                     bottom:
//                                         MediaQuery.of(
//                                           context,
//                                         ).viewInsets.bottom,
//                                   ),
//                                   child: Container(
//                                     child: SingleChildScrollView(
//                                       scrollDirection: Axis.vertical,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text(
//                                             "Edit Visit",
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20),
//                                           if (selectedValue == 'Dealer')
//                                             _buildDealerSection(
//                                               dealerId,
//                                               dealerName!,
//                                               (id, name) {
//                                                 setModalState(() {
//                                                   dealerId = id;
//                                                   dealerName = name;
//                                                 });
//                                               },
//                                             ),
//                                           if (selectedValue == 'Department')
//                                             _buildDepartmentSection(
//                                               name,
//                                               departmentController,
//                                             ),
//                                           if (selectedValue == 'Warehouse/Branch')
//                                             _buildWarehouseSection(
//                                               warehouseId,
//                                               warehouseName,
//                                               (id, name) {
//                                                 setModalState(() {
//                                                   warehouseId = id;
//                                                   warehouseName = name;
//                                                 });
//                                               },
//                                             ),
//                                           if (selectedValue == 'Service')
//                                             _buildServiceSection(
//                                               selectedService,
//                                               (value) => setModalState(() {
//                                                 selectedService = value;
//                                               }),
//                                               purposeController,
//                                               dealerId,
//                                               dealerName,
//                                               (id, name) => setModalState(() {
//                                                 dealerId = id;
//                                                 dealerName = name;
//                                               }),
//                                             ),
//                                           if (selectedValue == 'Activity')
//                                             _buildActivitySection(
//                                               selectedActivity,
//                                               (value) {
//                                                 setState(() {
//                                                   selectedActivity = value;
//                                                 });
//                                               },
//                                             ),
//                                           if (selectedValue == 'Others')
//                                             _buildOthersSection(
//                                               selectedOthers,
//                                               (value) => setModalState(() {
//                                                 selectedOthers = value;
//                                               }),
//                                               purposeController,
//                                               dealerId,
//                                               dealerName,
//                                               (id, name) => setModalState(() {
//                                                 dealerId = id;
//                                                 dealerName = name;
//                                               }),
//                                             ),
//                                           if (selectedValue == 'Transit')
//                                             _buildTransitSection(
//                                               name,
//                                               transitController,
//                                             ),
//                                           if (selectedValue == 'New lead')
//                                             newLead(context, setModalState),
//                                           if (selectedValue == 'FollowUp Leads')
//                                             followLeads(context),
//                                           if ((selectedValue == 'Service' &&
//                                                   selectedService ==
//                                                       'Service/Repair/Assembly') ||
//                                               (selectedValue == 'Others' &&
//                                                   selectedOthers == 'Others')) ...[
//                                             const SizedBox(height: 15),
//                                             TextField(
//                                               controller: purposeController,
//                                               decoration: _textDecoration(
//                                                 'Purpose of Visit',
//                                               ),
//                                               maxLines: 3,
//                                               textAlignVertical:
//                                                   TextAlignVertical.top,
//                                             ),
//                                           ],
//                                           if (selectedValue != 'Service' &&
//                                               selectedValue != 'Others' &&
//                                               selectedValue != 'New lead' &&
//                                               selectedValue !=
//                                                   'FollowUp Leads') ...{
//                                             const SizedBox(height: 15),
//                                             TextField(
//                                               controller: purposeController,
//                                               decoration: _textDecoration(
//                                                 'Purpose of Visit',
//                                               ),
//                                               maxLines: 3,
//                                               textAlignVertical:
//                                                   TextAlignVertical.top,
//                                             ),
//                                           },
//                                           const SizedBox(height: 20),
//                                           Align(
//                                             alignment: Alignment.bottomRight,
//                                             child: ElevatedButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   final visit = visits.firstWhere(
//                                                     (v) =>
//                                                         v['visit_date'] ==
//                                                         _visitDateController.text,
//                                                     orElse:
//                                                         () => <String, dynamic>{},
//                                                   );
//                                                   visit['data'][entryIndex] = {
//                                                     'type': entryValue['type'],
//                                                     if (selectedValue ==
//                                                         'Dealer') ...{
//                                                       'customer_id': dealerId,
//                                                       'name': dealerName,
//                                                     },
//                                                     if (selectedValue ==
//                                                         'Warehouse/Branch') ...{
//                                                       'location_id': warehouseId,
//                                                       'name': warehouseName,
//                                                     },
//                                                     if (selectedValue ==
//                                                         'Service') ...{
//                                                       'name': selectedService,
//                                                       "customer_id": dealerId,
//                                                       "dealerName": dealerName,
//                                                     },
//                                                     if (selectedValue ==
//                                                         'Others') ...{
//                                                       'name': selectedOthers,
//                                                       "customer_id": dealerId,
//                                                       "dealerName": dealerName,
//                                                     },
//                                                     if (selectedValue ==
//                                                         'New lead') ...{
//                                                       "name":
//                                                           _leadNameController.text,
//                                                       "primary_no":
//                                                           _phoneController.text,
//                                                       "state":
//                                                           _stateController.text,
//                                                       "city": _cityController.text,
//                                                       "lead_type":
//                                                           selectedLeadType?.name,
//                                                       "lead_source":
//                                                           selectedLeadSource?.name,
//                                                       "address":
//                                                           _addressController.text,
//                                                       "current_business":
//                                                           selectedBusiness?.id,
//                                                       "type": "new_lead",
//                                                       "is_gst_registered":
//                                                           isGstRegistered,
//                                                     },
//                                                     if (selectedValue ==
//                                                         'Department')
//                                                       'department_name':
//                                                           departmentController.text,
//                                                     if (selectedValue == 'Transit')
//                                                       'transit_name':
//                                                           transitController.text,
//                                                     if (selectedValue !=
//                                                             'Service' &&
//                                                         selectedValue != 'Others')
//                                                       'visit_purpose':
//                                                           purposeController.text,
//                                                     if ((selectedValue ==
//                                                                 'Service' &&
//                                                             entryValue['visit_purpose'] !=
//                                                                 '') ||
//                                                         (selectedValue ==
//                                                                 'Others' &&
//                                                             entryValue['visit_purpose'] !=
//                                                                 ''))
//                                                       'visit_purpose':
//                                                           purposeController.text,
//                                                   };
//                                                 });
//                                                 _clearForm();
//                                                 Navigator.pop(context);
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.black,
//                                                 foregroundColor: Colors.white,
//                                                 padding: const EdgeInsets.symmetric(
//                                                   vertical: 15,
//                                                   horizontal: 20,
//                                                 ),
//                                               ),
//                                               child: const Text("Update"),
//                                             ),
//                                           ),
//                                           const SizedBox(height: 30),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ).then((_) {
//                           _clearForm();
//                         });
//                       },
//                     ),
//                     const SizedBox(width: 10),
//                     TextButton.icon(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       label: const Text(
//                         "Delete",
//                         style: TextStyle(color: Colors.red),
//                       ),
//                       onPressed: () {
//                         deleteVisitData(_visitDateController.text, entryIndex);
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Column headOffice(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _visitDateController,
//           readOnly: true,
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),
//             border: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black.withValues(alpha: 0.42),
//                 width: 1.5,
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.black.withValues(alpha: 0.42),
//                 width: 2,
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.red.withValues(alpha: 0.6),
//                 width: 2,
//               ),
//             ),
//             hintText: 'Visit Date',
//             errorText: visitDateError,
//             suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
//           ),
//           onTap: () async {
//             DateTime? pickedDate = await showDatePicker(
//               context: context,
//               initialDate:
//                   _visitDateController.text.isNotEmpty
//                       ? DateFormat(
//                         'dd-MM-yyyy',
//                       ).parse(_visitDateController.text)
//                       : DateFormat(
//                         'dd-MM-yyyy',
//                       ).parse(_startDateController.text),
//
//               firstDate:
//                   _startDateController.text.isNotEmpty
//                       ? DateFormat(
//                         'dd-MM-yyyy',
//                       ).parse(_startDateController.text)
//                       : DateTime(2000),
//
//               lastDate:
//                   _endDateController.text.isNotEmpty
//                       ? DateFormat('dd-MM-yyyy').parse(_endDateController.text)
//                       : DateTime(2101),
//             );
//             if (pickedDate != null) {
//               setState(() {
//                 _visitDateController.text =
//                     "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
//               });
//             }
//           },
//         ),
//       ],
//     );
//   }
//
//   Column newLead(BuildContext context, setState) {
//     return Column(
//       children: [
//         TextField(
//           controller: _leadNameController,
//           decoration: _textDecoration('Lead name'),
//         ),
//         const SizedBox(height: 15),
//         TextField(
//           controller: _phoneController,
//           decoration: _textDecoration('Phone no'),
//         ),
//         const SizedBox(height: 15),
//         TextField(
//           controller: _contactPersonController,
//           decoration: _textDecoration('Contact person'),
//         ),
//         const SizedBox(height: 15),
//         TextField(
//           controller: _stateController,
//           decoration: _textDecoration('State'),
//         ),
//         const SizedBox(height: 15),
//         TextField(
//           controller: _cityController,
//           decoration: _textDecoration('City/Village'),
//         ),
//         const SizedBox(height: 15),
//         // TextField(
//         //   controller: _addressController,
//         //   decoration: _textDecoration('Address'),
//         // ),
//         GooglePlaceAutoCompleteTextField(
//           textEditingController: _addressController,
//           googleAPIKey: "AIzaSyDPbGzcvHYuIK2boIPD8VVuzWf8_g3tDs0",
//           inputDecoration: _textDecoration('Address'),
//           debounceTime: 600,
//           countries: ["in"],
//           isLatLngRequired: true,
//           getPlaceDetailWithLatLng: (Prediction prediction) {
//             print("Selected: ${prediction.description}");
//             print("Lat: ${prediction.lat}, Lng: ${prediction.lng}");
//           },
//           itemClick: (Prediction prediction) {
//             _addressController.text = prediction.description ?? "";
//             _addressController.selection = TextSelection.fromPosition(
//               TextPosition(offset: _addressController.text.length),
//             );
//           },
//           itemBuilder: (context, index, Prediction prediction) {
//             return ListTile(
//               leading: const Icon(Icons.location_on),
//               title: Text(prediction.description ?? ""),
//             );
//           },
//         ),
//         const SizedBox(height: 15),
//         DropdownButtonFormField<LeadBusinessModel>(
//           decoration: _dropdownDecoration('Business'),
//           value: selectedBusiness,
//           dropdownColor: Colors.white,
//           isExpanded: true,
//           items:
//           apiController.leadbusiness.map((leadB) {
//             return DropdownMenuItem(
//               value: leadB,
//               child: Text(leadB.name, overflow: TextOverflow.ellipsis),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedBusiness = value;
//             });
//           },
//         ),
//         const SizedBox(height: 15),
//         DropdownButtonFormField<LeadTypeModel>(
//           decoration: _dropdownDecoration('Lead Type'),
//           value: selectedLeadType,
//           dropdownColor: Colors.white,
//           items:
//           apiController.leadTypes.map((leadType) {
//             return DropdownMenuItem(
//               value: leadType,
//               child: Text(leadType.name),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedLeadType = value;
//             });
//           },
//         ),
//
//         if (selectedLeadType?.name.toLowerCase() == 'others') ...[
//           const SizedBox(height: 15),
//           TextField(
//             controller: _leadTypeOtherController,
//             decoration: _textDecoration('Please specify'),
//           ),
//         ],
//
//         const SizedBox(height: 15),
//
//         DropdownButtonFormField<LeadSourceModel>(
//           decoration: _dropdownDecoration('Lead Source'),
//           value: selectedLeadSource,
//           dropdownColor: Colors.white,
//           items:
//           apiController.leadSource.map((leadSource) {
//             return DropdownMenuItem(
//               value: leadSource,
//               child: Text(leadSource.name),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedLeadSource = value;
//             });
//           },
//         ),
//
//         if (selectedLeadSource?.name.toLowerCase() == 'others') ...[
//           const SizedBox(height: 15),
//           TextField(
//             controller: _leadSourceOtherController,
//             decoration: _textDecoration('Please specify'),
//           ),
//         ],
//         CheckboxListTile(
//           value: isGstRegistered,
//           fillColor: WidgetStateProperty.all(Colors.white),
//           side: BorderSide(color: Colors.black, width: 2),
//           onChanged: (v) {
//             if (v == null) return;
//             setState(() => isGstRegistered = v);
//           },
//           title: Text(
//             'Is this business GST registered?',
//             style: TextStyle(color: Colors.black.withValues(alpha: 0.8)),
//           ),
//           controlAffinity: ListTileControlAffinity.leading,
//           contentPadding: EdgeInsets.zero,
//           dense: true,
//         ),
//       ],
//     );
//   }
//   Column followLeads(BuildContext context) {
//     return Column(
//       children: [
//         SearchableDropdown<Visit>(
//           items: apiController.leads,
//           itemLabel: (item) => item.name,
//           onChanged: (value) {
//             var st = apiController.leadStatuses.where(
//               (status) => status.id == value.lead?.leadStatusId,
//             );
//             setState(() {
//               followLeadVisit = value;
//             });
//           },
//           selectedItem: followLeadVisit,
//         ),
//         // const SizedBox(height: 15),
//         // DropdownButtonFormField<LeadStatus>(
//         //   decoration: _dropdownDecoration('Lead status'),
//         //   value: leadStatus,
//         //   dropdownColor: Colors.white,
//         //   items:
//         //       apiController.leadStatuses
//         //           .map(
//         //             (status) => DropdownMenuItem(
//         //               value: status,
//         //               child: Text(status.name),
//         //             ),
//         //           )
//         //           .toList(),
//         //   onChanged: (value) {
//         //     setState(() => leadStatus = value);
//         //   },
//         // ),
//         // if (selectedLeadSource == 'others') ...[
//         //   const SizedBox(height: 15),
//         //   TextField(
//         //     controller: _leadSourceOtherController,
//         //     decoration: _textDecoration('Please specify'),
//         //   ),
//         // ],
//       ],
//     );
//   }
// }
