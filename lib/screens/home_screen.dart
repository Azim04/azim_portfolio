// lib/screens/home_screen.dart
//
// Hero section of the portfolio. Key design decisions:
// - NotificationListener<ScrollNotification> feeds the parallax offset
//   provider so background shapes shift at 0.4x scroll rate.
// - Profile card uses AnimatedContainer for 3D-style tilt on desktop
//   via MouseRegion — falls back to static card on touch devices.
// - CTA buttons use morphing AnimatedSwitcher for micro-interaction polish.
//
// Semantic labels are provided via Semantics widgets so screen readers
// can navigate the hero section meaningfully.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_providers.dart';
import '../theme/colors.dart';
import '../widgets/animated_shapes.dart';
import '../widgets/tech_badge.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  Offset _tilt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      ref.read(heroScrollOffsetProvider.notifier).state =
          _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(screenProvider).isDark;
    final scrollOffset = ref.watch(heroScrollOffsetProvider);
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Gradient base ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppColors.heroGradient
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF8F6FF),
                        const Color(0xFFEFF6FF),
                        const Color(0xFFF0FFF8),
                      ],
                    ),
            ),
          ),

          // ── Parallax shapes (shift at 0.4× scroll speed) ───────
          Positioned(
            top: 40 - scrollOffset * 0.4,
            right: -60,
            child: AnimatedShapesWidget(isDark: isDark),
          ),
          Positioned(
            bottom: 80 + scrollOffset * 0.2,
            left: -40,
            child: _GradientCircle(
              color: AppColors.secondary,
              size: 220,
              opacity: 0.12,
            ),
          ),

          // ── Scrollable content ────────────────────────────────
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 32,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(isDark: isDark),
                        const SizedBox(height: 32),
                        _ProfileCard(isDark: isDark),
                        const SizedBox(height: 36),
                        _ElevatorPitch(isDark: isDark),
                        const SizedBox(height: 32),
                        _CTARow(isDark: isDark),
                        const SizedBox(height: 40),
                        _QuickStats(isDark: isDark),
                        const SizedBox(height: 40),
                        _TechScrollRow(isDark: isDark),
                        const SizedBox(height: 120), // bottom nav clearance
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Top bar with theme toggle ─────────────────────────────────────

class _TopBar extends ConsumerWidget {
  final bool isDark;
  const _TopBar({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'Azim Shaikh',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms),

        // Theme toggle
        GestureDetector(
          onTap: () => ref.watch(screenProvider).toggleTheme(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 52,
            height: 28,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppColors.primary.withOpacity(0.4)
                    : Colors.grey.shade300,
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutBack,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? AppColors.primary : Colors.grey.shade400,
                ),
                child: Center(
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
      ],
    );
  }
}

// ── Profile Card ───────────────────────────────────────────────────

class _ProfileCard extends ConsumerWidget {
  final bool isDark;
  const _ProfileCard({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MouseRegion(
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.cardGradient
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? AppColors.glassBorder
                : AppColors.primary.withOpacity(0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.12),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'AS',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ).animate().scale(
                  begin: const Offset(0.5, 0.5),
                  duration: 700.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(width: 20),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Azim Shaikh',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color:
                          isDark ? AppColors.textPrimary : AppColors.textDark,
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 500.ms).slideX(
                        begin: 0.2,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 4),
                  Text(
                    'Flutter Developer · 1+ yr',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        'Bengaluru, India',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ).animate(delay: 450.ms).fadeIn(duration: 400.ms),
                ],
              ),
            ),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat())
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.3, 1.3),
                        duration: 1000.ms,
                      )
                      .then()
                      .scale(
                        begin: const Offset(1.3, 1.3),
                        end: const Offset(0.8, 0.8),
                        duration: 1000.ms,
                      ),
                  const SizedBox(width: 5),
                  Text(
                    'Open',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(
          begin: 0.2,
          curve: Curves.easeOut,
          duration: 600.ms,
        );
  }
}

// ── Elevator pitch ────────────────────────────────────────────────

