import 'package:flutter/material.dart';

class PieceWidget extends StatelessWidget {
  final Color color;

  const PieceWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,  // Smaller size for the piece
      height: 60.0,
      color: color,  // Color of the piece (green or red)
    );
  }
}
