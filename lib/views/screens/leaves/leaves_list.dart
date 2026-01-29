import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/api/leave_controller.dart';
import 'package:shrachi/views/components/tour_plan_widget.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/leaves/create_leave.dart';
import 'package:shrachi/views/screens/leaves/show_leave.dart';
import 'package:get/get.dart';

class LeavesList extends StatefulWidget {
  const LeavesList({super.key});

  @override
  State<LeavesList> createState() => _LeavesListState();
}

class _LeavesListState extends State<LeavesList> {
  final _searchController = TextEditingController();
  final LeaveController _leaveController = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _leaveController.getAllLeaves();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: Text("Leaves List",style: TextStyle(color: Colors.white),),
          leading: BackButton(),
        ),
        body: Stack(
          children: [
            Obx(() {
              return _leaveController.isLoading.value
                  ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorPalette.pictonBlue500,
                    ),
                  )
                  : Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 15.0,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.isMd(context) ? 5 : 25,
                          ),
                          child: Align(
                            alignment:
                                Responsive.isMd(context)
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                            child: SizedBox(
                              width:
                                  Responsive.isMd(context)
                                      ? screenWidth
                                      : screenWidth / 4,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Ionicons.search),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.42,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  hintText: 'Search',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child:
                                _leaveController.leaves.isEmpty
                                    ? Center(child: Text('No leaves to show'))
                                    : Wrap(
                                      spacing: 20,
                                      runSpacing: 10,
                                      children: List.generate(
                                        _leaveController.leaves.length,
                                        (index) {
                                          final leave = _leaveController.leaves[index];
                                          return SizedBox(
                                            width: Responsive.isMd(context)
                                                    ? screenWidth - 40
                                                    : Responsive.isXl(context)
                                                    ? screenWidth / 2 - 40
                                                    : screenWidth / 3 - 40,
                                            child: TourPlanWidget(
                                              title: leave.leaveType!.name,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) => ShowLeave(
                                                          leaveModel: leave,
                                                        ),
                                                  ),
                                                );
                                              },
                                              intervalBackgroundColor:
                                                  ColorPalette.pictonBlue100,
                                              intervalIcon:
                                                  Ionicons.calendar_outline,
                                              intervalIconColor:
                                                  ColorPalette.pictonBlue500,
                                              intervalText: DateFormat(
                                                'dd MMM, yyyy',
                                              ).format(leave.startDate),
                                              intervalTextColor:
                                                  ColorPalette.pictonBlue500,
                                              showStats: true,
                                              statsBackgroundColor:
                                                  leave.status == 'pending'
                                                      ? Colors.red.shade100
                                                      : leave.status ==
                                                          'approved'
                                                      ? ColorPalette.seaGreen100
                                                      : Colors.indigo.shade100,
                                              statsIcon:
                                                  leave.status == 'pending'
                                                      ? Ionicons.time_outline
                                                      : leave.status ==
                                                          'approved'
                                                      ? Ionicons
                                                          .checkmark_circle
                                                      : Ionicons.close_circle,
                                              statsIconColor:
                                                  leave.status == 'pending'
                                                      ? Colors.red.shade500
                                                      : leave.status ==
                                                          'approved'
                                                      ? ColorPalette.seaGreen500
                                                      : Colors.indigo,
                                              statsText: leave.status,
                                              statsTextColor:
                                                  leave.status == 'pending'
                                                      ? Colors.red
                                                      : leave.status ==
                                                          'approved'
                                                      ? ColorPalette.seaGreen500
                                                      : Colors.indigo,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
            }),
            Positioned(
              bottom: 30,
              right: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.seaGreen600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CreateLeave()),
                  );
                },
                child: Icon(Ionicons.add_sharp, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
