import 'package:flutter/material.dart';
import 'piece_widget.dart'; // Import the PieceWidget
import 'square.dart';

class SquareWidget extends StatelessWidget {
  final Square square;

  const SquareWidget({Key? key, required this.square}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: square.backgroundColor,  // Background color of the square
        border: Border.all(
          color: Colors.black,  // Black border color
          width: 1.0,  // Border width
        ),
      ),
      child: (square.pieceColor != Colors.transparent)
          ? Center(
              child: PieceWidget(color: square.pieceColor),  // Display the piece inside the square
            )
          : Container(),
    );
  }
}
