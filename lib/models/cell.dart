enum CellState {
  hidden,
  revealed,
  flagged,
}

class Cell {
  bool isMine;
  CellState state;
  int adjacentMines;
  
  Cell({
    this.isMine = false,
    this.state = CellState.hidden,
    this.adjacentMines = 0,
  });
  
  bool get isRevealed => state == CellState.revealed;
  bool get isFlagged => state == CellState.flagged;
  bool get isHidden => state == CellState.hidden;
  
  void reveal() {
    if (state == CellState.hidden) {
      state = CellState.revealed;
    }
  }
  
  void toggleFlag() {
    if (state == CellState.hidden) {
      state = CellState.flagged;
    } else if (state == CellState.flagged) {
      state = CellState.hidden;
    }
  }
}
