# Pixel art generator

[![Pub](https://img.shields.io/pub/v/pixel_art_generator)](https://pub.dev/packages/pixel_art_generator)

A Flutter package to generate pixel art sprites from an optional template.

|                                                     Humanoids                                                     |                                                     Robots                                                     |                                                     Spaceships                                                     |
|:-----------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------------------------------:|
| <img src="https://raw.githubusercontent.com/albemala/pixel_art_generator/main/example/screenshots/humanoids.png"> | <img src="https://raw.githubusercontent.com/albemala/pixel_art_generator/main/example/screenshots/robots.png"> | <img src="https://raw.githubusercontent.com/albemala/pixel_art_generator/main/example/screenshots/spaceships.png"> |

## Examples

#### Generate a single pixel art tile

```dart
final template = generateRandomPixelDataTemplate(
  5, 
  5,
  mirrorX: true,
  mirrorY: false,
  outline: true,
);
final pixelData = generateRandomPixelData(
  1,
  template,
).first;
```

#### Generate a list of pixel art tiles from a template

A set of predefined templates are
available [here](https://github.com/albemala/pixel_art_generator/blob/main/example/assets/templates.json).

```dart
// load templates from assets/templates.json
final jsonString = await rootBundle.loadString('assets/templates.json');
final templates = loadPixelTemplatesFromJson(jsonString);
final humanoidTemplate = templates[...];
final pixelData = generateRandomPixelData(9, humanoidTemplate);
```

## Support this project

<a href="https://www.buymeacoffee.com/albemala" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

## Credits

Inspired by [Pixel Sprite Generator](https://github.com/ArtBIT/pixel-sprite-generator)

Created by [@albemala](https://github.com/albemala) ([Twitter](https://twitter.com/albemala)).
