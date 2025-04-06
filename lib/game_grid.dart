import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              : null,  // No border when not selected
        ),
      ),
    );
  }
}

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

class GameGrid extends ConsumerStatefulWidget {
  const GameGrid({Key? key}) : super(key: key);

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends ConsumerState<GameGrid> {
  Piece? selectedPiece; // To track the selected piece
  Piece? previousPiece; // To track the previously selected piece


  // Handle piece selection
 void selectPiece(Piece? piece) {
   setState(() {
     // Deselect the piece if it's already selected
     if (selectedPiece == piece) {
       // If the same piece is clicked, deselect it and reset previousPiece
       selectedPiece = null;
       previousPiece = null;
     } else {
       previousPiece = selectedPiece; // Save the currently selected piece as previous
       selectedPiece = piece; // Select the new piece
     }
   });
 }

  // Handle piece movement
  void movePiece(int row, int col) {
    if (selectedPiece == null) return;

    // Rules for moving:
    // 1. Can't move outside the grid
    if (row < 0 || row >= 8 || col < 0 || col >= 8) {
      return;
    }

    // 2. Can't move to blue squares
    final gridState = ref.read(gridProvider);
    if (gridState[row][col].backgroundColor == Colors.blue) {
      return;
    }

    // 3. Can only move one step in any direction (up, down, left, right)
    if ((selectedPiece!.row - row).abs() > 1 || (selectedPiece!.col - col).abs() > 1 ||
        (selectedPiece!.row != row && selectedPiece!.col != col)) {
      return;
    }

    // Move the piece to the new position
    setState(() {
      gridState[selectedPiece!.row][selectedPiece!.col] = Square(
        backgroundColor: gridState[selectedPiece!.row][selectedPiece!.col].backgroundColor,
        pieceColor: Colors.transparent, // Clear the previous square
      );
      selectedPiece!.move(row, col); // Update the piece position
      gridState[row][col] = Square(
        backgroundColor: gridState[row][col].backgroundColor,
        pieceColor: selectedPiece!.color, // Place the piece on the new square
      );
      selectedPiece = null;  // Deselect the piece after moving
    });
  }

  @override
  Widget build(BuildContext context) {
    final gridState = ref.watch(gridProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(8, (rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(8, (colIndex) {
                  return SquareWidget(
                    square: gridState[rowIndex][colIndex],
                    onPieceTap: () {
                      if (gridState[rowIndex][colIndex].pieceColor != Colors.transparent) {
                        final piece = gridState[rowIndex][colIndex].pieceColor == Colors.green
                            ? Piece(rowIndex, colIndex, Colors.green)
                            : Piece(rowIndex, colIndex, Colors.red);

                        // Deselect the piece if it's already selected and clicked again
                        if (selectedPiece != null && (selectedPiece!.row == piece!.row && selectedPiece!.col == piece!.col)) {
                          selectPiece(null);
                        } else {
                          selectPiece(piece); // Select a new piece
                        }
                      } else if (selectedPiece != null) {
                        // Move the selected piece to this square
                        movePiece(rowIndex, colIndex);
                      }
                    },
                    isSelected: selectedPiece != null &&
                        selectedPiece!.row == rowIndex &&
                        selectedPiece!.col == colIndex
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}

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