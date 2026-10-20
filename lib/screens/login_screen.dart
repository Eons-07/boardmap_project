import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_logo.dart';
import '../widgets/app_text_field.dart';
import '../widgets/contour_painter.dart';
import '../widgets/status_banner.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _roles = ['Seeker', 'Owner', 'Admin'];
  static const _roleIcons = [Icons.person_outline, Icons.home_work_outlined, Icons.admin_panel_settings_outlined];
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(), _password = TextEditingController();
  String _role = _roles.first;
  bool _remember = false;
  UiStatus _status = UiStatus.idle; // what the banner shows right now
  bool _simulateError = false; // demo only: lets you see the error state

  bool get _isLoading => _status == UiStatus.loading;

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

  void _snack(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  // Validate -> block duplicate taps -> loading -> success (then open Home) or error.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isLoading) return;
    setState(() => _status = UiStatus.loading);
    try {
      await Future<void>.delayed(const Duration(seconds: 2)); // demo only: pretends to call POST /api/auth/login
      if (_simulateError) throw Exception('Simulated connection error');
      if (!mounted) return;
      setState(() => _status = UiStatus.success);
      await Future<void>.delayed(const Duration(seconds: 2)); // lets the user read the success message
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen(email: _email.text.trim())));
    } catch (_) {
      if (!mounted) return;
      setState(() => _status = UiStatus.error);
    }
  }

  String get _title => switch (_status) {
        UiStatus.loading => 'Signing you in...',
        UiStatus.success => 'Login successful',
        _ => 'Login failed',
      };

  String get _message => switch (_status) {
        UiStatus.loading => 'Checking your email and password for your $_role account. Please wait a moment.',
        UiStatus.success => 'Welcome back! Opening your dashboard...',
        _ => 'We could not reach BoardMap. Check your internet connection, then try again.',
      };

  Widget _feature(IconData icon, String title, String subtitle) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(children: [
          CircleAvatar(radius: 22, backgroundColor: Colors.white.withValues(alpha: 0.18), child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
          ])),
        ]),
      );

  Widget _hero(bool wide) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AppLogo(color: Colors.white, size: 30, tagline: 'Find Your Next Home'),
        SizedBox(height: wide ? 64 : 24),
        Text('Welcome Back!', style: TextStyle(color: Colors.white, fontSize: wide ? 40 : 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Text('Sign in to your account and continue your journey in finding the perfect boarding house in Cabadbaran City.', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 16, height: 1.4)),
        if (wide) ...[
          const SizedBox(height: 40),
          _feature(Icons.star_outline, 'Your Saved Preferences', 'Get personalized recommendations.'),
          _feature(Icons.manage_search, 'Quick & Easy Access', 'Find, book, and manage your listings.'),
          _feature(Icons.chat_bubble_outline, 'Stay Connected', 'Message owners and get updates.'),
        ],
      ]);

  Widget _card(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 8))]),
      child: Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('Login to Your Account', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('Enter your credentials to continue.', style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          SegmentedButton<String>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(selectedBackgroundColor: scheme.primary, selectedForegroundColor: Colors.white),
            segments: [for (var i = 0; i < _roles.length; i++) ButtonSegment(value: _roles[i], icon: Icon(_roleIcons[i], size: 18), label: Text(_roles[i]))],
            selected: {_role},
            onSelectionChanged: _isLoading ? null : (s) => setState(() => _role = s.first),
          ),
          const SizedBox(height: 20),
          AppTextField(controller: _email, label: 'Email Address', hint: 'Enter your email address', icon: Icons.mail_outline, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, validator: _validateEmail),
          const SizedBox(height: 16),
          AppTextField(controller: _password, label: 'Password', hint: 'Enter your password', icon: Icons.lock_outline, isPassword: true, textInputAction: TextInputAction.done, validator: _validatePassword, onSubmitted: (_) => _submit()),
          Row(children: [
            Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v!)),
            const Text('Remember me'),
            const Spacer(),
            TextButton(onPressed: () => _snack('Password reset is coming soon'), child: const Text('Forgot password?')),
          ]),
          const SizedBox(height: 8),
          if (_status != UiStatus.idle) ...[StatusBanner(status: _status, title: _title, message: _message, onRetry: _submit), const SizedBox(height: 16)],
          AppButton(label: 'Login', isLoading: _isLoading, onPressed: _status == UiStatus.success ? null : _submit),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OR')), Expanded(child: Divider())])),
          AppButton(label: 'Continue with Google', isOutlined: true, icon: Icons.g_mobiledata, onPressed: _isLoading ? null : () => _snack('Google sign-in is not available yet')),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Don't have an account?", style: TextStyle(color: scheme.onSurfaceVariant)),
            TextButton(onPressed: () => _snack('Registration is coming soon'), child: const Text('Register')),
          ]),
          TextButton(onPressed: _isLoading ? null : () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen(email: 'guest'))), child: const Text('Continue as guest')),
          const Divider(height: 24),
          SwitchListTile(contentPadding: EdgeInsets.zero, dense: true, title: const Text('Demo: simulate a connection error'), subtitle: const Text('Turn this on to see the error state. Remove it when the API is connected.'), value: _simulateError, onChanged: (v) => setState(() => _simulateError = v)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8), Color(0xFF0E7490)])),
          child: CustomPaint(
            painter: ContourPainter(),
            child: SafeArea(
              child: LayoutBuilder(builder: (context, box) {
                final wide = box.maxWidth >= 900; // two columns on wide screens, one column on narrow ones
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(wide ? 48 : 20),
                        child: wide
                            ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(child: _hero(true)), const SizedBox(width: 48), SizedBox(width: 460, child: _card(context))])
                            : Column(mainAxisSize: MainAxisSize.min, children: [_hero(false), const SizedBox(height: 24), _card(context)]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}