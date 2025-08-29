import 'package:flutter/material.dart';
import '../models/game_state.dart';
import 'game_cell.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final Function(int, int) onCellTap;
  final Function(int, int) onCellLongPress;
  
  const GameBoard({
    super.key,
    required this.gameState,
    required this.onCellTap,
    required this.onCellLongPress,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          gameState.rows,
          (row) => Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              gameState.cols,
              (col) => SizedBox(
                width: 24,
                height: 24,
                child: GameCell(
                  cell: gameState.board[row][col],
                  onTap: () => onCellTap(row, col),
                  onLongPress: () => onCellLongPress(row, col),
                  isGameOver: gameState.isGameOver,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
