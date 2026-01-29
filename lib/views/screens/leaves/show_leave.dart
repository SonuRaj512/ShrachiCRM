import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shrachi/api/leave_controller.dart';
import 'package:shrachi/models/leave_model.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';
import 'package:shrachi/views/screens/leaves/update_leave.dart';

class ShowLeave extends StatefulWidget {
  final LeaveModel leaveModel;
  const ShowLeave({super.key, required this.leaveModel});

  @override
  State<ShowLeave> createState() => _ShowLeaveState();
}

class _ShowLeaveState extends State<ShowLeave> {
  final LeaveController _leaveController = Get.put(LeaveController());
  int activeStep = 0;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Show Leave")),
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width:
                Responsive.isSm(context)
                    ? screenWidth
                    : Responsive.isXl(context)
                    ? screenWidth * 0.60
                    : screenWidth * 0.40,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leaveModel.status != 'approved')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ActionButton(
                          color: Colors.green,
                          icon: Icons.check,
                          label: "Send For Approval",
                          onTap: () {},
                        ),
                        _ActionButton(
                          color: Colors.brown,
                          icon: Icons.edit,
                          label: "Modify Leave",
                          onTap: () {
                            Get.to(
                              () => UpdateLeave(leaveModel: widget.leaveModel),
                            );
                          },
                        ),
                        _ActionButton(
                          color: Colors.red,
                          icon: Icons.delete,
                          label: "Delete Leave",
                          onTap: () async {
                            await _leaveController.deleteLeave(
                              id: widget.leaveModel.id,
                            );
                          },
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 6,
                    shadowColor: Colors.black.withValues(alpha: 0.2),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  'Leave Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  widget.leaveModel.leaveType!.name,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  DateFormat(
                                    'EEEE, dd MMM yyyy',
                                  ).format(DateTime(2025, 8, 26)),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  'Reason',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black.withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 4.0,
                                ),
                                child: Text(
                                  'test',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  EasyStepper(
                    activeStep: activeStep,
                    showLoadingAnimation: false,
                    internalPadding: 0,
                    stepRadius: 12,
                    fitWidth: true,
                    lineStyle: LineStyle(
                      lineLength:
                          Responsive.isMd(context)
                              ? screenWidth / 4 - 20
                              : screenWidth / 6 - 20,
                      lineType: LineType.normal,
                      lineSpace: 0,
                      activeLineColor: Colors.black.withValues(alpha: 0.3),
                      finishedLineColor: Colors.black.withValues(alpha: 0.3),
                      unreachedLineColor: Colors.black.withValues(alpha: 0.3),
                    ),
                    showStepBorder: false,
                    steps: [
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor:
                                activeStep >= 0
                                    ? ColorPalette.seaGreen500
                                    : Color(0xff6A7580),
                          ),
                        ),
                        customTitle: Text(
                          'New',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isSm(context) ? 14 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor:
                                activeStep >= 1
                                    ? ColorPalette.seaGreen500
                                    : Color(0xff6A7580),
                          ),
                        ),
                        customTitle: Text(
                          'Send For Approval',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isSm(context) ? 14 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor:
                                activeStep >= 2
                                    ? ColorPalette.seaGreen500
                                    : Color(0xff6A7580),
                          ),
                        ),
                        customTitle: Text(
                          'Approved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isSm(context) ? 14 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      EasyStep(
                        customStep: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 11,
                            backgroundColor:
                                activeStep >= 3
                                    ? Colors.red
                                    : Color(0xff6A7580),
                          ),
                        ),
                        customTitle: Text(
                          'Rejected',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Responsive.isSm(context) ? 14 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

class _ActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
