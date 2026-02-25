import 'package:azim_portfolio/utils/print_log.dart';
import 'package:flutter/material.dart';
import '../models/github_repo.dart';
import '../services/github_service.dart';

// ── Contact Form State ────────────────────────────────────────────
enum ContactFormState { idle, loading, success, error }

class ScreenProvider extends ChangeNotifier {
  // ── Theme ───────────────────────────────────────────────────────

  bool isDark = true;

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  // ── Navigation ──────────────────────────────────────────────────

  int currentIndex = 0;

  void setIndex(int index) {
    Print.greenLog('Setting Index : $index');
    currentIndex = index;
    notifyListeners();
  }

  // ── Scroll Offset (for parallax) ────────────────────────────────

  double heroScrollOffset = 0.0;

  void setHeroScrollOffset(double offset) {
    heroScrollOffset = offset;
    notifyListeners();
  }

  // ── Contact Form ────────────────────────────────────────────────

  ContactFormState contactFormState = ContactFormState.idle;

  void setContactFormState(ContactFormState state) {
    contactFormState = state;
    notifyListeners();
  }

  // ── GitHub — All Repos ──────────────────────────────────────────

  List<GitHubRepo> githubRepos = [];
  bool isLoadingRepos = false;
  String? reposError;

  Future<void> fetchRepos() async {
    if (isLoadingRepos) return;

    isLoadingRepos = true;
    reposError = null;
    notifyListeners();

    try {
      githubRepos = await GitHubService.instance.fetchRepos();
    } catch (e) {
      reposError = e.toString();
    } finally {
      isLoadingRepos = false;
      notifyListeners();
    }
  }

  final Map<String, GitHubRepo> _repoMeta = {};
  final Map<String, bool> _repoMetaLoading = {};
  final Map<String, String?> _repoMetaError = {};

  GitHubRepo? getRepoMeta(String repoName) => _repoMeta[repoName];
  bool isRepoMetaLoading(String repoName) =>
      _repoMetaLoading[repoName] ?? false;
  String? getRepoMetaError(String repoName) => _repoMetaError[repoName];

  Future<void> fetchRepoMeta(String repoName) async {
    // Skip if already fetched or currently in-flight
    if (_repoMeta.containsKey(repoName)) return;
    if (_repoMetaLoading[repoName] == true) return;

    _repoMetaLoading[repoName] = true;
    _repoMetaError[repoName] = null;
    notifyListeners();

    try {
      final repo = await GitHubService.instance.fetchRepo(repoName);
      if (repo != null) {
        _repoMeta[repoName] = repo;
      }
    } catch (e) {
      _repoMetaError[repoName] = e.toString();
    } finally {
      _repoMetaLoading[repoName] = false;
      notifyListeners();
    }
  }
}
