import 'cell.dart';

enum GameStatus {
  playing,
  won,
  lost,
}

class GameState {
  final int rows;
  final int cols;
  final int totalMines;
  List<List<Cell>> board;
  GameStatus status;
  int flagsUsed;
  int revealedCells;
  DateTime? startTime;
  Duration elapsedTime;
  
  GameState({
    required this.rows,
    required this.cols,
    required this.totalMines,
    required this.board,
    this.status = GameStatus.playing,
    this.flagsUsed = 0,
    this.revealedCells = 0,
    this.startTime,
    this.elapsedTime = Duration.zero,
  });
  
  int get remainingFlags => totalMines - flagsUsed;
  int get totalCells => rows * cols;
  int get nonMineCells => totalCells - totalMines;
  
  bool get isGameWon => revealedCells == nonMineCells && status != GameStatus.lost;
  bool get isGameOver => status == GameStatus.lost || status == GameStatus.won;
}
