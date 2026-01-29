// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shrachi/api/api_controller.dart';
// import 'package:shrachi/api/profile_controller.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:shrachi/views/screens/profile/Policy_Screen.dart';
// import 'package:shrachi/views/screens/profile/terms_and_conditions.dart';
// import 'package:shrachi/views/screens/profile/update_profile.dart';
// import 'package:get/get.dart';
// import '../../../api/api_const.dart';
// import '../../../api/attendance_controller.dart';
//
// class Profile extends StatefulWidget {
//   const Profile({super.key});
//
//   @override
//   State<Profile> createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//   final AttendanceController _attendanceController = Get.put(AttendanceController(),);
//   final ProfileController _profileController = Get.put(ProfileController());
//   final ApiController _apiController = Get.put(ApiController());
//   final ImagePicker _picker = ImagePicker();
//   List<XFile> pickedImages = [];
//   Map<String, String> errors = {};
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             "My Profile",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           automaticallyImplyLeading: false,
//         ),
//         body: Align(
//           alignment: Alignment.topCenter,
//           child: SizedBox(
//             width:
//                 Responsive.isMd(context)
//                     ? screenWidth
//                     : Responsive.isXl(context)
//                     ? screenWidth * 0.60
//                     : screenWidth * 0.40,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Obx(() {
//                 final user = _profileController.user.value;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Profile Image on top
//                           CircleAvatar(
//                             radius: 50,
//                             backgroundColor: Colors.grey[300],
//                         backgroundImage: NetworkImage(
//                       user?.image != null
//                       ? '$imageUrl${user?.image}'
//                           : 'https://placehold.co/400x400/png?text=no-image',
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                          Text(
//                            user?.name ?? '',
//                            style: const TextStyle(
//                              fontSize: 22,
//                              fontWeight: FontWeight.bold,
//                              color: Colors.black87,
//                            ),
//                          ),
//                          SizedBox(height: 20),
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Column(
//                                 children: [
//                                   Icon(
//                                     Ionicons.person_outline,
//                                     size: 18,
//                                     color: Colors.black,
//                                   ),
//                                  SizedBox(height: 12,),
//                                   Icon(
//                                     Ionicons.location_outline, // Use location icon for better meaning
//                                     size: 18,
//                                     color: Colors.black54,
//                                   ),
//                                   SizedBox(height: 12,),
//                                   Icon(
//                                     Icons.phone,
//                                     size: 16,
//                                     color: Colors.black54,
//                                   ),
//                                   SizedBox(height: 12,),
//                                   Icon(
//                                     Ionicons.calendar_outline,
//                                     size: 16,
//                                     color: Colors.black54,
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(width: 20,),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     user?.designation ?? 'Nil',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8,),
//                                   Text(
//                                     user?.address ?? 'Nil',
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.black54,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Text(
//                                     user?.phone ?? 'Nil'
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Text(
//                                     user!.joinDate != null
//                                         ? DateFormat('dd-MM-yyyy',).format(DateTime.parse(user.joinDate!)) : 'Nil',
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                          // Designation
//                          // Row(
//                          //   mainAxisAlignment: MainAxisAlignment.start,
//                          //   children: [
//                          //     const Icon(
//                          //       Ionicons.person_outline,
//                          //       size: 18,
//                          //       color: Colors.black,
//                          //     ),
//                          //     const SizedBox(width: 6),
//                          //     Padding(
//                          //       padding: const EdgeInsets.only(top: 17.0),
//                          //       child: Text(
//                          //         user?.designation ?? 'N/A',
//                          //         style: const TextStyle(
//                          //           fontSize: 14,
//                          //           color: Colors.black54,
//                          //         ),
//                          //       ),
//                          //     ),
//                          //   ],
//                          // ),
//                          // //const SizedBox(height: 12),
//                          // // Address Row
//                          // Row(
//                          //   mainAxisAlignment: MainAxisAlignment.start,
//                          //   children: [
//                          //     const Icon(
//                          //       Ionicons.location_outline, // Use location icon for better meaning
//                          //       size: 18,
//                          //       color: Colors.black54,
//                          //     ),
//                          //     const SizedBox(width: 6),
//                          //     Flexible(
//                          //       child: Text(
//                          //         user?.address ?? 'Please update your address from your Profile',
//                          //         textAlign: TextAlign.center,
//                          //         style: const TextStyle(
//                          //           fontSize: 14,
//                          //           color: Colors.black54,
//                          //         ),
//                          //       ),
//                          //     ),
//                          //   ],
//                          // ),
//                          // //  const SizedBox(height: 12),
//                          // // // Address Row
//                          // // Row(
//                          // //   mainAxisAlignment: MainAxisAlignment.start,
//                          // //   children: [
//                          // //     const Icon(
//                          // //       Ionicons.location_outline, // Use location icon for better meaning
//                          // //       size: 18,
//                          // //       color: Colors.black54,
//                          // //     ),
//                          // //     const SizedBox(width: 6),
//                          // //     Flexible(
//                          // //       child: Text(
//                          // //         user?.zone_code?.isNotEmpty == true ? user!.zone_code! : 'N/A',
//                          // //         style: const TextStyle(fontSize: 14, color: Colors.black54),
//                          // //       ),
//                          // //     ),
//                          // //
//                          // //   ],
//                          // // ),
//                          // //  const SizedBox(height: 12),
//                          // // // Address Row
//                          // // Row(
//                          // //   mainAxisAlignment: MainAxisAlignment.start,
//                          // //   children: [
//                          // //     const Icon(
//                          // //       Ionicons.location_outline, // Use location icon for better meaning
//                          // //       size: 18,
//                          // //       color: Colors.black54,
//                          // //     ),
//                          // //     const SizedBox(width: 6),
//                          // //     Flexible(
//                          // //       child: Text(
//                          // //         user?.state_code ?? 'N/A',
//                          // //         textAlign: TextAlign.center,
//                          // //         style: const TextStyle(
//                          // //           fontSize: 14,
//                          // //           color: Colors.black54,
//                          // //         ),
//                          // //       ),
//                          // //     ),
//                          // //   ],
//                          // // ),
//                          // const SizedBox(height: 12),
//                          // // Calendar Row
//                          // Row(
//                          //   mainAxisAlignment: MainAxisAlignment.start,
//                          //   children: [
//                          //     Icon(
//                          //       Ionicons.calendar_outline,
//                          //       size: 16,
//                          //       color: Colors.black54,
//                          //     ),
//                          //     SizedBox(width: 6),
//                          //     Text(
//                          //       user!.joinDate != null
//                          //         ? DateFormat('dd-MM-yyyy',).format(DateTime.parse(user.joinDate!)) : 'N/A',
//                          //     )
//                          //   ],
//                          // ),
//                          //  // Edit Button at top-right corner
//                           const SizedBox(height: 12),
//                           Align(
//                            alignment: Alignment.center,
//                             child: IconButton(
//                               icon: Row(
//                                 children: [
//                                   Text("Edit"),
//                                   const Icon(
//                                     Ionicons.pencil,
//                                     color: ColorPalette.pictonBlue500,
//                                     size: 14,
//                                   ),
//                                 ],
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => UpdateProfile(),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // Row(
//                     //   crossAxisAlignment: CrossAxisAlignment.start,
//                     //   children: [
//                     //     const CircleAvatar(
//                     //       radius: 40,
//                     //       backgroundImage: NetworkImage(
//                     //         'https://placehold.co/400x400/png?text=no-image',
//                     //       ),
//                     //     ),
//                     //     const SizedBox(width: 16),
//                     //     Expanded(
//                     //       child: Column(
//                     //         crossAxisAlignment: CrossAxisAlignment.start,
//                     //         children: [
//                     //           Text(
//                     //             user?.name ?? '',
//                     //             style: const TextStyle(
//                     //               fontSize: 22,
//                     //               fontWeight: FontWeight.bold,
//                     //               color: Colors.black,
//                     //             ),
//                     //           ),
//                     //           const SizedBox(height: 6),
//                     //           Row(
//                     //             children: [
//                     //               const Icon(
//                     //                 Ionicons.person_outline,
//                     //                 size: 18,
//                     //                 color: Colors.black,
//                     //               ),
//                     //               const SizedBox(width: 6),
//                     //               Expanded( //Add this for proper overflow handling inside Row
//                     //                 child: Text(
//                     //                   user?.designation ?? 'N/A',
//                     //                   maxLines: 1, //only one line show
//                     //                   overflow: TextOverflow.ellipsis, //if text is long => show ...
//                     //                   style: const TextStyle(
//                     //                     fontSize: 14,
//                     //                     color: Colors.black,
//                     //                   ),
//                     //                 ),
//                     //               ),
//                     //             ],
//                     //           ),
//                     //           const SizedBox(height: 6),
//                     //           Row(
//                     //             crossAxisAlignment: CrossAxisAlignment.start,
//                     //             children: [
//                     //               const Icon(
//                     //                 Ionicons.home_outline,
//                     //                 size: 18,
//                     //                 color: Colors.black,
//                     //               ),
//                     //               const SizedBox(width: 6),
//                     //               Expanded(child: Text(user?.address ?? 'N/A')),
//                     //             ],
//                     //           ),
//                     //           const SizedBox(height: 6),
//                     //           const Row(
//                     //             children: [
//                     //               Icon(
//                     //                 Ionicons.calendar_outline,
//                     //                 size: 18,
//                     //                 color: Colors.black,
//                     //               ),
//                     //               SizedBox(width: 6),
//                     //               Text("Monday 25 Jul, 2025"),
//                     //             ],
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //     IconButton(
//                     //       onPressed: () {
//                     //         Navigator.push(
//                     //           context,
//                     //           MaterialPageRoute(
//                     //             builder: (context) => UpdateProfile(),
//                     //           ),
//                     //         );
//                     //       },
//                     //       icon: const Icon(
//                     //         Ionicons.pencil,
//                     //         color: ColorPalette.pictonBlue500,
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     Divider(color: Colors.grey,),
//                     const Text(
//                       "Others",
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     ListTile(
//                       leading: const Icon(
//                         Ionicons.document_text_outline,
//                         color: Colors.black,
//                       ),
//                       title: const Text(
//                         "Terms & Conditions",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => TermsAndConditions(),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     ListTile(
//                       leading: const Icon(
//                         Ionicons.shield_checkmark_outline,
//                         color: Colors.black,
//                       ),
//                       title: const Text(
//                         "Privacy Policy",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PrivacyPolicy(),
//                           ),
//                         );
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     ListTile(
//                       leading: const Icon(
//                         Ionicons.log_out_outline,
//                         color: Colors.black,
//                       ),
//                       title: const Text(
//                         "Logout",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       onTap: () async {
//                         // 👇 Show confirmation dialog
//                         bool? confirmLogout = await showDialog<bool>(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               backgroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               title: const Text(
//                                 "Logout",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               content: const Text("Are you sure you want to logout?"),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context, false); // ❌ Cancel
//                                   },
//                                   child: const Text(
//                                     "Cancel",
//                                     style: TextStyle(color: Colors.black),
//                                   ),
//                                 ),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   onPressed: () async {
//
//                                     // 1️⃣ Clock-out
//                                    // await _attendanceController.clockOut();
//
//                                     // 2️⃣ Logout API call
//                                     bool success = await _apiController.logout();
//
//                                     // 3️⃣ Dialog close
//                                     Navigator.pop(context, true);
//
//                                     // 4️⃣ Snackbar after closing dialog
//                                     Future.microtask(() {
//                                       if (context.mounted) {
//                                         ScaffoldMessenger.of(context).showSnackBar(
//                                           SnackBar(
//                                             content: Text(
//                                               success ? "Logout successful!" : "Logout failed!",
//                                             ),
//                                             backgroundColor: success ? Colors.green : Colors.red,
//                                             behavior: SnackBarBehavior.floating,
//                                             duration: const Duration(seconds: 1),
//                                           ),
//                                         );
//                                       }
//                                     });
//                                   },
//                                   child: const Text(
//                                     "Logout",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                                 // ElevatedButton(
//                                 //   style: ElevatedButton.styleFrom(
//                                 //     backgroundColor: Colors.red,
//                                 //     shape: RoundedRectangleBorder(
//                                 //       borderRadius: BorderRadius.circular(8),
//                                 //     ),
//                                 //   ),
//                                 //   onPressed: () async {
//                                 //     await _attendanceController.clockOut();
//                                 //     /// Step 1: Auto clock-out
//                                 //     //await AttendanceController.checkAutoClockOut();
//                                 //
//                                 //     /// Step 2: Logout API call
//                                 //     //await _apiController.logout();
//                                 //
//                                 //     /// Step 3: Close dialog
//                                 //     Navigator.pop(context, true);
//                                 //
//                                 //     /// Step 4: Show snackbar *after* dialog closes safely
//                                 //     Future.microtask(() {
//                                 //       if (context.mounted) {
//                                 //         ScaffoldMessenger.of(context).showSnackBar(
//                                 //           const SnackBar(
//                                 //             content: Text("Logout successful!"),
//                                 //             backgroundColor: Colors.green,
//                                 //             behavior: SnackBarBehavior.floating,
//                                 //             duration: Duration(seconds: 1),
//                                 //           ),
//                                 //         );
//                                 //       }
//                                 //     });
//                                 //   },
//                                 //   child: const Text(
//                                 //     "Logout",
//                                 //     style: TextStyle(color: Colors.white),
//                                 //   ),
//                                 // ),
//                               ],
//                             );
//                           },
//                         );
//                         // 👇 If user confirmed, call logout API
//                         // if (confirmLogout == true) {
//                         //   await _apiController.logout();
//                         //   print("✅ User confirmed logout");
//                         // } else {
//                         //   print("❌ User canceled logout");
//                         // }
//                       },
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/api/ProfileController/profile_controller.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/profile/update_profile.dart';
import 'package:get/get.dart';
import '../../../api/api_const.dart';
import '../../../api/attendance_controller.dart';
import 'Policy_Screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AttendanceController _attendanceController = Get.put(AttendanceController(),);
  final ProfileController _profileController = Get.put(ProfileController());
  final ApiController _apiController = Get.put(ApiController());
  final ImagePicker _picker = ImagePicker();
  List<XFile> pickedImages = [];
  Map<String, String> errors = {};
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Center(
            child: Text(
              "My Profile",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: Responsive.isMd(context)
                ? screenWidth
                : Responsive.isXl(context)
                ? screenWidth * 0.60
                : screenWidth * 0.40,

            // ✅ 1. RefreshIndicator Add Kiya
            child: RefreshIndicator(
              color: ColorPalette.pictonBlue500, // Refresh icon ka color
              onRefresh: () async {
                // ✅ 2. Refresh hone par controller se data dubara mangwayein
                // Maan lijiye aapke controller mein 'profileDetails' ya 'fetchProfile' naam ka method hai
                await _profileController.profileDetails();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Obx(() {
                  final user = _profileController.user.value;
                  if (user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Image on top
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: NetworkImage(
                                user?.image != null
                                    ? '$imageUrl${user?.image}'
                                    : 'https://placehold.co/400x400/png?text=no-image',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user?.name ?? 'Nill',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Ionicons.person_outline,
                                      size: 18,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 12,),
                                    Icon(
                                      Ionicons.location_outline, // Use location icon for better meaning
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(height: 30,),
                                    Icon(
                                      Ionicons.locate_outline, // Use location icon for better meaning
                                      size: 18,
                                      color: Colors.black54,
                                    ),
                                    // Icon(
                                    //   Icons.phone,
                                    //   size: 16,
                                    //   color: Colors.black54,
                                    // ),
                                    // SizedBox(height: 12,),
                                    // Icon(
                                    //   Ionicons.calendar_outline,
                                    //   size: 16,
                                    //   color: Colors.black54,
                                    // ),
                                  ],
                                ),
                                SizedBox(width: 20,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.designation ?? 'Nil',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Text(
                                        user.address ?? 'Nil',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                        softWrap: true,
                                        maxLines: 5,
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(height: 10,),
                                      Text("${user.stateDescription ?? 'Nil'} (${user.state})")
                                      // Text(
                                      //   user?.phone ?? 'Nil'
                                      // ),
                                      // SizedBox(height: 10,),
                                      // Text(
                                      //   user!.joinDate != null
                                      //       ? DateFormat('dd-MM-yyyy',).format(DateTime.parse(user.joinDate!)) : 'Nil',
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Row(
                                  children: [
                                    Text("Edit"),
                                    const Icon(
                                      Ionicons.pencil,
                                      color: ColorPalette.pictonBlue500,
                                      size: 14,
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateProfile(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey,),
                      const Text(
                        "Others",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(
                          Ionicons.document_text_outline,
                          color: Colors.black,
                        ),
                        title: const Text(
                          "Terms & Conditions",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Get.to(() => PolicyScreen(
                            policyType: "$terms_conditions",
                            appBarTitle: "Terms & Conditions",
                          ));
                        },
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(
                          Ionicons.shield_checkmark_outline,
                          color: Colors.black,
                        ),
                        title: const Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Get.to(() => PolicyScreen(
                            policyType: "$privacy_policy",
                            appBarTitle: "Privacy Policy",
                          ));
                        },
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(Ionicons.log_out_outline, color: Colors.black),
                        title: const Text("Logout", style: TextStyle(color: Colors.black)),
                        onTap: () async {
                          // Show confirmation dialog to the user
                          bool? confirmLogout = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
                                content: const Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false), // User cancelled
                                    child: const Text("Cancel", style: TextStyle(color: Colors.black)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () async {
                                      // Call the logout method (now returns Future<bool>)
                                      bool success = await _apiController.logout();

                                      // Close the dialog
                                      if (context.mounted) Navigator.pop(context, true);

                                      // Show feedback snackbar
                                      Future.microtask(() {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(success ? "Logout successful!" : "Logout failed!"),
                                              backgroundColor: success ? Colors.green : Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: const Text("Logout", style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      // ListTile(
                      //   leading: const Icon(
                      //     Ionicons.log_out_outline,
                      //     color: Colors.black,
                      //   ),
                      //   title: const Text(
                      //     "Logout",
                      //     style: TextStyle(color: Colors.black),
                      //   ),
                      //   onTap: () async {
                      //     // 👇 Show confirmation dialog
                      //     bool? confirmLogout = await showDialog<bool>(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           backgroundColor: Colors.white,
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12),
                      //           ),
                      //           title: const Text(
                      //             "Logout",
                      //             style: TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //           content: const Text("Are you sure you want to logout?"),
                      //           actions: [
                      //             TextButton(
                      //               onPressed: () {
                      //                 Navigator.pop(context, false); // ❌ Cancel
                      //               },
                      //               child: const Text(
                      //                 "Cancel",
                      //                 style: TextStyle(color: Colors.black),
                      //               ),
                      //             ),
                      //             ElevatedButton(
                      //               style: ElevatedButton.styleFrom(
                      //                 backgroundColor: Colors.red,
                      //                 shape: RoundedRectangleBorder(
                      //                   borderRadius: BorderRadius.circular(8),
                      //                 ),
                      //               ),
                      //               onPressed: () async {
                      //                 // 2️⃣ Logout API call
                      //                 bool success = await _apiController.logout();
                      //
                      //                 // 3️⃣ Dialog close
                      //                 Navigator.pop(context, true);
                      //
                      //                 // 4️⃣ Snackbar after closing dialog
                      //                 Future.microtask(() {
                      //                   if (context.mounted) {
                      //                     ScaffoldMessenger.of(context).showSnackBar(
                      //                       SnackBar(
                      //                         content: Text(
                      //                           success ? "Logout successful!" : "Logout failed!",
                      //                         ),
                      //                         backgroundColor: success ? Colors.green : Colors.red,
                      //                         behavior: SnackBarBehavior.floating,
                      //                         duration: const Duration(seconds: 1),
                      //                       ),
                      //                     );
                      //                   }
                      //                 });
                      //               },
                      //               child: const Text(
                      //                 "Logout",
                      //                 style: TextStyle(color: Colors.white),
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}