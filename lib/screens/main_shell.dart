// lib/screens/main_shell.dart
//
// App shell that wraps all top-level screens.
// Uses a PageView (not Navigator.push) so screens are cached and
// swipe gestures feel native — critical for the "mobile app" UX target.
// Bottom nav indicator animates with AnimatedAlign for smooth slide.

import 'package:azim_portfolio/utils/print_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/app_providers.dart';
import '../theme/colors.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  late PageController _pageController;
  bool _isProgrammaticScroll = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        screenProvider.select((p) => p.currentIndex),
        (previous, next) {
          if (!_pageController.hasClients || previous == next) return;

          // Raise the flag BEFORE starting the animation.
          _isProgrammaticScroll = true;

          _pageController
              .animateToPage(
                next,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
              )
              // Lower the flag only once the animation is fully done.
              .then((_) => _isProgrammaticScroll = false);
        },
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const List<_NavItem> _navItems = [
    _NavItem(icon: FontAwesomeIcons.house, label: 'Home'),
    _NavItem(icon: FontAwesomeIcons.code, label: 'Projects'),
    _NavItem(icon: FontAwesomeIcons.user, label: 'About'),
    _NavItem(icon: FontAwesomeIcons.envelope, label: 'Contact'),
  ];

  void _onNavTap(int index) {
    // Haptic feedback on supported devices
    HapticFeedback.selectionClick();
    ref.read(screenProvider).setIndex(index);

    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 350),
    //   curve: Curves.easeInOutCubic,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final navIndex = ref.watch(screenProvider).currentIndex;
    Print.greenLog('Nav Index : $navIndex');
    final isDark = ref.watch(screenProvider).isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (_isProgrammaticScroll) return;
          Print.greenLog('Page Changed Index : $index');

          ref.read(screenProvider).setIndex(index);
        },
        children: const [
          HomeScreen(),
          ProjectsScreen(),
          AboutScreen(),
          ContactScreen(),
        ],
      ),
      bottomNavigationBar: _FloatingBottomNav(
        items: _navItems,
        activeIndex: navIndex,
        isDark: isDark,
        onTap: _onNavTap,
      ).animate().slideY(
            begin: 1.0,
            duration: 600.ms,
            delay: 400.ms,
            curve: Curves.easeOutBack,
          ),
      // floatingActionButton: _ResumeFAB(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
    );
  }
}

// ── Floating Bottom Navigation Bar ───────────────────────────────

class _FloatingBottomNav extends StatelessWidget {
  final List<_NavItem> items;
  final int activeIndex;
  final bool isDark;
  final ValueChanged<int> onTap;

  const _FloatingBottomNav({
    required this.items,
    required this.activeIndex,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      height: 64,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surface.withOpacity(0.92)
            : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.glassBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // ── Sliding indicator ───────────────────────────────
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              alignment: Alignment(
                -1.0 + (activeIndex * 2.0 / (items.length - 1)),
                0,
              ),
              child: FractionallySizedBox(
                widthFactor: 1.0 / items.length,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            // ── Nav items ───────────────────────────────────────
            Row(
              children: List.generate(
                items.length,
                (i) => Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: activeIndex == i ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            child: FaIcon(
                              items[i].icon,
                              size: 17,
                              color: activeIndex == i
                                  ? Colors.white
                                  : isDark
                                      ? AppColors.textMuted
                                      : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: activeIndex == i ? 1.0 : 0.0,
                            child: Text(
                              items[i].label,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ── Resume FAB ────────────────────────────────────────────────────

// class _ResumeFAB extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<_ResumeFAB> createState() => _ResumeFABState();
// }

// class _ResumeFABState extends ConsumerState<_ResumeFAB> {
//   bool _downloaded = false;

//   void _handleTap() {
//     // In production: trigger JS download via dart:html
//     // or open URL to the hosted PDF
//     setState(() => _downloaded = true);
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) setState(() => _downloaded = false);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOutBack,
//       child: FloatingActionButton.extended(
//         heroTag: 'resume-fab',
//         onPressed: _handleTap,
//         backgroundColor: _downloaded ? AppColors.success : AppColors.primary,
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         icon: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 250),
//           child: Icon(
//             _downloaded ? Icons.check_rounded : Icons.download_rounded,
//             key: ValueKey(_downloaded),
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         label: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 250),
//           child: Text(
//             _downloaded ? 'Saved!' : 'Resume',
//             key: ValueKey(_downloaded),
//             style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 13,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
