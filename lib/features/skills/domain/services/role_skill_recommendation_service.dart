/// Service responsible for producing role-specific recommended skills based on Job Role normalization.
class RoleSkillRecommendationService {
  const RoleSkillRecommendationService();

  static const List<String> _defaultFallbackSkills = [
    'Communication',
    'Problem Solving',
    'Teamwork',
    'Git',
    'Time Management',
    'Critical Thinking',
    'Project Management',
    'Research',
    'Agile',
    'Documentation',
  ];

  static const Map<String, List<String>> _roleSkillMap = {
    'frontend': [
      'HTML5',
      'CSS3',
      'JavaScript',
      'TypeScript',
      'React',
      'Next.js',
      'Vue.js',
      'Angular',
      'Tailwind CSS',
      'REST API',
      'Git',
      'Responsive Design',
      'Accessibility',
      'Redux',
      'UI/UX Design',
    ],
    'backend': [
      'Node.js',
      'Express.js',
      'Python',
      'Java',
      'Go',
      'SQL',
      'PostgreSQL',
      'MySQL',
      'MongoDB',
      'Redis',
      'REST API',
      'GraphQL',
      'gRPC',
      'Microservices',
      'Docker',
      'Git',
    ],
    'full_stack': [
      'JavaScript',
      'TypeScript',
      'React',
      'Node.js',
      'Express.js',
      'HTML5',
      'CSS3',
      'SQL',
      'PostgreSQL',
      'MongoDB',
      'REST API',
      'Git',
      'Docker',
      'Tailwind CSS',
    ],
    'flutter': [
      'Flutter',
      'Dart',
      'Riverpod',
      'Bloc',
      'Clean Architecture',
      'Firebase',
      'REST API',
      'Git',
      'Mobile UI/UX',
      'Widget Testing',
      'App Store Deployment',
      'Google Play Deployment',
    ],
    'android': [
      'Android',
      'Kotlin',
      'Java',
      'Jetpack Compose',
      'REST API',
      'SQLite',
      'Firebase',
      'Git',
      'Google Play Deployment',
      'Architecture Patterns',
    ],
    'ios': [
      'iOS',
      'Swift',
      'SwiftUI',
      'Core Data',
      'REST API',
      'Firebase',
      'Git',
      'App Store Deployment',
      'Mobile UI/UX',
    ],
    'mobile': [
      'Flutter',
      'Dart',
      'React Native',
      'Kotlin',
      'Swift',
      'Firebase',
      'REST API',
      'Mobile UI/UX',
      'Git',
      'App Store Deployment',
    ],
    'software_engineer': [
      'Data Structures',
      'Algorithms',
      'Java',
      'Python',
      'C++',
      'Git',
      'SQL',
      'REST API',
      'System Design',
      'Unit Testing',
      'Agile',
    ],
    'devops': [
      'Docker',
      'Kubernetes',
      'AWS',
      'Terraform',
      'CI/CD',
      'GitHub Actions',
      'Jenkins',
      'Linux',
      'Bash',
      'Nginx',
      'Prometheus',
      'Grafana',
      'Git',
    ],
    'data_scientist': [
      'Python',
      'R',
      'Machine Learning',
      'Data Science',
      'Data Analysis',
      'Pandas',
      'NumPy',
      'Scikit-learn',
      'SQL',
      'Statistics',
      'Data Visualization',
    ],
    'data_analyst': [
      'SQL',
      'Data Analysis',
      'Excel',
      'Tableau',
      'Power BI',
      'Python',
      'Pandas',
      'Data Visualization',
      'Statistics',
    ],
    'machine_learning': [
      'Python',
      'Machine Learning',
      'Deep Learning',
      'TensorFlow',
      'PyTorch',
      'Scikit-learn',
      'Natural Language Processing',
      'Computer Vision',
      'Generative AI',
      'MLOps',
    ],
    'ui_ux': [
      'UI Design',
      'UX Design',
      'Figma',
      'Adobe XD',
      'Wireframing',
      'Prototyping',
      'User Research',
      'Design Systems',
      'Usability Testing',
      'Responsive Design',
    ],
    'product_manager': [
      'Product Management',
      'Roadmapping',
      'Agile',
      'Scrum',
      'User Research',
      'Jira',
      'Requirements Analysis',
      'Stakeholder Management',
      'Data Analysis',
    ],
    'project_manager': [
      'Project Management',
      'Agile',
      'Scrum',
      'Kanban',
      'Jira',
      'Risk Management',
      'Stakeholder Management',
      'Communication',
      'Time Management',
    ],
    'qa': [
      'Unit Testing',
      'Integration Testing',
      'Selenium',
      'Cypress',
      'Playwright',
      'Postman',
      'API Testing',
      'Test Automation',
      'Performance Testing',
      'Bug Tracking',
    ],
    'cloud': [
      'AWS',
      'Microsoft Azure',
      'Google Cloud Platform',
      'Docker',
      'Kubernetes',
      'Terraform',
      'Cloud Security',
      'Serverless',
      'Linux',
    ],
    'cybersecurity': [
      'Cybersecurity',
      'Network Security',
      'Application Security',
      'Penetration Testing',
      'Ethical Hacking',
      'OWASP',
      'Identity and Access Management',
      'OAuth',
      'JWT',
      'Encryption',
    ],
    'database_admin': [
      'SQL',
      'PostgreSQL',
      'MySQL',
      'Oracle',
      'SQL Server',
      'MongoDB',
      'Redis',
      'Query Optimization',
      'Database Security',
      'Backup & Recovery',
    ],
    'business_analyst': [
      'Requirements Analysis',
      'Data Analysis',
      'SQL',
      'Agile',
      'Jira',
      'Process Mapping',
      'Communication',
      'Presentation',
      'Analytical Thinking',
    ],
  };

