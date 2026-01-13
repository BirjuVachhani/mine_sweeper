import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  final ThemeService themeService;
  
  const ThemeToggleButton({
    super.key,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
      ),
      tooltip: themeService.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      onPressed: () => themeService.toggleTheme(),
    );
  }
}
