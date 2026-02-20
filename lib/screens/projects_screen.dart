// lib/screens/projects_screen.dart
//
// Features:
//  - Staggered reveal of project cards as user scrolls in
//  - Each card flips 3D on tap to reveal tech details + metrics
//  - FutureProvider hydrates live GitHub stars/language when available
//  - VisibilityDetector triggers per-card entrance animations (no janky
//    all-at-once load — feels exactly like a native app list)
//  - Skeleton shimmer shown while GitHub data is in-flight

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/project_model.dart';
import '../providers/app_providers.dart';
import '../theme/colors.dart';
import '../widgets/section_header.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(screenProvider).isDark;
    final reposAsync = ref.watch(githubReposProvider);

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
                      tag: 'PORTFOLIO',
                      title: 'My Projects',
                      subtitle:
                          'Production apps shipped at scale — each one a story of constraints, trade-offs, and shipping.',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 8),

                    // GitHub status bar
                    _GitHubStatusBar(reposAsync: reposAsync, isDark: isDark),

                    const SizedBox(height: 24),

                    // Project cards
                    ...kProjects.asMap().entries.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _ProjectCard(
                              project: e.value,
                              index: e.key,
                              isDark: isDark,
                            ),
                          ),
                        ),

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

// ── GitHub sync status indicator ──────────────────────────────────

class _GitHubStatusBar extends StatelessWidget {
  final AsyncValue<dynamic> reposAsync;
  final bool isDark;

  const _GitHubStatusBar({
    required this.reposAsync,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return reposAsync.when(
      loading: () => Row(
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Syncing GitHub metadata…',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : Colors.grey.shade400,
            ),
          ),
        ],
      ),
      data: (repos) => Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 13, color: AppColors.success),
          const SizedBox(width: 6),
          Text(
            'Live data synced from GitHub · ${(repos as List).length} repos',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : Colors.grey.shade400,
            ),
          ),
        ],
      ),
      error: (_, __) => Row(
        children: [
          Icon(Icons.cloud_off_rounded,
              size: 13,
              color: isDark ? AppColors.textMuted : Colors.grey.shade400),
          const SizedBox(width: 6),
          Text(
            'Showing resume data (GitHub offline)',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Animated Project Card ─────────────────────────────────────────

class _ProjectCard extends ConsumerStatefulWidget {
  final ProjectModel project;
  final int index;
  final bool isDark;

  const _ProjectCard({
    required this.project,
    required this.index,
    required this.isDark,
  });

  @override
  ConsumerState<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<_ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  bool _isVisible = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _flip() {
    setState(() => _isFlipped = !_isFlipped);
    if (_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final repoMeta = project.repoName != null
        ? ref.watch(repoMetaProvider(project.repoName!))
        : null;

    return VisibilityDetector(
      key: Key('project-${project.id}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.25 && !_isVisible) {
          setState(() => _isVisible = true);
        }
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 600),
        opacity: _isVisible ? 1.0 : 0.0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 600),
          offset: _isVisible ? Offset.zero : const Offset(0, 0.15),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTap: _flip,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value * 3.14159;
                final isFront = angle < 1.5708;

                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  alignment: Alignment.center,
                  child: isFront
                      ? _CardFront(
                          project: project,
                          isDark: ref.watch(screenProvider).isDark,
                          repoMeta: repoMeta,
                        )
                      : Transform(
                          transform: Matrix4.identity()..rotateY(3.14159),
                          alignment: Alignment.center,
                          child: _CardBack(
                            project: project,
                            isDark: ref.watch(screenProvider).isDark,
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ProjectModel get project => widget.project;
}

// ── Card front ────────────────────────────────────────────────────

class _CardFront extends StatefulWidget {
  final ProjectModel project;
  final bool isDark;
  final AsyncValue<dynamic>? repoMeta;

  const _CardFront({
    required this.project,
    required this.isDark,
    this.repoMeta,
  });

  @override
  State<_CardFront> createState() => _CardFrontState();
}

class _CardFrontState extends State<_CardFront> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()..translate(0.0, _hovered ? -4.0 : 0.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: widget.isDark
              ? AppColors.cardGradient
              : const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8F6FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withOpacity(0.4)
                : widget.isDark
                    ? AppColors.glassBorder
                    : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_hovered ? 0.25 : 0.10),
              blurRadius: _hovered ? 32 : 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Text(
                    widget.project.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.project.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isDark
                                ? AppColors.textPrimary
                                : AppColors.textDark,
                          ),
                        ),
                        // Live GitHub metadata
                        if (widget.repoMeta != null)
                          widget.repoMeta!.when(
                            loading: () => _MetaShimmer(isDark: widget.isDark),
                            data: (repo) => repo != null
                                ? _RepoMetaChips(
                                    repo: repo, isDark: widget.isDark)
                                : const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                      ],
                    ),
                  ),
                  // Flip hint
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.flip_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                widget.project.description,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.isDark
                      ? AppColors.textSecondary
                      : Colors.grey.shade600,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 16),

              // Tech stack chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: widget.project.techStack
                    .map((t) => _TechChip(label: t, isDark: widget.isDark))
                    .toList(),
              ),

              const SizedBox(height: 16),

              // Action row
              Row(
                children: [
                  _IconLink(
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    url:
                        widget.project.githubUrl ?? 'https://github.com/Azim04',
                    isDark: widget.isDark,
                  ),
                  if (widget.project.demoUrl != null) ...[
                    const SizedBox(width: 12),
                    _IconLink(
                      icon: Icons.open_in_new_rounded,
                      label: 'Live Demo',
                      url: widget.project.demoUrl!,
                      isDark: widget.isDark,
                    ),
                  ],
                  const Spacer(),
                  Text(
                    'Tap to flip →',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : Colors.grey.shade400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Card back ─────────────────────────────────────────────────────

class _CardBack extends StatelessWidget {
  final ProjectModel project;
  final bool isDark;

  const _CardBack({required this.project, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, Color(0xFF5E35B1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(project.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Key Metrics',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.bar_chart_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...project.highlights.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 5, right: 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.secondary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          e.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(delay: Duration(milliseconds: e.key * 100))
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: 0.15, curve: Curves.easeOut),
              ),
          const Spacer(),
          const Text(
            '← Tap to flip back',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white60,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────

class _TechChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _TechChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final bool isDark;

  const _IconLink({
    required this.icon,
    required this.label,
    required this.url,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) launchUrl(uri);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RepoMetaChips extends StatelessWidget {
  final dynamic repo;
  final bool isDark;

  const _RepoMetaChips({required this.repo, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (repo.language != null) ...[
          Text(
            '● ${repo.language}',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (repo.stargazersCount > 0) ...[
          const Icon(Icons.star_rounded, size: 11, color: Color(0xFFFFD700)),
          const SizedBox(width: 2),
          Text(
            '${repo.stargazersCount}',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? AppColors.textSecondary : Colors.grey.shade500,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaShimmer extends StatelessWidget {
  final bool isDark;
  const _MetaShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A3050) : Colors.grey.shade200,
      highlightColor: isDark ? const Color(0xFF3A4060) : Colors.grey.shade100,
      child: Container(
        width: 80,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
