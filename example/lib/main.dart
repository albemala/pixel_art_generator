import 'package:flutter/material.dart';
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
  final dataColorConverter = CustomPixelDataColorConverter();

  int tilesCount = 3;

  int dataSize = 4;
  bool mirrorX = false;
  bool mirrorY = false;
  bool outline = false;

  var template = emptyPixelDataTemplate;
  var data = <PixelData>[];

  @override
  void initState() {
    super.initState();
    updateData();
  }

  void updateData() {
    setState(() {
      // regenerate template data
      template = generateRandomPixelDataTemplate(
        dataSize,
        dataSize,
        mirrorX: mirrorX,
        mirrorY: mirrorY,
        outline: outline,
      );
      data = generateRandomPixelData(tilesCount * tilesCount, template);
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
              Text('Data size $dataSize'),
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
                    value: mirrorX,
                    onChanged: (value) {
                      mirrorX = value ?? false;
                      updateData();
                    },
                  ),
                  const Text('Mirror X'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: mirrorY,
                    onChanged: (value) {
                      mirrorY = value ?? false;
                      updateData();
                    },
                  ),
                  const Text('Mirror Y'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: outline,
                    onChanged: (value) {
                      outline = value ?? false;
                      updateData();
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
            itemCount: data.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: tilesCount,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: PixelDataViewer(
                  pixels: data[index],
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
        return Colors.grey[500]!;
      case accentData:
        return Colors.grey[700]!;
      case outlineData:
        return Colors.grey[900]!;
    }
    return Colors.red;
  }
}
