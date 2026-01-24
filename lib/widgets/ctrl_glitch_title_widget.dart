import 'dart:async';
import 'package:flutter/material.dart';
import '../services/theme_manager_service.dart';

class CtrlGlitchTitleWidget extends StatefulWidget {
  final double fontSize;
  final Duration glitchInterval;

  const CtrlGlitchTitleWidget({
    super.key,
    this.fontSize = 22,
    this.glitchInterval = const Duration(milliseconds: 850),
  });

  @override
  State<CtrlGlitchTitleWidget> createState() => _CtrlGlitchTitleWidgetState();
}

class _CtrlGlitchTitleWidgetState extends State<CtrlGlitchTitleWidget> {
  late Timer _timer;
  int _fontIndex = 0;
  double _offset = 0;

  final List<String> _fonts = const [
    'Inter',
    'Roboto',
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
        _fontIndex = (_fontIndex + 1) % _fonts.length;
        _offset = (_offset == 0) ? 1.3 : 0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = ThemeManagerService.instance.primaryVibeColor;

    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(_offset, 0),
          child: Text(
            'CTRL',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontFamily: _fonts[_fontIndex],
              color: color.withOpacity(0.35),
              letterSpacing: 2,
            ),
          ),
        ),
        Text(
          'CTRL',
          style: TextStyle(
            fontSize: widget.fontSize,
            fontFamily: _fonts[_fontIndex],
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}
