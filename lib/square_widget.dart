import 'package:flutter/material.dart';

class SquareWidget extends StatelessWidget {
  final int row;
  final int col;
  final Color color;

  const SquareWidget({
    Key? key,
    required this.row,
    required this.col,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
          color: color,  // Background color of the square
          border: Border.all(
            color: Colors.black,  // Black border color
            width: 1.0,  // Border width (adjust as needed)
          ),
        ),
    );
  }
}
