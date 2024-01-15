import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

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
