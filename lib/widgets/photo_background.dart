import 'package:flutter/material.dart';

class PhotoBackground extends StatelessWidget {
  final Widget child;
  final double radius;
  const PhotoBackground({super.key, required this.child, this.radius = 0});

  static void _ignoreError(Object error, StackTrace? stack) {} 
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(radius),
        image: const DecorationImage(image: AssetImage('assets/images/cabadbaran.jpg'), fit: BoxFit.cover, onError: _ignoreError),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [scheme.primary.withValues(alpha: 0.9), scheme.primary.withValues(alpha: 0.55)])),
        child: child,
      ),
    );
  }
}