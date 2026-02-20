// lib/models/project_model.dart
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;
  final String? githubUrl;
  final String? demoUrl;
  final List<String> highlights;
  final String emoji;
  final String? repoName; // used to fetch GitHub metadata

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
    this.githubUrl,
    this.demoUrl,
    required this.highlights,
    required this.emoji,
    this.repoName,
  });
}

// ── Static resume-sourced project data ────────────────────────────
const List<ProjectModel> kProjects = [
  ProjectModel(
    id: 'protip',
    title: 'Protip — Mutual Fund Platform',
    emoji: '💹',
    description:
        'Production-grade mutual fund investment app for Android & iOS. '
        'Achieved 98% crash-free sessions through BLoC state management '
        'and Firebase-backed secure auth.',
    techStack: ['Flutter', 'Firebase', 'BLoC', 'Shorebird', 'GitHub Actions', 'REST APIs'],
    githubUrl: 'https://github.com/Azim04',
    highlights: [
      '98% crash-free uptime across Android & iOS',
      '35% improvement in data retrieval via optimised API sync',
      '40% faster deployments with GitHub Actions CI/CD',
      '50% faster OTA updates via Shorebird',
    ],
    repoName: 'protip',
  ),
  ProjectModel(
    id: 'paw',
    title: 'PAW — Plan A Wedding',
    emoji: '💍',
    description:
        'Comprehensive AI-powered wedding planning app for Android & iOS '
        'at Evibe Solutions. Features intelligent vendor recommendations, '
        'automated timeline generation, and predictive budget forecasting.',
    techStack: ['Flutter', 'Firebase', 'Riverpod', 'REST APIs', 'AI/ML'],
    githubUrl: 'https://github.com/Azim04',
    highlights: [
      '99% uptime for guest management & vendor coordination',
      '50% boost in planning efficiency via AI-driven features',
      '30% performance improvement with Riverpod state management',
    ],
    repoName: 'PAW',
  ),
  ProjectModel(
    id: 'goev',
    title: 'GoEV — EV Route Planner',
    emoji: '⚡',
    description:
        'Map-based mobile app for electric vehicle journey planning. '
        'Integrates Mappls Maps for real-time charging station routing '
        'with precise charging duration estimates.',
    techStack: ['Flutter', 'Firebase', 'Mappls Maps', 'Django', 'SQL'],
    githubUrl: 'https://github.com/Azim04',
    highlights: [
      '25% reduction in route planning time',
      'Real-time charging station availability & ETA',
      'Django + SQL backend for vehicle/owner data management',
    ],
    repoName: 'GoEV',
  ),
  ProjectModel(
    id: 'content-rec',
    title: 'Content Recommendation System',
    emoji: '🤖',
    description:
        'Web application leveraging Amazon Personalize to deliver '
        'personalised content recommendations, with automated AWS '
        'infrastructure provisioned via Terraform.',
    techStack: ['ReactJS', 'Node.js', 'Amazon Personalize', 'AWS SDK', 'Terraform'],
    githubUrl: 'https://github.com/Azim04',
    highlights: [
      '40% increase in user engagement',
      '30% improvement in recommendation accuracy',
      '25% reduction in infrastructure setup time via Terraform IaC',
    ],
    repoName: 'content-recommendation',
  ),
];
