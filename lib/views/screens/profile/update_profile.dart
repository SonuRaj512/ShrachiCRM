// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:shrachi/api/profile_controller.dart';
// import 'package:shrachi/views/enums/color_palette.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import 'package:get/get.dart';
//
// import '../../../models/ProfileStatesModel.dart';
//
// class UpdateProfile extends StatefulWidget {
//   const UpdateProfile({super.key});
//
//   @override
//   State<UpdateProfile> createState() => _UpdateProfileState();
// }
//
// class _UpdateProfileState extends State<UpdateProfile> {
//   File? _imageFile;
//
//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.camera_alt, color: Colors.black),
//                 title: const Text("Take Photo", style: TextStyle(color: Colors.black),),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final pickedFile = await ImagePicker().pickImage(
//                     source: ImageSource.camera,
//                     imageQuality: 80,
//                   );
//                   if (pickedFile != null) {
//                     setState(() {
//                       _imageFile = File(pickedFile.path);
//                     });
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.photo_library, color: Colors.black),
//                 title: const Text("Choose from Gallery", style: TextStyle(color: Colors.black),),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   final pickedFile = await ImagePicker().pickImage(
//                     source: ImageSource.gallery,
//                     imageQuality: 80,
//                   );
//                   if (pickedFile != null) {
//                     setState(() {
//                       _imageFile = File(pickedFile.path);
//                     });
//                   }
//                 },
//               ),
//               const SizedBox(height: 10),
//               Center(
//                 child: TextButton(
//                   child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//
//   final ProfileController _profileController = Get.put(ProfileController());
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _phoneController = TextEditingController();
//   bool _isLoadingLocation = false;
//   String? selectedState;
//
//   late double lat = 0.00;
//   late double lng = 0.00;
//
//   Future<void> fetchHomeLocation() async {
//     try {
//       setState(() {
//         _isLoadingLocation = true;
//         _addressController.text = 'please wait ...';
//       });
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           print("Location permissions are denied");
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         print("Location permissions are permanently denied");
//         return;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         locationSettings: const LocationSettings(
//           accuracy: LocationAccuracy.high,
//         ),
//       );
//
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         lat = position.latitude;
//         lng = position.longitude;
//         String address = "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
//         _addressController.text = address;
//       }
//     } catch (e) {
//       print("Error fetching location: $e");
//     } finally {
//       setState(() {
//         _isLoadingLocation = false;
//       });
//     }
//   }
//
//   Future<void> getLatLngFromAddress(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         lat = locations.first.latitude;
//         lng = locations.first.longitude;
//       }
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _profileController.fetchStates();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = _profileController.user.value;
//       if (user != null) {
//         _nameController.text = user.name;
//         _emailController.text = user.email;
//         _addressController.text = user.address!;
//         //_phoneController.text = user.phone;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             "Update Profile",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: Align(
//           alignment: Alignment.topCenter,
//           child: SizedBox(
//             width:Responsive.isMd(context)
//                     ? screenWidth
//                     : Responsive.isXl(context)
//                     ? screenWidth * 0.60
//                     : screenWidth * 0.40,
//             child: Obx(() {
//               final user = _profileController.user.value;
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),
//                     Stack(
//                       alignment: Alignment.bottomRight,
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundImage:
//                               _imageFile != null
//                                   ? FileImage(_imageFile!)
//                                   : const NetworkImage(
//                                         'https://placehold.co/400x400/png?text=no-image',
//                                       )
//                                       as ImageProvider,
//                         ),
//                         Positioned(
//                           bottom: -5,
//                           right: -5,
//                           child: IconButton(
//                             icon: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.black,
//                             ),
//                             onPressed: _pickImage,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 30),
//                     TextField(
//                       controller: _nameController,
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(
//                           Ionicons.person_outline,
//                           color: Colors.black,
//                         ),
//                         labelText: 'Username',
//                         labelStyle: const TextStyle(color: Colors.black),
//                         hintText: 'Username',
//                         hintStyle: const TextStyle(color: Colors.black54),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.black,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextField(
//                       controller: _emailController,
//                       style: const TextStyle(color: Colors.black),
//                       decoration: InputDecoration(
//                         prefixIcon: const Icon(
//                           Ionicons.mail_outline,
//                           color: Colors.black,
//                         ),
//                         labelText: 'Email',
//                         labelStyle: const TextStyle(color: Colors.black),
//                         hintText: 'Email',
//                         hintStyle: const TextStyle(color: Colors.black54),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(color: Colors.black),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.black,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     // if (!user!.isEdited) ...{
//                     //   const SizedBox(height: 20),
//                     //   TextField(
//                     //     controller: _addressController,
//                     //     style: const TextStyle(color: Colors.black),
//                     //     readOnly: _isLoadingLocation,
//                     //     decoration: InputDecoration(
//                     //       prefixIcon: const Icon(
//                     //         Ionicons.location_outline,
//                     //         color: Colors.black,
//                     //       ),
//                     //       labelText: 'Address',
//                     //       labelStyle: const TextStyle(color: Colors.black),
//                     //       hintText: 'Address',
//                     //       hintStyle: const TextStyle(color: Colors.black54),
//                     //       border: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(12),
//                     //         borderSide: const BorderSide(color: Colors.black),
//                     //       ),
//                     //       enabledBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(12),
//                     //         borderSide: const BorderSide(color: Colors.black),
//                     //       ),
//                     //       focusedBorder: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(12),
//                     //         borderSide: const BorderSide(
//                     //           color: Colors.black,
//                     //           width: 2,
//                     //         ),
//                     //       ),
//                     //       suffixIcon: IconButton(
//                     //         icon: const Icon(
//                     //           Icons.my_location,
//                     //           color: Colors.black,
//                     //         ),
//                     //         onPressed: () {
//                     //           fetchHomeLocation();
//                     //         },
//                     //       ),
//                     //     ),
//                     //   ),
//                     // },
//                     // const SizedBox(height: 20),
//                     // Obx(() {
//                     //   if (_profileController.isLoading.value) {
//                     //     return const Center(child: CircularProgressIndicator());
//                     //   }
//                     //   return DropdownButtonFormField<StateModel>(
//                     //     dropdownColor: Colors.white,
//                     //     decoration: InputDecoration(
//                     //       labelText: 'Select State',
//                     //       border: OutlineInputBorder(
//                     //         borderRadius: BorderRadius.circular(10),
//                     //       ),
//                     //     ),
//                     //     value: selectedState == null
//                     //         ? null
//                     //         : _profileController.statesList.firstWhereOrNull(
//                     //           (state) => state.description == selectedState,
//                     //     ),
//                     //     items: _profileController.statesList.map((stateModel) {
//                     //       return DropdownMenuItem<StateModel>(
//                     //         value: stateModel,
//                     //         child: Text(stateModel.description),
//                     //       );
//                     //     }).toList(),
//                     //     onChanged: (value) {
//                     //       setState(() {
//                     //         selectedState = value!.description;
//                     //         _stateController.text = value.description;
//                     //       });
//                     //     },
//                     //   );
//                     // }),
//                     // TextField(
//                     //   controller: _phoneController,
//                     //   keyboardType: TextInputType.phone,
//                     //   style: const TextStyle(color: Colors.black),
//                     //   decoration: InputDecoration(
//                     //     prefixIcon: const Icon(
//                     //       Ionicons.call_outline,
//                     //       color: Colors.black,
//                     //     ),
//                     //     labelText: 'Phone',
//                     //     labelStyle: const TextStyle(color: Colors.black),
//                     //     hintText: 'Phone',
//                     //     hintStyle: const TextStyle(color: Colors.black54),
//                     //     border: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(12),
//                     //       borderSide: const BorderSide(color: Colors.black),
//                     //     ),
//                     //     enabledBorder: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(12),
//                     //       borderSide: const BorderSide(color: Colors.black),
//                     //     ),
//                     //     focusedBorder: OutlineInputBorder(
//                     //       borderRadius: BorderRadius.circular(12),
//                     //       borderSide: const BorderSide(
//                     //         color: Colors.black,
//                     //         width: 2,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     if (!user!.isEdited) ...{
//                       const SizedBox(height: 20),
//
//                       // 🏠 Address Field
//                       TextField(
//                         controller: _addressController,
//                         style: const TextStyle(color: Colors.black),
//                         readOnly: _isLoadingLocation,
//                         decoration: InputDecoration(
//                           prefixIcon: const Icon(
//                             Ionicons.location_outline,
//                             color: Colors.black,
//                           ),
//                           labelText: 'Address',
//                           labelStyle: const TextStyle(color: Colors.black),
//                           hintText: 'Address',
//                           hintStyle: const TextStyle(color: Colors.black54),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: Colors.black),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(color: Colors.black),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: const BorderSide(
//                               color: Colors.black,
//                               width: 2,
//                             ),
//                           ),
//                           suffixIcon: IconButton(
//                             icon: const Icon(
//                               Icons.my_location,
//                               color: Colors.black,
//                             ),
//                             onPressed: () {
//                               fetchHomeLocation();
//                             },
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(height: 20),
//
//                       // 🌍 State Dropdown (Only show when !user.isEdited)
//                       Obx(() {
//                         if (_profileController.isLoading.value) {
//                           return const Center(child: CircularProgressIndicator());
//                         }
//                         return DropdownButtonFormField<StateModel>(
//                           dropdownColor: Colors.white,
//                           decoration: InputDecoration(
//                             labelText: 'Select State',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           value: selectedState == null
//                               ? null
//                               : _profileController.statesList.firstWhereOrNull(
//                                 (state) => state.description == selectedState,
//                           ),
//                           items: _profileController.statesList.map((stateModel) {
//                             return DropdownMenuItem<StateModel>(
//                               value: stateModel,
//                               child: Text(stateModel.description),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedState = value!.description;
//                               _stateController.text = value.description;
//                             });
//                           },
//                         );
//                       }),
//                     },
//                     const SizedBox(height: 40),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorPalette.pictonBlue500,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () async {
//                           await getLatLngFromAddress(_addressController.text);
//                           if (lat != 0.00 && lng != 0.00) {
//                             final selectedStateModel = _profileController.statesList
//                                 .firstWhereOrNull((s) => s.description == selectedState);
//
//                             if (selectedStateModel == null) {
//                               Get.snackbar('Error', 'Please select a valid state');
//                               return;
//                             }
//                             await _profileController.editProfile(
//                               name: _nameController.text.trim(),
//                               email: _emailController.text.trim(),
//                               address: _addressController.text.trim(),
//                               // state: jsonEncode({
//                               //   "code": selectedStateModel.code,
//                               //   "description": selectedStateModel.description,
//                               // }), // 👈 dono bhej rahe hain
//                               state: selectedStateModel.code,
//                               state_description:selectedStateModel.description,
//                               lat: lat.toString(),
//                               lng: lng.toString(),
//                               image: _imageFile,
//                             );
//                           } else {
//                             print("Invalid coordinates");
//                           }
//                         },
//
//                         // onPressed: () async {
//                         //   await getLatLngFromAddress(_addressController.text);
//                         //   if (lat != 0.00 && lng != 0.00) {
//                         //     await _profileController.editProfile(
//                         //       name: _nameController.text.toString(),
//                         //       email: _emailController.text.toString(),
//                         //       //phone: _phoneController.text.toString(),
//                         //       address: _addressController.text.toString(),
//                         //       state: _stateController.text.toString(),
//                         //       lat: lat.toString(),
//                         //       lng: lng.toString(),
//                         //       image: _imageFile ,
//                         //     );
//                         //   } else {
//                         //     print("Invalid coordinates");
//                         //   }
//                         // },
//                         child: _profileController.isLoading.value
//                                 ? CircularProgressIndicator(color: Colors.white)
//                                 : Text(
//                                   'Update',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/ProfileController/profile_controller.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:get/get.dart';
import '../../../models/ProfileStatesModel.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _imageFile;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.black),
                title: const Text("Take Photo", style: TextStyle(color: Colors.black),),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.black),
                title: const Text("Choose from Gallery", style: TextStyle(color: Colors.black),),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _imageFile = File(pickedFile.path);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  final ProfileController _profileController = Get.put(ProfileController());
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoadingLocation = false;
  String? selectedState;

  late double lat = 0.00;
  late double lng = 0.00;

  Future<void> fetchHomeLocation() async {
    try {
      setState(() {
        _isLoadingLocation = true;
        _addressController.text = 'please wait ...';
      });
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Location permissions are denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        lat = position.latitude;
        lng = position.longitude;
        String address = "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        _addressController.text = address;
      }
    } catch (e) {
      print("Error fetching location: $e");
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        lat = locations.first.latitude;
        lng = locations.first.longitude;
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.fetchStates();
      final user = _profileController.user.value;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _addressController.text = user.address!;
        //_phoneController.text = user.phone;
      }
    });
  }
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
          title: const Text(
            "Update Profile",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width:Responsive.isMd(context)
                ? screenWidth
                : Responsive.isXl(context)
                ? screenWidth * 0.60
                : screenWidth * 0.40,
            child: Obx(() {
              final user = _profileController.user.value;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : const NetworkImage(
                            'https://placehold.co/400x400/png?text=no-image',
                          )
                          as ImageProvider,
                        ),
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Ionicons.person_outline,
                          color: Colors.black,
                        ),
                        labelText: 'Username',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Username',
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Ionicons.mail_outline,
                          color: Colors.black,
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (!user!.isEdited) ...{
                      const SizedBox(height: 20),
                      // 🏠 Address Field
                      TextField(
                        controller: _addressController,
                        style: const TextStyle(color: Colors.black),
                        readOnly: _isLoadingLocation,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Ionicons.location_outline,
                            color: Colors.black,
                          ),
                          labelText: 'Address',
                          labelStyle: const TextStyle(color: Colors.black),
                          hintText: 'Address',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.my_location,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              fetchHomeLocation();
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🌍 State Dropdown (Only show when !user.isEdited)
                      Obx(() {
                        if (_profileController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return DropdownButtonFormField<StateModel>(
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Select State',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          value: selectedState == null
                              ? null
                              : _profileController.statesList.firstWhereOrNull(
                                (state) => state.description == selectedState,
                          ),
                          items: _profileController.statesList.map((stateModel) {
                            return DropdownMenuItem<StateModel>(
                              value: stateModel,
                              child: Text(stateModel.description),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedState = value!.description;
                              _stateController.text = value.description;
                            });
                          },
                        );
                      }),
                    },
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.pictonBlue500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () async {
                          await getLatLngFromAddress(_addressController.text);
                          if (lat != 0.00 && lng != 0.00) {
                            final selectedStateModel = _profileController.statesList
                                .firstWhereOrNull((s) => s.description == selectedState);

                            if (selectedStateModel == null) {
                              Get.snackbar('Message', 'Please select a valid state',backgroundColor: Colors.grey[700]);
                              return;
                            }
                            await _profileController.editProfile(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              address: _addressController.text.trim(),
                              // state: jsonEncode({
                              //   "code": selectedStateModel.code,
                              //   "description": selectedStateModel.description,
                              // }), // 👈 dono bhej rahe hain
                              state: selectedStateModel.code,
                              state_description:selectedStateModel.description,
                              lat: lat.toString(),
                              lng: lng.toString(),
                              image: _imageFile,
                            );
                          } else {
                            print("Invalid coordinates");
                          }
                        },
                        child: _profileController.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}