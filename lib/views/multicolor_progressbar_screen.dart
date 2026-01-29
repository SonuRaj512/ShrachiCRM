import 'package:flutter/material.dart';

class MultiColorCircularLoader extends StatefulWidget {
  const MultiColorCircularLoader({super.key, this.size = 22});

  final double size;

  @override
  State<MultiColorCircularLoader> createState() =>
      _MultiColorCircularLoaderState();
}

class _MultiColorCircularLoaderState extends State<MultiColorCircularLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.grey),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.grey, end: Colors.blue),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: _colorAnimation, // ✅ CORRECT
      ),
    );
  }
}