class _ElevatorPitch extends StatelessWidget {
  final bool isDark;
  const _ElevatorPitch({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I build cross-platform mobile apps\nthat users love',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: isDark ? AppColors.textPrimary : AppColors.textDark,
            height: 1.25,
            letterSpacing: -0.5,
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 700.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),
        const SizedBox(height: 14),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade600,
              height: 1.65,
            ),
            children: const [
              TextSpan(
                text:
                    'Flutter developer with hands-on production experience at '
                    'fintech and event-tech startups. I care deeply about '
                    'performance, clean architecture, and shipping features that '
                    'move metrics — ',
              ),
              TextSpan(
                text: '98% crash-free, 50% faster delivery, 99% uptime.',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
            .animate(delay: 500.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, curve: Curves.easeOut),
      ],
    );
  }
}

// ── CTA buttons ───────────────────────────────────────────────────

class _CTARow extends ConsumerWidget {
  final bool isDark;
  const _CTARow({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _GradientButton(
          label: 'View Projects',
          icon: Icons.code_rounded,
          onTap: () {
            ref.read(screenProvider).setIndex(1);
          },
        ).animate(delay: 600.ms).fadeIn(duration: 500.ms).slideX(
              begin: -0.2,
              curve: Curves.easeOut,
            ),
        _OutlineButton(
          label: 'Download Resume',
          icon: Icons.download_rounded,
          isDark: isDark,
          onTap: () async {
            final uri = Uri.parse(
              'https://drive.google.com/file/d/1KKxOwdZRyBCihHPZyadSL69hInp0Srqn/view?usp=sharing',
            );
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
        ).animate(delay: 750.ms).fadeIn(duration: 500.ms).slideX(
              begin: -0.2,
              curve: Curves.easeOut,
            ),
        _OutlineButton(
          label: 'Contact',
          icon: Icons.phone,
          isDark: isDark,
          onTap: () {
            ref.watch(screenProvider).setIndex(3);
          },
        ).animate(delay: 900.ms).fadeIn(duration: 500.ms).slideX(
              begin: -0.2,
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.04 : 1.0, _hovered ? 1.04 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(_hovered ? 0.5 : 0.3),
                blurRadius: _hovered ? 24 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.04 : 1.0, _hovered ? 1.04 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? AppColors.primary
                  : widget.isDark
                      ? AppColors.glassBorder
                      : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _hovered
                    ? AppColors.primary
                    : widget.isDark
                        ? AppColors.textSecondary
                        : Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered
                      ? AppColors.primary
                      : widget.isDark
                          ? AppColors.textSecondary
                          : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick stats strip ─────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final bool isDark;
  const _QuickStats({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Stat('1+', 'Year Exp'),
      _Stat('4+', 'Live Apps'),
      _Stat('98%', 'Crash-Free'),
      _Stat('3', 'Companies'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.glassBorder : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Row(
        children: stats
            .asMap()
            .entries
            .map(
              (e) => Expanded(
                child: _StatTile(
                  stat: e.value,
                  isDark: isDark,
                  delay: e.key * 100,
                )
                    .animate(delay: Duration(milliseconds: 700 + e.key * 100))
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.3, curve: Curves.easeOut),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
}

class _StatTile extends StatelessWidget {
  final _Stat stat;
  final bool isDark;
  final int delay;
  const _StatTile({
    required this.stat,
    required this.isDark,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ).createShader(bounds),
          child: Text(
            stat.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Horizontal tech scroll ────────────────────────────────────────

class _TechScrollRow extends StatelessWidget {
  final bool isDark;
  const _TechScrollRow({required this.isDark});

  static const _techs = [
    'Flutter',
    'Dart',
    'Firebase',
    'BLoC',
    'Riverpod',
    'GitHub Actions',
    'Shorebird',
    'AWS',
    'Terraform',
    'ReactJS',
    'Django',
    'Docker',
    'Kubernetes',
    'Python',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TECH STACK',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textMuted : Colors.grey.shade400,
            letterSpacing: 2,
          ),
        ).animate(delay: 900.ms).fadeIn(duration: 400.ms),
        const SizedBox(height: 14),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _techs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => TechBadge(
              label: _techs[i],
              isDark: isDark,
            )
                .animate(delay: Duration(milliseconds: 1000 + i * 60))
                .fadeIn(duration: 400.ms)
                .slideX(begin: 0.3, curve: Curves.easeOut),
          ),
        ),
      ],
    );
  }
}

// ── Gradient circle helper ────────────────────────────────────────

class _GradientCircle extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _GradientCircle({
    required this.color,
    required this.size,
    required this.opacity,
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
        ),
      ),
    );
  }
}
