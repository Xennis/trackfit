// Draws the app icon and writes the launcher images for Android.
//
// Run from apps/trackfit: dart run tool/generate_icons.dart
import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const _teal = (0x1B, 0x6E, 0x7A);
const _light = (0xC4, 0xF1, 0xF8);

img.Image drawIcon(int size) {
  final icon = img.Image(width: size, height: size, numChannels: 4);
  final s = size / 1024;
  final radius = (224 * s).round();
  img.fillRect(
    icon,
    x1: 0,
    y1: 0,
    x2: size - 1,
    y2: size - 1,
    radius: radius,
    color: img.ColorRgba8(_teal.$1, _teal.$2, _teal.$3, 255),
  );
  // Reference band.
  img.fillRect(
    icon,
    x1: (160 * s).round(),
    y1: (380 * s).round(),
    x2: (864 * s).round(),
    y2: (640 * s).round(),
    radius: (40 * s).round(),
    color: img.ColorRgba8(_light.$1, _light.$2, _light.$3, 90),
  );
  // History line with points.
  const points = [(200, 600), (400, 470), (600, 540), (820, 330)];
  final white = img.ColorRgba8(255, 255, 255, 255);
  for (var i = 0; i < points.length - 1; i++) {
    final (x1, y1) = points[i];
    final (x2, y2) = points[i + 1];
    img.drawLine(
      icon,
      x1: (x1 * s).round(),
      y1: (y1 * s).round(),
      x2: (x2 * s).round(),
      y2: (y2 * s).round(),
      color: white,
      thickness: math.max(2, 44 * s),
    );
  }
  for (final (x, y) in points) {
    img.fillCircle(
      icon,
      x: (x * s).round(),
      y: (y * s).round(),
      radius: math.max(2, (54 * s).round()),
      color: white,
      antialias: true,
    );
  }
  return icon;
}

void main() {
  File('assets/icon/icon.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(img.encodePng(drawIcon(1024)));
  const densities = {
    'mdpi': 48,
    'hdpi': 72,
    'xhdpi': 96,
    'xxhdpi': 144,
    'xxxhdpi': 192,
  };
  densities.forEach((density, size) {
    File(
      'android/app/src/main/res/mipmap-$density/ic_launcher.png',
    ).writeAsBytesSync(img.encodePng(drawIcon(size)));
  });
}
