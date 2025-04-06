// square.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'piece_widget.dart';

class SquareWidget extends StatelessWidget {
  final Square square;
  final VoidCallback onPieceTap; // Handle tapping the square for selection or movement
  final bool isSelected;

  const SquareWidget({
    Key? key,
    required this.square,
    required this.onPieceTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPieceTap,  // When square is tapped, trigger selection or movement
      child: Container(
        width: 80.0,
        height: 80.0,
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: square.backgroundColor,  // Background color of the square
          border: Border.all(
            color: Colors.black,  // Black border color
            width: 1.0,
          ),
        ),
        child: (square.pieceColor != Colors.transparent)
            ? Center(
                child: PieceWidget(
                  color: square.pieceColor,
                  isSelected: isSelected,
                  onTap: onPieceTap,  // Make the piece widget clickable
                ),
              )
            : Container(),
      ),
    );
  }
}
