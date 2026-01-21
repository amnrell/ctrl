import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';

class DynamicBackgroundWidget extends StatefulWidget {
  final Color primaryColor;

  const DynamicBackgroundWidget({
    super.key,
    required this.primaryColor,
  });

  @override
  State<DynamicBackgroundWidget> createState() =>
      _DynamicBackgroundWidgetState();
}

class _DynamicBackgroundWidgetState extends State<DynamicBackgroundWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      behaviour: RandomParticleBehaviour(
        options: ParticleOptions(
          baseColor: widget.primaryColor.withValues(alpha: 0.2),
          spawnOpacity: 0.0,
          opacityChangeRate: 0.15,
          minOpacity: 0.05,
          maxOpacity: 0.2,
          particleCount: 25,
          spawnMinSpeed: 5,
          spawnMaxSpeed: 15,
          spawnMinRadius: 3,
          spawnMaxRadius: 7,
        ),
      ),
      vsync: this,
      child: Container(), // your content above it
    );
  }
}
