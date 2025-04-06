import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PieceType {
  empty,
  flag, // ⚑ Flag
  bomb, // 💣 Bomb
  spy, // 🕵 Spy
  scout, // 🥾 Scout
  miner, // 🛠 Miner
  soldier, // 🪖 Soldier
  major, // 👨🏼‍✈️ Major
}

class Piece {
  int row;
  int col;
  final Color color;
  final PieceType type; // Type of piece (Flag, Bomb, Spy, etc.)
  final int typeValue; // Value associated with the piece type

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
  final PieceType pieceType;
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
  final PieceType type;
  final int typeValue;

  const PieceWidget({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.type,
    required this.typeValue,
  }) : super(key: key);

  String getPieceText(PieceType pieceType) {
    switch (pieceType) {
      case PieceType.flag:
        return '⚑\nFlag';
      case PieceType.bomb:
        return '💣\nBomb';
      case PieceType.spy:
        return '🕵\nSpy';
      case PieceType.scout:
        return '🥾\nScout';
      case PieceType.miner:
        return '🛠\nMiner';
      case PieceType.soldier:
        return '🪖\nSoldier';
      case PieceType.major:
        return '👨🏼‍✈️\nMajor';
      default:
        return ''; // Return empty string for unknown piece type
    }
  }

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
          border:
              isSelected ? Border.all(color: Colors.white, width: 2.0) : null,
        ),
        child: Center(
          child: typeValue != -1 && typeValue != 0
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${getPieceText(type)}\n',
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
                  getPieceText(type),
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
  bool isReady = false;

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

  void calculate(Piece selected, Piece piece, int row, int col) {
    final grid = ref.read(gridProvider.notifier);
    if (((selectedPiece!.row - row).abs() > 1 ||
            (selectedPiece!.col - col).abs() > 1 ||
            (selectedPiece!.row != row && selectedPiece!.col != col))) {
          return;
        }

        List<List<Square>> currentGrid = [...ref.read(gridProvider)];
         void removeAt(int r, int c) {
            currentGrid[r][c] = Square(
              backgroundColor: currentGrid[r][c].backgroundColor,
              pieceColor: Colors.transparent,
              pieceType: PieceType.empty,
              pieceTypeValue: -1,
            );
          }

    if (piece.typeValue == -1 && piece.type == PieceType.flag) {
      print("win");
    } else if (piece.typeValue == 0) {
      print("bomb");
          removeAt(selected.row, selected.col);
    } else if (piece.typeValue == 5 && selected.type == PieceType.spy) {
      print("spy"); //
      removeAt(row, col);


      movePiece(row, col);
    } else if (selected.typeValue == piece.typeValue) {
      print("draw");
      removeAt(row, col);
          removeAt(selected.row, selected.col);
    } else if (selected.typeValue < piece.typeValue) {
      print("lose selected");
      removeAt(selected.row, selected.col);
    } else if (selected.typeValue > piece.typeValue) {
      print("lose piece"); //
      removeAt(row, col);

       movePiece(row, col);
    } else {
      print("bombom");
    }

//     setState(() {
        grid.state = currentGrid;
        selectedPiece = null;
//       }
  }

  void movePiece(int row, int col) {
    if (selectedPiece == null) return;

    final gridState = ref.read(gridProvider);
    if (gridState[row][col].backgroundColor == Colors.blue) return;

    if (isReady) {



      if (((selectedPiece!.row - row).abs() > 1 ||
          (selectedPiece!.col - col).abs() > 1 ||
          (selectedPiece!.row != row && selectedPiece!.col != col))) {

          if(selectedPiece!.typeValue == PieceType.scout) {
            int diffRow = (selectedPiece!.row - row).abs();
            int diffCol = (selectedPiece!.col - col).abs();
            if (diffRow > diffCol) {
                
            } else {

            }
          }

        return;
      }
      if (selectedPiece!.typeValue <= 0) {
        return; // Bombs and Flags can't be moved
      }
    } else {
      // In not-ready state, restrict movement within starting zone
      bool isGreen = selectedPiece!.color == Colors.green;
      bool isRed = selectedPiece!.color == Colors.red;
      if ((isGreen && (row > 2 || selectedPiece!.row > 2)) ||
          (isRed && (row < 5 || selectedPiece!.row < 5))) {
        return;
      }
    }

    setState(() {
      gridState[selectedPiece!.row][selectedPiece!.col] = Square(
        backgroundColor:
            gridState[selectedPiece!.row][selectedPiece!.col].backgroundColor,
        pieceColor: Colors.transparent,
        pieceType: PieceType.empty,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isReady = !isReady;
                });
              },
              child:
                  Text(isReady ? 'Ready (🔒 Locked)' : 'Not Ready (✏️ Setup)'),
            ),
            const SizedBox(height: 8),
            Container(
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
                          final square = gridState[rowIndex][colIndex];

                          if (square.pieceColor != Colors.transparent) {
                            // 🚫 Don't allow selecting flags or bombs if in Ready mode

                            final piece = Piece(
                              rowIndex,
                              colIndex,
                              square.pieceColor,
                              square.pieceType,
                              square.pieceTypeValue,
                            );

                            if (selectedPiece != null &&
                                selectedPiece!.row == piece.row &&
                                selectedPiece!.col == piece.col) {
                              selectPiece(null);
                            } else {
                            if (isReady) {

                                if (selectedPiece != null && selectedPiece!.color != piece.color) {
                                    calculate(selectedPiece!, piece, rowIndex, colIndex);
                                } else {
                                    if ((square.pieceType == PieceType.empty || square.pieceType == PieceType.flag || square.pieceType == PieceType.bomb)) {
                                            return;
                                    }
                                    selectPiece(piece);
                                }

                            } else {
                                selectPiece(piece);
                            }



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
          ],
        ),
      ),
    );
  }
}

