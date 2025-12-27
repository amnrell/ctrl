import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/ctrl_glitch_logo.dart';
import '../../services/theme_manager_service.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_email.text.isEmpty || _password.text.isEmpty) return;
    setState(() => _loading = true);

    final success = await AuthService.instance.login(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );

    setState(() => _loading = false);

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vibe = ThemeManagerService.instance.primaryVibeColor;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              CtrlGlitchLogo(fontSize: 48.sp),
              SizedBox(height: 1.h),
              Text("Welcome Back",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4.h),

              _input("Email", _email, TextInputType.emailAddress),
              SizedBox(height: 2.h),
              _passwordInput(),

              SizedBox(height: 3.h),
              _loading
                  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(vibe))
                  : _mainBtn("Login", vibe, _login),

              SizedBox(height: 2.h),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text("Don't have an account? Create one",
                  style: TextStyle(color: vibe),
                ),
              ),

              SizedBox(height: 1.h),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/main-dashboard'),
                child: const Text("Continue as Guest", style: TextStyle(color: Colors.white70)),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl, TextInputType type) {
    return TextField(
      keyboardType: type,
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
    );
  }

  Widget _passwordInput() {
    return TextField(
      controller: _password,
      obscureText: _obscure,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Password").copyWith(
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _mainBtn(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(text,
          style: TextStyle(color: Colors.black, fontSize: 11.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
