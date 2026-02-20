// lib/providers/app_providers.dart
//
// All Riverpod providers for the portfolio app.
// We use Riverpod over BLoC here because:
//  - FutureProvider gives us async GitHub data with zero boilerplate
//  - StateProvider handles simple toggle state (dark mode, nav index)
//  - No codegen needed for this scale of app

import 'package:azim_portfolio/providers/screen_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/github_repo.dart';
import '../services/github_service.dart';

// ── Theme ────────────────────────────────────────────────────────

// ── GitHub Data ──────────────────────────────────────────────────

/// Fetches all public repos for Azim04 from GitHub REST API v3.
/// Automatically cached; UI shows ShimmerList while loading.
final githubReposProvider = FutureProvider<List<GitHubRepo>>((ref) async {
  return GitHubService.instance.fetchRepos();
});

/// Fetches metadata for a specific repo by name.
/// Used to hydrate individual project cards with live stars / language.
final repoMetaProvider =
    FutureProvider.family<GitHubRepo?, String>((ref, repoName) async {
  return GitHubService.instance.fetchRepo(repoName);
});

// ── Contact Form ─────────────────────────────────────────────────

enum ContactFormState { idle, loading, success, error }

final contactFormStateProvider =
    StateProvider<ContactFormState>((ref) => ContactFormState.idle);

final screenProvider = ChangeNotifierProvider((_) => ScreenProvider());

// ── Scroll offset (for parallax) ─────────────────────────────────
final heroScrollOffsetProvider = StateProvider<double>((ref) => 0.0);