final gridProvider = StateProvider<List<List<Square>>>((ref) {
  List<List<Square>> grid = List.generate(8, (rowIndex) {
    return List.generate(8, (colIndex) {
      if ((rowIndex == 3 && colIndex == 2) ||
          (rowIndex == 4 && colIndex == 2) ||
          (rowIndex == 3 && colIndex == 5) ||
          (rowIndex == 4 && colIndex == 5)) {
        return Square(
            backgroundColor: Colors.blue,
            pieceColor: Colors.transparent,
            pieceType: PieceType.empty,
            pieceTypeValue: -1);
      }
      return Square(
        backgroundColor: Colors.grey,
        pieceColor: Colors.transparent,
        pieceType: PieceType.empty,
        pieceTypeValue: -1,
      );
    });
  });

  List<Piece> greenPieces = [
    Piece(0, 2, Colors.green, PieceType.flag, -1),
    Piece(0, 3, Colors.green, PieceType.bomb, 0),
    Piece(0, 4, Colors.green, PieceType.bomb, 0),
    Piece(0, 5, Colors.green, PieceType.spy, 1),
    Piece(1, 2, Colors.green, PieceType.scout, 2),
    Piece(1, 3, Colors.green, PieceType.scout, 2),
    Piece(1, 4, Colors.green, PieceType.miner, 3),
    Piece(1, 5, Colors.green, PieceType.miner, 3),
    Piece(2, 3, Colors.green, PieceType.soldier, 4),
    Piece(2, 4, Colors.green, PieceType.major, 5),
  ];

  List<Piece> redPieces = [
    Piece(6, 2, Colors.red, PieceType.flag, -1),
    Piece(5, 3, Colors.red, PieceType.bomb, 0),
    Piece(5, 4, Colors.red, PieceType.bomb, 0),
    Piece(6, 3, Colors.red, PieceType.spy, 1),
    Piece(6, 4, Colors.red, PieceType.scout, 2),
    Piece(6, 5, Colors.red, PieceType.scout, 2),
    Piece(7, 2, Colors.red, PieceType.miner, 3),
    Piece(7, 3, Colors.red, PieceType.miner, 3),
    Piece(7, 4, Colors.red, PieceType.soldier, 4),
    Piece(7, 5, Colors.red, PieceType.major, 5),
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

/*



mke el scout konkret liqy kara gna u chen kara irar glxi trni scout axpery

not readyi jamanak ham el irar tex poxven irar het

kancay cuyc chtal amenaverjum
*/
