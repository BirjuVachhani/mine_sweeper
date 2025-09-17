import 'dart:math';
import '../models/cell.dart';
import '../models/game_state.dart';

class GameService {
  static const List<List<int>> directions = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1],           [0, 1],
    [1, -1],  [1, 0],  [1, 1],
  ];
  
  static GameState createNewGame({
    int rows = 16,
    int cols = 16,
    int mines = 40,
  }) {
    final board = List.generate(
      rows,
      (i) => List.generate(cols, (j) => Cell()),
    );
    
    _placeMines(board, rows, cols, mines);
    _calculateAdjacentMines(board, rows, cols);
    
    return GameState(
      rows: rows,
      cols: cols,
      totalMines: mines,
      board: board,
    );
  }
  
  static void _placeMines(List<List<Cell>> board, int rows, int cols, int mines) {
    final random = Random();
    int placedMines = 0;
    
    while (placedMines < mines) {
      final row = random.nextInt(rows);
      final col = random.nextInt(cols);
      
      if (!board[row][col].isMine) {
        board[row][col].isMine = true;
        placedMines++;
      }
    }
  }
  
  static void _calculateAdjacentMines(List<List<Cell>> board, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (!board[i][j].isMine) {
          int count = 0;
          for (final direction in directions) {
            final newRow = i + direction[0];
            final newCol = j + direction[1];
            
            if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
              if (board[newRow][newCol].isMine) {
                count++;
              }
            }
          }
          board[i][j].adjacentMines = count;
        }
      }
    }
  }
  
  static GameState revealCell(GameState gameState, int row, int col) {
    if (gameState.isGameOver || 
        row < 0 || row >= gameState.rows || 
        col < 0 || col >= gameState.cols) {
      return gameState;
    }
    
    final cell = gameState.board[row][col];
    
    if (cell.isFlagged || cell.isRevealed) {
      return gameState;
    }
    
    // Start timer on first move
    gameState.startTime ??= DateTime.now();
    
    if (cell.isMine) {
      cell.reveal();
      gameState.status = GameStatus.lost;
      _revealAllMines(gameState);
      return gameState;
    }
    
    _floodFill(gameState, row, col);
    
    if (gameState.isGameWon) {
      gameState.status = GameStatus.won;
    }
    
    return gameState;
  }
  
  static void _floodFill(GameState gameState, int row, int col) {
    if (row < 0 || row >= gameState.rows || 
        col < 0 || col >= gameState.cols) {
      return;
    }
    
    final cell = gameState.board[row][col];
    
    if (cell.isRevealed || cell.isFlagged || cell.isMine) {
      return;
    }
    
    cell.reveal();
    gameState.revealedCells++;
    
    if (cell.adjacentMines == 0) {
      for (final direction in directions) {
        _floodFill(gameState, row + direction[0], col + direction[1]);
      }
    }
  }
  
  static void _revealAllMines(GameState gameState) {
    for (int i = 0; i < gameState.rows; i++) {
      for (int j = 0; j < gameState.cols; j++) {
        if (gameState.board[i][j].isMine) {
          gameState.board[i][j].reveal();
        }
      }
    }
  }
  
  static GameState toggleFlag(GameState gameState, int row, int col) {
    if (gameState.isGameOver || 
        row < 0 || row >= gameState.rows || 
        col < 0 || col >= gameState.cols) {
      return gameState;
    }
    
    final cell = gameState.board[row][col];
    
    if (cell.isRevealed) {
      return gameState;
    }
    
    if (cell.isFlagged) {
      cell.toggleFlag();
      gameState.flagsUsed--;
    } else if (gameState.flagsUsed < gameState.totalMines) {
      cell.toggleFlag();
      gameState.flagsUsed++;
    }
    
    return gameState;
  }
  
  static Duration updateElapsedTime(GameState gameState) {
    if (gameState.startTime != null && !gameState.isGameOver) {
      gameState.elapsedTime = DateTime.now().difference(gameState.startTime!);
    }
    return gameState.elapsedTime;
  }
}
