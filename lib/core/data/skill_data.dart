/// Comprehensive compiled-in Skill catalogue for search & suggestions.
const List<String> kGlobalSkillCatalogue = [
  // Programming Languages
  'Dart',
  'Java',
  'Kotlin',
  'Swift',
  'Python',
  'JavaScript',
  'TypeScript',
  'C',
  'C++',
  'C#',
  'Go',
  'Rust',
  'PHP',
  'Ruby',
  'R',
  'Scala',
  'Bash',
  'PowerShell',
  'SQL',

  // Frontend
  'HTML5',
  'CSS3',
  'React',
  'React Native',
  'Angular',
  'Vue.js',
  'Next.js',
  'Nuxt.js',
  'Svelte',
  'Tailwind CSS',
  'Bootstrap',
  'Material UI',
  'SASS',
  'Redux',
  'Zustand',

  // Backend
  'Node.js',
  'Express.js',
  'NestJS',
  'Django',
  'Flask',
  'FastAPI',
  'Spring Boot',
  'ASP.NET Core',
  'Laravel',
  'Ruby on Rails',
  'REST API',
  'GraphQL',
  'gRPC',
  'Microservices',

  // Mobile
  'Flutter',
  'Android',
  'iOS',
  'Jetpack Compose',
  'SwiftUI',
  'Firebase',
  'App Store Deployment',
  'Google Play Deployment',
  'Mobile UI/UX',

  // Databases
  'PostgreSQL',
  'MySQL',
  'SQLite',
  'MongoDB',
  'Redis',
  'Oracle',
  'SQL Server',
  'Firebase Firestore',
  'Firebase Realtime Database',
  'DynamoDB',
  'Cassandra',

  // Cloud
  'AWS',
  'Microsoft Azure',
  'Google Cloud Platform',
  'Docker',
  'Kubernetes',
  'Terraform',
  'CloudFormation',
  'Serverless',
  'Cloud Functions',

  // DevOps
  'Git',
  'GitHub',
  'GitLab',
  'Bitbucket',
  'GitHub Actions',
  'Jenkins',
  'CI/CD',
  'Linux',
  'Nginx',
  'Monitoring',
  'Prometheus',
  'Grafana',

  // Data / AI
  'Machine Learning',
  'Deep Learning',
  'Artificial Intelligence',
  'Data Science',
  'Data Analysis',
  'Pandas',
  'NumPy',
  'Scikit-learn',
  'TensorFlow',
  'PyTorch',
  'OpenCV',
  'Natural Language Processing',
  'Computer Vision',
  'Generative AI',
  'Large Language Models',
  'LangChain',

  // Testing
  'Unit Testing',
  'Widget Testing',
  'Integration Testing',
  'Flutter Testing',
  'JUnit',
  'pytest',
  'Selenium',
  'Cypress',
  'Playwright',
  'Postman',
  'API Testing',
  'Performance Testing',
  'Test Automation',

  // Security
  'Cybersecurity',
  'Network Security',
  'Application Security',
  'Cloud Security',
  'OWASP',
  'Penetration Testing',
  'Ethical Hacking',
  'Identity and Access Management',
  'OAuth',
  'JWT',
  'Encryption',
  'Security Auditing',

  // UI/UX & Design
  'UI Design',
  'UX Design',
  'Figma',
  'Adobe XD',
  'Wireframing',
  'Prototyping',
  'Design Systems',
  'Responsive Design',
  'Accessibility',
  'User Research',
  'Usability Testing',

  // Product & Management
  'Product Management',
  'Project Management',
  'Agile',
  'Scrum',
  'Kanban',
  'Jira',
  'Confluence',
  'Stakeholder Management',
  'Requirements Analysis',
  'Roadmapping',
  'Risk Management',

  // Business & Professional
  'Communication',
  'Leadership',
  'Problem Solving',
  'Teamwork',
  'Time Management',
  'Critical Thinking',
  'Presentation',
  'Negotiation',
  'Research',
  'Analytical Thinking',
];

/// Single shared Skill Data Service.
class SkillDataService {
  const SkillDataService();

  List<String> getSuggestions(String query) {
    if (query.trim().isEmpty) return kGlobalSkillCatalogue;
    final cleanQuery = query.trim().toLowerCase();
    return kGlobalSkillCatalogue
        .where((skill) => skill.toLowerCase().contains(cleanQuery))
        .toList();
  }
}
