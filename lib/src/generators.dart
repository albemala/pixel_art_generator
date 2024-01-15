import 'dart:math';

import 'package:pixel_art_generator/src/pixel_data.dart';
import 'package:pixel_art_generator/src/templates.dart';
import 'package:pixel_art_generator/src/transformations.dart';

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
