import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class BoardMapApp extends StatelessWidget {
  const BoardMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF1D4ED8), ink = Color(0xFF0F172A), mist = Color(0xFFF4F7FB), line = Color(0xFFE2E8F0);
    final scheme = ColorScheme.fromSeed(seedColor: blue).copyWith(primary: blue, onPrimary: Colors.white, onSurface: ink, surface: Colors.white, tertiary: const Color(0xFFF59E0B), secondaryContainer: const Color(0xFFDBEAFE), onSecondaryContainer: blue, outlineVariant: line);
    return MaterialApp(
      title: 'BoardMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: scheme, scaffoldBackgroundColor: mist),
      home: const LoginScreen(),
    );
  }
}