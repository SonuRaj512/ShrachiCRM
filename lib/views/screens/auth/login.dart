import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import '../../../api/api_controller.dart';
import '../../../global.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiController loginController = Get.put(ApiController());


  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isButtonEnabled = false;

  void toggleVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  // ---------------- FORGOT PASSWORD POPUP ----------------
  void _showForgotPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(15),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                Text(
                  'Enter your registered email to receive reset link.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 20),

                // EMAIL INPUT
                TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() => _isButtonEnabled = value.isNotEmpty);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Ionicons.mail_outline, color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.42)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.42)),
                    ),
                    hintText: "Email",
                  ),
                ),

                const SizedBox(height: 30),

                // SEND RESET LINK BUTTON 🚀
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _isButtonEnabled ? ColorPalette.pictonBlue500 : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      if (_emailController.text.trim().isEmpty) {
                        Get.snackbar("Error", "Please enter email",
                            backgroundColor: Colors.red, colorText: Colors.white);
                        return;
                      }

                      Navigator.of(context).pop(); // close popup

                      // API CALL 🔥
                      await loginController.sendResetLink(
                        _emailController.text.trim(),
                      );

                      _showSuccessLinkSent(context);
                    },
                    child: const Text(
                      "Send Reset Link",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- SUCCESS POPUP ----------------
  void _showSuccessLinkSent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(15),
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/reset.json',
                  width: 250,
                ),
                const SizedBox(height: 20),
                Text(
                  'A password reset link has been sent to your email address.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: ColorPalette.pictonBlue200),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Image.asset('assets/images/logo.png', width: 200),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -80,
                      right: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(60),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              width: 20.0,
                              color: Colors.white,
                            ),
                            right: BorderSide(width: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 20.0,
                      ),
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width:
                          Responsive.isMd(context)
                              ? screenWidth * 0.80
                              : screenWidth * 0.40,
                          child: Column(
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 30.0),
                              TextField(
                                controller: _emailController,
                                cursorColor: ColorPalette.pictonBlue500,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Ionicons.mail_outline,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.42,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.42,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Email',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                cursorColor: ColorPalette.pictonBlue500,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Ionicons.key_outline,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: toggleVisibility,
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Ionicons.eye
                                          : Ionicons.eye_off,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.42,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.42,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Password',
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      foregroundColor: Colors.black.withValues(
                                        alpha: 0.6,
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () => _showForgotPassword(context),
                                    child: Text(
                                      'forgot password?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.0),
                              // Row(
                              //   children: [
                              //     Checkbox(
                              //       value: _rememberMe,
                              //       activeColor: Colors.black,
                              //       checkColor: Colors.white,
                              //       side: BorderSide(
                              //         color: Colors.black,
                              //         width: 2,
                              //       ),
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _rememberMe = value ?? false;
                              //         });
                              //       },
                              //     ),
                              //     Text(
                              //       'Remember Me',
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //         color: Colors.black.withValues(
                              //           alpha: 0.7,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 30.0),
                              SizedBox(
                                width:
                                Responsive.isSm(context)
                                    ? double.infinity
                                    : 300,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPalette.pictonBlue500,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 20.0),
                                  ),
                                  onPressed: () {
                                    if (globalUniqueId == null || globalUniqueId!.trim().isEmpty) {
                                      Get.snackbar(
                                        "Error",
                                        "Device Unique ID not generated!",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }
                                    loginController.loginUser(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      globalUniqueId!.trim(),
                                    );
                                    print("Device Unique ID UnicKey:${globalUniqueId}");
                                  },
                                  child: Obx(() => loginController.isLoading.value
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
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
  }
}



// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:ionicons/ionicons.dart';
// // import 'package:lottie/lottie.dart';
// // import 'package:shrachi/views/enums/color_palette.dart';
// // import 'package:shrachi/views/enums/responsive.dart';
// // import '../../../api/api_controller.dart';
// // import '../../../global.dart';
// //
// // class Login extends StatefulWidget {
// //   const Login({super.key});
// //
// //   @override
// //   State<Login> createState() => _LoginState();
// // }
// //
// // class _LoginState extends State<Login> {
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();
// //   final ApiController loginController = Get.put(ApiController());
// //
// //   bool _isPasswordVisible = false;
// //   bool _rememberMe = false;
// //   bool _isButtonEnabled = false;
// //
// //   void toggleVisibility() {
// //     setState(() {
// //       _isPasswordVisible = !_isPasswordVisible;
// //     });
// //   }
// //
// //   // ---------------- FORGOT PASSWORD POPUP ----------------
// //   void _showForgotPassword(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return Dialog(
// //           insetPadding: const EdgeInsets.all(15),
// //           child: Container(
// //             height: MediaQuery.of(context).size.height / 2,
// //             padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Column(
// //               children: [
// //                 const Text(
// //                   'Forgot Password?',
// //                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   'Enter your registered email to receive reset link.',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     fontSize: 14,
// //                     color: Colors.black.withValues(alpha: 0.4),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //
// //                 // EMAIL INPUT
// //                 TextField(
// //                   controller: _emailController,
// //                   onChanged: (value) {
// //                     setState(() => _isButtonEnabled = value.isNotEmpty);
// //                   },
// //                   decoration: InputDecoration(
// //                     prefixIcon: const Icon(Ionicons.mail_outline, color: Colors.black),
// //                     enabledBorder: UnderlineInputBorder(
// //                       borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.42)),
// //                     ),
// //                     focusedBorder: UnderlineInputBorder(
// //                       borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.42)),
// //                     ),
// //                     hintText: "Email",
// //                   ),
// //                 ),
// //
// //                 const SizedBox(height: 30),
// //
// //                 // SEND RESET LINK BUTTON 🚀
// //                 SizedBox(
// //                   width: double.infinity,
// //                   child: ElevatedButton(
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor:
// //                       _isButtonEnabled ? ColorPalette.pictonBlue500 : Colors.grey,
// //                       foregroundColor: Colors.white,
// //                       padding: const EdgeInsets.symmetric(vertical: 15),
// //                     ),
// //                     onPressed: () async {
// //                       if (_emailController.text.trim().isEmpty) {
// //                         Get.snackbar("Error", "Please enter email",
// //                             backgroundColor: Colors.red, colorText: Colors.white);
// //                         return;
// //                       }
// //
// //                       Navigator.of(context).pop(); // close popup
// //
// //                       // API CALL 🔥
// //                       await loginController.sendResetLink(
// //                         _emailController.text.trim(),
// //                       );
// //
// //                       _showSuccessLinkSent(context);
// //                     },
// //                     child: const Text(
// //                       "Send Reset Link",
// //                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   // ---------------- SUCCESS POPUP ----------------
// //   void _showSuccessLinkSent(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return Dialog(
// //           insetPadding: const EdgeInsets.all(15),
// //           child: Container(
// //             height: MediaQuery.of(context).size.height / 2,
// //             padding: const EdgeInsets.all(25),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Lottie.asset(
// //                   'assets/lottie/reset.json',
// //                   width: 250,
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Text(
// //                   'A password reset link has been sent to your email address.',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Colors.black.withValues(alpha: 0.5),
// //                     fontSize: 16,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Container(
// //           decoration: BoxDecoration(color: ColorPalette.pictonBlue200),
// //           child: Column(
// //             children: [
// //               const SizedBox(height: 50),
// //               Image.asset("assets/images/logo.png", width: 200),
// //               Expanded(
// //                 child: Stack(
// //                   children: [
// //                     Positioned(
// //                       top: -80,
// //                       right: -20,
// //                       child: Container(
// //                         width: 100,
// //                         height: 100,
// //                         decoration: const BoxDecoration(
// //                           borderRadius: BorderRadius.only(
// //                             bottomRight: Radius.circular(60),
// //                           ),
// //                           border: Border(
// //                             bottom: BorderSide(width: 20, color: Colors.white),
// //                             right: BorderSide(width: 20, color: Colors.white),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //
// //                     // MAIN WHITE CONTAINER
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
// //                       decoration: const BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
// //                       ),
// //                       child: SingleChildScrollView(
// //                         child: SizedBox(
// //                           width: Responsive.isMd(context)
// //                               ? screenWidth * 0.80
// //                               : screenWidth * 0.40,
// //                           child: Column(
// //                             children: [
// //                               const Text(
// //                                 "Login",
// //                                 style: TextStyle(
// //                                     fontSize: 30, fontWeight: FontWeight.w600),
// //                               ),
// //
// //                               const SizedBox(height: 30),
// //
// //                               // EMAIL FIELD
// //                               TextField(
// //                                 controller: _emailController,
// //                                 decoration: InputDecoration(
// //                                   prefixIcon: const Icon(Ionicons.mail_outline),
// //                                   labelText: "Email",
// //                                   enabledBorder: OutlineInputBorder(
// //                                     borderSide: BorderSide(
// //                                       color: Colors.black.withValues(alpha: 0.4),
// //                                     ),
// //                                   ),
// //                                   focusedBorder: const OutlineInputBorder(),
// //                                 ),
// //                               ),
// //
// //                               const SizedBox(height: 20),
// //
// //                               // PASSWORD FIELD
// //                               TextField(
// //                                 controller: _passwordController,
// //                                 obscureText: !_isPasswordVisible,
// //                                 decoration: InputDecoration(
// //                                   prefixIcon: const Icon(Ionicons.key_outline),
// //                                   labelText: "Password",
// //                                   suffixIcon: IconButton(
// //                                     icon: Icon(
// //                                       _isPasswordVisible
// //                                           ? Ionicons.eye
// //                                           : Ionicons.eye_off,
// //                                     ),
// //                                     onPressed: toggleVisibility,
// //                                   ),
// //                                   enabledBorder: OutlineInputBorder(
// //                                     borderSide: BorderSide(
// //                                       color: Colors.black.withValues(alpha: 0.4),
// //                                     ),
// //                                   ),
// //                                   focusedBorder: const OutlineInputBorder(),
// //                                 ),
// //                               ),
// //
// //                               const SizedBox(height: 10),
// //
// //                               // FORGOT PASSWORD BUTTON
// //                               Row(
// //                                 mainAxisAlignment: MainAxisAlignment.end,
// //                                 children: [
// //                                   TextButton(
// //                                     onPressed: () => _showForgotPassword(context),
// //                                     child: Text(
// //                                       "Forgot password?",
// //                                       style:
// //                                       TextStyle(color: Colors.black.withOpacity(0.6)),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //
// //                               const SizedBox(height: 30),
// //
// //                               // LOGIN BUTTON
// //                               SizedBox(
// //                                 width: 300,
// //                                 child: ElevatedButton(
// //                                   style: ElevatedButton.styleFrom(
// //                                     backgroundColor: ColorPalette.pictonBlue500,
// //                                     padding: const EdgeInsets.symmetric(vertical: 20),
// //                                   ),
// //                                   onPressed: () {
// //                                     if (globalUniqueId == null ||
// //                                         globalUniqueId!.trim().isEmpty) {
// //                                       Get.snackbar("Error", "Device Unique ID missing!",
// //                                           backgroundColor: Colors.red,
// //                                           colorText: Colors.white);
// //                                       return;
// //                                     }
// //
// //                                     loginController.login(
// //                                       _emailController.text.trim(),
// //                                       _passwordController.text.trim(),
// //                                       globalUniqueId!.trim(),
// //                                     );
// //                                   },
// //                                   child: Obx(() => loginController.isLoading.value
// //                                       ? const CircularProgressIndicator(color: Colors.white)
// //                                       : const Text(
// //                                     "Sign In",
// //                                     style: TextStyle(
// //                                         fontSize: 18, fontWeight: FontWeight.w600),
// //                                   )),
// //                                 ),
// //                               ),
// //
// //                               const SizedBox(height: 30),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../main.dart';
//
// class LoginController extends GetxController {
//   var isLoading = false.obs;
//
//   Future<void> loginUser(String email, String password) async {
//     try {
//       isLoading.value = true;
//       final response = await http.post(
//         Uri.parse("https://btlsalescrm.cloud/api/login"),
//         body: {"email": email, "password": password},
//       );
//
//       var data = jsonDecode(response.body);
//
//       if (response.statusCode == 200) {
//         // SUCCESS POPUP
//         showTopPopup("Success", data["message"] ?? "Login Successful", Colors.green);
//       } else {
//         // ERROR POPUP
//         showTopPopup("Error", data["message"] ?? "Invalid Credentials", Colors.red);
//       }
//     } catch (e) {
//       showTopPopup("Error", "Check your internet connection", Colors.orange);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // YEH FUNCTION TOP SE POPUP DIKHAYEGA (NO ERROR METHOD)
//   void showTopPopup(String title, String message, Color color) {
//     final overlay = Get.key.currentState?.overlay; // Direct overlay access
//     if (overlay == null) return;
//
//     late OverlayEntry overlayEntry;
//     overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: MediaQuery.of(context).padding.top + 10, // iPhone Notch ke niche
//         left: 20,
//         right: 20,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
//                 const SizedBox(height: 4),
//                 Text(message, style: const TextStyle(color: Colors.white, fontSize: 14)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//     // Overlay mein insert karein
//     overlay.insert(overlayEntry);
//
//     // 3 second baad automatic hata dein
//     Future.delayed(const Duration(seconds: 3), () {
//       overlayEntry.remove();
//     });
//   }
// }
//
//
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//   final controller = Get.put(LoginController());
//   final email = TextEditingController();
//   final pass = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("BTL Login")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(controller: email, decoration: const InputDecoration(hintText: "Email")),
//             TextField(controller: pass, obscureText: true, decoration: const InputDecoration(hintText: "Password")),
//             const SizedBox(height: 20),
//             Obx(() => ElevatedButton(
//               onPressed: controller.isLoading.value ? null : () => controller.loginUser(email.text, pass.text),
//               child: controller.isLoading.value ? const CircularProgressIndicator() : const Text("Login"),
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }