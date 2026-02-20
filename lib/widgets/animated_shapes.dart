// lib/widgets/animated_shapes.dart
//
// Purely decorative — renders a cluster of animated gradient shapes
// that give the hero its depth. Wrapped in RepaintBoundary to isolate
// repaints from the main content layer (critical for 60fps on web).

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';

class AnimatedShapesWidget extends StatelessWidget {
  final bool isDark;
  const AnimatedShapesWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 280,
        height: 320,
        child: Stack(
          children: [
            // Large primary orb
            Positioned(
              top: 20,
              right: 20,
              child: _AnimatedOrb(
                color: AppColors.primary,
                size: 180,
                opacity: isDark ? 0.18 : 0.10,
                duration: const Duration(seconds: 5),
              ),
            ),
            // Secondary teal orb
            Positioned(
              bottom: 30,
              left: 20,
              child: _AnimatedOrb(
                color: AppColors.secondary,
                size: 130,
                opacity: isDark ? 0.14 : 0.08,
                duration: const Duration(seconds: 7),
              ),
            ),
            // Accent coral orb
            Positioned(
              top: 100,
              left: 60,
              child: _AnimatedOrb(
                color: AppColors.accent,
                size: 80,
                opacity: isDark ? 0.10 : 0.06,
                duration: const Duration(seconds: 6),
              ),
            ),
            // Small floating dot grid
            Positioned(
              top: 10,
              left: 10,
              child: _DotGrid(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedOrb extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;
  final Duration duration;

  const _AnimatedOrb({
    required this.color,
    required this.size,
    required this.opacity,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(opacity), Colors.transparent],
          stops: const [0.4, 1.0],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1.15, 1.15),
          duration: duration,
          curve: Curves.easeInOut,
        )
        .moveY(
          begin: 0,
          end: 12,
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}

class _DotGrid extends StatelessWidget {
  final bool isDark;
  const _DotGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: CustomPaint(
        painter: _DotGridPainter(isDark: isDark),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(
          begin: 0.3,
          end: 0.7,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
        );
  }
}

class _DotGridPainter extends CustomPainter {
  final bool isDark;
  const _DotGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark
          ? AppColors.textMuted.withOpacity(0.4)
          : Colors.grey.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    const spacing = 12.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
