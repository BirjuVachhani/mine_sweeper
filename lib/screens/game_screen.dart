import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../models/game_state.dart';
import '../services/game_service.dart';
import '../widgets/game_header.dart';
import '../widgets/game_board.dart';

class GameScreen extends StatefulWidget {
  final Function(ThemeMode) toggleTheme;

  const GameScreen({super.key, required this.toggleTheme});
  
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Icon(
              isWon ? Icons.emoji_events : Icons.mood_bad,
              color: isWon ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(width: 8),
            Text(
              isWon ? 'VICTORY!' : 'DEFEAT!',
              style: GoogleFonts.pressStart2p(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isWon ? 'You\'ve cleared the field!' : 'BOOM! Mine Exploded!',
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${_formatTime(_gameState.elapsedTime)}',
              style: GoogleFonts.pressStart2p(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isWon)
              Text(
                'Mines Found: ${_gameState.totalMines}',
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startNewGame();
            },
            child: Text(
              'RETRY',
              style: GoogleFonts.pressStart2p(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
              ),
            ),
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
        return 'WON!';
      case GameStatus.lost:
        return 'LOST!';
      case GameStatus.playing:
        return 'PLAYING';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final currentThemeBrightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MINESWEEPER'),
        actions: [
          IconButton(
            icon: Icon(
              currentThemeBrightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              widget.toggleTheme(
                currentThemeBrightness == Brightness.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              );
            },
          ),
        ],
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
            Card(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOW TO PLAY:',
                      style: GoogleFonts.pressStart2p(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionText('• Tap to reveal cells'),
                    _buildInstructionText('• Long press to flag/unflag mines'),
                    _buildInstructionText('• Numbers show adjacent mine count'),
                    _buildInstructionText('• Avoid mines and reveal all safe cells to win!'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: GoogleFonts.pressStart2p(
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
