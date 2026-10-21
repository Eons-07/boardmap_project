import 'package:flutter/material.dart';

enum UiStatus { idle, loading, success, error }

class StatusBanner extends StatelessWidget {
  final UiStatus status;
  final String title, message;
  final VoidCallback? onRetry;
  const StatusBanner({super.key, required this.status, required this.title, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      UiStatus.idle => scheme.onSurfaceVariant,
      UiStatus.loading => scheme.primary,
      UiStatus.success => const Color(0xFF1E7B4F),
      UiStatus.error => scheme.error,
    };
    final icon = switch (status) {
      UiStatus.success => Icons.check_circle,
      UiStatus.error => Icons.error,
      _ => Icons.search,
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withValues(alpha: 0.4))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        status == UiStatus.loading ? SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 3, color: color)) : Icon(icon, color: color, size: 28),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(message, style: const TextStyle(fontSize: 14, height: 1.4)),
            if (status == UiStatus.loading) ...[const SizedBox(height: 12), LinearProgressIndicator(color: color, minHeight: 6, borderRadius: BorderRadius.circular(3))],
            if (status == UiStatus.error && onRetry != null) ...[const SizedBox(height: 12), OutlinedButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Try again'))],
          ]),
        ),
      ]),
    );
  }
}