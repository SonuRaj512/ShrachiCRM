import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/attendance_controller.dart';
import 'package:shrachi/api/profile_controller.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/layouts/authenticated_layout.dart';
import 'package:shrachi/views/screens/attendance/attendance.dart';
import 'package:shrachi/views/screens/notifications/notifications_page.dart';
import 'package:get/get.dart';
import 'package:shrachi/views/screens/tours/show_tour.dart';
import '../../api/api_controller.dart';
import 'CustomErrorMessage/CustomeErrorMessage.dart';

class Home extends StatefulWidget {
  final VoidCallback openDrawer;
  const Home({super.key, required this.openDrawer});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AttendanceController _attendanceController = Get.put(AttendanceController());
  // final AttendanceController _attendanceController = Get.put(AttendanceController(),);
  final ApiController controller = Get.put(ApiController());
  final ProfileController _profileController = Get.put(ProfileController());
  String _currentAddress = "Fetching address...";
  bool _loading = false;

  Future<void> _getCurrentLocationAndAddress() async {
    setState(() => _loading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Location services are disabled";
        _loading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = "Location permission denied";
        _loading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final user = _profileController.user.value;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String fullAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, "
            "${place.postalCode}, ${place.country}";

        if (user?.lat != null && user?.lng != null) {
          double homeLat = double.tryParse(user!.lat!) ?? 0.0;
          double homeLng = double.tryParse(user.lng!) ?? 0.0;

          if (homeLat != 0.0 && homeLng != 0.0) {
            double distance = Geolocator.distanceBetween(
              homeLat,
              homeLng,
              position.latitude,
              position.longitude,
            );

            if (distance <= 100) {
              fullAddress = 'Home Location';
            }
          }
        }

        setState(() {
          _currentAddress = fullAddress;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = "Error getting location: $e";
      });
    }

    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndAddress();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.profileDetails();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTourPlans();
    });
  }

  Color getStatusTextColor(String status) {
    status = status.toLowerCase();        // convert string
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      case 'approval':
        return Colors.blue;
      case 'partially approved' :
        return Colors.orange;

      case 'pending_partial_approval' :
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }
  Color getStatusBackgroundColor(String status) {
    status = status.toLowerCase();        // convert string
    print("tour ststus : $status");
    switch (status) {
      case 'confirmed':
        return Colors.green.withOpacity(0.1);

      case 'approval':
        return Colors.blue.withOpacity(0.1);

      case 'pending':
      case 'cancelled':
      case 'rejected':
        return Colors.red.withOpacity(0.1);

      case 'partially approved' :
        return Colors.orange.withOpacity(0.2);

      case 'pending_partial_approval' :
        return Colors.blue.withOpacity(0.1);

      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
  String formatStatusLabel(String status) {
    String s = status.toLowerCase().trim();
    switch (s) {
      case 'pending':
        return 'Pending';

      case 'cancelled':
        return 'Cancelled';

      case 'rejected':
        return 'Rejected';

      case 'approval' :
        return 'Send For Approval';

      case 'partially approved' :
        return 'Partially Approved';

      case 'pending_partial_approval' :
        return 'Partial Approval';

      case 'confirmed':
        return 'Approved';

      default:
        return status;
    }
  }

  ///Expense Status
  Color getExpenseStatusBackgroundColor(String? status) {
    switch (status) {
      case "confirmed":
        return Colors.green.withOpacity(0.15);
      case "approval":
        return Colors.blue.withOpacity(0.15);
      case "partial":
        return Colors.orange.withOpacity(0.15);
      case "pending":
        return Colors.amber.withOpacity(0.15);
      case "rejected":
        return Colors.red.withOpacity(0.15);
      default:
        return Colors.grey.withOpacity(0.15);
    }
  }

  Color getExpenseStatusTextColor(String? status) {
    switch (status) {
      case "confirmed":
        return Colors.green;

      case "approval":
        return Colors.blue;

      case "partial":
        return Colors.orange;

      case "no_expense":
        return Colors.grey.shade600;

      case "pending":
      case "rejected":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isSm(context) ? 10.0 : 15.0,
                vertical: 20.0,
              ),
              decoration: BoxDecoration(
                color: ColorPalette.pictonBlue400,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Ionicons.location_outline,
                                size: Responsive.isXs(context) ? 20 : 24,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                _loading ? 'Loading...' : _currentAddress,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Responsive.isXs(context) ? 14 : 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: widget.openDrawer,
                            icon: Icon(
                              Ionicons.grid_outline,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationsPage(),
                                ),
                              );
                            },
                            icon: Icon(
                              Ionicons.notifications,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final user = _profileController.user.value;
                        final firstAssignment = user?.stateZoneAssignments.isNotEmpty == true ? user!.stateZoneAssignments.first : null;
                        final assignments = user?.stateZoneAssignments ?? [];
                        final first = assignments.isNotEmpty ? assignments.first : null;
                        final count = assignments.length;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${user?.name.split(' ')[0]}',
                              style: TextStyle(
                                fontSize: Responsive.isXs(context) ? 18 : 20,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              user?.employeeCode ?? 'Nil',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            InkWell(
                              onTap: () {
                                if (assignments.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Assigned States & Zones",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                         backgroundColor: Colors.white,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            // ⭐ HEADER ROW
                                            Row(
                                              children: const [
                                                Text(
                                                  "* State Code",
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                ),
                                                Text("  |  "),
                                                Text(
                                                  "Zone Code",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                      fontSize: 14
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            // ⭐ LIST OF ASSIGNMENTS
                                            ...assignments.map((item) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      item.stateCode,
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                    const Text("              |   "),
                                                    Text(
                                                      item.zoneCode,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ],
                                        ),

                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("Close",style: TextStyle(color: Colors.black),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    first?.stateCode ?? 'Nil',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),

                                  const Text(" - ", style: TextStyle(color: Colors.white)),

                                  Text(
                                    first?.zoneCode ?? 'Nil',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  // COUNT OF ASSIGNMENTS → (2)
                                    if (count > 1)
                                    Text(
                                      "($count)",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            SizedBox(
                              width: 180, // 👈 adjust as per your layout
                              child: Text(
                                user?.designation ?? 'Nil',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            )
                          ],
                        );
                      }),
                      SizedBox(width: 30),
                      /// ye bhi clockIn or clockOut ka hi code hai but es me dialog box open nahi ho raha hai
                      //Obx(() {
                      //   return _attendanceController.isClockedIn.value
                      //       ? Column(
                      //         crossAxisAlignment: CrossAxisAlignment.end,
                      //         children: [
                      //           Row(
                      //             children: [
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                   color: _attendanceController.isRunning.value
                      //                           ? Color(0xffe6b309)
                      //                           : ColorPalette.seaGreen500,
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //                 child: IconButton(
                      //                   onPressed: () async {
                      //                     if (!_attendanceController.isLoading.value) {
                      //                       if (_attendanceController.isRunning.value) {
                      //                         final TextEditingController reasonController = TextEditingController();
                      //                         // final TextEditingController reasonLatController = TextEditingController();
                      //                         // final TextEditingController reasonLonController = TextEditingController();
                      //
                      //                         Get.defaultDialog(
                      //                           title: "Break Reason",
                      //                           backgroundColor: Colors.white,
                      //                           radius: 16,
                      //                           titleStyle: const TextStyle(
                      //                             fontWeight: FontWeight.bold,
                      //                             fontSize: 20,
                      //                             color: Colors.black,
                      //                           ),
                      //                           content: StatefulBuilder(
                      //                             builder: (context, setState) {
                      //                               String? errorText;
                      //
                      //                               return Padding(
                      //                                 padding: const EdgeInsets.symmetric(
                      //                                       horizontal: 12,
                      //                                       vertical: 8,
                      //                                     ),
                      //                                 child: Column(
                      //                                   mainAxisSize: MainAxisSize.min,
                      //                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                      //                                   children: [
                      //                                     TextField(
                      //                                       controller: reasonController,
                      //                                       maxLines: 4,
                      //                                       style: const TextStyle(
                      //                                             color: Colors.black,
                      //                                             fontSize: 16,
                      //                                           ),
                      //                                       decoration: InputDecoration(
                      //                                         labelText: "Reason",
                      //                                         alignLabelWithHint: true,
                      //                                         labelStyle: const TextStyle(
                      //                                               color: Colors.black87,
                      //                                             ),
                      //                                         hintText: "Enter your break reason...",
                      //                                         hintStyle: const TextStyle(
                      //                                               color: Colors.black54,
                      //                                             ),
                      //                                         filled: true,
                      //                                         fillColor:
                      //                                             Colors.grey.shade100,
                      //                                         errorText: errorText,
                      //                                         border: OutlineInputBorder(
                      //                                           borderRadius: BorderRadius.circular(12,),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                     const SizedBox(
                      //                                       height: 20,
                      //                                     ),
                      //                                     Row(
                      //                                       children: [
                      //                                         Expanded(
                      //                                           child: OutlinedButton(
                      //                                             style: OutlinedButton.styleFrom(
                      //                                               foregroundColor: Colors.black87,
                      //                                               side: BorderSide(
                      //                                                 color: Colors.grey.shade400,
                      //                                               ),
                      //                                               shape: RoundedRectangleBorder(
                      //                                                 borderRadius: BorderRadius.circular(12,),
                      //                                               ),
                      //                                               padding: const EdgeInsets.symmetric(vertical: 14,),),
                      //                                             onPressed: () {
                      //                                               reasonController.clear();
                      //                                               setState(() {
                      //                                                 errorText = null;
                      //                                               });
                      //                                               Get.back();
                      //                                             },
                      //                                             child: const Text("Cancel",),
                      //                                           ),
                      //                                         ),
                      //                                         const SizedBox(
                      //                                           width: 12,
                      //                                         ),
                      //                                         Expanded(
                      //                                           child: ElevatedButton(
                      //                                             style: ElevatedButton.styleFrom(
                      //                                               backgroundColor: Colors.blue,
                      //                                               shape: RoundedRectangleBorder(
                      //                                                 borderRadius: BorderRadius.circular(12,),
                      //                                               ),
                      //                                               padding: const EdgeInsets.symmetric(vertical: 14,),
                      //                                             ),
                      //                                             onPressed: () async {
                      //                                               final user = _profileController.user.value;
                      //                                               final reason = reasonController.text.trim();
                      //                                               final reasonlat = user?.lat != null ? double.tryParse(user!.lat!) : null;
                      //                                               final reasonlng = user?.lng != null ? double.tryParse(user!.lng!) : null;
                      //                                               if (reason.isEmpty) {
                      //                                                 setState(() {
                      //                                                   errorText = "Please enter a reason";
                      //                                                 });
                      //                                                 return;
                      //                                               }
                      //                                               setState(() {
                      //                                                 errorText = null;
                      //                                               });
                      //                                               await _attendanceController.breakIn(reason: reason, reasonlat: reasonlat, reasonlng: reasonlng,);
                      //                                               setState(
                      //                                                 () {},
                      //                                               );
                      //                                               reasonController.clear();
                      //                                               Get.back();
                      //                                             },
                      //                                             child: const Text(
                      //                                               "Submit",
                      //                                               style: TextStyle(
                      //                                                 color: Colors.white,
                      //                                                 fontSize: 16,
                      //                                                 fontWeight: FontWeight.w600,
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                         ),
                      //                                       ],
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               );
                      //                             },
                      //                           ),
                      //                         );
                      //                       } else {
                      //                         final user = _profileController.user.value;
                      //                         final reasonlat = user?.lat != null ? double.tryParse(user!.lat!) : null;
                      //                         final reasonlng = user?.lng != null ? double.tryParse(user!.lng!) : null;
                      //                         await _attendanceController.breakOut(reasonlat: reasonlat, reasonlng: reasonlng);
                      //                       }
                      //                     }
                      //                   },
                      //                   icon: _attendanceController.isLoading.value
                      //                           ? SizedBox(
                      //                             width: 20,
                      //                             height: 20,
                      //                             child: CircularProgressIndicator(
                      //                                   color: Colors.white,
                      //                                 ),
                      //                           )
                      //                           : Icon(_attendanceController.isRunning.value
                      //                                 ? Ionicons.pause
                      //                                 : Ionicons.play,
                      //                             color: Colors.white,
                      //                           ),
                      //                 ),
                      //               ),
                      //               SizedBox(width: 10.0),
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                   color: Color(0xffff4a12),
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //                 child: IconButton(
                      //                   onPressed: () async {
                      //                     !_attendanceController.isClockOutLoading.value
                      //                         ? await _attendanceController.clockOut()
                      //                         : null;
                      //                   },
                      //                   icon: _attendanceController.isClockOutLoading.value
                      //                           ? SizedBox(
                      //                             width: 20,
                      //                             height: 20,
                      //                             child: CircularProgressIndicator(
                      //                                   color: Colors.white,
                      //                                 ),
                      //                           ) : Icon(
                      //                             Ionicons.stop,
                      //                             color: Colors.white,
                      //                           ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(height: 10.0),
                      //           Text(
                      //             _attendanceController.formattedTime,
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.w600,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //       : ElevatedButton(
                      //         onPressed: () async {
                      //           await _attendanceController.clockIn();
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: ColorPalette.seaGreen600,
                      //           foregroundColor: Colors.white,
                      //           padding: EdgeInsets.symmetric(
                      //             vertical: 15.0,
                      //             horizontal: 20.0,
                      //           ),
                      //         ),
                      //         child: _attendanceController.isLoading.value
                      //                 ? SizedBox(
                      //                   width: 20,
                      //                   height: 20,
                      //                   child: CircularProgressIndicator(
                      //                     color: Colors.white,
                      //                   ),
                      //                 )
                      //                 :Text(
                      //                   'Clock In',
                      //                   style: TextStyle(
                      //                     fontSize: 16,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //       );
                      // }),

                      Obx(() {
                        return _attendanceController.isClockedIn.value
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: _attendanceController.isOnBreak.value
                                        ? Color(0xffe6b309) // on break (yellow)
                                        : ColorPalette.seaGreen500, // working
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      if (_attendanceController.isLoading.value || _attendanceController.isBreakLoading.value) return;

                                      // If not on break -> start break (ask reason)
                                      if (!_attendanceController.isOnBreak.value) {
                                        final TextEditingController reasonController = TextEditingController();

                                        Get.defaultDialog(
                                          title: "Break Reason",
                                          backgroundColor: Colors.white,
                                          radius: 16,
                                          titleStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          content: StatefulBuilder(
                                            builder: (context, setState) {
                                              String? errorText;
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    TextField(
                                                      controller: reasonController,
                                                      maxLines: 4,
                                                      style: const TextStyle(color: Colors.black, fontSize: 16),
                                                      decoration: InputDecoration(
                                                        labelText: "Reason",
                                                        alignLabelWithHint: true,
                                                        labelStyle: const TextStyle(color: Colors.black87),
                                                        hintText: "Enter your break reason...",
                                                        hintStyle: const TextStyle(color: Colors.black54),
                                                        filled: true,
                                                        fillColor: Colors.grey.shade100,
                                                        errorText: errorText,
                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            style: OutlinedButton.styleFrom(
                                                              foregroundColor: Colors.black87,
                                                              side: BorderSide(color: Colors.grey.shade400),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                            ),
                                                            onPressed: () {
                                                              reasonController.clear();
                                                              setState(() {
                                                                errorText = null;
                                                              });
                                                              Get.back();
                                                            },
                                                            child: const Text("Cancel"),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.blue,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                                            ),
                                                            onPressed: () async {
                                                              final user = _profileController.user.value;
                                                              final reason = reasonController.text.trim();
                                                              final reasonlat = user?.lat != null ? double.tryParse(user!.lat!) : null;
                                                              final reasonlng = user?.lng != null ? double.tryParse(user!.lng!) : null;
                                                              // final reasonlat = user?.lat;
                                                              // final reasonlng = user?.lng;
                                                              if (reason.isEmpty) {
                                                                setState(() {
                                                                  errorText = "Please enter a reason";
                                                                });
                                                                return;
                                                              }
                                                              setState(() {
                                                                errorText = null;
                                                              });

                                                              // call controller breakIn
                                                              await _attendanceController.breakIn(
                                                                reason: reason,
                                                                reasonlat: reasonlat,
                                                                reasonlng: reasonlng,
                                                              );
                                                              reasonController.clear();
                                                              //Get.back();
                                                              Navigator.pop(context);
                                                              // SHOW TOP POPUP
                                                              showTopPopup("Success", "Break started successfully", Colors.orange);
                                                            },
                                                            child: const Text(
                                                              "Submit",
                                                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      else {
                                        // if on break -> breakOut (resume)
                                        final user = _profileController.user.value;
                                        final reasonlat = user?.lat != null ? double.tryParse(user!.lat!) : null;
                                        final reasonlng = user?.lng != null ? double.tryParse(user!.lng!) : null;

                                        await _attendanceController.breakOut(
                                          reasonlat: reasonlat,
                                          reasonlng: reasonlng,
                                        );
                                      }
                                      // else {
                                      //   // if on break -> breakOut (resume)
                                      //   final user = _profileController.user.value;
                                      //   final reasonlat = user!.lat;
                                      //   final reasonlng = user?.lng;
                                      //   await _attendanceController.breakOut(reasonlat: reasonlat, reasonlng: reasonlng);
                                      // }
                                    },
                                    icon: _attendanceController.isBreakLoading.value || _attendanceController.isLoading.value
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                                        : Icon(
                                      _attendanceController.isOnBreak.value ? Ionicons.play : Ionicons.pause,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffff4a12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      if (_attendanceController.isClockOutLoading.value) return;

                                      if (_attendanceController.isOnBreak.value) {
                                        showTopPopup("Error", "Please end your break first", Colors.red);
                                        return;
                                      }
                                      // ---------- SHOW CONFIRMATION DIALOG ----------
                                      Get.defaultDialog(
                                        backgroundColor: Colors.white,
                                        buttonColor: Colors.black,
                                        title: "Confirm Clockout",
                                        middleText: "Are you sure you want to clockout?",
                                        textCancel: "No",cancelTextColor: Colors.black,
                                        textConfirm: "Yes",
                                        confirmTextColor: Colors.white,
                                        onConfirm: () async {
                                          //Get.back(); // close dialog
                                          // ---------------- RUN SAME LOGIC HERE ----------------
                                          Navigator.pop(context);
                                          await _attendanceController.clockOut();
                                        },
                                      );
                                    },
                                    icon: _attendanceController.isClockOutLoading.value
                                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                                        : Icon(Ionicons.stop, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              _attendanceController.formattedTime,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ): ElevatedButton(
                          onPressed: () {
                            // Show confirmation dialog
                            Get.defaultDialog(
                              backgroundColor: Colors.white,
                              buttonColor: Colors.black,
                              title: "Confirm Clock In",
                              middleText: "Are you sure you want to clock in?",
                              textCancel: "No",cancelTextColor: Colors.black,
                              textConfirm: "Yes",
                              confirmTextColor: Colors.white,
                              onConfirm: () async {
                                //Get.back(); // Close dialog
                                // ---- SAME ACTION THAT BUTTON ALREADY DOES ----
                                Navigator.pop(context);
                                await _attendanceController.clockIn();
                                ;
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.seaGreen600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                          ),
                          child: _attendanceController.isLoading.value
                              ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                              : Text(
                            'Clock In',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    // // Dynamically get previous month full name
                    // final String previousMonthName = DateFormat('MMMM').format(
                    //   DateTime(DateTime.now().year, DateTime.now().month - 1),
                    // );
                    // Get previous month short name (e.g., "Sep", "Oct")
                    final String previousMonthName = DateFormat('MMM').format(
                      DateTime(DateTime.now().year, DateTime.now().month - 1),
                    );
                    return SizedBox(
                      width: screenWidth,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /// Follow Up Leads - 1st
                            Container(
                              padding: EdgeInsets.all(10),
                              width: Responsive.isMd(context) ? screenWidth * 0.4 : screenWidth * 0.32,
                              height: Responsive.isMd(context) ? 150 : 200,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,  // Change this to any color you want
                                borderRadius: BorderRadius.circular(10), // optional rounded corners
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _profileController.leadFollowThisMonth.value.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Follow Up Leads',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Responsive.isXs(context) ? 12 : 14,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Last Month : ${_profileController.leadPendingPreviousMonth.value}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Responsive.isXs(context) ? 12 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),

                            /// Pending Leads - 2nd
                            Container(
                              padding: EdgeInsets.all(10),
                              width: Responsive.isMd(context) ? screenWidth * 0.4 : screenWidth * 0.32,
                              height: Responsive.isMd(context) ? 150 : 200,
                              decoration: BoxDecoration(
                                color: Colors.red, // deeper orange background
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1.0, color: Colors.teal), // deeper border
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _profileController.leadPendingThisMonth.value.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white, // deeper text color
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      'Pending Leads',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Responsive.isXs(context) ? 12 : 14
                                      )
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      'Last Month : ${_profileController.leadPendingPreviousMonth.value}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Responsive.isXs(context) ? 12 : 14
                                      )
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),

                            /// Checkins - 3rd
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: Responsive.isMd(context) ? screenWidth * 0.4 : screenWidth * 0.32,
                              height: Responsive.isMd(context) ? 150 : 200,
                              decoration: BoxDecoration(
                                color: Color(0xFF1B5E20), // refreshing green
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1.0, color: Colors.green.withOpacity(0.5)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _profileController.checkinsThisMonth.value.toString(),
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Text('Checkins',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: Responsive.isXs(context) ? 12 : 14)),
                                  SizedBox(height: 5),
                                  Text(
                                    'Last Month : ${_profileController.checkinsPrevious.value}',
                                    style: TextStyle(color: Colors.white, fontSize: Responsive.isXs(context) ? 12 : 14),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(width: 10),

                            /// Days Present - 4th
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => Attendance()),
                            //     );
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(10.0),
                            //     width: Responsive.isMd(context) ? screenWidth * 0.4 : screenWidth * 0.32,
                            //     height: Responsive.isMd(context) ? 150 : 200,
                            //     decoration: BoxDecoration(
                            //       color: Colors.white, // nice purple
                            //       borderRadius: BorderRadius.circular(5),
                            //       border: Border.all(width: 1.0, color: Colors.purple.withOpacity(0.5)),
                            //     ),
                            //     child: Column(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Text(
                            //           '${_profileController.activeDays.value}/${_profileController.workingDays.value}',
                            //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.purple),
                            //         ),
                            //         SizedBox(height: 5),
                            //         Text('Days Present',
                            //             style: TextStyle(
                            //                 color: Colors.purple, fontSize: Responsive.isXs(context) ? 12 : 14)),
                            //         SizedBox(height: 5),
                            //         Text(
                            //           '$previousMonthName : ${_profileController.leadPendingPreviousMonth.value}',
                            //           style: TextStyle(
                            //             color: Colors.purple,
                            //             fontSize: Responsive.isXs(context) ? 12 : 14,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Attendance()),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: Responsive.isMd(context) ? screenWidth * 0.4 : screenWidth * 0.32,
                          height: Responsive.isMd(context) ? 150 : 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1.0, color: Colors.purple.withOpacity(0.5)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${_profileController.activeDays.value}/${_profileController.workingDays.value}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Days Present',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: Responsive.isXs(context) ? 12 : 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '$previousMonthName : ${_profileController.leadPendingPreviousMonth.value}',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: Responsive.isXs(context) ? 12 : 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                          ],
                        ),
                      ),
                    );
                  }),
                  // Obx(() {
                  //   return SizedBox(
                  //     width: screenWidth,
                  //     child: SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         spacing: 10,
                  //         children: [
                  //           Container(
                  //             padding: EdgeInsets.all(10.0),
                  //             width:
                  //                 Responsive.isMd(context)
                  //                     ? screenWidth * 0.4
                  //                     : screenWidth * 0.32,
                  //             height: Responsive.isMd(context) ? 150 : 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.white.withValues(alpha: 0.1),
                  //               borderRadius: BorderRadius.circular(5),
                  //               border: Border.all(
                  //                 width: 1.0,
                  //                 color: Colors.white.withValues(alpha: 0.5),
                  //               ),
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   _profileController.checkinsThisMonth.value
                  //                       .toString(),
                  //                   style: TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Checkins',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Last Month : ${_profileController.checkinsPrevious.value}',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => Attendance(),
                  //                 ),
                  //               );
                  //             },
                  //             child: Container(
                  //               padding: EdgeInsets.all(10.0),
                  //               width:
                  //                   Responsive.isMd(context)
                  //                       ? screenWidth * 0.4
                  //                       : screenWidth * 0.33,
                  //               height: Responsive.isMd(context) ? 150 : 200,
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white.withValues(alpha: 0.1),
                  //                 borderRadius: BorderRadius.circular(5),
                  //                 border: Border.all(
                  //                   width: 1.0,
                  //                   color: Colors.white.withValues(alpha: 0.5),
                  //                 ),
                  //               ),
                  //               child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     '${_profileController.activeDays.value}/${_profileController.workingDays.value}',
                  //                     style: TextStyle(
                  //                       fontSize: 24,
                  //                       fontWeight: FontWeight.w600,
                  //                       color: Colors.white,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 5),
                  //                   Text(
                  //                     'Days Present',
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize:
                  //                           Responsive.isXs(context) ? 12 : 14,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 5),
                  //                   Text(
                  //                     'Last Month : ${_profileController.previousDays.value}',
                  //                     style: TextStyle(
                  //                       color: Colors.white,
                  //                       fontSize:
                  //                           Responsive.isXs(context) ? 12 : 14,
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.all(10.0),
                  //             width:
                  //                 Responsive.isMd(context)
                  //                     ? screenWidth * 0.4
                  //                     : screenWidth * 0.32,
                  //             height: Responsive.isMd(context) ? 150 : 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.white.withValues(alpha: 0.1),
                  //               borderRadius: BorderRadius.circular(5),
                  //               border: Border.all(
                  //                 width: 1.0,
                  //                 color: Colors.white.withValues(alpha: 0.5),
                  //               ),
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   _profileController
                  //                       .leadPendingThisMonth
                  //                       .value
                  //                       .toString(),
                  //                   style: TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Pending Leads',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Last Month : ${_profileController.leadPendingPreviousMonth.value}',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           Container(
                  //             padding: EdgeInsets.all(10.0),
                  //             width:
                  //                 Responsive.isMd(context)
                  //                     ? screenWidth * 0.4
                  //                     : screenWidth * 0.32,
                  //             height: Responsive.isMd(context) ? 150 : 200,
                  //             decoration: BoxDecoration(
                  //               color: Colors.white.withValues(alpha: 0.1),
                  //               borderRadius: BorderRadius.circular(5),
                  //               border: Border.all(
                  //                 width: 1.0,
                  //                 color: Colors.white.withValues(alpha: 0.5),
                  //               ),
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Text(
                  //                   _profileController.leadFollowThisMonth.value
                  //                       .toString(),
                  //                   style: TextStyle(
                  //                     fontSize: 24,
                  //                     fontWeight: FontWeight.w600,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Follow Up Leads',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: 5),
                  //                 Text(
                  //                   'Last Month : ${_profileController.leadPendingPreviousMonth.value}',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize:
                  //                         Responsive.isXs(context) ? 12 : 14,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   );
                  // }),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let\'s Start Today\'s Journey',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Wrap(
                    spacing: 20,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AuthenticatedLayout(newIndex: 2),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: Responsive.isSm(context) ? 150 : 200,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ColorPalette.pictonBlue100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Ionicons.person_add_outline,
                                  color: ColorPalette.pictonBlue500,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'CHECK IN',
                                style: TextStyle(
                                  color: ColorPalette.pictonBlue500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => AuthenticatedLayout(newIndex: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                offset: Offset(0, 2),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          height: Responsive.isSm(context) ? 150 : 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: ColorPalette.seaGreen100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Ionicons.airplane_outline,
                                  color: ColorPalette.seaGreen500,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'TOUR PLAN',
                                style: TextStyle(
                                  color: ColorPalette.seaGreen500,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20.0),
            Divider(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Latest Tours',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Obx(() {
                        return IconButton(
                          onPressed: () async {
                            if (!_profileController.isRefreshing.value) {
                              _profileController.profileDetails();
                            }
                          },
                          icon: AnimatedRotation(
                            turns: _profileController.isRefreshing.value ? 50 : 0,
                            duration: Duration(seconds: 7),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue,
                                    Colors.purple,
                                    Colors.cyan,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Obx(() {
                    return Wrap(
                      spacing: 20,
                      runSpacing: 5,
                      children: List.generate(_profileController.latestTours.length, (
                        index,
                      ) {
                         final tour = _profileController.latestTours[index];
                            //print("hsgvsgsoujbsd ${tour.status}");
                         return SizedBox(
                          width:
                              Responsive.isMd(context)
                                  ? screenWidth - 40
                                  : Responsive.isXl(context)
                                  ? screenWidth / 2 - 40
                                  : screenWidth / 3 - 40,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => ShowTour(
                                  tourPlan: tour,
                                  status: tour.status,
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.0),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 20.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tour.serial_no!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2.0,
                                          horizontal: 15.0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getStatusBackgroundColor(tour.status),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          formatStatusLabel(tour.status),     // 👉 Capital + Rename here
                                          style: TextStyle(
                                            color: getStatusTextColor(tour.status),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xff6d6d6d),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            child: Icon(
                                              Ionicons.time_outline,
                                              size: 15,
                                            ),
                                          ),
                                          SizedBox(width: 10.0),
                                          Text(
                                            '${DateFormat('dd MMM, yy').format(DateTime.parse(tour.startDate))} - ${DateFormat('dd MMM, yy').format(DateTime.parse(tour.endDate))}',
                                            style: TextStyle(
                                              color: Color(0xff9a9a9a),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  if (tour.expenseOverallStatus != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2.0,
                                        horizontal: 7.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getExpenseStatusBackgroundColor(
                                          tour.expenseOverallStatus!.status,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        //mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Expense Status : ",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            tour.expenseOverallStatus!.label, // ✅ DIRECT API LABEL
                                            style: TextStyle(
                                              color: getExpenseStatusTextColor(
                                                tour.expenseOverallStatus!.status,
                                              ),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
