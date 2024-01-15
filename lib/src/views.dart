import 'package:flutter/material.dart';
import 'package:pixel_art_generator/src/pixel_data.dart';

abstract class PixelDataColorConverter {
  Color convert(int value);
}

class PixelDataViewer extends StatelessWidget {
  final PixelData pixelData;
  final PixelDataColorConverter colorConverter;

  const PixelDataViewer({
    required this.pixelData,
    required this.colorConverter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PixelDataPainter(
        pixelData,
        colorConverter,
      ),
    );
  }
}

class _PixelDataPainter extends CustomPainter {
  final PixelData pixels;
  final PixelDataColorConverter colorConverter;

  _PixelDataPainter(
    this.pixels,
    this.colorConverter,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = Size(
      size.width / pixels.width,
      size.height / pixels.height,
    );

    for (var y = 0; y < pixels.height; y++) {
      for (var x = 0; x < pixels.width; x++) {
        final value = pixels.get(x, y);
        final paint = Paint()
          ..color = colorConverter.convert(value)
          ..style = PaintingStyle.fill;
        canvas.drawRect(
          Rect.fromLTWH(
            x * pixelSize.width,
            y * pixelSize.height,
            pixelSize.width,
            pixelSize.height,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
