// lib/services/github_service.dart
//
// Fetches public repo data from the GitHub REST API v3.
// Caches results in-memory to avoid redundant network hits during
// a single session (important for 60fps scrolling performance).

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_repo.dart';

class GitHubService {
  GitHubService._();
  static final GitHubService instance = GitHubService._();

  static const String _username = 'Azim04';
  static const String _baseUrl = 'https://api.github.com';

  // In-memory cache — persists for the app session lifetime
  List<GitHubRepo>? _cachedRepos;
  DateTime? _cacheTime;
  static const Duration _cacheTtl = Duration(minutes: 15);

  bool get _isCacheValid =>
      _cacheTime != null &&
      _cachedRepos != null &&
      DateTime.now().difference(_cacheTime!) < _cacheTtl;

  /// Returns all public repos for [_username], sorted by most recently updated.
  Future<List<GitHubRepo>> fetchRepos() async {
    if (_isCacheValid) return _cachedRepos!;

    final uri = Uri.parse(
      '$_baseUrl/users/$_username/repos?sort=updated&per_page=30&type=public',
    );

    final response = await http.get(uri, headers: {
      'Accept': 'application/vnd.github.v3+json',
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw GitHubException(
        'GitHub API returned ${response.statusCode}',
        response.statusCode,
      );
    }

    final raw = json.decode(response.body) as List<dynamic>;
    final repos = raw
        .map((e) => GitHubRepo.fromJson(e as Map<String, dynamic>))
        .toList();

    _cachedRepos = repos;
    _cacheTime = DateTime.now();
    return repos;
  }

  /// Fetch metadata for a single repo by [repoName].
  Future<GitHubRepo?> fetchRepo(String repoName) async {
    // Prefer serving from cache if available
    if (_isCacheValid) {
      try {
        return _cachedRepos!.firstWhere(
          (r) => r.name.toLowerCase() == repoName.toLowerCase(),
        );
      } catch (_) {}
    }

    final uri = Uri.parse('$_baseUrl/repos/$_username/$repoName');
    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/vnd.github.v3+json',
      }).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return GitHubRepo.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
    } catch (_) {
      // Silently fail — caller falls back to resume data
    }
    return null;
  }
}

class GitHubException implements Exception {
  final String message;
  final int statusCode;
  const GitHubException(this.message, this.statusCode);

  @override
  String toString() => 'GitHubException($statusCode): $message';
}
