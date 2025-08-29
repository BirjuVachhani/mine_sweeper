import 'package:flutter/material.dart';
import '../models/cell.dart';

class GameCell extends StatelessWidget {
  final Cell cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isGameOver;
  
  const GameCell({
    super.key,
    required this.cell,
    required this.onTap,
    required this.onLongPress,
    required this.isGameOver,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: _getCellColor(),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: _buildCellContent(),
        ),
      ),
    );
  }
  
  Color _getCellColor() {
    if (cell.isRevealed) {
      if (cell.isMine) {
        return Colors.red.shade300;
      }
      return Colors.grey.shade200;
    } else if (cell.isFlagged) {
      return Colors.orange.shade200;
    }
    return Colors.grey.shade300;
  }
  
  Widget _buildCellContent() {
    if (cell.isFlagged) {
      return Icon(
        Icons.flag,
        color: Colors.red.shade700,
        size: 16,
      );
    }
    
    if (cell.isRevealed) {
      if (cell.isMine) {
        return Icon(
          Icons.dangerous,
          color: Colors.red.shade700,
          size: 16,
        );
      } else if (cell.adjacentMines > 0) {
        return Text(
          '${cell.adjacentMines}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _getNumberColor(cell.adjacentMines),
          ),
        );
      }
    }
    
    return const SizedBox.shrink();
  }
  
  Color _getNumberColor(int number) {
    switch (number) {
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.red;
      case 4: return Colors.purple;
      case 5: return Colors.brown;
      case 6: return Colors.pink;
      case 7: return Colors.black;
      case 8: return Colors.grey;
      default: return Colors.black;
    }
  }
}
