import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading, isOutlined;
  final IconData? icon;
  const AppButton({super.key, required this.label, this.onPressed, this.isLoading = false, this.isOutlined = false, this.icon});

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    final content = isLoading
        ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: isOutlined ? null : Colors.white))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ]);
    final action = isLoading ? null : onPressed;
    final size = const Size.fromHeight(52);
    return isOutlined
        ? OutlinedButton(onPressed: action, style: OutlinedButton.styleFrom(minimumSize: size, shape: shape), child: content)
        : FilledButton(onPressed: action, style: FilledButton.styleFrom(minimumSize: size, shape: shape), child: content);
  }
}