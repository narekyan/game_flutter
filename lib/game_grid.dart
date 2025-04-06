import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Piece {
  int row;
  int col;
  final Color color;
  final String type;  // Type of piece (Flag, Bomb, Spy, etc.)
  final int typeValue;  // Value associated with the piece type

  Piece(this.row, this.col, this.color, this.type, this.typeValue);

  // Move the piece to a new position
  void move(int newRow, int newCol) {
    row = newRow;
    col = newCol;
  }
}

class Square {
  final Color backgroundColor;
  final Color pieceColor;
  final String pieceType;
  final int pieceTypeValue;

  Square({
    required this.backgroundColor,
    required this.pieceColor,
    required this.pieceType,
    required this.pieceTypeValue,
  });
}

class PieceWidget extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function() onTap;
  final String type;
  final int typeValue;

  const PieceWidget({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.type,
    required this.typeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: isSelected
              ? Border.all(color: Colors.white, width: 3.0)
              : null,
        ),
        child: Center(
          child: typeValue != -1 && typeValue != 0
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$type\n',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      TextSpan(
                        text: '$typeValue',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )
              : Text(
                  type,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
        ),
      ),
    );
  }
}

class SquareWidget extends StatelessWidget {
  final Square square;
  final VoidCallback onPieceTap;
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
      onTap: onPieceTap,
      child: Container(
        width: 80.0,
        height: 80.0,
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: square.backgroundColor,
          border: Border.all(color: Colors.black, width: 1.0),
        ),
        child: (square.pieceColor != Colors.transparent)
            ? Center(
                child: PieceWidget(
                  color: square.pieceColor,
                  isSelected: isSelected,
                  onTap: onPieceTap,
                  type: square.pieceType,
                  typeValue: square.pieceTypeValue,
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
  Piece? selectedPiece;
  Piece? previousPiece;

  void selectPiece(Piece? piece) {
    setState(() {
      if (selectedPiece == piece) {
        selectedPiece = null;
        previousPiece = null;
      } else {
        previousPiece = selectedPiece;
        selectedPiece = piece;
      }
    });
  }

  void movePiece(int row, int col) {
    if (selectedPiece == null) return;

    final gridState = ref.read(gridProvider);
    if (gridState[row][col].backgroundColor == Colors.blue) return;

    if ((selectedPiece!.row - row).abs() > 1 || (selectedPiece!.col - col).abs() > 1 ||
        (selectedPiece!.row != row && selectedPiece!.col != col)) {
      return;
    }

    setState(() {
      gridState[selectedPiece!.row][selectedPiece!.col] = Square(
        backgroundColor: gridState[selectedPiece!.row][selectedPiece!.col].backgroundColor,
        pieceColor: Colors.transparent,
        pieceType: "",
        pieceTypeValue: -1,
      );
      selectedPiece!.move(row, col);
      gridState[row][col] = Square(
        backgroundColor: gridState[row][col].backgroundColor,
        pieceColor: selectedPiece!.color,
        pieceType: selectedPiece!.type,
        pieceTypeValue: selectedPiece!.typeValue,
      );
      selectedPiece = null;
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
                        final piece = Piece(
                          rowIndex,
                          colIndex,
                          gridState[rowIndex][colIndex].pieceColor,
                          gridState[rowIndex][colIndex].pieceType,
                          gridState[rowIndex][colIndex].pieceTypeValue,
                        );

                        if (selectedPiece != null && (selectedPiece!.row == piece.row && selectedPiece!.col == piece.col)) {
                          selectPiece(null);
                        } else {
                          selectPiece(piece);
                        }
                      } else if (selectedPiece != null) {
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

final gridProvider = StateProvider<List<List<Square>>>((ref) {
  List<List<Square>> grid = List.generate(8, (rowIndex) {
    return List.generate(8, (colIndex) {
      if ((rowIndex == 3 && colIndex == 2) || (rowIndex == 4 && colIndex == 2) ||
          (rowIndex == 3 && colIndex == 5) || (rowIndex == 4 && colIndex == 5)) {
        return Square(backgroundColor: Colors.blue, pieceColor: Colors.transparent, pieceType: "", pieceTypeValue: -1);
      }
      return Square(
        backgroundColor: Colors.grey,
        pieceColor: Colors.transparent,
        pieceType: "",
        pieceTypeValue: -1,
      );
    });
  });

  List<Piece> greenPieces = [
    Piece(0, 2, Colors.green, '⚑ Flag', -1),
    Piece(0, 3, Colors.green, '💣Bomb', 0),
    Piece(0, 4, Colors.green, '💣Bomb', 0),
    Piece(0, 5, Colors.green, '🕵Spy', 1),
    Piece(1, 2, Colors.green, '🥾Scout', 2),
    Piece(1, 3, Colors.green, '🥾Scout', 2),
    Piece(1, 4, Colors.green, '🛠Miner', 3),
    Piece(1, 5, Colors.green, '🛠Miner', 3),
    Piece(2, 3, Colors.green, '🪖Soldier', 4),
    Piece(2, 4, Colors.green, '👨🏼‍✈️Major', 5),
  ];

  List<Piece> redPieces = [
    Piece(6, 2, Colors.red, '⚑ Flag', -1),
    Piece(5, 3, Colors.red, '💣Bomb', 0),
    Piece(5, 4, Colors.red, '💣Bomb', 0),
    Piece(6, 3, Colors.red, '🕵Spy', 1),
    Piece(6, 4, Colors.red, '🥾Scout', 2),
    Piece(6, 5, Colors.red, '🥾Scout', 2),
    Piece(7, 2, Colors.red, '🛠Miner', 3),
    Piece(7, 3, Colors.red, '🛠Miner', 3),
    Piece(7, 4, Colors.red, '🪖Soldier', 4),
    Piece(7, 5, Colors.red, '👨🏼‍✈️Major', 5),
  ];


  for (var piece in greenPieces) {
    grid[piece.row][piece.col] = Square(
      backgroundColor: Colors.grey,
      pieceColor: piece.color,
      pieceType: piece.type,
      pieceTypeValue: piece.typeValue,
    );
  }

  for (var piece in redPieces) {
    grid[piece.row][piece.col] = Square(
      backgroundColor: Colors.grey,
      pieceColor: piece.color,
      pieceType: piece.type,
      pieceTypeValue: piece.typeValue,
    );
  }

  return grid;
});
