import 'package:flutter/material.dart';
import 'dart:async';
import '../models/game_state.dart';
import '../services/game_service.dart';
import '../widgets/game_header.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameState _gameState;
  Timer? _timer;
  
  @override
  void initState() {
    super.initState();
    _startNewGame();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startNewGame() {
    setState(() {
      _gameState = GameService.createNewGame();
    });
    _startTimer();
  }
  
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_gameState.isGameOver) {
        setState(() {
          GameService.updateElapsedTime(_gameState);
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  void _onCellTap(int row, int col) {
    if (_gameState.isGameOver) return;
    
    setState(() {
      _gameState = GameService.revealCell(_gameState, row, col);
    });
    
    if (_gameState.isGameOver) {
      _timer?.cancel();
      _showGameOverDialog();
    }
  }
  
  void _onCellLongPress(int row, int col) {
    if (_gameState.isGameOver) return;
    
    setState(() {
      _gameState = GameService.toggleFlag(_gameState, row, col);
    });
  }
  
  void _showGameOverDialog() {
    final isWon = _gameState.status == GameStatus.won;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isWon ? Icons.celebration : Icons.sentiment_dissatisfied,
              color: isWon ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(isWon ? 'Congratulations!' : 'Game Over'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isWon ? 'You won!' : 'You hit a mine!'),
            const SizedBox(height: 8),
            Text('Time: ${_formatTime(_gameState.elapsedTime)}'),
            if (isWon) Text('Mines: ${_gameState.totalMines}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewGame();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  String _getGameStatus() {
    switch (_gameState.status) {
      case GameStatus.won:
        return 'Won!';
      case GameStatus.lost:
        return 'Lost!';
      case GameStatus.playing:
        return 'Playing';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minesweeper'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GameHeader(
              remainingFlags: _gameState.remainingFlags,
              elapsedTime: _gameState.elapsedTime,
              onNewGame: _startNewGame,
              gameStatus: _getGameStatus(),
            ),
            const SizedBox(height: 20),
            Center(
              child: GameBoard(
                gameState: _gameState,
                onCellTap: _onCellTap,
                onCellLongPress: _onCellLongPress,
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to Play:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Tap to reveal cells'),
                    Text('• Long press to flag/unflag mines'),
                    Text('• Numbers show adjacent mine count'),
                    Text('• Avoid mines and reveal all safe cells to win!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
