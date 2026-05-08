import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final sizeProvider = StateProvider<int>((ref) => 0);

final colorProvider = StateProvider<int>((ref) => 0);

final parsedColorsProvider =
    Provider.autoDispose.family<List<Color>, List<String>>((ref, rawColors) {
  if (rawColors.isEmpty) {
    // Default fallback colors if no colors are provided by the product
    return [
      const Color(0xff8b302c),
      const Color(0xff222222),
      const Color(0xffdfa88d),
    ];
  }

  return rawColors.map((c) {
    String colorStr = c.trim().toLowerCase();

    // Handle named colors
    switch (colorStr) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      case 'cyan':
        return Colors.cyan;
      case 'indigo':
        return Colors.indigo;
      case 'teal':
        return Colors.teal;
      case 'lime':
        return Colors.lime;
    }

    // Handle hex colors
    String hexString = colorStr.replaceAll('#', '');
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    if (hexString.length == 8) {
      try {
        return Color(int.parse(hexString, radix: 16));
      } catch (_) {
        return Colors.grey;
      }
    }

    return Colors.grey; // Default fallback for unparseable color strings
  }).toList();
});
