// lib/main.dart
//
// Entry point. Key architectural decisions documented here:
//
// 1. ProviderScope at root — Riverpod's requirement; single store for
//    all providers, including the GitHub FutureProvider which starts
//    warming up as soon as the app launches (behind the splash).
//
// 2. MaterialApp.router + GoRouter — enables browser back/forward
//    navigation, proper URL updates, and deep link support essential
//    for a portfolio on the web.
//
// 3. Theme toggling via themeProvider StateProvider — single source,
//    zero boilerplate, smooth AnimatedTheme transitions.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on narrow mobile — the portfolio is mobile-first
  // but also supports landscape on desktop (unconstrained).
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Transparent status bar to allow full-bleed hero gradient
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: PortfolioApp(),
    ),
  );
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(screenProvider).isDark;

    return AnimatedTheme(
      data: isDark ? AppTheme.dark : AppTheme.light,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: MaterialApp.router(
        title: 'Azim Shaikh — Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        routerConfig: appRouter,

        // Web-specific: update <title> and meta description
        // (Flutter web renders into a <canvas>; SEO meta is in index.html)
        builder: (context, child) {
          // Enforce max width for desktop — keeps it feeling mobile
          // even on wide viewports by centring a constrained column
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
