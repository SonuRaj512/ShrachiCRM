import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

void showTopPopup(String title, String message, Color color) {
  // Get.key.currentState?.overlay use karne se "No Overlay" error nahi aata
  final overlay = Get.key.currentState?.overlay;
  if (overlay == null) return;

  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      // MediaQuery notch handle karne ke liye
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 4),
              Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14)
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Screen par dikhao
  overlay.insert(overlayEntry);

  // 3 second baad automatic hata do
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}