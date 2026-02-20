// lib/models/github_repo.dart
class GitHubRepo {
  final String name;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final String htmlUrl;
  final String? homepage;
  final DateTime updatedAt;
  final List<String> topics;

  const GitHubRepo({
    required this.name,
    this.description,
    this.language,
    required this.stargazersCount,
    required this.forksCount,
    required this.htmlUrl,
    this.homepage,
    required this.updatedAt,
    required this.topics,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      name: json['name'] as String,
      description: json['description'] as String?,
      language: json['language'] as String?,
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      forksCount: json['forks_count'] as int? ?? 0,
      htmlUrl: json['html_url'] as String,
      homepage: json['homepage'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  /// Human-readable relative time (e.g. "3 months ago")
  String get relativeUpdate {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    return 'Today';
  }
}
