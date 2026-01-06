import 'package:flutter/material.dart';

import '../services/theme_manager_service.dart';
import '../theme/app_theme.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? ctrl;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? prefixIcon;
  final String? name;
  final String? validationMsg;
  final int? maxLines;
  final int? maxLength;
  final bool formSubmitted;
  final bool? isCapital;

  const CustomTextFormField(
      {super.key,
      this.ctrl,
      this.hintText,
      this.keyboardType,
      this.prefixIcon,
      this.maxLines,
      this.formSubmitted = false,
      this.name,
      this.isCapital = false,
      this.validationMsg,
      this.maxLength});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  bool isTouched = false;
  bool _passwordVisible = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  String fcmToken = '';
  final ThemeManagerService _themeManager = ThemeManagerService();
  Color _currentVibeColor = AppTheme.primaryZen;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Load current vibe color from theme manager
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _themeManager.initialize();
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });

    // Listen to theme changes
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });
  }

  validateInput(value) {
    if (isTouched || widget.formSubmitted) {
      if (value != null && value?.toString() != '') {
        if (widget.name == 'email') {
          if (value.isEmpty) {
            widget.validationMsg;
          } else {
            const pattern =
                r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9-.]+$)';
            final regExp = RegExp(pattern);

            if (!regExp.hasMatch(value.toString())) {
              return "Please enter valid email";
            }
          }
        }
        if (widget.name == "password") {
          if (value.isEmpty) {
            widget.validationMsg;
          }
        }
        return null;
      }
      return widget.validationMsg;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = _currentVibeColor;
    return TextFormField(
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      controller: widget.ctrl,
      keyboardType: widget.keyboardType,
      textInputAction:
          widget.name == "email" ? TextInputAction.next : TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return validateInput(value);
      },
      obscureText: widget.name == "password" ? !_passwordVisible : false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: widget.hintText,
        contentPadding:
            EdgeInsets.fromLTRB(15, widget.name == "rcomment" ? 25 : 0, 25, 0),
        hintStyle: const TextStyle(color: Color.fromARGB(255, 162, 161, 161)),
        labelStyle: const TextStyle(color: Colors.black),
        prefixText: widget.name == "rcontactno" ? '+1 ' : null,
        prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: widget.prefixIcon != null
            ? ImageIcon(
                AssetImage(widget.prefixIcon ?? ''),
                color: Colors.black,
              )
            : null,
        suffixIcon: widget.name == "password"
            ? IconButton(
                splashColor: Colors.black,
                highlightColor: Colors.black,
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.3), // Subtle vibe color for default border
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withValues(alpha: 0.3), // Subtle vibe color for enabled state
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor, // Full vibe color when focused
            width: 2.0, // Slightly thicker for focus indication
          ),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      maxLines: widget.maxLines,
      onChanged: (value) => {
        isTouched = true,
        if (widget.name == "rcontactno")
          {
            if (value.length >= 14)
              {
                FocusScope.of(context).unfocus(),
              }
          }
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).unfocus(); // Hide keyboard
      },
    );
  }
}