  /// Normalizes job role string to match role families.
  static String normalizeJobRole(String role) {
    final clean = role.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
    if (clean.contains('flutter')) return 'flutter';
    if (clean.contains('front_end') || clean.contains('frontend') || clean.contains('web_dev')) return 'frontend';
    if (clean.contains('back_end') || clean.contains('backend')) return 'backend';
    if (clean.contains('full_stack') || clean.contains('fullstack')) return 'full_stack';
    if (clean.contains('android')) return 'android';
    if (clean.contains('ios')) return 'ios';
    if (clean.contains('mobile')) return 'mobile';
    if (clean.contains('devops') || clean.contains('sre')) return 'devops';
    if (clean.contains('data_sci')) return 'data_scientist';
    if (clean.contains('data_anal')) return 'data_analyst';
    if (clean.contains('machine_learn') || clean.contains('ml_eng') || clean.contains('ai_eng')) return 'machine_learning';
    if (clean.contains('ui') || clean.contains('ux') || clean.contains('design')) return 'ui_ux';
    if (clean.contains('product_man')) return 'product_manager';
    if (clean.contains('project_man')) return 'project_manager';
    if (clean.contains('qa') || clean.contains('test')) return 'qa';
    if (clean.contains('cloud')) return 'cloud';
    if (clean.contains('cyber') || clean.contains('secur')) return 'cybersecurity';
    if (clean.contains('db') || clean.contains('database')) return 'database_admin';
    if (clean.contains('business_anal')) return 'business_analyst';
    if (clean.contains('software') || clean.contains('engineer') || clean.contains('developer')) return 'software_engineer';
    return 'default';
  }

  /// Returns recommended skills for a given job role, excluding already selected skills.
  static List<String> getRecommendedSkills({
    required String jobRole,
    required List<String> selectedSkills,
  }) {
    final key = normalizeJobRole(jobRole);
    final rawList = _roleSkillMap[key] ?? _defaultFallbackSkills;
    return rawList.where((skill) => !selectedSkills.contains(skill)).toList();
  }
}
