import 'package:flutter/material.dart';
import 'package:shrachi/api/api_controller.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/checkins/checkins_search.dart';
import 'package:get/get.dart';

class CheckinsScreen extends StatefulWidget {
  const CheckinsScreen({super.key});

  @override
  State<CheckinsScreen> createState() => _CheckinsScreenState();
}

class _CheckinsScreenState extends State<CheckinsScreen> {
  final ApiController controller = Get.put(ApiController());
  final List<String> options = [
    'Dealer',
    'Leads',
    'New lead',
    'Department',
    'HO',
    'Warehouse',
    'Transit',
  ];
  String optionError = '';
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Check In')),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width:
              Responsive.isMd(context)
                  ? screenWidth
                  : Responsive.isXl(context)
                  ? screenWidth * 0.60
                  : screenWidth * 0.40,
          child: Card(
            color: Colors.white,
            elevation: 6,
            shadowColor: Colors.black.withValues(alpha: 0.2),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: options.map((option) {
                          return RadioListTile<String>(
                            title: Text(
                              option,
                              style: TextStyle(color: Colors.black),
                            ),
                            activeColor: Colors.black,
                            fillColor: WidgetStateProperty.all(Colors.black),
                            value: option,
                            groupValue: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          );
                        }).toList(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinsSearch(),
                        ),
                      );
                    },
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
