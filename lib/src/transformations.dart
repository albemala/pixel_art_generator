import 'dart:math';

import 'package:pixel_art_generator/src/pixel_data.dart';

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
