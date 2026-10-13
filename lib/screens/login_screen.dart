import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Email is required';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s) ? null : 'Enter a valid email address';
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    return v.length < 6 ? 'Use at least 6 characters' : null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // replace with real authentication
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(email: _email.text.trim())));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            height: 280,
            decoration: BoxDecoration(color: scheme.primary, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36))),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(
              painter: _ContourPainter(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: scheme.tertiary, shape: BoxShape.circle), child: Icon(Icons.place, color: scheme.primary, size: 28)),
                    const SizedBox(height: 20),
                    const Text('BoardMap', style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w800, letterSpacing: -1)),
                    const SizedBox(height: 6),
                    Text('Find a place to stay, mapped for you.', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16)),
                  ]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Log in to see your saved places.', style: TextStyle(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 24),
                AppTextField(controller: _email, label: 'Email', hint: 'you@example.com', icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, validator: _validateEmail),
                const SizedBox(height: 16),
                AppTextField(controller: _password, label: 'Password', hint: 'Enter your password', icon: Icons.lock_outline, isPassword: true, textInputAction: TextInputAction.done, validator: _validatePassword, onSubmitted: (_) => _submit()),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text('Forgot password?'))),
                const SizedBox(height: 8),
                AppButton(label: 'Sign In', isLoading: _loading, onPressed: _submit),
                const SizedBox(height: 12),
                AppButton(label: 'Continue as guest', isOutlined: true, icon: Icons.explore_outlined, onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen(email: 'guest')))),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('New to BoardMap?', style: TextStyle(color: scheme.onSurfaceVariant)),
                  TextButton(onPressed: () {}, child: const Text('Create account')),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

/// Topographic contour lines, drawn behind the header.
class _ContourPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.9, size.height * 0.25);
    for (var i = 1; i <= 10; i++) {
      final path = Path();
      for (var a = 0; a <= 360; a += 4) {
        final t = a * math.pi / 180, r = i * 34.0 * (1 + 0.1 * math.sin(3 * t + i * 0.7) + 0.05 * math.cos(5 * t - i));
        final p = center + Offset(math.cos(t) * r, math.sin(t) * r);
        a == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path..close(), Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2..color = Colors.white.withValues(alpha: 0.07 + i * 0.008));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}