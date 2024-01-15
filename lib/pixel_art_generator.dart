import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

const int backgroundData = 0;
const int foregroundData = 1;
const int accentData = 2;
const int outlineData = 3;

class PixelData {
  int width;
  int height;
  List<int> data;

  PixelData(
    this.width,
    this.height, [
    List<int>? data,
  ]) : data = data ?? List<int>.filled(width * height, 0);

  PixelData clone() {
    return PixelData(
      width,
      height,
      List<int>.from(data),
    );
  }

  int get(int x, int y) {
    return data[(y * width + x) % data.length];
  }

  void set(int x, int y, int value) {
    data[(y * width + x) % data.length] = value;
  }

  void reset([int? value]) {
    data.fillRange(0, data.length, value ?? 0);
  }

  bool isEmpty() {
    return data.every((value) => value == 0);
  }
}

sealed class PixelDataTransformation {
  PixelData transform(PixelData pixelData);
}

class MirrorXPixelDataTransformation extends PixelDataTransformation {
  @override
  PixelData transform(PixelData pixelData) {
    final wHalf = pixelData.width >> 1;
    final newData = List<int>.from(pixelData.data);
    for (var j = 0; j < pixelData.height; j++) {
      for (var i = 0; i < wHalf; i++) {
        newData[j * pixelData.width + pixelData.width - 1 - i] =
            pixelData.data[j * pixelData.width + i];
      }
    }
    return PixelData(pixelData.width, pixelData.height, newData);
  }
}

class MirrorYPixelDataTransformation extends PixelDataTransformation {
  @override
  PixelData transform(PixelData pixelData) {
    final hHalf = pixelData.height >> 1;
    final newData = List<int>.from(pixelData.data);
    for (var j = 0; j < hHalf; j++) {
      for (var i = 0; i < pixelData.width; i++) {
        newData[(pixelData.height - 1 - j) * pixelData.width + i] =
            pixelData.data[j * pixelData.width + i];
      }
    }
    return PixelData(pixelData.width, pixelData.height, newData);
  }
}

class OutlinePixelDataTransformation extends PixelDataTransformation {
  @override
  PixelData transform(PixelData pixelData) {
    final newData = List<int>.from(pixelData.data);
    final directions = [pixelData.width, -pixelData.width, 1, -1];
    for (var i = 0; i < pixelData.data.length; i++) {
      if (pixelData.data[i] > 0 && pixelData.data[i] != outlineData) {
        for (final direction in directions) {
          if (i + direction >= 0 &&
              i + direction < pixelData.data.length &&
              pixelData.data[i + direction] == 0) {
            newData[i + direction] = outlineData;
          }
        }
      }
    }
    return PixelData(pixelData.width, pixelData.height, newData);
  }
}

class RandomizePixelDataTransformation extends PixelDataTransformation {
  @override
  PixelData transform(PixelData pixelData) {
    final random = Random();
    final newData = pixelData.data.map((value) {
      if (value.isNegative) return value.abs();
      if (value == 1) return random.nextInt(2);
      if (value > 1) return random.nextInt(value) + 1;
      return 0;
    }).toList();
    return PixelData(pixelData.width, pixelData.height, newData);
  }
}

@immutable
class PixelDataTemplateOptions {
  final bool mirrorX;
  final bool mirrorY;
  final bool outline;

  const PixelDataTemplateOptions({
    required this.mirrorX,
    required this.mirrorY,
    required this.outline,
  });
}

@immutable
class PixelDataTemplate {
  final String name;
  final int width;
  final int height;
  final List<int> data;
  final PixelDataTemplateOptions options;

  const PixelDataTemplate({
    required this.name,
    required this.width,
    required this.height,
    required this.data,
    required this.options,
  });
}

const emptyPixelDataTemplate = PixelDataTemplate(
  name: 'Empty',
  width: 1,
  height: 1,
  data: [0],
  options: PixelDataTemplateOptions(
    mirrorX: false,
    mirrorY: false,
    outline: false,
  ),
);

PixelDataTemplate generateRandomPixelDataTemplate(
  int width,
  int height, {
  bool mirrorX = false,
  bool mirrorY = false,
  bool outline = false,
}) {
  final random = Random();
  final data = List<int>.generate(
    width * height,
    (index) {
      return random.nextInt(3);
    },
  );

  return PixelDataTemplate(
    name: 'Random',
    width: width,
    height: height,
    data: data,
    options: PixelDataTemplateOptions(
      mirrorX: mirrorX,
      mirrorY: mirrorY,
      outline: outline,
    ),
  );
}

List<PixelData> generateRandomPixelData(
  int count,
  PixelDataTemplate template,
) {
  final transformations = [
    RandomizePixelDataTransformation(),
    if (template.options.mirrorX) MirrorXPixelDataTransformation(),
    if (template.options.mirrorY) MirrorYPixelDataTransformation(),
    if (template.options.outline) OutlinePixelDataTransformation(),
  ];

  return List.generate(
    count,
    (index) {
      var data = PixelData(template.width, template.height, template.data);
      for (final transformation in transformations) {
        data = transformation.transform(data);
      }
      return data;
    },
  );
}

// TODO rewrite
Future<List<PixelDataTemplate>> loadPixelTemplatesFromJson(
    String filePath) async {
  final file = File(filePath);
  final content = await file.readAsString();
  final json = jsonDecode(content) as Map<String, dynamic>;

  return json.entries.map((entry) {
    final name = entry.key;
    final templateJson = entry.value as Map<String, dynamic>;
    final optionsJson = templateJson['options'] as Map<String, dynamic>;

    final options = PixelDataTemplateOptions(
      mirrorX: optionsJson['mirrorX'] as bool,
      mirrorY: optionsJson['mirrorY'] as bool,
      outline: optionsJson['outline'] as bool,
    );

    final template = PixelDataTemplate(
      name: name,
      width: templateJson['width'] as int,
      height: templateJson['height'] as int,
      data: List<int>.from(templateJson['data'] as List<dynamic>),
      options: options,
    );

    return template;
  }).toList();
}

abstract class PixelDataColorConverter {
  Color convert(int value);
}

class PixelDataViewer extends StatelessWidget {
  final PixelData pixels;
  final PixelDataColorConverter colorConverter;

  const PixelDataViewer({
    required this.pixels,
    required this.colorConverter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PixelDataPainter(
        pixels,
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
