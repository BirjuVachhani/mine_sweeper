import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const MinesweeperApp());
}

class MinesweeperApp extends StatefulWidget {
  const MinesweeperApp({super.key});

  @override
  State<MinesweeperApp> createState() => _MinesweeperAppState();
}

class _MinesweeperAppState extends State<MinesweeperApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      home: GameScreen(toggleTheme: _toggleTheme),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.light,
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.amber,
        onSecondary: Colors.black,
        surface: Colors.grey[200]!,
        onSurface: Colors.black87,
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: Colors.black87,
              displayColor: Colors.black87,
            ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ).headlineSmall,
      ),
      scaffoldBackgroundColor: Colors.grey[300],
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
          textStyle: GoogleFonts.pressStart2p(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
        primary: Colors.lightBlueAccent,
        onPrimary: Colors.black,
        secondary: Colors.deepOrangeAccent,
        onSecondary: Colors.white,
        surface: Colors.grey[900]!,
        onSurface: Colors.white70,
      ),
      textTheme: GoogleFonts.pressStart2pTextTheme(
        Theme.of(context).textTheme.apply(
              bodyColor: Colors.white70,
              displayColor: Colors.white70,
            ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ).headlineSmall,
      ),
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.pressStart2p(fontSize: 14),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
      useMaterial3: true,
    );
  }
}
