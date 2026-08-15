/// Compiled catalogue of modern job roles for hybrid dropdown selection.
const List<String> kGlobalJobRoleCatalogue = [
  'Frontend Developer',
  'Frontend Engineer',
  'React Developer',
  'Angular Developer',
  'Vue.js Developer',
  'Web Developer',
  'UI Developer',
  'Backend Developer',
  'Backend Engineer',
  'Node.js Developer',
  'Java Developer',
  'Python Developer',
  '.NET Developer',
  'PHP Developer',
  'Full Stack Developer',
  'Full Stack Engineer',
  'Software Engineer',
  'Software Developer',
  'Flutter Developer',
  'Mobile Developer',
  'Android Developer',
  'iOS Developer',
  'React Native Developer',
  'DevOps Engineer',
  'Cloud Engineer',
  'Site Reliability Engineer',
  'Platform Engineer',
  'Data Analyst',
  'Data Scientist',
  'Machine Learning Engineer',
  'AI Engineer',
  'UI/UX Designer',
  'UX Designer',
  'UI Designer',
  'Product Designer',
  'Product Manager',
  'Project Manager',
  'Program Manager',
  'QA Engineer',
  'Test Engineer',
  'Automation Test Engineer',
  'Cybersecurity Engineer',
  'Security Engineer',
  'Database Administrator',
  'Database Engineer',
  'Business Analyst',
  'System Analyst',
  'Solutions Architect',
  'Software Architect',
  'Technical Lead',
  'Engineering Manager',
];

/// Service responsible for job role search suggestions.
class JobRoleDataService {
  const JobRoleDataService();

  static List<String> getSuggestions(String query) {
    if (query.trim().isEmpty) return kGlobalJobRoleCatalogue;
    final cleanQuery = query.trim().toLowerCase();
    return kGlobalJobRoleCatalogue
        .where((role) => role.toLowerCase().contains(cleanQuery))
        .toList();
  }
}
