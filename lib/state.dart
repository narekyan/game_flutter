import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final gridProvider = StateProvider<List<List<Color>>>((ref) {
  // Initialize the 8x8 grid
  return List.generate(8, (rowIndex) {
    return List.generate(8, (colIndex) {
      // Set blue color for the specified squares
      if ((rowIndex == 3 && colIndex == 2) || (rowIndex == 4 && colIndex == 2) ||
          (rowIndex == 3 && colIndex == 5) || (rowIndex == 4 && colIndex == 5)) {
        return Colors.blue;
      }
      return Colors.grey;
    });
  });
});
