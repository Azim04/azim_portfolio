// test/projects_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:azim_portfolio/providers/app_providers.dart';
import 'package:azim_portfolio/models/github_repo.dart';
import 'package:azim_portfolio/screens/projects_screen.dart';

Widget buildTestApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: ThemeData.dark(),
      home: child,
    ),
  );
}

final _mockRepos = [
  GitHubRepo(
    name: 'GoEV',
    description: 'EV Route Planner',
    language: 'Dart',
    stargazersCount: 3,
    forksCount: 0,
    htmlUrl: 'https://github.com/Azim04/GoEV',
    updatedAt: DateTime.now().subtract(const Duration(days: 20)),
    topics: ['flutter'],
  ),
];

void main() {
  group('ProjectsScreen', () {
    testWidgets('renders all 4 project cards from static data', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const ProjectsScreen(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _mockRepos),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // Verify all project titles appear
      expect(
        find.textContaining('Protip'),
        findsWidgets,
        reason: 'Protip project card should be visible',
      );
      expect(
        find.textContaining('GoEV'),
        findsWidgets,
        reason: 'GoEV project card should be visible',
      );
      expect(
        find.textContaining('PAW'),
        findsWidgets,
        reason: 'PAW project card should be visible',
      );
      expect(
        find.textContaining('Content Recommendation'),
        findsWidgets,
        reason: 'Content Recommendation card should be visible',
      );
    });

    testWidgets('GitHub sync bar shows loading state initially',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const ProjectsScreen(),
          overrides: [
            // Delay to keep it in loading state
            githubReposProvider.overrideWith(
              (ref) => Future.delayed(
                const Duration(seconds: 10),
                () => <GitHubRepo>[],
              ),
            ),
          ],
        ),
      );
      await tester.pump(); // One frame — still loading

      expect(find.textContaining('Syncing GitHub'), findsOneWidget);
    });

    testWidgets('GitHub sync bar shows success state after data loads',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const ProjectsScreen(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _mockRepos),
          ],
        ),
      );
      // Pump until future completes
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.textContaining('Live data synced'), findsOneWidget);
    });

    testWidgets('project card flip hint text is present', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const ProjectsScreen(),
          overrides: [
            githubReposProvider.overrideWith((ref) async => _mockRepos),
          ],
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Tap to flip'), findsWidgets);
    });
  });
}
