// test/home_screen_test.dart
//
// Smoke tests verifying that the top-level screens render without
// throwing.  We override the githubReposProvider with a mock so
// tests are fully hermetic — no network I/O.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:azim_portfolio/main.dart';
import 'package:azim_portfolio/providers/app_providers.dart';
import 'package:azim_portfolio/models/github_repo.dart';
import 'package:azim_portfolio/screens/home_screen.dart';
import 'package:azim_portfolio/screens/main_shell.dart';

// ── Helpers ───────────────────────────────────────────────────────

/// Wraps [child] in the minimum widget tree required:
/// ProviderScope + MaterialApp with the dark theme.
Widget buildTestableWidget(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: child,
    ),
  );
}

/// Fake GitHub repos returned by the overridden provider.
final _fakeRepos = [
  GitHubRepo(
    name: 'GoEV',
    description: 'EV Route Planner — Flutter + Django',
    language: 'Dart',
    stargazersCount: 4,
    forksCount: 1,
    htmlUrl: 'https://github.com/Azim04/GoEV',
    updatedAt: DateTime.now().subtract(const Duration(days: 30)),
    topics: ['flutter', 'django', 'maps'],
  ),
  GitHubRepo(
    name: 'content-recommendation',
    description: 'AWS Personalize content recommendation engine',
    language: 'JavaScript',
    stargazersCount: 2,
    forksCount: 0,
    htmlUrl: 'https://github.com/Azim04/content-recommendation',
    updatedAt: DateTime.now().subtract(const Duration(days: 60)),
    topics: ['aws', 'reactjs', 'node'],
  ),
];

// ── Tests ─────────────────────────────────────────────────────────

void main() {
  group('HomeScreen', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const HomeScreen(),
          overrides: [
            githubReposProvider.overrideWith(
              (ref) async => _fakeRepos,
            ),
          ],
        ),
      );

      // Allow animations to settle
      await tester.pump(const Duration(milliseconds: 100));

      // Core content visible
      expect(find.textContaining('Azim Shaikh'), findsWidgets);
      expect(find.textContaining('Flutter Developer'), findsWidgets);
    });

    testWidgets('CTA buttons are present', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const HomeScreen(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _fakeRepos),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.textContaining('View Projects'), findsOneWidget);
      expect(find.textContaining('Resume'), findsWidgets);
    });

    testWidgets('quick stats strip shows 4 stat tiles', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const HomeScreen(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _fakeRepos),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // 4 stats: 1+ yr, 4+ apps, 98%, 3 companies
      expect(find.text('1+'), findsOneWidget);
      expect(find.text('4+'), findsOneWidget);
      expect(find.text('98%'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });

  group('MainShell', () {
    testWidgets('bottom navigation renders with 4 tabs', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const MainShell(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _fakeRepos),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Check nav labels
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Projects'), findsWidgets);
      expect(find.text('About'), findsWidgets);
      expect(find.text('Contact'), findsWidgets);
    });
  });
}
