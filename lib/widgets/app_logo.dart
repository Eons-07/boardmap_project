import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final Color color; 
  final double size;
  final String? tagline;
  const AppLogo({super.key, required this.color, this.size = 26, this.tagline});

  @override
  Widget build(BuildContext context) {
    final asset = color.computeLuminance() > 0.5 ? 'assets/images/logo_light.png' : 'assets/images/logo.png';
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Image.asset(asset, height: size * 1.9, width: size * 1.9, errorBuilder: (_, __, ___) => Icon(Icons.home_work_outlined, color: color, size: size * 1.6)),
      const SizedBox(width: 8),
      Flexible(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('BoardMap: CBR', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1)),
          if (tagline != null) Text(tagline!, style: TextStyle(color: color.withValues(alpha: 0.85), fontSize: size * 0.5)),
        ]),
      ),
    ]);
  }
}