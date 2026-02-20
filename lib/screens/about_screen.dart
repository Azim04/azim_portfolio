// lib/screens/about_screen.dart
//
// Three logical sub-sections rendered in a single scroll:
//   1. Bio intro with first-person copy
//   2. Work timeline (staggered reveal per card)
//   3. Education strip
//   4. Skill meters — animated progress bars triggered on visibility
//
// VisibilityDetector on each SkillCategory section fires the bar
// animation exactly once (isFired guard) for authentic app-like feel.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/experience_model.dart';
import '../providers/app_providers.dart';
import '../theme/colors.dart';
import '../widgets/section_header.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(screenProvider).isDark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.heroGradient
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFFF8F6FF), const Color(0xFFEFF6FF)],
                ),
        ),
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 28),
                    SectionHeader(
                      tag: 'ABOUT',
                      title: 'Who I Am',
                      subtitle: null,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 20),
                    _BioCard(isDark: isDark),
                    const SizedBox(height: 32),
                    _SectionLabel(label: 'EXPERIENCE', isDark: isDark),
                    const SizedBox(height: 16),
                    _ExperienceTimeline(isDark: isDark),
                    const SizedBox(height: 32),
                    _SectionLabel(label: 'EDUCATION', isDark: isDark),
                    const SizedBox(height: 16),
                    _EducationList(isDark: isDark),
                    const SizedBox(height: 32),
                    _SectionLabel(label: 'SKILLS', isDark: isDark),
                    const SizedBox(height: 16),
                    _SkillsSection(isDark: isDark),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bio card ───────────────────────────────────────────────────────

