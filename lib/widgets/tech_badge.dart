// lib/widgets/tech_badge.dart
import 'package:flutter/material.dart';
import '../theme/colors.dart';

class TechBadge extends StatefulWidget {
  final String label;
  final bool isDark;

  const TechBadge({super.key, required this.label, required this.isDark});

  @override
  State<TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<TechBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primary.withOpacity(0.15)
              : (widget.isDark
                  ? AppColors.surface
                  : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withOpacity(0.4)
                : (widget.isDark
                    ? AppColors.glassBorder
                    : Colors.grey.shade200),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _hovered
                ? AppColors.primary
                : (widget.isDark
                    ? AppColors.textSecondary
                    : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }
}
