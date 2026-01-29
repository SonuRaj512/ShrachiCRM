import 'package:flutter/material.dart';

class LeanClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double slant = 10;
    return Path()
      ..moveTo(slant, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - slant, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
