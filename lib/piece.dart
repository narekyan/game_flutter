import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Piece {
  final int row;
  final int col;
  final Color color;

  Piece(this.row, this.col, this.color);
}