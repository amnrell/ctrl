import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/ctrl_glitch_logo.dart';
import '../../services/theme_manager_service.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  Future<void> _register() async {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await AuthService.instance.register(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );
    setState(() => _loading = false);

    if (ok && mounted) {
      Navigator.pushReplacementNamed(context, '/main-dashboard');
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
              Text("Create Account",
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.2,
                )
              ),
              SizedBox(height: 4.h),

              _input("Email", _email, TextInputType.emailAddress),
              SizedBox(height: 2.h),
              _passwordInput(_password, "Password"),
              SizedBox(height: 2.h),
              _passwordInput(_confirm, "Confirm Password"),

              SizedBox(height: 3.h),
              _loading
                ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(vibe))
                : _btn("Create Account", vibe, _register),

              SizedBox(height: 2.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Already have an account? Login",
                  style: TextStyle(color: vibe)
                ),
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
      decoration: _dec(label),
    );
  }

  Widget _passwordInput(TextEditingController c, String label) {
    return TextField(
      controller: c,
      obscureText: _obscure,
      style: const TextStyle(color: Colors.white),
      decoration: _dec(label).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  InputDecoration _dec(String l) => InputDecoration(
    labelText: l,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white.withOpacity(0.06),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );

  Widget _btn(String text, Color color, VoidCallback tap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
        onPressed: tap,
        child: Text(text,
          style: TextStyle(
            color: Colors.black, fontSize: 11.sp, fontWeight: FontWeight.w600
          )
        ),
      ),
    );
  }
}
