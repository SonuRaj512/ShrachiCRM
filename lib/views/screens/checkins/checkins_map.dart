// import 'dart:async';
// import 'dart:io';
// import 'dart:math' as Math;
// import 'dart:ui';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
// import 'package:geocoding/geocoding.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shrachi/api/checkin_controller.dart';
// import 'package:shrachi/views/components/CustomMarkerGenerator.dart';
// import 'package:shrachi/views/enums/responsive.dart';
// import '../../../OfflineDatabase/DBHelper.dart';
// import '../../../api/LocationHelper/LocationHelper.dart';
// import '../../../utils/internet_helper.dart';
// import '../multicolor_progressbar_screen.dart';
//
// class CheckinsMap extends StatefulWidget {
//   final int tourPlanId;
//   final int visitId;
//   final String Type;
//   final bool? islatestcheck;
//   final LatLng? coordinate;
//   final DateTime startDate;
//   const CheckinsMap({
//     super.key,
//     required this.tourPlanId,
//     required this.visitId,
//     required this.Type,
//     this.islatestcheck,
//     this.coordinate,
//     required this.startDate,
//   });
//
//   @override
//   State<CheckinsMap> createState() => _CheckinsMapState();
// }
//
// class _CheckinsMapState extends State<CheckinsMap> with WidgetsBindingObserver{
//   final _additionalInfoController = TextEditingController();
//   final CheckinController _checkinController = Get.put(CheckinController());
//   final Completer<GoogleMapController> _controller = Completer();
//   StreamSubscription<Position>? _positionStream;
//   LatLng? _currentPosition;
//   bool _initializing = true;
//   LatLng? _destination;
//   LatLng? _lastPosition;
//   double? _lastBearing;
//   Circle? _circle;
//   BitmapDescriptor? _personIcon;
//   final Set<Marker> _markers = {};
//   final Map<PolylineId, Polyline> _polylines = {};
//   final List<LatLng> _polylineCoords = [];
//   final poly.PolylinePoints _polylinePoints = poly.PolylinePoints(
//     apiKey: "AIzaSyBxB6C4qvkBdWkyEdtsaP3x3rohW9N0m3A",
//   );
//   poly.Route? _currentRoute;
//   final List<File> _images = [];
//   final ImagePicker _picker = ImagePicker();
//   bool _showBlur = true;
//   bool? _isLatestCheck;
//   CameraController? cameraController;
//   bool isCameraOpen = false;
//   bool _isCheckingIn = false; // Used to show loader on button during API call
//   // ⭐ Class level variable for distance
//   double _liveDistanceKm = 0.0;
//   bool _expand = false;
//   Timer? _syncTimer;
// ///image picker
//   // Future<void> _pickImage() async {
//   //   // STEP 1: Check current permission
//   //   PermissionStatus status = await Permission.camera.status;
//   //
//   //   // STEP 2: If denied → request (popup)
//   //   if (status.isDenied) {
//   //     status = await Permission.camera.request();
//   //   }
//   //
//   //   // STEP 3: If permanently denied → show settings dialog
//   //   if (status.isPermanentlyDenied) {
//   //     if (!mounted) return;
//   //
//   //     showDialog(
//   //       context: context,
//   //       builder: (_) => AlertDialog(
//   //         title: const Text("Camera Permission Required"),
//   //         content: const Text(
//   //           "Camera permission is required to take live photos. Please enable it from Settings.",
//   //         ),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () => Navigator.pop(context),
//   //             child: const Text("Cancel"),
//   //           ),
//   //           ElevatedButton(
//   //             onPressed: () {
//   //               openAppSettings();
//   //               Navigator.pop(context);
//   //             },
//   //             child: const Text("Open Settings"),
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //     return;
//   //   }
//   //
//   //   // STEP 4: If granted → open camera safely
//   //   if (status.isGranted) {
//   //     try {
//   //       final cameras = await availableCameras();
//   //
//   //       final frontCamera = cameras.firstWhere(
//   //             (cam) => cam.lensDirection == CameraLensDirection.front,
//   //         orElse: () => cameras.first,
//   //       );
//   //
//   //       cameraController = CameraController(
//   //         frontCamera,
//   //         ResolutionPreset.medium,
//   //         enableAudio: false,
//   //       );
//   //
//   //       await cameraController!.initialize();
//   //
//   //       if (!mounted) return;
//   //
//   //       setState(() {
//   //         isCameraOpen = true;
//   //       });
//   //     } catch (e) {
//   //       debugPrint("Camera open error: $e");
//   //     }
//   //   }
//   // }
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
//       _images.add(File(picture.path));
//       isCameraOpen = false; // camera close karo
//     });
//
//     await cameraController!.dispose();
//   }
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
//   Future<void> _loadPersonIcon() async {
//     final BitmapDescriptor bitmap = await BitmapDescriptor.asset(
//       const ImageConfiguration(size: Size(40, 40)),
//       "assets/images/person.png",
//     );
//     setState(() {
//       _personIcon = bitmap;
//     });
//   }
//
//   Future<void> _checkPermissionsAndStartStream() async {
//     await _positionStream?.cancel();
//
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Location services are disabled. Please enable them."),
//         ),
//       );
//       await Geolocator.openLocationSettings();
//       return;
//     }
//
//     PermissionStatus status = await Permission.location.status;
//
//     if (status.isDenied) {
//       status = await Permission.location.request();
//       if (status.isDenied) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permissions are denied.")),
//         );
//         return;
//       }
//     }
//
//     if (status.isPermanentlyDenied) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Permissions permanently denied. Please enable from app settings.",
//           ),
//         ),
//       );
//       await openAppSettings();
//       return;
//     }
//
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 1,
//       ),
//     ).listen((Position pos) async {
//       final LatLng newPos = LatLng(pos.latitude, pos.longitude);
//       _updateLocation(newPos);
//       setState(() {
//         _showBlur = false;
//       });
//       if (_destination == null) {
//         await showRouteTo(widget.coordinate!, updateCamera: true);
//       } else {
//         _updateRouteInfo();
//       }
//     });
//   }
//
//   Future<void> _updateLocation(LatLng pos) async {
//     final circle = Circle(
//       circleId: const CircleId("radius"),
//       center: pos,
//       radius: 30,
//       strokeWidth: 2,
//       strokeColor: Colors.blue,
//       fillColor: Colors.blue.withValues(alpha: 0.1),
//     );
//
//     setState(() {
//       _currentPosition = pos;
//       _circle = circle;
//     });
//
//     final controller = await _controller.future;
//
//     double bearing = 0;
//     if (_lastPosition != null) {
//       bearing = _calculateBearing(_lastPosition!, pos);
//     }
//     if (_lastPosition != null) {
//       final distance = _calculateDistance(_lastPosition!, pos);
//       if (distance < 10) {
//         return;
//       }
//     }
//     controller.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: pos, zoom: 19, tilt: 45, bearing: bearing),
//       ),
//     );
//
//     _lastPosition = pos;
//     if (_destination != null) {
//       await showRouteTo(_destination!, updateCamera: false);
//     }
//   }
//
//   double _calculateDistance(LatLng start, LatLng end) {
//     const R = 6371000;
//     final lat1 = start.latitude * (3.141592653589793 / 180);
//     final lon1 = start.longitude * (3.141592653589793 / 180);
//     final lat2 = end.latitude * (3.141592653589793 / 180);
//     final lon2 = end.longitude * (3.141592653589793 / 180);
//
//     final dLat = lat2 - lat1;
//     final dLon = lon2 - lon1;
//
//     final a =
//         (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
//             Math.cos(lat1) *
//                 Math.cos(lat2) *
//                 Math.sin(dLon / 2) *
//                 Math.sin(dLon / 2);
//     final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
//
//     return R * c;
//   }
//
//   double _calculateBearing(LatLng start, LatLng end) {
//     // if (_lastPosition != null &&
//     //     start.latitude == _lastPosition!.latitude &&
//     //     start.longitude == _lastPosition!.longitude) {
//     //   return _lastBearing ?? 0.0;
//     // }
//
//     final lat1 = start.latitude * (3.141592653589793 / 180.0);
//     final lon1 = start.longitude * (3.141592653589793 / 180.0);
//     final lat2 = end.latitude * (3.141592653589793 / 180.0);
//     final lon2 = end.longitude * (3.141592653589793 / 180.0);
//
//     final dLon = lon2 - lon1;
//
//     final y = Math.sin(dLon) * Math.cos(lat2);
//     final x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
//
//     final bearing = (Math.atan2(y, x) * 180.0 / 3.141592653589793 + 360.0) % 360.0;
//
//     _lastPosition = start;
//     _lastBearing = bearing;
//
//     return bearing;
//   }
//
//   Future<String> _getAddressFromLatLng(destination) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         destination.latitude,
//         destination.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         return "${place.name ?? ''} ${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}"
//             .trim()
//             .replaceAll(RegExp(r'\s+'), ' ');
//       }
//     } catch (e) {
//       print("Error fetching address: $e");
//     }
//     return "Destination";
//   }
//
//   Future<void> showRouteTo(LatLng destination, {bool updateCamera = true,}) async {
//     if (_currentPosition == null) {
//       print('Current position is null, cannot draw route');
//       return;
//     }
//
//     _destination = destination;
//
//     final poly.RoutesApiRequest request = poly.RoutesApiRequest(
//       origin: poly.PointLatLng(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//       ),
//       destination: poly.PointLatLng(
//         destination.latitude,
//         destination.longitude,
//       ),
//       travelMode: poly.TravelMode.driving,
//       routingPreference: poly.RoutingPreference.trafficAware,
//     );
//
//     try {
//       final poly.RoutesApiResponse response = await _polylinePoints
//           .getRouteBetweenCoordinatesV2(request: request);
//
//       if (response.routes.isEmpty) {
//         print('No route found: ${response.errorMessage}');
//         return;
//       }
//
//       final route = response.routes.first;
//       _polylineCoords.clear();
//
//       if (route.polylinePoints != null) {
//         for (final point in route.polylinePoints!) {
//           _polylineCoords.add(LatLng(point.latitude, point.longitude));
//         }
//       }
//
//       final PolylineId polyId = const PolylineId('route');
//       final Polyline polyline = Polyline(
//         polylineId: polyId,
//         points: List<LatLng>.from(_polylineCoords),
//         width: 5,
//         color: Colors.blue.shade400,
//       );
//
//       String destinationLabel = await _getAddressFromLatLng(destination);
//       final destinationIcon =
//       await CustomMarkerGenerator.createMarkerWithLabelOnDefault(
//         label: destinationLabel,
//         labelColor: Colors.black,
//         width: 400,
//       );
//       setState(() {
//         _polylines[polyId] = polyline;
//         _markers.clear();
//         _markers.add(
//           Marker(
//             markerId: const MarkerId("destination"),
//             position: destination,
//             icon: destinationIcon,
//           ),
//         );
//         if (_personIcon != null) {
//           _markers.add(
//             Marker(
//               markerId: const MarkerId("current_location"),
//               position: _currentPosition!,
//               icon: _personIcon!,
//               rotation: 0,
//               anchor: const Offset(0.5, 0.5),
//               zIndexInt: 3,
//             ),
//           );
//         }
//         _currentRoute = route;
//         // ⭐ Distance Update: Meters to Km
//         _liveDistanceKm = (route.distanceMeters ?? 0) / 1000.0;
//       });
//
//       if (updateCamera && _polylineCoords.isNotEmpty) {
//         final LatLngBounds bounds = _computeBounds(_polylineCoords);
//         final GoogleMapController mapController = await _controller.future;
//         mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
//       }
//     } catch (e) {
//       print('Error in showRouteTo: $e');
//     }
//   }
//
//   void _updateRouteInfo() {
//     if (_currentPosition == null || _destination == null || _currentRoute == null) {
//       return;
//     }
//
//     double remainingMeters = 0.0;
//
//     if (_polylineCoords.isNotEmpty) {
//       int nearestIndex = 0;
//       double minDistance = double.infinity;
//
//       for (int i = 0; i < _polylineCoords.length; i++) {
//         final d = Geolocator.distanceBetween(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//           _polylineCoords[i].latitude,
//           _polylineCoords[i].longitude,
//         );
//         if (d < minDistance) {
//           minDistance = d;
//           nearestIndex = i;
//         }
//       }
//
//       for (int i = nearestIndex; i < _polylineCoords.length - 1; i++) {
//         remainingMeters += Geolocator.distanceBetween(
//           _polylineCoords[i].latitude,
//           _polylineCoords[i].longitude,
//           _polylineCoords[i + 1].latitude,
//           _polylineCoords[i + 1].longitude,
//         );
//       }
//     }
//
//     final totalDistance = _currentRoute!.distanceMeters ?? remainingMeters.toInt();
//     final totalDuration = _currentRoute!.duration ?? 0;
//
//     final remainingDuration =
//     (totalDistance > 0 && totalDuration > 0)
//         ? (remainingMeters / totalDistance * totalDuration).toInt()
//         : totalDuration;
//
//     final updatedRoute = poly.Route(
//       distanceMeters: remainingMeters.toInt(),
//       duration: remainingDuration,
//       polylinePoints: _currentRoute!.polylinePoints,
//     );
//
//     setState(() {
//       _currentRoute = updatedRoute;
//       // ⭐ Live Distance Update
//       _liveDistanceKm = remainingMeters / 1000.0;
//     });
//   }
//
//   LatLngBounds _computeBounds(List<LatLng> coords) {
//     double? minLat, maxLat, minLng, maxLng;
//     for (var c in coords) {
//       if (minLat == null || c.latitude < minLat) minLat = c.latitude;
//       if (maxLat == null || c.latitude > maxLat) maxLat = c.latitude;
//       if (minLng == null || c.longitude < minLng) minLng = c.longitude;
//       if (maxLng == null || c.longitude > maxLng) maxLng = c.longitude;
//     }
//     return LatLngBounds(
//       southwest: LatLng(minLat!, minLng!),
//       northeast: LatLng(maxLat!, maxLng!),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _startSyncTimer(); // Timer start karein
//     WidgetsBinding.instance.addObserver(this);
//     _startLocation();
//     _loadPersonIcon();
//     _isLatestCheck = widget.islatestcheck;
//   }
//
//   @override
//   void dispose() {
//     _syncTimer?.cancel(); // Timer stop karein
//     WidgetsBinding.instance.removeObserver(this);
//     _positionStream?.cancel();
//     super.dispose();
//   }
//   // 🔄 Yeh function har 15 second baad check karega ki internet aaya ya nahi
//   void _startSyncTimer() {
//     _syncTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
//       if (await hasInternet()) {
//         await DatabaseHelper.instance.syncAllData();
//       }
//     });
//   }
//   /// 🔥 iOS SETTINGS → APP RESUME FIX
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       if (_currentPosition == null) {
//         _startLocation();
//       }
//     }
//   }
//
//   Future<void> _startLocation() async {
//     bool allowed = await LocationHelper.ensurePermission();
//     if (!allowed) return;
//
//     await _positionStream?.cancel();
//
//     _positionStream = Geolocator.getPositionStream(
//       locationSettings: const LocationSettings(
//         accuracy: LocationAccuracy.best,
//         distanceFilter: 5,
//       ),
//     ).listen((pos) {
//       setState(() {
//         _initializing = false;
//         _currentPosition = LatLng(pos.latitude, pos.longitude);
//         _showBlur = false;
//       });
//
//       _updateLocation(_currentPosition!);
//
//       if (_destination == null && widget.coordinate != null) {
//         showRouteTo(widget.coordinate!, updateCamera: true);
//       }
//     }, onError: (e) {
//       debugPrint("Location stream error: $e");
//     });
//   }
//
//   // CheckIn Button logic
//   Future<void> handleCheckIn() async {
//     setState(() => _isCheckingIn = true);
//     final online = await hasInternet();
//
//     if (!online) {
//       // Offline Save
//       await DatabaseHelper.instance.saveOfflineCheckin(
//         lat: _currentPosition!.latitude,
//         lng: _currentPosition!.longitude,
//         tourPlanId: widget.tourPlanId,
//         visitId: widget.visitId,
//         convinceType: "complaint",
//         checkIn_distance: _liveDistanceKm,
//       );
//       setState(() {
//         _isCheckingIn = false;
//         _isLatestCheck = true;
//       });
//       Get.snackbar("Offline", "Check-In saved locally", backgroundColor: Colors.orange);
//       return;
//     }
//
//     // Online API call
//     bool result = await _checkinController.checkIncontroller(
//       lat: _currentPosition!.latitude,
//       lng: _currentPosition!.longitude,
//       tourPlanId: widget.tourPlanId,
//       visitId: widget.visitId,
//       convinceType: "complaint",
//       convinceText: "",
//       checkIn_distance: _liveDistanceKm,
//     );
//
//     setState(() => _isCheckingIn = false);
//     if (result) {
//       setState(() => _isLatestCheck = true);
//     } else {
//       _showReasonDialog(); // Reason dialog call karein
//     }
//   }
//   void _showReasonDialog() {
//     TextEditingController _reason = TextEditingController();
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text("Non-Compliance Reason"),
//         content: TextField(
//             controller: _reason,
//             decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                  labelText: "Reason",
//             ),
//         ),
//         // content: TextField(controller: _reason, decoration: InputDecoration(hintText: "Enter reason")),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               // if (_reason.text.isEmpty) return;
//               // Navigator.pop(context);
//               if (_reason.text.isEmpty) {
//                 Get.snackbar("Error", "Reason is required");
//                 return;
//               }
//               Navigator.pop(context);
//               final online = await hasInternet();
//               if(!online) {
//                 await DatabaseHelper.instance.saveOfflineCheckin(
//                   lat: _currentPosition!.latitude,
//                   lng: _currentPosition!.longitude,
//                   tourPlanId: widget.tourPlanId,
//                   visitId: widget.visitId,
//                   convinceType: "non-complaint",
//                   convinceText: _reason.text,
//                   checkIn_distance: _liveDistanceKm,
//                 );
//                 setState(() => _isLatestCheck = true);
//               }
//               else {
//                 bool ok = await _checkinController.checkIncontroller(
//                   lat: _currentPosition!.latitude,
//                   lng: _currentPosition!.longitude,
//                   tourPlanId: widget.tourPlanId,
//                   visitId: widget.visitId,
//                   convinceType: "non-complaint",
//                   convinceText: _reason.text,
//                   checkIn_distance: _liveDistanceKm,
//                 );
//                 if(ok) setState(() => _isLatestCheck = true);
//               }
//             },
//             child: Text("Submit"),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         body:_initializing || _currentPosition == null
//             ? const Center(child: CircularProgressIndicator())
//             : Stack(
//           children: [
//             GoogleMap(
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: _currentPosition!,
//                 zoom: 17,
//               ),
//               onMapCreated: (ctrl) {
//                 if (!_controller.isCompleted) {
//                   _controller.complete(ctrl);
//                 }
//               },
//               myLocationEnabled: false,
//               myLocationButtonEnabled: true,
//               circles: _circle != null ? {_circle!} : {},
//               polylines: Set<Polyline>.of(_polylines.values),
//               markers: _markers,
//               zoomControlsEnabled: false,
//             ),
//             if (_currentRoute != null)
//               _buildRouteInfoCard(_currentRoute!, context),
//
//             if (!_expand)
//               Positioned(
//                 right: 10,
//                 bottom: 10,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.white,
//                         blurRadius: 6,
//                         spreadRadius: 1,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       shape: CircleBorder(),
//                     ),
//                     icon: Icon(
//                       Ionicons.expand_outline,
//                       color: Colors.black,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _expand = true;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//
//             if (_expand)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: AnimatedSwitcher(
//                   duration: Duration(milliseconds: 400),
//
//                   transitionBuilder: (child, animation) {
//                     return SlideTransition(
//                       position: Tween<Offset>(
//                         begin: Offset(0, 1),
//                         end: Offset(0, 0),
//                       ).animate(animation),
//                       child: child,
//                     );
//                   },
//
//                   child: Container(
//                     key: ValueKey(_isLatestCheck),
//                     padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                     margin: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//
//                     child: Stack(
//                       children: [
//
//                         // Close Button
//                         Positioned(
//                           right: -15,
//                           top: -5,
//                           child: IconButton(
//                             style: IconButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               shape: const CircleBorder(),
//                             ),
//                             icon: const Icon(Ionicons.expand_outline, color: Colors.black),
//                             onPressed: () {
//                               setState(() {
//                                 _expand = false;
//                               });
//                             },
//                           ),
//                         ),
//
//                         // ⭐⭐⭐ CHECK-IN UI (When false or null)
//                         if (_isLatestCheck == false || _isLatestCheck == null)
//                           Padding(
//                             padding: EdgeInsets.only(top: 50),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   "Please click the CheckIn button",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     /// Disable button while API is in progress
//                                     // onPressed: _isCheckingIn
//                                     //     ? null
//                                     //     : () async {
//                                     //
//                                     //   // 🔴 START LOADER
//                                     //   setState(() {
//                                     //     _isCheckingIn = true;
//                                     //   });
//                                     //
//                                     //   // 🔥 STEP 1: INTERNET CHECK
//                                     //   final online = await hasInternet();
//                                     //
//                                     //   // 🔴 OFFLINE CASE → LOCAL SAVE
//                                     //   if (!online) {
//                                     //     await DatabaseHelper.instance.saveOfflineCheckin(
//                                     //       lat: _currentPosition!.latitude,
//                                     //       lng: _currentPosition!.longitude,
//                                     //       tourPlanId: widget.tourPlanId,
//                                     //       visitId: widget.visitId,
//                                     //       convinceType: "complaint",
//                                     //       convinceText: "",
//                                     //       additionalInfo: "",
//                                     //     );
//                                     //
//                                     //     setState(() {
//                                     //       _isCheckingIn = false;
//                                     //       _isLatestCheck = true;
//                                     //     });
//                                     //
//                                     //     Get.snackbar(
//                                     //       "Offline Check-In",
//                                     //       "ICheck-In Successfully",
//                                     //       backgroundColor: Colors.orange,
//                                     //       colorText: Colors.white,
//                                     //     );
//                                     //     return; // ⛔ API CALL NA HO
//                                     //   }
//                                     //
//                                     //   // 🟢 ONLINE → FIRST API CALL
//                                     //   bool result = await _checkinController.checkIncontroller(
//                                     //     lat: _currentPosition!.latitude,
//                                     //     lng: _currentPosition!.longitude,
//                                     //     tourPlanId: widget.tourPlanId,
//                                     //     visitId: widget.visitId,
//                                     //     convinceType: "complaint",
//                                     //     convinceText: "",
//                                     //     checkIn_distance: _liveDistanceKm, // 👈 Added here
//                                     //   );
//                                     //
//                                     //   setState(() {
//                                     //     _isCheckingIn = false;
//                                     //   });
//                                     //
//                                     //   // ✅ SUCCESS
//                                     //   if (result == true) {
//                                     //     setState(() {
//                                     //       _isLatestCheck = true;
//                                     //     });
//                                     //   }
//                                     //   // ❌ FAILED → REASON DIALOG
//                                     //   else {
//                                     //     TextEditingController _reason = TextEditingController();
//                                     //     showDialog(
//                                     //       context: context,
//                                     //       barrierDismissible: false,
//                                     //       builder: (context) {
//                                     //         return AlertDialog(
//                                     //           backgroundColor: Colors.white,
//                                     //           title: const Text("Non-Compliance CheckIn"),
//                                     //           content: Column(
//                                     //             mainAxisSize: MainAxisSize.min,
//                                     //             children: [
//                                     //               const Text("Please enter the reason."),
//                                     //               const SizedBox(height: 10),
//                                     //               TextField(
//                                     //                 controller: _reason,
//                                     //                 decoration: const InputDecoration(
//                                     //                   border: OutlineInputBorder(),
//                                     //                   labelText: "Reason",
//                                     //                 ),
//                                     //               ),
//                                     //             ],
//                                     //           ),
//                                     //           actions: [
//                                     //             TextButton(
//                                     //               onPressed: () => Navigator.pop(context),
//                                     //               child: const Text("Cancel"),
//                                     //             ),
//                                     //             ElevatedButton(
//                                     //               onPressed: () async {
//                                     //
//                                     //                 if (_reason.text.isEmpty) {
//                                     //                   Get.snackbar("Error", "Reason is required");
//                                     //                   return;
//                                     //                 }
//                                     //
//                                     //                 Navigator.pop(context);
//                                     //
//                                     //                 setState(() {
//                                     //                   _isCheckingIn = true;
//                                     //                 });
//                                     //
//                                     //                 bool secondTry = await _checkinController.checkIncontroller(
//                                     //                   lat: _currentPosition!.latitude,
//                                     //                   lng: _currentPosition!.longitude,
//                                     //                   tourPlanId: widget.tourPlanId,
//                                     //                   visitId: widget.visitId,
//                                     //                   convinceType: "non-complaint",
//                                     //                   convinceText: _reason.text,
//                                     //                   checkIn_distance: _liveDistanceKm,
//                                     //                 );
//                                     //                 print("Total distance km ok: $_liveDistanceKm");
//                                     //                 setState(() {
//                                     //                   _isCheckingIn = false;
//                                     //                 });
//                                     //
//                                     //                 if (secondTry == true) {
//                                     //                   setState(() {
//                                     //                     _isLatestCheck = true;
//                                     //                   });
//                                     //                 }
//                                     //               },
//                                     //               child: const Text("Submit"),
//                                     //             ),
//                                     //           ],
//                                     //         );
//                                     //       },
//                                     //     );
//                                     //   }
//                                     // },
//                                     onPressed: _isCheckingIn ? null : handleCheckIn,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       padding: const EdgeInsets.symmetric(vertical: 14),
//                                     ),
//
//                                     // 🔥 MULTI COLOR PROGRESS BAR
//                                     child: _isCheckingIn
//                                         ? const MultiColorCircularLoader(size: 22)
//                                         : const Text(
//                                       "CheckIn",
//                                       style: TextStyle(color: Colors.white, fontSize: 16),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         // ⭐⭐⭐ CHECK-OUT UI (When true)
//                         if (_isLatestCheck == true)
//                           Padding(
//                             padding: EdgeInsets.only(top: 50),
//                             child: Column(
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 // Comments field
//                                 TextField(
//                                   controller: _additionalInfoController,
//                                   decoration: _textDecoration(
//                                     'Additional Information',
//                                   ),
//                                   maxLines: 3,
//                                 ),
//                                 const SizedBox(height: 15),
//
//                                 // Add Photo button (camera)
//                                 isCameraOpen ? Stack(
//                                   children: [
//                                     SizedBox(
//                                       height: 400,
//                                       child: CameraPreview(cameraController!),
//                                     ),
//                                     Positioned(
//                                       bottom: 20,
//                                       left: 0,
//                                       right: 0,
//                                       child: Center(
//                                         child: FloatingActionButton(
//                                           onPressed: _capturePhoto,
//                                           child: const Icon(Icons.camera),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ) : InkWell(
//                                   onTap: _pickImage,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.grey.shade400),
//                                       borderRadius: BorderRadius.circular(6),
//                                     ),
//                                     child: const Row(
//                                       children: [
//                                         Icon(Icons.camera_alt, size: 20, color: Colors.grey),
//                                         SizedBox(width: 8),
//                                         Text("Add Photo",
//                                             style: TextStyle(fontSize: 16, color: Colors.grey)),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Text(
//                                   "Please upload ${widget.Type} photo",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.black.withValues(
//                                       alpha: 0.8,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 // Show selected photos
//                                 if (_images.isNotEmpty)
//                                   SizedBox(
//                                     height: 80,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: _images.length,
//                                       itemBuilder: (context, index) {
//                                         return Stack(
//                                           children: [
//                                             Container(
//                                               margin:
//                                               const EdgeInsets.only(right: 8,),
//                                               width: 80,
//                                               height: 80,
//                                               decoration: BoxDecoration(
//                                                 borderRadius: BorderRadius.circular(6,),
//                                                 image: DecorationImage(
//                                                   image: FileImage(
//                                                     _images[index],
//                                                   ),
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                             ),
//                                             // Remove button
//                                             Positioned(
//                                               right: 4,
//                                               top: 4,
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     _images.removeAt(
//                                                       index,
//                                                     );
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   decoration: const BoxDecoration(
//                                                     color: Colors.black54,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                   child: const Icon(
//                                                     Icons.close,
//                                                     color: Colors.white,
//                                                     size: 18,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 SizedBox(height: 15),
//                                 // Continue button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: Obx(() {
//                                     return ElevatedButton(
//                                       onPressed: () async {
//                                         final online = await hasInternet();
//                                         // 🔴 OFFLINE CHECK-OUT
//                                         if (!online) {
//                                           await DatabaseHelper.instance.saveOfflineCheckout(
//                                             lat: _currentPosition!.latitude,
//                                             lng: _currentPosition!.longitude,
//                                             tourPlanId: widget.tourPlanId,
//                                             visitId: widget.visitId,
//                                             images: _images,
//                                             additionalInfo: _additionalInfoController.text,
//                                             startDate: widget.startDate,
//                                           );
//
//                                           Get.snackbar("Offline", "Check-Out Saved Locally", backgroundColor: Colors.orange, colorText: Colors.white);
//
//                                           return; // ⛔ API CALL NA HO
//                                         }
//                                         // 🟢 ONLINE → NORMAL CHECK-OUT API
//                                         await _checkinController.checkInDetails(
//                                           lat: _currentPosition!.latitude,
//                                           lng: _currentPosition!.longitude,
//                                           tourPlanId: widget.tourPlanId,
//                                           visitId: widget.visitId,
//                                           images: _images,
//                                           additionalInfo: _additionalInfoController.text,
//                                           startDate: widget.startDate,
//                                         );
//                                       },
//
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.blue,
//                                         padding: const EdgeInsets.symmetric(
//                                           vertical: 14,
//                                         ),
//                                       ),
//                                       child: _checkinController.isLoading.value ? SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           color: Colors.white,
//                                         ),
//                                       ):Text(
//                                         "CheckOut",
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             if (_showBlur && widget.coordinate?.latitude != 0.0 && widget.coordinate?.longitude != 0.0)
//               Positioned.fill(
//                 child: ClipRect(
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
//                     child: Container(
//                       color: Colors.black.withValues(alpha: 0.3),
//                       child: Center(
//                         child: Container(
//                           width:
//                           Responsive.isMd(context)
//                               ? screenWidth * 0.8
//                               : screenWidth * 0.5,
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(
//                                   alpha: 0.2,
//                                 ),
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 "This lead has no geolocation. We are going to update this geolocation value with your current location",
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(height: 20),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _showBlur = false;
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue,
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 24,
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                       6,
//                                     ),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   "Continue",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildRouteInfoCard(poly.Route route, BuildContext context) {
//     final duration = route.duration!;
//     //final distanceKm = (route.distanceMeters! / 1000).toStringAsFixed(1);
//     String eta = duration >= 3600 ? "${(duration / 3600).floor()}h ${(duration % 3600 / 60).round()}m" : "${(duration / 60).round()}m";
//
//     final screenWidth = MediaQuery.of(context).size.width;
//
//    // String eta;
//     if (duration >= 3600) {
//       final hours = (duration / 3600).floor();
//       final minutes = ((duration % 3600) / 60).round();
//       eta =
//       "$hours h""${minutes > 0 ? " $minutes m" : ""}";
//     } else if (duration >= 60) {
//       final minutes = (duration / 60).round();
//       eta = "$minutes m";
//     } else {
//       eta = "$duration s";
//     }
//     return Positioned(
//       top: 10,
//       left: (screenWidth - (screenWidth * 0.7)) / 2,
//       child: SizedBox(
//         width: screenWidth * 0.7,
//         child: Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           elevation: 10,
//           shadowColor: Colors.black26,
//           color: Colors.white,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.place, color: Colors.redAccent, size: 20),
//                     const SizedBox(width: 5),
//                     Text(eta, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
//                   ],
//                 ),
//                 Container(
//                   height: 20,
//                   width: 1,
//                   color: Colors.black12,
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.access_time,
//                       color: Colors.blueAccent,
//                       size: 20,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       eta,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as poly;
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shrachi/api/checkin_controller.dart';
import 'package:shrachi/views/components/CustomMarkerGenerator.dart';
import 'package:shrachi/views/enums/responsive.dart';
import '../../../OfflineDatabase/DBHelper.dart';
import '../../../api/LocationHelper/LocationHelper.dart';
import '../../../utils/internet_helper.dart';
import '../multicolor_progressbar_screen.dart';
import 'ExpensePage/expense_list.dart';

class CheckinsMap extends StatefulWidget {
  final int tourPlanId;
  final int visitId;
  final String Type;
  final bool? islatestcheck;
  final LatLng? coordinate;
  final DateTime startDate;
  const CheckinsMap({
    super.key,
    required this.tourPlanId,
    required this.visitId,
    required this.Type,
    this.islatestcheck,
    this.coordinate,
    required this.startDate,
  });

  @override
  State<CheckinsMap> createState() => _CheckinsMapState();
}

class _CheckinsMapState extends State<CheckinsMap> with WidgetsBindingObserver{
  final _additionalInfoController = TextEditingController();
  final CheckinController _checkinController = Get.put(CheckinController());
  final Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<Position>? _positionStream;
  LatLng? _currentPosition;
  bool _initializing = true;
  LatLng? _destination;
  LatLng? _lastPosition;
  double? _lastBearing;
  Circle? _circle;
  BitmapDescriptor? _personIcon;
  final Set<Marker> _markers = {};
  final Map<PolylineId, Polyline> _polylines = {};
  final List<LatLng> _polylineCoords = [];
  final poly.PolylinePoints _polylinePoints = poly.PolylinePoints(
    apiKey: "AIzaSyBxB6C4qvkBdWkyEdtsaP3x3rohW9N0m3A",
  );
  poly.Route? _currentRoute;
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _showBlur = true;
  bool? _isLatestCheck;
  CameraController? cameraController;
  bool isCameraOpen = false;
  bool _isCheckingIn = false; // Used to show loader on button during API call
  // ⭐ Class level variable for distance
  double _liveDistanceKm = 0.0;
  bool _expand = false;
  Timer? _syncTimer;
  bool _isCheckedOut = false;
  bool? isConfirmedAddress;

  Future<void> _pickImage() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      final cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(frontCamera, ResolutionPreset.medium);

      await cameraController!.initialize();

      setState(() {
        isCameraOpen = true; // SCREEN me camera show hoga
      });
    }
  }
  Future<void> _capturePhoto() async {
    final picture = await cameraController!.takePicture();

    setState(() {
      _images.add(File(picture.path));
      isCameraOpen = false; // camera close karo
    });

    await cameraController!.dispose();
  }
  InputDecoration _textDecoration(String label) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withValues(alpha: 0.42),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withValues(alpha: 0.42),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      hintText: label,
    );
  }

  Future<void> _loadPersonIcon() async {
    final BitmapDescriptor bitmap = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(40, 40)),
      "assets/images/person.png",
    );
    setState(() {
      _personIcon = bitmap;
    });
  }

  Future<void> _checkPermissionsAndStartStream() async {
    await _positionStream?.cancel();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location services are disabled. Please enable them."),
        ),
      );
      await Geolocator.openLocationSettings();
      return;
    }

    PermissionStatus status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
      if (status.isDenied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are denied.")),
        );
        return;
      }
    }

    if (status.isPermanentlyDenied) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Permissions permanently denied. Please enable from app settings.",
          ),
        ),
      );
      await openAppSettings();
      return;
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 1,
      ),
    ).listen((Position pos) async {
      final LatLng newPos = LatLng(pos.latitude, pos.longitude);
      _updateLocation(newPos);
      setState(() {
        _showBlur = false;
      });
      if (_destination == null) {
        await showRouteTo(widget.coordinate!, updateCamera: true);
      } else {
        _updateRouteInfo();
      }
    });
  }

  Future<void> _updateLocation(LatLng pos) async {
    final circle = Circle(
      circleId: const CircleId("radius"),
      center: pos,
      radius: 30,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withValues(alpha: 0.1),
    );

    setState(() {
      _currentPosition = pos;
      _circle = circle;
    });

    final controller = await _controller.future;

    double bearing = 0;
    if (_lastPosition != null) {
      bearing = _calculateBearing(_lastPosition!, pos);
    }
    if (_lastPosition != null) {
      final distance = _calculateDistance(_lastPosition!, pos);
      if (distance < 10) {
        return;
      }
    }
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 19, tilt: 45, bearing: bearing),
      ),
    );

    _lastPosition = pos;
    if (_destination != null) {
      await showRouteTo(_destination!, updateCamera: false);
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const R = 6371000;
    final lat1 = start.latitude * (3.141592653589793 / 180);
    final lon1 = start.longitude * (3.141592653589793 / 180);
    final lat2 = end.latitude * (3.141592653589793 / 180);
    final lon2 = end.longitude * (3.141592653589793 / 180);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a =
        (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
            Math.cos(lat1) *
                Math.cos(lat2) *
                Math.sin(dLon / 2) *
                Math.sin(dLon / 2);
    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    // if (_lastPosition != null &&
    //     start.latitude == _lastPosition!.latitude &&
    //     start.longitude == _lastPosition!.longitude) {
    //   return _lastBearing ?? 0.0;
    // }

    final lat1 = start.latitude * (3.141592653589793 / 180.0);
    final lon1 = start.longitude * (3.141592653589793 / 180.0);
    final lat2 = end.latitude * (3.141592653589793 / 180.0);
    final lon2 = end.longitude * (3.141592653589793 / 180.0);

    final dLon = lon2 - lon1;

    final y = Math.sin(dLon) * Math.cos(lat2);
    final x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);

    final bearing = (Math.atan2(y, x) * 180.0 / 3.141592653589793 + 360.0) % 360.0;

    _lastPosition = start;
    _lastBearing = bearing;

    return bearing;
  }

  Future<String> _getAddressFromLatLng(destination) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        destination.latitude,
        destination.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        String name = place.name ?? '';
        String street = place.street ?? '';
        String locality = place.locality ?? '';
        String state = place.administrativeArea ?? '';
        String country = place.country ?? '';

        // --- Duplicate hatane ka logic ---
        String mainAddress = "";

        // Agar name aur street bilkul same hain, ya street ke andar name pehle se hai
        if (name == street || street.contains(name)) {
          mainAddress = street;
        } else if (name.contains(street)) {
          mainAddress = name;
        } else {
          mainAddress = "$name $street".trim();
        }

        // Baaki fields ko list mein daal kar join karenge taaki extra comma na aaye
        List<String> parts = [];
        if (mainAddress.isNotEmpty) parts.add(mainAddress);
        if (locality.isNotEmpty) parts.add(locality);
        if (state.isNotEmpty) parts.add(state);
        if (country.isNotEmpty) parts.add(country);

        return parts.join(", ").trim().replaceAll(RegExp(r'\s+'), ' ');
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
    return "Destination";
  }
  // Future<String> _getAddressFromLatLng(destination) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(
  //       destination.latitude,
  //       destination.longitude,
  //     );
  //     if (placemarks.isNotEmpty) {
  //       final place = placemarks.first;
  //       return "${place.name ?? ''} ${place.street ?? ''}, ${place.locality ?
  //       ? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}"
  //           .trim()
  //           .replaceAll(RegExp(r'\s+'), ' ');
  //     }
  //   } catch (e) {
  //     print("Error fetching address: $e");
  //   }
  //   return "Destination";
  // }

  Future<void> showRouteTo(LatLng destination, {bool updateCamera = true,}) async {
    if (_currentPosition == null) {
      print('Current position is null, cannot draw route');
      return;
    }

    _destination = destination;

    // New: Check if online for routing
    final online = await hasInternet();
    if (online) {
      // Online: Use Directions API as before
      final poly.RoutesApiRequest request = poly.RoutesApiRequest(
        origin: poly.PointLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        destination: poly.PointLatLng(
          destination.latitude,
          destination.longitude,
        ),
        travelMode: poly.TravelMode.driving,
        routingPreference: poly.RoutingPreference.trafficAware,
      );

      try {
        final poly.RoutesApiResponse response = await _polylinePoints
            .getRouteBetweenCoordinatesV2(request: request);

        if (response.routes.isEmpty) {
          print('No route found: ${response.errorMessage}');
          return;
        }

        final route = response.routes.first;
        _polylineCoords.clear();

        if (route.polylinePoints != null) {
          for (final point in route.polylinePoints!) {
            _polylineCoords.add(LatLng(point.latitude, point.longitude));
          }
        }

        final PolylineId polyId = const PolylineId('route');
        final Polyline polyline = Polyline(
          polylineId: polyId,
          points: List<LatLng>.from(_polylineCoords),
          width: 5,
          color: Colors.blue.shade400,
        );

        String destinationLabel = await _getAddressFromLatLng(destination);
        final destinationIcon =
        await CustomMarkerGenerator.createMarkerWithLabelOnDefault(
          label: destinationLabel,
          labelColor: Colors.black,
          width: 400,
        );
        setState(() {
          _polylines[polyId] = polyline;
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId("destination"),
              position: destination,
              icon: destinationIcon,
            ),
          );
          if (_personIcon != null) {
            _markers.add(
              Marker(
                markerId: const MarkerId("current_location"),
                position: _currentPosition!,
                icon: _personIcon!,
                rotation: 0,
                anchor: const Offset(0.5, 0.5),
                zIndexInt: 3,
              ),
            );
          }
          _currentRoute = route;
          // ⭐ Distance Update: Meters to Km
          _liveDistanceKm = (route.distanceMeters ?? 0) / 1000.0;
        });

        if (updateCamera && _polylineCoords.isNotEmpty) {
          final LatLngBounds bounds = _computeBounds(_polylineCoords);
          final GoogleMapController mapController = await _controller.future;
          mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
        }
      } catch (e) {
        print('Error in showRouteTo: $e');
      }
    } else {
      // Offline: Use straight-line polyline and distance
      _polylineCoords.clear();
      _polylineCoords.add(_currentPosition!);
      _polylineCoords.add(destination);

      final PolylineId polyId = const PolylineId('route');
      final Polyline polyline = Polyline(
        polylineId: polyId,
        points: List<LatLng>.from(_polylineCoords),
        width: 5,
        color: Colors.red.shade400, // Red to indicate offline straight line
      );

      String destinationLabel = "Offline Destination"; // Can't fetch address offline
      final destinationIcon =
      await CustomMarkerGenerator.createMarkerWithLabelOnDefault(
        label: destinationLabel,
        labelColor: Colors.black,
        width: 400,
      );

      setState(() {
        _polylines[polyId] = polyline;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId("destination"),
            position: destination,
            icon: destinationIcon,
          ),
        );
        if (_personIcon != null) {
          _markers.add(
            Marker(
              markerId: const MarkerId("current_location"),
              position: _currentPosition!,
              icon: _personIcon!,
              rotation: 0,
              anchor: const Offset(0.5, 0.5),
              zIndexInt: 3,
            ),
          );
        }
        _currentRoute = null; // No route object offline
        // Offline distance: straight line
        _liveDistanceKm = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          destination.latitude,
          destination.longitude,
        ) / 1000.0;
      });

      if (updateCamera && _polylineCoords.isNotEmpty) {
        final LatLngBounds bounds = _computeBounds(_polylineCoords);
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }

      Get.snackbar("Offline Mode", "Showing straight-line route. Full routing unavailable offline.");
    }
  }

  void _updateRouteInfo() {
    if (_currentPosition == null || _destination == null || _currentRoute == null) {
      return;
    }

    double remainingMeters = 0.0;

    if (_polylineCoords.isNotEmpty) {
      int nearestIndex = 0;
      double minDistance = double.infinity;

      for (int i = 0; i < _polylineCoords.length; i++) {
        final d = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          _polylineCoords[i].latitude,
          _polylineCoords[i].longitude,
        );
        if (d < minDistance) {
          minDistance = d;
          nearestIndex = i;
        }
      }

      for (int i = nearestIndex; i < _polylineCoords.length - 1; i++) {
        remainingMeters += Geolocator.distanceBetween(
          _polylineCoords[i].latitude,
          _polylineCoords[i].longitude,
          _polylineCoords[i + 1].latitude,
          _polylineCoords[i + 1].longitude,
        );
      }
    }

    final totalDistance = _currentRoute!.distanceMeters ?? remainingMeters.toInt();
    final totalDuration = _currentRoute!.duration ?? 0;

    final remainingDuration =
    (totalDistance > 0 && totalDuration > 0)
        ? (remainingMeters / totalDistance * totalDuration).toInt()
        : totalDuration;

    final updatedRoute = poly.Route(
      distanceMeters: remainingMeters.toInt(),
      duration: remainingDuration,
      polylinePoints: _currentRoute!.polylinePoints,
    );

    setState(() {
      _currentRoute = updatedRoute;
      // ⭐ Live Distance Update
      _liveDistanceKm = remainingMeters / 1000.0;
    });
  }

  LatLngBounds _computeBounds(List<LatLng> coords) {
    double? minLat, maxLat, minLng, maxLng;
    for (var c in coords) {
      if (minLat == null || c.latitude < minLat) minLat = c.latitude;
      if (maxLat == null || c.latitude > maxLat) maxLat = c.latitude;
      if (minLng == null || c.longitude < minLng) minLng = c.longitude;
      if (maxLng == null || c.longitude > maxLng) maxLng = c.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   _checkPermissionsAndStartStream();
  //   _startLocation();
  //   _loadPersonIcon();
  //   _isLatestCheck = widget.islatestcheck;
  // }

  //initState ko clean karein

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPersonIcon();
    _isLatestCheck = widget.islatestcheck;

    _initLocationProcess();
  }

  //Ek single initialization process banayein
  Future<void> _initLocationProcess() async {
    setState(() => _initializing = true);

    try {
      // Permissions check karein
      bool allowed = await LocationHelper.ensurePermission();
      if (!allowed) {
        setState(() => _initializing = false);
        return;
      }

      // ⭐ TRICK: Stream ka wait karne se pehle current location le lein
      // Isse white screen turant hat jayegi
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _initializing = false; // Progress bar yahan hat jayega
        _showBlur = false;
      });

      // Ab stream shuru karein updates ke liye
      _startLocationStream();

    } catch (e) {
      debugPrint("Init Location Error: $e");
      setState(() => _initializing = false);
    }
  }

  //Location Stream ko alag rakhein
  void _startLocationStream() {
    _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5, // 5 meter chalne par update hoga
      ),
    ).listen((pos) {
      if (!mounted) return;

      LatLng newPos = LatLng(pos.latitude, pos.longitude);

      setState(() {
        _currentPosition = newPos;
      });

      _updateLocation(newPos);

      if (_destination == null && widget.coordinate != null) {
        showRouteTo(widget.coordinate!, updateCamera: true);
      }
    }, onError: (e) {
      debugPrint("Location stream error: $e");
    });
  }

  // Map Created function ko safe banayein
  void _onMapCreated(GoogleMapController ctrl) {
    if (!_controller.isCompleted) {
      _controller.complete(ctrl);
    }
  }
  @override
  void dispose() {
    _syncTimer?.cancel(); // Timer stop karein
    WidgetsBinding.instance.removeObserver(this);
    _positionStream?.cancel();
    super.dispose();
  }
  /// 🔥 iOS SETTINGS → APP RESUME FIX
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_currentPosition == null) {
        _startLocation();
      }
    }
  }

  Future<void> _startLocation() async {
    bool allowed = await LocationHelper.ensurePermission();
    if (!allowed) return;

    await _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      setState(() {
        _initializing = false;
        _currentPosition = LatLng(pos.latitude, pos.longitude);
        _showBlur = false;
      });

      _updateLocation(_currentPosition!);

      if (_destination == null && widget.coordinate != null) {
        showRouteTo(widget.coordinate!, updateCamera: true);
      }
    }, onError: (e) {
      debugPrint("Location stream error: $e");
    });
  }

  Future<void> handleCheckIn() async {
    setState(() => _isCheckingIn = true);
    const double distanceThreshold = 0.5;
    if (_liveDistanceKm > distanceThreshold) {
      setState(() => _isCheckingIn = false);
      _showReasonDialog();
      return;
    }

    final online = await hasInternet();

    if (!online) {
      await DatabaseHelper.instance.saveOfflineCheckin(
        lat: _currentPosition!.latitude,
        lng: _currentPosition!.longitude,
        tourPlanId: widget.tourPlanId,
        visitId: widget.visitId,
        convinceType: "complaint", // Kyunki distance sahi hai
        checkIn_distance: _liveDistanceKm,
        isConfirmedAddress: isConfirmedAddress ?? false,
      );
      setState(() {
        _isCheckingIn = false;
        _isLatestCheck = true;
      });
      Get.snackbar("Offline", "Check-In saved locally", backgroundColor: Colors.orange, colorText: Colors.white);
    } else {
      // Online API call (Normal)
      bool result = await _checkinController.checkIncontroller(
        lat: _currentPosition!.latitude,
        lng: _currentPosition!.longitude,
        tourPlanId: widget.tourPlanId,
        visitId: widget.visitId,
        convinceType: "complaint",
        convinceText: "",
        checkIn_distance: _liveDistanceKm,
        isConfirmedAddress: isConfirmedAddress ?? false,
      );

      setState(() => _isCheckingIn = false);
      if (result) {
        setState(() => _isLatestCheck = true);
      } else {
        // Agar API kisi wajah se false de toh dialog dikhaye
        _showReasonDialog();
      }
    }
  }
  void _showReasonDialog() {
    TextEditingController _reason = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Location Mismatch", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("You are ${(_liveDistanceKm).toStringAsFixed(2)} km away from the dealer location. Please provide a reason:"),
              const SizedBox(height: 15),
              TextField(
                controller: _reason,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter reason here...",
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Do you want to continue?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    return Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.black),
                            ),
                            value: true,
                            groupValue: isConfirmedAddress, // null by default
                            activeColor: Colors.blue, // 🔵 selected color
                            onChanged: (value) {
                              setStateDialog(() {
                                isConfirmedAddress = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "No",
                              style: TextStyle(color: Colors.black),
                            ),
                            value: false,
                            groupValue: isConfirmedAddress,
                            activeColor: Colors.blue, // 🔵 selected color
                            onChanged: (value) {
                              setStateDialog(() {
                                isConfirmedAddress = value;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // StatefulBuilder(
              //   builder: (context, setStateDialog) {
              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         RadioListTile<bool>(
              //           title: const Text("Do you want to continue?",style: TextStyle(color: Colors.blue, fontSize: 10,fontWeight: FontWeight.bold),),
              //           value: true,
              //           groupValue: isConfirmed,
              //           onChanged: (value) {
              //             setStateDialog(() {
              //               isConfirmed = value; // true ho jayega
              //             });
              //           },
              //         ),
              //         if (isConfirmed == null)
              //           const Padding(
              //             padding: EdgeInsets.only(left: 16),
              //             child: Text(
              //               "Please select this option to continue",
              //               style: TextStyle(color: Colors.red, fontSize: 12),
              //             ),
              //           ),
              //       ],
              //     );
              //   },
              // ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",style: TextStyle(color: Colors.grey[700]),),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_reason.text.trim().isEmpty) {
                Get.snackbar("Message", "Please enter a reason for non-compliance");
                return;
              }

              /// Validation
              if (isConfirmedAddress == null) {
                Get.snackbar("Message", "Please select Yes or No before submitting");
                return;
              }

              Navigator.pop(context);

              final online = await hasInternet();
              if (!online) {
                // OFFLINE SAVE (Non-Complaint)
                await DatabaseHelper.instance.saveOfflineCheckin(
                  lat: _currentPosition!.latitude,
                  lng: _currentPosition!.longitude,
                  tourPlanId: widget.tourPlanId,
                  visitId: widget.visitId,
                  convinceType: "non-complaint", // Reason ke sath save hoga
                  convinceText: _reason.text,
                  checkIn_distance: _liveDistanceKm,
                  isConfirmedAddress: isConfirmedAddress ?? false, // ✅ TRUE / FALSE
                );
                setState(() => _isLatestCheck = true);
                Get.snackbar("Offline", "Non-compliance Check-In saved locally", backgroundColor: Colors.orange, colorText: Colors.white);
              } else {
                // ONLINE API (Non-Complaint)
                bool ok = await _checkinController.checkIncontroller(
                  lat: _currentPosition!.latitude,
                  lng: _currentPosition!.longitude,
                  tourPlanId: widget.tourPlanId,
                  visitId: widget.visitId,
                  convinceType: "non-complaint",
                  convinceText: _reason.text,
                  checkIn_distance: _liveDistanceKm,
                  isConfirmedAddress: isConfirmedAddress, // ✅ TRUE / FALSE
                );
                if (ok) setState(() => _isLatestCheck = true);
              }
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body:_initializing || _currentPosition == null
            ? const Center(child:
                  MultiColorCircularLoader(size: 40)
                  // CircularProgressIndicator()
            )
            : Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 17,
              ),
              onMapCreated: _onMapCreated,
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              circles: _circle != null ? {_circle!} : {},
              polylines: Set<Polyline>.of(_polylines.values),
              markers: _markers,
              zoomControlsEnabled: false,
            ),
            if (_currentRoute != null)
              _buildRouteInfoCard(_currentRoute!, context),

            if (!_expand)
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                    ),
                    icon: Icon(
                      Ionicons.expand_outline,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _expand = true;
                      });
                    },
                  ),
                ),
              ),

            if (_expand)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1),
                        end: Offset(0, 0),
                      ).animate(animation),
                      child: child,
                    );
                  },
                  child: Container(
                    key: ValueKey(_isLatestCheck),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // Close Button
                        Positioned(
                          right: -15,
                          top: -5,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                            ),
                            icon: const Icon(Ionicons.expand_outline, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                _expand = false;
                              });
                            },
                          ),
                        ),

                        // ⭐⭐⭐ CHECK-IN UI (When false or null)
                        if (_isLatestCheck == false || _isLatestCheck == null)
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Column(
                              children: [
                                Text(
                                  "Please click the CheckIn button",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isCheckingIn ? null : handleCheckIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                    ),

                                    // 🔥 MULTI COLOR PROGRESS BAR
                                    child: _isCheckingIn
                                        ? const MultiColorCircularLoader(size: 22)
                                        : const Text(
                                      "CheckIn",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // ⭐⭐⭐ CHECK-OUT UI (When true)
                        if (_isLatestCheck == true)
                          Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Comments field
                                TextField(
                                  controller: _additionalInfoController,
                                  decoration: _textDecoration(
                                    'Additional Information',
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 15),

                                // Add Photo button (camera)
                                isCameraOpen ? Stack(
                                  children: [
                                    SizedBox(
                                      height: 400,
                                      child: CameraPreview(cameraController!),
                                    ),
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: FloatingActionButton(
                                          onPressed: _capturePhoto,
                                          child: const Icon(Icons.camera),
                                        ),
                                      ),
                                    ),
                                  ],
                                ) : InkWell(
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
                                        Text("Add Photo",
                                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "Please upload ${widget.Type} photo",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withValues(
                                      alpha: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Show selected photos
                                if (_images.isNotEmpty)
                                  SizedBox(
                                    height: 80,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _images.length,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              margin:
                                              const EdgeInsets.only(right: 8,),
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(6,),
                                                image: DecorationImage(
                                                  image: FileImage(
                                                    _images[index],
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            // Remove button
                                            Positioned(
                                              right: 4,
                                              top: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _images.removeAt(
                                                      index,
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                SizedBox(height: 15),
                                // Continue button
                                SizedBox(
                                  width: double.infinity,
                                  child: Obx(() {
                                    return ElevatedButton(
                                      onPressed: (_isCheckedOut)
                                          ? () {
                                        Get.snackbar(
                                            "Info",
                                            "Already Checked Out",
                                            backgroundColor: Colors.blueGrey,
                                            colorText: Colors.white
                                        );
                                        // Button click par section band karne ke liye
                                        setState(() {
                                          _expand = false;
                                        });
                                      }
                                      : (_checkinController.isLoading.value ? null : () async {
                                        // Check-Out Button Logic
                                        final online = await hasInternet();
                                        if (!online) {
                                          // 🟠 OFFLINE MODE
                                          await DatabaseHelper.instance.saveOfflineCheckout(
                                            lat: _currentPosition!.latitude,
                                            lng: _currentPosition!.longitude,
                                            tourPlanId: widget.tourPlanId,
                                            visitId: widget.visitId,
                                            images: _images,
                                            additionalInfo: _additionalInfoController.text,
                                            startDate: widget.startDate,
                                          );
                                          setState(() {
                                            _isCheckedOut = true; // Button ko disable/deep color karne ke liye
                                            _expand = false;
                                          });
                                          Get.snackbar(
                                              "Offline Success",
                                              "Check-Out saved locally",
                                              backgroundColor: Colors.orange,
                                              colorText: Colors.white
                                          );
                                          // 🔥 FIXED: Get.back() ki jagah ExpenseList par bhejo
                                          Get.off(() => ExpenseList(
                                            tourPlanId: widget.tourPlanId,
                                            visitId: widget.visitId,
                                            startDate: widget.startDate,
                                          ));
                                          // 2 second baad screen back kar sakte hain agar chahein
                                          Future.delayed(Duration(seconds: 2), () => Get.back());
                                        } else {
                                          // 🟢 ONLINE MODE
                                          bool success = await _checkinController.CheckoutController(
                                            lat: _currentPosition!.latitude,
                                            lng: _currentPosition!.longitude,
                                            tourPlanId: widget.tourPlanId,
                                            visitId: widget.visitId,
                                            images: _images,
                                            additionalInfo: _additionalInfoController.text,
                                            startDate: widget.startDate,
                                            isSync: false,
                                          );

                                          if (success) {
                                            setState(() {
                                              _isCheckedOut = true;
                                            });
                                          }
                                        }
                                      }),
                                      style: ElevatedButton.styleFrom(
                                        // ⭐ Agar checkout ho gaya hai toh Deep Color (Grey), warna Blue
                                        backgroundColor: _isCheckedOut ? Colors.grey.shade800 : Colors.blue,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: _checkinController.isLoading.value
                                          ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white),
                                      ): Text(
                                        _isCheckedOut ? "Checked Out" : "CheckOut", // Text change
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_showBlur && widget.coordinate?.latitude != 0.0 && widget.coordinate?.longitude != 0.0)
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: Container(
                          width:
                          Responsive.isMd(context)
                              ? screenWidth * 0.8
                              : screenWidth * 0.5,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "This lead has no geolocation. We are going to update this geolocation value with your current location",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showBlur = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildRouteInfoCard(poly.Route route, BuildContext context) {
    // final duration = route.duration!;
    // final distanceKm = (route.distanceMeters! / 1000).toStringAsFixed(1);
    final duration = route.duration ?? 0;
    final distanceKm =
    ((route.distanceMeters ?? 0) / 1000).toStringAsFixed(1);

    String eta = duration >= 3600 ? "${(duration / 3600).floor()}h ${(duration % 3600 / 60).round()}m" : "${(duration / 60).round()}m";

    final screenWidth = MediaQuery.of(context).size.width;

    // String eta;
    if (duration >= 3600) {
      final hours = (duration / 3600).floor();
      final minutes = ((duration % 3600) / 60).round();
      eta =
      "$hours h""${minutes > 0 ? " $minutes m" : ""}";
    } else if (duration >= 60) {
      final minutes = (duration / 60).round();
      eta = "$minutes m";
    } else {
      eta = "$duration s";
    }
    return Positioned(
      top: 10,
      left: (screenWidth - (screenWidth * 0.7)) / 2,
      child: SizedBox(
        width: screenWidth * 0.8,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          shadowColor: Colors.black26,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Icon(Icons.place, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 5),
                    Text("$distanceKm km", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
                  ],
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.black12,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      eta,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
