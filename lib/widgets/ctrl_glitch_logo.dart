import 'dart:async';
import 'package:flutter/material.dart';

import '../services/theme_manager_service.dart';

/// Animated CTRL logo that:
/// - Uses "Ctrl" with a Roboto-italic baseline (matches your visual)
/// - Glitches through alternate fonts as an offset shadow
/// - Always uses the current vibe color from ThemeManagerService
class CtrlGlitchLogo extends StatefulWidget {
  /// Base font size for the logo text
  final double fontSize;

  /// How often the glitch animates
  final Duration glitchInterval;

  const CtrlGlitchLogo({
    super.key,
    this.fontSize = 22,
    this.glitchInterval = const Duration(milliseconds: 900),
  });

  @override
  State<CtrlGlitchLogo> createState() => _CtrlGlitchLogoState();
}

class _CtrlGlitchLogoState extends State<CtrlGlitchLogo> {
  Timer? _timer;
  int _fontIndex = 0;
  double _glitchOffset = 0;

  /// Fonts used for the glitch overlay only.
  /// The base logo always stays Roboto (italic, bold).
  final List<String> _overlayFonts = const [
    'Inter',
    'Poppins',
    'Lato',
    'Open Sans',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.glitchInterval, (_) {
      if (!mounted) return;
      setState(() {
        _fontIndex = (_fontIndex + 1) % _overlayFonts.length;
        _glitchOffset = _glitchOffset == 0 ? 1.5 : 0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the global theme manager singleton (factory constructor)
    final themeManager = ThemeManagerService();
    final color = themeManager.primaryVibeColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Glitch overlay (offset + lighter)
        Transform.translate(
          offset: Offset(_glitchOffset, 0),
          child: Text(
            'Ctrl',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontFamily: _overlayFonts[_fontIndex],
              color: color.withOpacity(0.35),
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Base brand lockup – Roboto italic, bold
        Text(
          'Ctrl',
          style: TextStyle(
            fontSize: widget.fontSize,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: color,
          ),
        ),
      ],
    );
  }
}
