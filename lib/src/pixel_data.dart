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
