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
      duration: const Duration(milliseconds: 500),
    )..repeat();

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.yellow,),
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
        strokeWidth: 3.7,
        valueColor: _colorAnimation, // ✅ CORRECT
      ),
    );
  }
}


class AnimatedRefreshIcon extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedRefreshIcon({super.key, required this.onTap});

  @override
  _AnimatedRefreshIconState createState() => _AnimatedRefreshIconState();
}

class _AnimatedRefreshIconState extends State<AnimatedRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 500 milliseconds में एक चक्कर पूरा होगा
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePress() {
    // आइकन को 0 से 1 (360 degree) घुमाना शुरू करें
    _controller.forward(from: 0.0);
    // आपका reset function कॉल करें
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: _handlePress,
      ),
    );
  }
}