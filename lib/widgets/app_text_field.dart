import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label, hint;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged, onSubmitted;
  const AppTextField({super.key, required this.controller, this.label, this.hint, this.icon, this.isPassword = false, this.keyboardType, this.textInputAction, this.validator, this.onChanged, this.onSubmitted});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c, width: w));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.label != null) ...[Text(widget.label!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 6)],
      TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _hidden,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: scheme.surface,
          prefixIcon: widget.icon == null ? null : Icon(widget.icon, size: 20),
          suffixIcon: widget.isPassword ? IconButton(icon: Icon(_hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20), onPressed: () => setState(() => _hidden = !_hidden)) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          enabledBorder: border(scheme.outlineVariant),
          focusedBorder: border(scheme.primary, 2),
          errorBorder: border(scheme.error),
          focusedErrorBorder: border(scheme.error, 2),
        ),
      ),
    ]);
  }
}