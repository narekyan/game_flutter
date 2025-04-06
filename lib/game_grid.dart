import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'square_widget.dart';
import 'state.dart';

class GameGrid extends ConsumerWidget {
  const GameGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridState = ref.watch(gridProvider);

    return Scaffold(
      backgroundColor: Colors.white,  // White background for the whole screen
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),  // Optional padding for spacing around the grid
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(8, (rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(8, (colIndex) {
                  return SquareWidget(
                    square: gridState[rowIndex][colIndex],  // Pass the square to the widget
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
