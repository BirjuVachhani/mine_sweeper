import 'package:flutter/material.dart';

class GameHeader extends StatelessWidget {
  final int remainingFlags;
  final Duration elapsedTime;
  final VoidCallback onNewGame;
  final String gameStatus;

  const GameHeader({
    super.key,
    required this.remainingFlags,
    required this.elapsedTime,
    required this.onNewGame,
    required this.gameStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoCard(
            context,
            icon: Icons.flag,
            value: remainingFlags.toString().padLeft(2, '0'),
            color: colorScheme.error,
          ),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: onNewGame,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('New Game'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                gameStatus,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(context),
                ),
              ),
            ],
          ),
          _buildInfoCard(
            context,
            icon: Icons.timer,
            value: _formatTime(elapsedTime),
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
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

  Color _getStatusColor(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    switch (gameStatus) {
      case 'Won!':
        return isLight ? Colors.green.shade700 : Colors.green.shade300;
      case 'Lost!':
        return Theme.of(context).colorScheme.error;
      default:
        return isLight ? Colors.orange.shade700 : Colors.orange.shade300;
    }
  }
}
