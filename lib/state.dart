// state.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

final gridProvider = StateProvider<List<List<Square>>>((ref) {
  // Initialize the grid with default colors (gray)
  List<List<Square>> grid = List.generate(8, (rowIndex) {
    return List.generate(8, (colIndex) {
      if ((rowIndex == 3 && colIndex == 2) || (rowIndex == 4 && colIndex == 2) ||
          (rowIndex == 3 && colIndex == 5) || (rowIndex == 4 && colIndex == 5)) {
        return Square(backgroundColor: Colors.blue, pieceColor: Colors.transparent);
      }
      return Square(backgroundColor: Colors.grey, pieceColor: Colors.transparent); // Default square color
    });
  });

  // Define green team pieces
  List<Piece> greenPieces = [
    Piece(0, 2, Colors.green),
    Piece(0, 3, Colors.green),
    Piece(0, 4, Colors.green),
    Piece(0, 5, Colors.green),
    Piece(1, 2, Colors.green),
    Piece(1, 3, Colors.green),
    Piece(1, 4, Colors.green),
    Piece(1, 5, Colors.green),
    Piece(2, 3, Colors.green),
    Piece(2, 4, Colors.green),
  ];

  // Define red team pieces
  List<Piece> redPieces = [
    Piece(5, 3, Colors.red),
    Piece(5, 4, Colors.red),
    Piece(6, 2, Colors.red),
    Piece(6, 3, Colors.red),
    Piece(6, 4, Colors.red),
    Piece(6, 5, Colors.red),
    Piece(7, 2, Colors.red),
    Piece(7, 3, Colors.red),
    Piece(7, 4, Colors.red),
    Piece(7, 5, Colors.red),
  ];

  // Place the green and red pieces on the grid
  for (var piece in greenPieces) {
    grid[piece.row][piece.col] = Square(backgroundColor: Colors.grey, pieceColor: piece.color);
  }

  for (var piece in redPieces) {
    grid[piece.row][piece.col] = Square(backgroundColor: Colors.grey, pieceColor: piece.color);
  }

  // Return the grid with all pieces placed
  return grid;
});
