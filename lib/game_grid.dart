// game_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'state.dart';
import 'square_widget.dart';

class GameGrid extends ConsumerStatefulWidget {
  const GameGrid({Key? key}) : super(key: key);

  @override
  _GameGridState createState() => _GameGridState();
}

class _GameGridState extends ConsumerState<GameGrid> {
  Piece? selectedPiece; // To track the selected piece

  // Handle piece selection
  void selectPiece(Piece piece) {
    setState(() {
      // Deselect the piece if it's already selected
      if (selectedPiece == piece) {
        selectedPiece = null;
      } else {
        selectedPiece = piece;
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
    if ((selectedPiece!.row - row).abs() > 1 || (selectedPiece!.col - col).abs() > 1) {
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
                        selectPiece(piece); // Select the piece
                      } else if (selectedPiece != null) {
                        // Move the selected piece to this square
                        movePiece(rowIndex, colIndex);
                      }
                    },
                    isSelected: selectedPiece != null &&
                        selectedPiece!.row == rowIndex &&
                        selectedPiece!.col == colIndex,
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
