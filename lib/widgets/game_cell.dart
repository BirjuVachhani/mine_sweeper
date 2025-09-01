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
          color: _getCellColor(context),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(
          child: _buildCellContent(context),
        ),
      ),
    );
  }
  
  Color _getCellColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (cell.isRevealed) {
      if (cell.isMine) {
        return colorScheme.errorContainer;
      }
      return colorScheme.surfaceVariant.withOpacity(0.7);
    } else if (cell.isFlagged) {
      return colorScheme.secondaryContainer;
    }
    return colorScheme.surfaceVariant;
  }
  
  Widget _buildCellContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (cell.isFlagged) {
      return Icon(
        Icons.flag,
        color: colorScheme.error,
        size: 16,
      );
    }
    
    if (cell.isRevealed) {
      if (cell.isMine) {
        return Icon(
          Icons.dangerous,
          color: colorScheme.error,
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
      case 1: return Colors.blueAccent;
      case 2: return Colors.green.shade600;
      case 3: return Colors.redAccent;
      case 4: return Colors.purpleAccent;
      case 5: return Colors.brown.shade400;
      case 6: return Colors.pinkAccent;
      case 7: return Colors.black;
      case 8: return Colors.grey.shade700;
      default: return Colors.black;
    }
  }
}
