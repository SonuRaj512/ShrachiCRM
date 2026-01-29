// import 'dart:async';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../api/checkin_controller.dart';
// import '../CustomErrorMessage/CustomeErrorMessage.dart';
//
// class CheckinStorage {
//   static Future<void> saveCheckinStatus(
//     int tourPlanId,
//     int visitId,
//     bool status,
//   ) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool("isCheckedIn_${tourPlanId}_${visitId}", status);
//   }
//
//   static Future<bool> getCheckinStatus(int tourPlanId, int visitId) async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool("isCheckedIn_${tourPlanId}_${visitId}") ?? false;
//   }
//
//   static Future<void> clearCheckinStatus(int tourPlanId, int visitId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove("isCheckedIn_${tourPlanId}_${visitId}");
//   }
// }
//
// class CheckinNoMap_Screen extends StatefulWidget {
//   final int tourPlanId;
//   final int visitId;
//   final String Type;
//   final StartDate;
//
//     CheckinNoMap_Screen({
//     super.key,
//     required this.tourPlanId,
//     required this.visitId,
//     required this.Type,
//     required this.StartDate,
//   });
//
//   @override
//   State<CheckinNoMap_Screen> createState() => _CheckinNoMap_ScreenState();
// }
//
// class _CheckinNoMap_ScreenState extends State<CheckinNoMap_Screen> {
//   final TextEditingController additionalInfoController = TextEditingController();
//   final CheckinController _checkinController = Get.put(CheckinController());
//
//   // --- Current Location related variables (extracted from CheckinsMap) ---
//   StreamSubscription<Position>? _positionStream;
//   LatLng?
//   _currentPosition; // To store the current location latitude and longitude
//   bool _locationInitialized = false; // To track if current location is obtained
//   List<File> images = [];
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;
//   CameraController? cameraController;
//   bool isCheckedIn = false;
//   bool isCameraOpen = false;
//
//
//   InputDecoration _textDecoration(String label) {
//     return InputDecoration(
//       alignLabelWithHint: true,
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withOpacity(0.42), // Fixed withOpacity
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.black.withOpacity(0.42), // Fixed withOpacity
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       hintText: label,
//     );
//   }
//   Future<void> _checkPermissionsAndStartStream() async {
//     await _positionStream?.cancel();
//
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) return;
//
//     PermissionStatus status = await Permission.location.status;
//
//     if (status.isDenied) {
//       status = await Permission.location.request();
//       if (!status.isGranted) return;
//     }
//
//     if (status.isPermanentlyDenied) {
//       _showPermissionDialog();
//       return;
//     }
//
//     // 🔥 START LOCATION LISTENER
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 1,
//       ),
//     ).listen((Position pos) {
//       // ✅ FIRST LOCATION MILTE HI SET KARO
//       if (!_locationInitialized) {
//         setState(() {
//           _currentPosition = LatLng(pos.latitude, pos.longitude);
//           _locationInitialized = true;
//         });
//       }
//     });
//   }
//   void _showPermissionDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => AlertDialog(
//         title: const Text("Location Permission"),
//         content: const Text(
//           "Location permission is permanently denied.\nPlease enable it from Settings.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               openAppSettings(); // ✅ ONLY HERE
//               Navigator.pop(context);
//             },
//             child: const Text("Open Settings"),
//           ),
//         ],
//       ),
//     );
//   }
//   void _openInitialBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       isDismissible: false,
//       enableDrag: false,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: 20,
//               right: 20,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 25,
//               top: 35,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   "Please Click the Check-In Button",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 25),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     // 🔥 Jab tak location ready nahi → button disabled
//                     onPressed: !_locationInitialized
//                         ? null
//                         : () async {
//
//                       final success = await _checkinController.checkIncontroller(
//                         lat: _currentPosition!.latitude,
//                         lng: _currentPosition!.longitude,
//                         tourPlanId: widget.tourPlanId,
//                         visitId: widget.visitId,
//                         convinceType: "complaint",
//                       );
//
//                       if (success) {
//                         isCheckedIn = true;
//
//                         await CheckinStorage.saveCheckinStatus(
//                           widget.tourPlanId,
//                           widget.visitId,
//                           true,
//                         );
//
//                         Navigator.pop(context);
//                         setState(() {});
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                       _locationInitialized ? Colors.green : Colors.grey,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     child: !_locationInitialized
//                         ? const Text(
//                       "Fetching Location...",
//                       style: TextStyle(color: Colors.green),
//                     ) : const Text(
//                       "Check-In",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//
//                 // SizedBox(
//                 //   width: double.infinity,
//                 //   child: ElevatedButton(
//                 //     onPressed: () async {
//                 //       if (_currentPosition == null) {
//                 //         showTopPopup("Location Error", "Fetching your location, please wait...", Colors.grey);
//                 //         return;
//                 //       }
//                 //       await _checkinController.checkIncontroller(
//                 //         lat: _currentPosition!.latitude,
//                 //         lng: _currentPosition!.longitude,
//                 //         tourPlanId: widget.tourPlanId,
//                 //         visitId: widget.visitId,
//                 //         convinceType: "complaint",
//                 //       );
//                 //       isCheckedIn = true;
//                 //       // SAVE CHECK-IN STATUS
//                 //       await CheckinStorage.saveCheckinStatus(
//                 //         widget.tourPlanId,
//                 //         widget.visitId,
//                 //         true,
//                 //       );
//                 //       Navigator.pop(context);
//                 //       setState(() {});
//                 //     },
//                 //     style: ElevatedButton.styleFrom(
//                 //       backgroundColor: Colors.green,
//                 //       padding: const EdgeInsets.symmetric(vertical: 14),
//                 //     ),
//                 //     child: const Text(
//                 //       "Check-In",
//                 //       style: TextStyle(color: Colors.white, fontSize: 16),
//                 //     ),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ---------------- Back Button Logic ----------------
//   Future<bool> _onWillPop() async {
//     if (!isCheckedIn) {
//       _openInitialBottomSheet();
//       return false;
//     }
//     return true;
//   }
//
//   Future<void> _pickImage() async {
//     var status = await Permission.camera.request();
//
//     if (status.isGranted) {
//       final cameras = await availableCameras();
//
//       final frontCamera = cameras.firstWhere(
//             (cam) => cam.lensDirection == CameraLensDirection.front,
//       );
//
//       cameraController = CameraController(frontCamera, ResolutionPreset.medium);
//
//       await cameraController!.initialize();
//
//       setState(() {
//         isCameraOpen = true; // SCREEN me camera show hoga
//       });
//     }
//   }
//   Future<void> _capturePhoto() async {
//     final picture = await cameraController!.takePicture();
//
//     setState(() {
//       images.add(File(picture.path));
//       isCameraOpen = false; // camera close karo
//     });
//
//     await cameraController!.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionsAndStartStream();
//
//     // CHECK IF USER ALREADY CHECKED-IN
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       isCheckedIn = await CheckinStorage.getCheckinStatus(
//         widget.tourPlanId,
//         widget.visitId,
//       );
//
//       if (!isCheckedIn) {
//         _openInitialBottomSheet();
//       }
//
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _positionStream?.cancel();
//     additionalInfoController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           foregroundColor: Colors.white,
//           title: Text(
//             "${widget.Type}",
//             style: const TextStyle(color: Colors.white),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Map is not available for",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   Text(" ${widget.Type}", style: TextStyle(color: Colors.red)),
//                 ],
//               ),
//               //SizedBox(height: 40,),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.all(12),
//                   width: MediaQuery.of(context).size.width * 0.92,
//                   constraints: const BoxConstraints(
//                     maxHeight: 600, // ✅ limit height so scrolling works
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 8,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   /// ✅ Scrollable content to prevent overflow
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         //Text("Fill the Check Out Screen"),
//                         Padding(
//                           padding: EdgeInsets.only(top: 50),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // Comments field
//                               TextField(
//                                 controller: additionalInfoController,
//                                 decoration: _textDecoration(
//                                   'Additional Information',
//                                 ),
//                                 maxLines: 3,
//                               ),
//                               const SizedBox(height: 15),
//                               // Add Photo button (camera)
//                               isCameraOpen
//                                   ? Stack(
//                                 children: [
//                                   SizedBox(
//                                     height: 400,
//                                     child: CameraPreview(cameraController!),
//                                   ),
//                                   Positioned(
//                                     bottom: 20,
//                                     left: 0,
//                                     right: 0,
//                                     child: Center(
//                                       child: FloatingActionButton(
//                                         onPressed: _capturePhoto,
//                                         child: const Icon(Icons.camera),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                                   :
//                               InkWell(
//                                 onTap: _pickImage,
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.grey.shade400),
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                   child: const Row(
//                                     children: [
//                                       Icon(Icons.camera_alt, size: 20, color: Colors.grey),
//                                       SizedBox(width: 8),
//                                       Text("Add Photo",
//                                           style: TextStyle(fontSize: 16, color: Colors.grey)),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 "Please upload ${widget.Type} photo",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black.withOpacity(
//                                     // Fixed withOpacity
//                                     0.8,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               // Show selected photos
//                               if (images.isNotEmpty)
//                                 SizedBox(
//                                   height: 80,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: images.length,
//                                     itemBuilder: (context, index) {
//                                       return Stack(
//                                         children: [
//                                           Container(
//                                             margin: const EdgeInsets.only(
//                                               right: 8,
//                                             ),
//                                             width: 80,
//                                             height: 80,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(
//                                                 6,
//                                               ),
//                                               image: DecorationImage(
//                                                 image: FileImage(images[index]),
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           // Remove button
//                                           Positioned(
//                                             right: 4,
//                                             top: 4,
//                                             child: GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   images.removeAt(index);
//                                                 });
//                                               },
//                                               child: Container(
//                                                 decoration: const BoxDecoration(
//                                                   color: Colors.black54,
//                                                   // Fixed Colors.black54
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: const Icon(
//                                                   Icons.close,
//                                                   color: Colors.white,
//                                                   size: 18,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               SizedBox(height: 15),
//                               // Continue button
//                               SizedBox(
//                                 width: double.infinity,
//                                 child: Obx(() {
//                                   return ElevatedButton(
//                                     onPressed: _locationInitialized && !_checkinController.isLoading.value
//                                         ? () async {
//                                       if (images.isEmpty) {
//                                         // Optionally show a message if images are required
//                                         ScaffoldMessenger.of(
//                                           context,
//                                         ).showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                               "Please upload at least one photo.",style: TextStyle(color: Colors.red),
//                                             ),
//                                           ),
//                                         );
//                                         return;
//                                       }
//                                       await _checkinController.checkInDetails(
//                                         lat: _currentPosition!.latitude,
//                                         lng: _currentPosition!.longitude,
//                                         tourPlanId: widget.tourPlanId,
//                                         visitId: widget.visitId,
//                                         images: images,
//                                         additionalInfo:
//                                         additionalInfoController.text,
//                                         startDate: widget.StartDate,
//                                       );
//                                     } : null,
//                                     // Disable button if location not initialized or loading
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue,
//                                       padding: const EdgeInsets.symmetric(
//                                         vertical: 14,
//                                       ),
//                                     ),
//                                     child: _checkinController.isLoading.value
//                                         ? SizedBox(
//                                       height: 20,
//                                       width: 20,
//                                       child: CircularProgressIndicator(
//                                         color: Colors.blue,
//                                       ),
//                                     ) : Text(
//                                       "CheckOut",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         // The second "Continue" button seems redundant, removed its logic
//                         // and made it conditional to prevent double buttons/logic.
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/checkin_controller.dart';

class CheckinStorage {
  static Future<void> saveCheckinStatus(int tourPlanId, int visitId, bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isCheckedIn_${tourPlanId}_${visitId}", status);
  }

  static Future<bool> getCheckinStatus(int tourPlanId, int visitId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isCheckedIn_${tourPlanId}_${visitId}") ?? false;
  }

  static Future<void> clearCheckinStatus(int tourPlanId, int visitId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isCheckedIn_${tourPlanId}_${visitId}");
  }
}

class CheckinNoMap_Screen extends StatefulWidget {
  final int tourPlanId;
  final int visitId;
  final String Type;
  final StartDate;

  CheckinNoMap_Screen({
    super.key,
    required this.tourPlanId,
    required this.visitId,
    required this.Type,
    required this.StartDate,
  });

  @override
  State<CheckinNoMap_Screen> createState() => _CheckinNoMap_ScreenState();
}

class _CheckinNoMap_ScreenState extends State<CheckinNoMap_Screen> {
  final TextEditingController additionalInfoController = TextEditingController();
  final CheckinController _checkinController = Get.put(CheckinController());


  StreamSubscription<Position>? _positionStream;
  final RxBool _isLocationLoading = true.obs;
  final Rxn<LatLng> _currentPosition = Rxn<LatLng>();
  List<File> images = [];
  CameraController? cameraController;
  bool isCheckedIn = false;
  bool isCameraOpen = false;

  @override
  void initState() {
    super.initState();
    _initLocationLogic();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isCheckedIn = await CheckinStorage.getCheckinStatus(widget.tourPlanId, widget.visitId);
      if (!isCheckedIn) {
        _openInitialBottomSheet();
      }
      setState(() {});
    });
  }

  Future<void> _initLocationLogic() async {
    _isLocationLoading.value = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isLocationLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isLocationLoading.value = false;
        return;
      }
    }

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Value update karein
      _currentPosition.value = LatLng(pos.latitude, pos.longitude);
      _isLocationLoading.value = false;

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1,
        ),
      ).listen((Position pos) {
        _currentPosition.value = LatLng(pos.latitude, pos.longitude);
      });
    } catch (e) {
      _isLocationLoading.value = false;
      print("Location Error: $e");
    }
  }

  //BottomSheet
  void _openInitialBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 10, right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 25,
              top: 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Please Click the Check-In Button",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.red))
                  ],
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() { // 🔥 Obx yaha hona chahiye, taaki button update ho sake
                    return ElevatedButton(
                      // Location load ho rahi ho ya position null ho toh button disable (null) rahega
                      onPressed: (_isLocationLoading.value || _currentPosition.value == null)
                          ? null
                          : () async {
                        bool success = await _checkinController.checkIncontroller(
                          lat: _currentPosition.value!.latitude,
                          lng: _currentPosition.value!.longitude,
                          tourPlanId: widget.tourPlanId,
                          visitId: widget.visitId,
                          convinceType: "complaint",
                        );

                        if (success) {
                          isCheckedIn = true;
                          await CheckinStorage.saveCheckinStatus(widget.tourPlanId, widget.visitId, true);
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        disabledBackgroundColor: Colors.grey.shade300, // Disable color
                      ),
                      child: (_isLocationLoading.value)
                          ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                          : const Text("Check-In", style: TextStyle(color: Colors.white, fontSize: 16)),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Logic for Back Button ---
  Future<bool> _onWillPop() async {
    if (!isCheckedIn) {
      _openInitialBottomSheet();
      return false;
    }
    return true;
  }

  // --- Image Picking Logic ---
  Future<void> _pickImage() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere((cam) => cam.lensDirection == CameraLensDirection.front, orElse: () => cameras.first);
      cameraController = CameraController(frontCamera, ResolutionPreset.medium);
      await cameraController!.initialize();
      setState(() { isCameraOpen = true; });
    }
  }

  Future<void> _capturePhoto() async {
    final picture = await cameraController!.takePicture();
    setState(() {
      images.add(File(picture.path));
      isCameraOpen = false;
    });
    await cameraController!.dispose();
  }

  InputDecoration _textDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.42), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showCheckinRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🛑 Icon Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.info_outline_rounded, color: Colors.red.shade600, size: 40),
            ),
            const SizedBox(height: 20),

            // 📝 Title Section
            const Text(
              "Action Required",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // ✉️ Message Section
            const Text(
              "Please complete Check-In first to proceed with Check-Out.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // 🚀 Button Section
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _openInitialBottomSheet(); // Open check-in sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Go to Check-In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            // ✖️ Cancel Option
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Maybe Later",
                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _positionStream?.cancel();
    additionalInfoController.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          title: Center(
            child: Text(
              widget.Type.isNotEmpty
                  ? widget.Type[0].toUpperCase() + widget.Type.substring(1)
                  : widget.Type,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Map is not available for", style: TextStyle(color: Colors.red)),
                  Text(" ${widget.Type}", style: const TextStyle(color: Colors.red)),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      TextField(
                        controller: additionalInfoController,
                        decoration: _textDecoration('Additional Information'),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 15),
                      if (isCameraOpen)
                        Column(
                          children: [
                            SizedBox(height: 300, child: CameraPreview(cameraController!)),
                            IconButton(
                              icon: const Icon(Icons.camera, size: 50, color: Colors.blue),
                              onPressed: _capturePhoto,
                            ),
                          ],
                        )
                      else
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                                SizedBox(width: 8),
                                Text("Add Photo", style: TextStyle(fontSize: 16, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(right: 100.0),
                        child: Text(
                          "Please upload ${widget.Type} photo",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (images.isNotEmpty)
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    width: 80, height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      image: DecorationImage(image: FileImage(images[index]), fit: BoxFit.cover),
                                    ),
                                  ),
                                  Positioned(
                                    right: 4, top: 4,
                                    child: GestureDetector(
                                      onTap: () => setState(() => images.removeAt(index)),
                                      child: Container(
                                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed: (_isLocationLoading.value || _currentPosition.value == null || _checkinController.isLoading.value)
                                ? null
                                : () async {
                              // 🔴 Validation: Agar check-in nahi hua hai
                              if (!isCheckedIn) {
                                _showCheckinRequiredDialog();
                                return;
                              }
                              if (images.isEmpty) {
                                Get.snackbar("Required", "Please upload at least one photo", backgroundColor: Colors.red, colorText: Colors.white);
                                return;
                              }
                              await _checkinController.CheckoutController(
                                lat: _currentPosition.value!.latitude,
                                lng: _currentPosition.value!.longitude,
                                tourPlanId: widget.tourPlanId,
                                visitId: widget.visitId,
                                images: images,
                                additionalInfo: additionalInfoController.text,
                                startDate: widget.StartDate,
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 14)),
                            child: _checkinController.isLoading.value
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("CheckOut", style: TextStyle(fontSize: 16, color: Colors.white)),
                          );
                        }),
                      ),
                    ],
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