import 'package:flutter/material.dart';

class Responsive {
  static const double xs = 390;
  static const double sm = 640;
  static const double md = 768;
  static const double xl = 1280;
  static const double xxl = 1440;
  static const double xxxl = 1536;

  static bool isXs(BuildContext context) =>
      MediaQuery.of(context).size.width <= xs;

  static bool isSm(BuildContext context) =>
      MediaQuery.of(context).size.width <= sm;

  static bool isMd(BuildContext context) =>
      MediaQuery.of(context).size.width <= md;

  static bool isXl(BuildContext context) =>
      MediaQuery.of(context).size.width <= xl;

  static bool is2Xl(BuildContext context) =>
      MediaQuery.of(context).size.width <= xxl;

  static bool is3Xl(BuildContext context) =>
      MediaQuery.of(context).size.width <= xxxl;

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
}
