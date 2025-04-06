// piece_widget.dart
import 'package:flutter/material.dart';


class PieceWidget extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function() onTap;

  const PieceWidget({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // Handle piece selection
      child: Container(
        width: 60.0,  // Size set to 60x60
        height: 60.0,
        decoration: BoxDecoration(
          color: color,  // Piece color (green or red)
          borderRadius: BorderRadius.circular(8.0),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3.0)  // White border when selected
              : null,
        ),
      ),
    );
  }
}
