// lib/models/experience_model.dart
class ExperienceModel {
  final String role;
  final String company;
  final String companyFull;
  final String location;
  final String startDate;
  final String endDate;
  final List<String> bullets;
  final String emoji;
  final bool isCurrent;

  const ExperienceModel({
    required this.role,
    required this.company,
    required this.companyFull,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.bullets,
    required this.emoji,
    this.isCurrent = false,
  });

  String get dateRange => '$startDate – $endDate';
}

class EducationModel {
  final String institution;
  final String degree;
  final String location;
  final String startDate;
  final String endDate;
  final String grade;
  final String gradeLabel;

  const EducationModel({
    required this.institution,
    required this.degree,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.grade,
    required this.gradeLabel,
  });
}

class SkillCategory {
  final String name;
  final String emoji;
  final List<SkillItem> skills;

  const SkillCategory({
    required this.name,
    required this.emoji,
    required this.skills,
  });
}

class SkillItem {
  final String name;
  final double proficiency; // 0.0 – 1.0
  const SkillItem(this.name, this.proficiency);
}

// ─────────────────────────────────────────────────────────────────
//  STATIC DATA (sourced from resume — see README §Content Sources)
// ─────────────────────────────────────────────────────────────────

const List<ExperienceModel> kExperiences = [
  ExperienceModel(
    role: 'App Developer (Android & iOS)',
    company: 'Evibe Solutions',
    companyFull: 'Evibe Solutions',
    location: 'Bangalore, India',
    startDate: 'Jun 2025',
    endDate: 'Present',
    isCurrent: true,
    emoji: '💍',
    bullets: [
      'Developed PAW (Plan A Wedding) — comprehensive Flutter app for Android & iOS, integrating Firebase for real-time auth, data sync, and cloud storage. Achieved 99% uptime for guest management & vendor coordination.',
      'Implemented AI-driven features: personalised vendor recommendations, automated timeline generation, and predictive budget forecasting — boosting planning efficiency by 50%.',
      'Leveraged Riverpod for robust state management, improving performance & responsiveness by 30% for dynamic API-driven content.',
    ],
  ),
  ExperienceModel(
    role: 'Flutter Developer',
    company: 'Protip',
    companyFull: 'Pronion Fintech Pvt. Ltd.',
    location: 'Bangalore, India',
    startDate: 'Sep 2024',
    endDate: 'Jun 2025',
    emoji: '💹',
    bullets: [
      'Built a production-grade mutual fund mobile app (Android & iOS) with Flutter, Firebase authentication, and BLoC state management — achieving 98% crash-free sessions.',
      'Synchronised frontend with backend APIs for real-time NAV and portfolio updates, improving data consistency by 35%.',
      'Configured GitHub Actions CI/CD pipelines — reduced deployment time by 40%.',
      'Leveraged Shorebird for OTA updates — cut update delivery time by 50%.',
    ],
  ),
  ExperienceModel(
    role: 'AWS Cloud Intern',
    company: 'F13 Technologies',
    companyFull: 'F13 Enhance Pvt. Ltd.',
    location: 'Remote (New Delhi)',
    startDate: 'Dec 2023',
    endDate: 'Apr 2024',
    emoji: '☁️',
    bullets: [
      'Built a content recommendation system with ReactJS, Node.js, and Amazon Personalize — achieved 30% increase in content relevance via generative-AI-enhanced predictive algorithms.',
      'Deployed on AWS (EC2 + S3) and optimised infrastructure with Terraform, reducing provisioning time by 25%.',
      'Earned AWS Partner Technical and Cloud Economics accreditations.',
    ],
  ),
];

const List<EducationModel> kEducation = [
  EducationModel(
    institution: 'Jayawantrao Sawant College of Engineering, Pune',
    degree: 'B.E. — Computer Engineering',
    location: 'Pune, India',
    startDate: 'Dec 2021',
    endDate: 'Jun 2025',
    grade: '9.43',
    gradeLabel: 'CGPA',
  ),
  EducationModel(
    institution: 'Nashik Presidency Junior College',
    degree: 'Higher Secondary Certificate (HSC)',
    location: 'Nashik, India',
    startDate: 'Aug 2020',
    endDate: 'Jul 2021',
    grade: '93.17%',
    gradeLabel: 'Percentage',
  ),
  EducationModel(
    institution: 'Shri Sharda English Medium School',
    degree: 'Secondary School Certificate (SSC)',
    location: 'Kopargaon, India',
    startDate: 'Jun 2018',
    endDate: 'Mar 2019',
    grade: '90.60%',
    gradeLabel: 'Percentage',
  ),
];

const List<SkillCategory> kSkillCategories = [
  SkillCategory(
    name: 'Languages',
    emoji: '💻',
    skills: [
      SkillItem('Dart', 0.95),
      SkillItem('Python', 0.80),
      SkillItem('JavaScript', 0.75),
      SkillItem('Java', 0.70),
      SkillItem('C++', 0.65),
      SkillItem('SQL', 0.75),
      SkillItem('Shell Scripting', 0.60),
    ],
  ),
  SkillCategory(
    name: 'Mobile & Frontend',
    emoji: '📱',
    skills: [
      SkillItem('Flutter (Android & iOS)', 0.95),
      SkillItem('Firebase', 0.90),
      SkillItem('BLoC / Riverpod', 0.90),
      SkillItem('ReactJS', 0.70),
      SkillItem('REST APIs', 0.85),
    ],
  ),
  SkillCategory(
    name: 'DevOps & Cloud',
    emoji: '☁️',
    skills: [
      SkillItem('AWS (EC2, S3, Personalize)', 0.80),
      SkillItem('GitHub Actions / CI-CD', 0.85),
      SkillItem('Docker', 0.70),
      SkillItem('Terraform', 0.70),
      SkillItem('Kubernetes', 0.60),
      SkillItem('GCP', 0.55),
    ],
  ),
  SkillCategory(
    name: 'Tools',
    emoji: '🔧',
    skills: [
      SkillItem('Git & GitHub', 0.90),
      SkillItem('MySQL', 0.75),
      SkillItem('Shorebird OTA', 0.85),
      SkillItem('Linux CLI', 0.75),
    ],
  ),
];
