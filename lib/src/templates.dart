import 'dart:convert';

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

List<PixelDataTemplate> loadPixelTemplatesFromJson(String jsonString) {
  final templatesJson = jsonDecode(jsonString) as List<dynamic>;

  return templatesJson.map((templateJson) {
    final templateMap = templateJson as Map<String, dynamic>;

    final optionsMap = templateMap['options'] as Map<String, dynamic>;
    final options = PixelDataTemplateOptions(
      mirrorX: optionsMap['mirrorX'] as bool,
      mirrorY: optionsMap['mirrorY'] as bool,
      outline: optionsMap['outline'] as bool,
    );

    final template = PixelDataTemplate(
      name: templateMap['name'] as String,
      width: templateMap['width'] as int,
      height: templateMap['height'] as int,
      data: List<int>.from(templateMap['data'] as List<dynamic>),
      options: options,
    );

    return template;
  }).toList();
}
