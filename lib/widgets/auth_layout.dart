import 'package:flutter/material.dart';
import 'app_logo.dart';
import 'photo_background.dart';

class AuthLayout extends StatelessWidget {
  final String title, subtitle;
  final List<(IconData, String, String)> features;
  final Widget child; 
  const AuthLayout({super.key, required this.title, required this.subtitle, required this.features, required this.child});

  Widget _feature((IconData, String, String) f) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(children: [
          CircleAvatar(radius: 22, backgroundColor: Colors.white.withValues(alpha: 0.18), child: Icon(f.$1, color: Colors.white)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(f.$2, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            Text(f.$3, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
          ])),
        ]),
      );

  Widget _hero(bool wide) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AppLogo(color: Colors.white, size: 30, tagline: 'Find Your Next Home'),
        SizedBox(height: wide ? 64 : 24),
        Text(title, style: TextStyle(color: Colors.white, fontSize: wide ? 38 : 28, fontWeight: FontWeight.w800, height: 1.15)),
        const SizedBox(height: 12),
        Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 16, height: 1.4)),
        if (wide) ...[const SizedBox(height: 40), for (final f in features) _feature(f)],
      ]);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final card = Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 8))]),
      child: child,
    );
    return Scaffold(
      body: SizedBox.expand(
        child: PhotoBackground(
          child: SafeArea(
            child: LayoutBuilder(builder: (context, box) {
              final wide = box.maxWidth >= 900; 
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(wide ? 48 : 20),
                      child: wide
                          ? Row(children: [Expanded(child: _hero(true)), const SizedBox(width: 48), SizedBox(width: 460, child: card)])
                          : Column(mainAxisSize: MainAxisSize.min, children: [_hero(false), const SizedBox(height: 24), card]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}