import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerGenerator {
  static Future<BitmapDescriptor> createMarkerWithLabelOnDefault({
    required String label,
    Color labelColor = Colors.black,
    Color labelBackgroundColor = Colors.white,
    double width = 250,
    TextStyle? textStyle,
    double markerHeight = 60,
    double borderRadius = 8,
  }) async {
    final ts =
        textStyle ??
        TextStyle(fontSize: 28, color: labelColor, fontWeight: FontWeight.bold);

    final lines = _wrapText(label, ts, width.toInt());

    final textHeight = lines.length * ts.fontSize! * 1.4;
    final canvasHeight = textHeight + markerHeight + 8; // extra padding

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Calculate max line width
    double maxLineWidth = 0;
    for (final line in lines) {
      textPainter.text = TextSpan(text: line, style: ts);
      textPainter.layout(minWidth: 0, maxWidth: width);
      if (textPainter.width > maxLineWidth) maxLineWidth = textPainter.width;
    }

    // Draw white box behind text
    final boxPadding = 8.0;
    final rect = RRect.fromLTRBR(
      (width - maxLineWidth) / 2 - boxPadding,
      0,
      (width + maxLineWidth) / 2 + boxPadding,
      textHeight + boxPadding,
      Radius.circular(borderRadius),
    );

    final paint = Paint()..color = labelBackgroundColor;
    canvas.drawRRect(rect, paint);

    // Draw text
    double yOffset = 4; // slight top padding
    for (final line in lines) {
      textPainter.text = TextSpan(text: line, style: ts);
      textPainter.layout(minWidth: 0, maxWidth: width);
      textPainter.paint(
        canvas,
        Offset((width - textPainter.width) / 2, yOffset),
      );
      yOffset += ts.fontSize! * 1.4;
    }

    // Draw default marker circle (approximate)
    final markerPaint = Paint()..color = Colors.red;
    final radius = markerHeight / 2.5;
    canvas.drawCircle(Offset(width / 2, yOffset + radius), radius, markerPaint);

    final img = await pictureRecorder.endRecording().toImage(
      width.toInt(),
      canvasHeight.toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  static List<String> _wrapText(String text, TextStyle style, int maxWidth) {
    final words = text.split(' ');
    final lines = <String>[];
    String currentLine = '';
    final tp = TextPainter(textDirection: TextDirection.ltr);

    for (final word in words) {
      final testLine = currentLine.isEmpty ? word : '$currentLine $word';
      tp.text = TextSpan(text: testLine, style: style);
      tp.layout();
      if (tp.width > maxWidth && currentLine.isNotEmpty) {
        lines.add(currentLine);
        currentLine = word;
      } else {
        currentLine = testLine;
      }
    }

    if (currentLine.isNotEmpty) lines.add(currentLine);

    return lines;
  }
}
