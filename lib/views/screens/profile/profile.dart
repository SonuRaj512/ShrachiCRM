import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/api/profile_controller.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/profile/privacy_policy.dart';
import 'package:shrachi/views/screens/profile/terms_and_conditions.dart';
import 'package:shrachi/views/screens/profile/update_profile.dart';
import 'package:get/get.dart';
import '../../../api/api_const.dart';
import '../../../api/attendance_controller.dart';

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
          backgroundColor: Colors.blue,
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
                                        softWrap: true, // ✅ Line break allow karega
                                        maxLines: 5,    // Optional: Agar aap limits chahte hain
                                        overflow: TextOverflow.visible, // Text ko katne nahi dega, niche bhej dega
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndConditions(),
                            ),
                          );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicy(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: const Icon(
                          Ionicons.log_out_outline,
                          color: Colors.black,
                        ),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () async {
                          // 👇 Show confirmation dialog
                          bool? confirmLogout = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: const Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false); // ❌ Cancel
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () async {
              
                                      // 1️⃣ Clock-out
                                     // await _attendanceController.clockOut();
              
                                      // 2️⃣ Logout API call
                                      bool success = await _apiController.logout();
              
                                      // 3️⃣ Dialog close
                                      Navigator.pop(context, true);
              
                                      // 4️⃣ Snackbar after closing dialog
                                      Future.microtask(() {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success ? "Logout successful!" : "Logout failed!",
                                              ),
                                              backgroundColor: success ? Colors.green : Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
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
