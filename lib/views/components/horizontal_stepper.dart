import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shrachi/views/enums/color_palette.dart';
import 'package:shrachi/views/enums/responsive.dart';

class HorizontalStepper extends StatefulWidget {
  final List<Widget> steps;
  final int currentStep;
  final ValueChanged<int>? onStepTapped;
  final VoidCallback? onStepContinue;
  final VoidCallback? onStepCancel;

  const HorizontalStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
  });

  @override
  State<HorizontalStepper> createState() => _HorizontalStepperState();
}

class _HorizontalStepperState extends State<HorizontalStepper> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentStep);
  }

  @override
  void didUpdateWidget(covariant HorizontalStepper oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentStep != widget.currentStep) {
      _pageController.animateToPage(
        widget.currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment:
          Responsive.isSm(context) ? Alignment.topLeft : Alignment.center,
      child: SizedBox(
        width:
            Responsive.isSm(context)
                ? screenWidth
                : Responsive.isMd(context)
                ? screenWidth * 0.70
                : Responsive.isXl(context)
                ? screenWidth * 0.60
                : screenWidth * 0.30,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 30.0,
              ),
              child: Row(
                children: List.generate(widget.steps.length * 2 - 1, (index) {
                  if (index.isOdd) {
                    final leftStepIndex = index ~/ 2;
                    final isCompleted = leftStepIndex < widget.currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        color:
                            isCompleted
                                ? ColorPalette.seaGreen600
                                : ColorPalette.pictonBlue500,
                      ),
                    );
                  } else {
                    final stepIndex = index ~/ 2;
                    final isActive = widget.currentStep == stepIndex;
                    final isCompleted = stepIndex < widget.currentStep;
                    return GestureDetector(
                      onTap: () => widget.onStepTapped?.call(stepIndex),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            isActive || isCompleted
                                ? ColorPalette.seaGreen600
                                : ColorPalette.pictonBlue500,
                        child:
                            isCompleted
                                ? const Icon(
                                  Ionicons.checkmark_sharp,
                                  color: Colors.white,
                                  size: 20,
                                )
                                : Text(
                                  "${stepIndex + 1}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                      ),
                    );
                  }
                }),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    widget.steps.map((step) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: step,
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.currentStep > 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: widget.onStepCancel,
                      child: const Text("Previous"),
                    )
                  else
                    const SizedBox(width: 100),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: widget.onStepContinue,
                    child: Text("Next")
                    // Text(
                    //   widget.currentStep == widget.steps.length - 1
                    //       ? "Next"
                    //       : "Next",
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
