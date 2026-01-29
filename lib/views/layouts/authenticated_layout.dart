import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/profile_controller.dart';
import 'package:shrachi/views/screens/attendance/attendance.dart';
import 'package:shrachi/views/screens/checkins/checkins_search.dart';
import 'package:shrachi/views/screens/holiday/calender.dart';
import 'package:shrachi/views/screens/home.dart';
import 'package:shrachi/views/screens/profile/profile.dart';
import 'package:shrachi/views/screens/tours/tours_list.dart';
import 'package:get/get.dart';
import '../screens/checkins/ExpeAndOutcome/ExpenseAndOutComeList_Screen.dart';

class AuthenticatedLayout extends StatefulWidget {
  final int? newIndex;
  const AuthenticatedLayout({super.key, this.newIndex});

  @override
  State<AuthenticatedLayout> createState() => _AuthenticatedLayoutState();
}

class _AuthenticatedLayoutState extends State<AuthenticatedLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController _profileController = Get.put(ProfileController());
  int _selectedIndex = 0;
  late var _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.newIndex != null) {
      _selectedIndex = widget.newIndex!;
    }

    _pages = [
      Home(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      Tours(),
      CheckinsSearch(),
      Profile(),
    ];

    _profileController.profileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "SHRACHI",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Kolkata, West Bengal",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                leading: const Icon(
                  Icons.event_note_outlined,
                  color: Colors.black,
                ),
                title: const Text(
                  "Attendance",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Attendance()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.exposure,
                  color: Colors.black,
                ),
                title: const Text(
                  "Tour Details",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExpenseAndOutCome_Screeen()),
                  );
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.report,
              //     color: Colors.black,
              //   ),
              //   title: const Text(
              //     "Expense Report",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ExpenseReportScreen(tourId : "60")),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.event_available_outlined,
              //     color: Colors.black,
              //   ),
              //   title: const Text(
              //     "Leaves",
              //     style: TextStyle(color: Colors.black),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => LeavesList()),
              //     );
              //   },
              // ),
              ListTile(
                leading: const Icon(
                  Ionicons.calendar_number,
                  color: Colors.black,
                ),
                title: const Text(
                  "Holidays",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calender()),
                  );
                },
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: Offset(0, -1),
                blurRadius: 8,
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 15,
            unselectedFontSize: 15,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 0 ? Ionicons.home : Ionicons.home_outline,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 1
                      ? Ionicons.paper_plane
                      : Ionicons.paper_plane_outline,
                ),
                label: 'Tours',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 2
                      ? Ionicons.reader
                      : Ionicons.reader_outline,
                ),
                label: 'Check In',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  _selectedIndex == 3
                      ? Ionicons.person_circle
                      : Ionicons.person_circle_outline,
                ),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