class _BioCard extends StatelessWidget {
  final bool isDark;
  const _BioCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.cardGradient
            : const LinearGradient(
                colors: [Colors.white, Color(0xFFF5F3FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? AppColors.glassBorder
              : AppColors.primary.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I build cross-platform mobile apps with Flutter — '
            'the kind that handle real users, real edge-cases, and real uptime SLAs.',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimary : AppColors.textDark,
              height: 1.55,
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2),
          const SizedBox(height: 12),
          Text(
            'Over the past year I\'ve shipped production Flutter apps at Protip '
            '(fintech, mutual fund investments) and Evibe Solutions (wedding-tech, '
            'AI-powered planning). Before that, I built a cloud-based content '
            'recommendation engine on AWS during my internship at F13 Technologies.\n\n'
            'I\'m passionate about BLoC and Riverpod patterns, CI/CD with GitHub '
            'Actions, OTA delivery via Shorebird, and squeezing every millisecond '
            'out of frame render times.',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
              height: 1.65,
            ),
          ).animate(delay: 200.ms).fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.location_on_rounded,
                label: 'Bangalore, India',
                isDark: isDark,
              ),
              _InfoChip(
                icon: Icons.school_rounded,
                label: 'B.E. CE · CGPA 9.43',
                isDark: isDark,
              ),
              _InfoChip(
                icon: Icons.work_rounded,
                label: 'Open to opportunities',
                isDark: isDark,
                accent: true,
              ),
            ],
          ).animate(delay: 400.ms).fadeIn(duration: 500.ms),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool accent;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.isDark,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.success.withOpacity(0.1)
            : (isDark
                ? AppColors.glassBorder.withOpacity(0.5)
                : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              accent ? AppColors.success.withOpacity(0.3) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: accent
                ? AppColors.success
                : (isDark ? AppColors.textSecondary : Colors.grey.shade500),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent
                  ? AppColors.success
                  : (isDark ? AppColors.textSecondary : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Experience timeline ───────────────────────────────────────────

class _ExperienceTimeline extends StatelessWidget {
  final bool isDark;
  const _ExperienceTimeline({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: kExperiences.asMap().entries.map((e) {
        return _TimelineItem(
          experience: e.value,
          isDark: isDark,
          isLast: e.key == kExperiences.length - 1,
          delay: e.key * 150,
        );
      }).toList(),
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final ExperienceModel experience;
  final bool isDark;
  final bool isLast;
  final int delay;

  const _TimelineItem({
    required this.experience,
    required this.isDark,
    required this.isLast,
    required this.delay,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _expanded = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    final exp = widget.experience;
    final isDark = widget.isDark;

    return VisibilityDetector(
      key: Key('exp-${exp.company}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.15 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isVisible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 500),
          offset: _isVisible ? Offset.zero : const Offset(0.1, 0),
          curve: Curves.easeOut,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Timeline line
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: exp.isCurrent
                              ? const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary
                                  ],
                                )
                              : null,
                          color: exp.isCurrent ? null : AppColors.surface,
                          border: Border.all(
                            color: exp.isCurrent
                                ? Colors.transparent
                                : AppColors.glassBorder,
                            width: 2,
                          ),
                          boxShadow: exp.isCurrent
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            exp.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      if (!widget.isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primary.withOpacity(0.4),
                                  AppColors.glassBorder,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surface : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? AppColors.glassBorder
                                : Colors.grey.shade100,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.06),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exp.role,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.textPrimary
                                              : AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        exp.companyFull,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (exp.isCurrent)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            AppColors.success.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      'Current',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 11,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  exp.dateRange,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textMuted
                                        : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 11,
                                  color: isDark
                                      ? AppColors.textMuted
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    exp.location,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? AppColors.textMuted
                                          : Colors.grey.shade400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Expandable bullets
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutCubic,
                              child: _expanded
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: exp.bullets
                                            .map(
                                              (b) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 5,
                                                      height: 5,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 6, right: 8),
                                                      decoration:
                                                          const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        b,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: isDark
                                                              ? AppColors
                                                                  .textSecondary
                                                              : Colors.grey
                                                                  .shade600,
                                                          height: 1.55,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),

                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _expanded ? 'Show less ↑' : 'Show more ↓',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Education list ────────────────────────────────────────────────

class _EducationList extends StatelessWidget {
  final bool isDark;
  const _EducationList({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: kEducation
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _EducationCard(
                edu: e.value,
                isDark: isDark,
              )
                  .animate(delay: Duration(milliseconds: e.key * 100))
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),
            ),
          )
          .toList(),
    );
  }
}

class _EducationCard extends StatelessWidget {
  final EducationModel edu;
  final bool isDark;

  const _EducationCard({required this.edu, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : Colors.grey.shade100,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('🎓', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  edu.institution,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimary : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  edu.degree,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDark ? AppColors.textSecondary : Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${edu.startDate} – ${edu.endDate} · ${edu.location}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMuted : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  edu.grade,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  edu.gradeLabel,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skills section ────────────────────────────────────────────────

class _SkillsSection extends StatelessWidget {
  final bool isDark;
  const _SkillsSection({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: kSkillCategories
          .map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _SkillCategoryCard(category: cat, isDark: isDark),
              ))
          .toList(),
    );
  }
}

class _SkillCategoryCard extends StatefulWidget {
  final SkillCategory category;
  final bool isDark;

  const _SkillCategoryCard({
    required this.category,
    required this.isDark,
  });

  @override
  State<_SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<_SkillCategoryCard> {
  bool _animate = false;
  bool _fired = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('skill-${widget.category.name}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_fired) {
          _fired = true;
          // Small delay for stagger feel
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) setState(() => _animate = true);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.surface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isDark ? AppColors.glassBorder : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.category.emoji,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  widget.category.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: widget.isDark
                        ? AppColors.textPrimary
                        : AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.category.skills.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SkillBar(
                      item: e.value,
                      isDark: widget.isDark,
                      animate: _animate,
                      delay: e.key * 80,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final SkillItem item;
  final bool isDark;
  final bool animate;
  final int delay;

  const _SkillBar({
    required this.item,
    required this.isDark,
    required this.animate,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
              ),
            ),
            Text(
              '${(item.proficiency * 100).toInt()}%',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                // Background track
                Container(
                  color: isDark
                      ? AppColors.glassBorder.withOpacity(0.5)
                      : Colors.grey.shade100,
                ),
                // Animated fill
                AnimatedFractionallySizedBox(
                  duration: Duration(milliseconds: 800 + delay),
                  curve: Curves.easeOutCubic,
                  widthFactor: animate ? item.proficiency : 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textMuted : Colors.grey.shade400,
        letterSpacing: 2,
      ),
    );
  }
}
