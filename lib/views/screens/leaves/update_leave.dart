import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrachi/api/leave_controller.dart';
import 'package:shrachi/models/leave_model.dart';
import 'package:shrachi/models/leave_type_model.dart';
import 'package:shrachi/views/enums/responsive.dart';

class UpdateLeave extends StatefulWidget {
  final LeaveModel leaveModel;
  const UpdateLeave({super.key, required this.leaveModel});

  @override
  State<UpdateLeave> createState() => _UpdateLeaveState();
}

class _UpdateLeaveState extends State<UpdateLeave> {
  LeaveTypeModel? _leaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();
  final LeaveController _leaveController = Get.put(LeaveController());
  final ImagePicker _picker = ImagePicker();
  List<XFile> pickedImages = [];
  Map<String, String> errors = {};

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leaveController.getLeaveTypes();

      setState(() {
        _startDate = widget.leaveModel.startDate;
        _endDate = widget.leaveModel.endDate;
        _reasonController.text = widget.leaveModel.reason;
      });
    });
  }
  //---- after endDate function------

  void showPickerOptions(Function(List<XFile>) onImagesPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8), // minimal top gap
            // Handle bar
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Select Option",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded, color: Colors.blue),
              title: const Text(
                'Take Photo',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () async {
                final XFile? img = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (img != null) onImagesPicked([img]);
                Navigator.pop(context);
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
                final List<XFile> images = await _picker.pickMultiImage();
                if (images.isNotEmpty) onImagesPicked(images);
                Navigator.pop(context);
              },
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.close_rounded, color: Colors.redAccent),
              title: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Update leave"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Obx(() {
            final leaveType = _leaveController.leaveTypes.firstWhere(
              (leave) => leave.id == widget.leaveModel.leaveTypeId,
              orElse: () => _leaveController.leaveTypes.first,
            );
            _leaveType = leaveType; //update_leave mein
            return SizedBox(
              width:
                  Responsive.isSm(context)
                      ? screenWidth
                      : Responsive.isXl(context)
                      ? screenWidth * 0.60
                      : screenWidth * 0.40,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DropdownButtonFormField<LeaveTypeModel>(
                        decoration: const InputDecoration(
                          hintText: "Leave Type",
                          labelText: 'Leave type',
                          border: OutlineInputBorder(),
                        ),
                        dropdownColor: Colors.white,
                        value:
                            widget.leaveModel.leaveTypeId != null
                                ? leaveType
                                : _leaveType,
                        style: const TextStyle(color: Colors.black),
                        items:
                            _leaveController.leaveTypes.map((leave) {
                              return DropdownMenuItem<LeaveTypeModel>(
                                value: leave,
                                child: Text(
                                  leave.name,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                        onChanged: (LeaveTypeModel? val) {
                          _leaveType = val;
                        },
                      ),
                  
                      const SizedBox(height: 12),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Start Date",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pickStartDate(context),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              _startDate != null
                                  ? "${_startDate!.day}-${_startDate!.month}-${_startDate!.year}"
                                  : "",
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "End Date",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _pickEndDate(context),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                        controller: TextEditingController(
                          text:
                              _endDate != null
                                  ? "${_endDate!.day}-${_endDate!.month}-${_endDate!.year}"
                                  : "",
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 5,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          hintText: "Reason",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      // ===== Image Picker Button =====
                      InkWell(
                        onTap: () {
                          showPickerOptions((images) {
                            setState(() {
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
                              color: Colors.black.withOpacity(0.5),
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
                                        setState(() {
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
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
                            horizontal: 30,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () async {
                          await _leaveController.updateLeave(
                            id: widget.leaveModel.id,
                            leaveType: _leaveType,
                            startDate: _startDate,
                            endDate: _endDate,
                            images: pickedImages,
                            reason: _reasonController.text,
                          );
                        },
                        child:
                            _leaveController.isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
