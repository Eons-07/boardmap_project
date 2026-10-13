import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class BoardMapApp extends StatelessWidget {
  const BoardMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF10303A), amber = Color(0xFFE8A33D), mist = Color(0xFFF2F5F7), line = Color(0xFFD5DEE3);
    final scheme = ColorScheme.fromSeed(seedColor: ink).copyWith(primary: ink, onPrimary: Colors.white, tertiary: amber, surface: Colors.white, secondaryContainer: const Color(0xFFE1EDE8), outlineVariant: line);
    return MaterialApp(
      title: 'BoardMap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: mist,
        chipTheme: ChipThemeData(selectedColor: ink, backgroundColor: Colors.white, side: const BorderSide(color: line), labelStyle: const TextStyle(fontWeight: FontWeight.w600), secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white, indicatorColor: Color(0xFFE1EDE8)),
      ),
      home: const LoginScreen(),
    );
  }
}