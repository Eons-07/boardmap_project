import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class BoardMapApp extends StatelessWidget {
  const BoardMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF244C3A), teal = Color(0xFF367F78), amber = Color(0xFFD99A45), ivory = Color(0xFFF7F4EC);
    final scheme = ColorScheme.fromSeed(seedColor: forest).copyWith(
      primary: forest,
      onPrimary: Colors.white,
      secondary: teal,
      onSecondary: Colors.white,
      tertiary: amber,
      onSurface: const Color(0xFF1F2A24),
      onSurfaceVariant: const Color(0xFF5B6B63),
      surface: const Color(0xFFFCFAF5),
      secondaryContainer: const Color(0xFFDCEBE8),
      onSecondaryContainer: forest,
      outlineVariant: const Color(0xFFE4DFD0),
    );
    return MaterialApp(
      title: 'BoardMap: CBR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: ivory),
      home: const LoginScreen(),
    );
  }
}