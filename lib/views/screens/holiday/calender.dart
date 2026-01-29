import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shrachi/api/holiday_controller.dart';
import 'package:shrachi/views/components/holiday_calendar.dart';

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final HolidayController holidayController = Get.put(HolidayController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      holidayController.getAllHolidays();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Holiday Calendar')),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Obx(() {
            return holidayController.isLoading.value
                ? CircularProgressIndicator(color: Colors.white)
                : HolidayCalendar(holidays: holidayController.holidays);
          }),
        ),
      ),
    );
  }
}
