import 'package:flutter/material.dart';

// piece.dart
class Piece {
  int row;
  int col;
  final Color color;

  Piece(this.row, this.col, this.color);

  // Move the piece to a new position
  void move(int newRow, int newCol) {
    row = newRow;
    col = newCol;
  }
}

class Square {
  final Color backgroundColor;
  final Color pieceColor;

  Square({required this.backgroundColor, required this.pieceColor});
}
