import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel_art_generator/pixel_art_generator.dart';

void main() {
  runApp(const AppView());
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pixel Art Generator',
      home: AppContentView(),
    );
  }
}

class AppContentView extends StatelessWidget {
  const AppContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Art Generator'),
      ),
      body: const PixelArtGeneratorView(),
    );
  }
}

class PixelArtGeneratorView extends StatefulWidget {
  const PixelArtGeneratorView({super.key});

  @override
  State<PixelArtGeneratorView> createState() => _PixelArtGeneratorViewState();
}

class _PixelArtGeneratorViewState extends State<PixelArtGeneratorView> {
  static const randomTemplateName = 'Random';

  bool isRandomTemplateName(String name) {
    return name == randomTemplateName;
  }

  final dataColorConverter = CustomPixelDataColorConverter();

  int tilesCount = 3;

  final availableTemplates = <PixelDataTemplate>[];

  final allTemplates = <String>[
    randomTemplateName,
  ];
  String selectedTemplateName = randomTemplateName;

  int dataSize = 4;
  bool mirrorX = false;
  bool mirrorY = false;
  bool outline = false;

  var pixelData = <PixelData>[];

  PixelDataTemplate get selectedTemplate {
    return availableTemplates.firstWhere((element) {
      return element.name == selectedTemplateName;
    });
  }

  int get selectedTemplateDataSize {
    return isRandomTemplateName(selectedTemplateName)
        ? dataSize
        : selectedTemplate.width;
  }

  bool get selectedTemplateMirrorX {
    return isRandomTemplateName(selectedTemplateName)
        ? mirrorX
        : selectedTemplate.options.mirrorX;
  }

  bool get selectedTemplateMirrorY {
    return isRandomTemplateName(selectedTemplateName)
        ? mirrorY
        : selectedTemplate.options.mirrorY;
  }

  bool get selectedTemplateOutline {
    return isRandomTemplateName(selectedTemplateName)
        ? outline
        : selectedTemplate.options.outline;
  }

  @override
  void initState() {
    super.initState();
    updateData();
    _init();
  }

  Future<void> _init() async {
    // load templates from assets/templates.json
    final jsonString = await rootBundle.loadString('assets/templates.json');
    availableTemplates.addAll(loadPixelTemplatesFromJson(jsonString));
    setState(() {
      allTemplates.addAll(availableTemplates.map((e) => e.name));
    });
  }

  void updateData() {
    setState(() {
      final template = isRandomTemplateName(selectedTemplateName)
          ? generateRandomPixelDataTemplate(
              dataSize,
              dataSize,
              mirrorX: mirrorX,
              mirrorY: mirrorY,
              outline: outline,
            )
          : selectedTemplate;
      pixelData = generateRandomPixelData(
        tilesCount * tilesCount,
        template,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tiles count $tilesCount'),
              SizedBox(
                width: 240,
                child: Slider(
                  value: tilesCount.toDouble(),
                  min: 3,
                  max: 9,
                  divisions: 6,
                  onChanged: (value) {
                    tilesCount = value.toInt();
                    updateData();
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text('Template'),
              SizedBox(
                width: 240,
                child: DropdownButton<String>(
                  value: selectedTemplateName,
                  onChanged: (value) {
                    selectedTemplateName = value ?? randomTemplateName;
                    updateData();
                  },
                  items: allTemplates.map((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Data size $selectedTemplateDataSize'),
              if (isRandomTemplateName(selectedTemplateName))
                SizedBox(
                  width: 240,
                  child: Slider(
                    value: dataSize.toDouble(),
                    min: 4,
                    max: 16,
                    divisions: 12,
                    onChanged: (value) {
                      dataSize = value.toInt();
                      updateData();
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: selectedTemplateMirrorX,
                    onChanged: (value) {
                      if (isRandomTemplateName(selectedTemplateName)) {
                        mirrorX = value ?? false;
                        updateData();
                      }
                    },
                  ),
                  const Text('Mirror X'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: selectedTemplateMirrorY,
                    onChanged: (value) {
                      if (isRandomTemplateName(selectedTemplateName)) {
                        mirrorY = value ?? false;
                        updateData();
                      }
                    },
                  ),
                  const Text('Mirror Y'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: selectedTemplateOutline,
                    onChanged: (value) {
                      if (isRandomTemplateName(selectedTemplateName)) {
                        outline = value ?? false;
                        updateData();
                      }
                    },
                  ),
                  const Text('Outline'),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  updateData();
                },
                child: const Text('Generate'),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: pixelData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: tilesCount,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: PixelDataViewer(
                  pixelData: pixelData[index],
                  colorConverter: dataColorConverter,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CustomPixelDataColorConverter extends PixelDataColorConverter {
  CustomPixelDataColorConverter();

  @override
  Color convert(int value) {
    switch (value) {
      case backgroundData:
        return Colors.grey[100]!;
      case foregroundData:
        return Colors.grey[400]!;
      case accentData:
        return Colors.grey[600]!;
      case outlineData:
        return Colors.grey[800]!;
    }
    return Colors.red;
  }
}
