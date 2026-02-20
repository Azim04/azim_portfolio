// lib/router/app_router.dart
//
// GoRouter is chosen over Navigator 2.0 directly for:
//  - Declarative URL-based routing (deep links work on web)
//  - CustomTransitionPage for slide/fade transitions that mirror
//    native iOS/Android push animations
//  - Shell routing so the bottom nav persists across tab switches
//    without rebuilding the entire widget tree

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash — displayed once then auto-navigates to /home
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // Main shell with bottom navigation
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const MainShell(),
        transitionsBuilder: _slideUpTransition,
      ),
    ),
  ],
);

// ── Transition builders ───────────────────────────────────────────

Widget _fadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideUpTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    )),
    child: FadeTransition(opacity: animation, child: child),
  );
}
