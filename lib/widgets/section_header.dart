// lib/widgets/section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/colors.dart';

class SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String? subtitle;
  final bool isDark;

  const SectionHeader({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withOpacity(0.25)),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2),

        const SizedBox(height: 10),

        // Title
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
            letterSpacing: -0.5,
            height: 1.15,
          ),
        ).animate(delay: 100.ms).fadeIn(duration: 500.ms).slideY(
              begin: 0.2,
              curve: Curves.easeOut,
            ),

        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
              height: 1.55,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
        ],
      ],
    );
  }
}
