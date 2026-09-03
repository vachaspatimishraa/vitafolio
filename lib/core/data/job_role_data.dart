/// Compiled catalogue of diverse job roles across various domains for hybrid dropdown selection.
const List<String> kGlobalJobRoleCatalogue = [
  // --- Technology, Software & Data ---
  'Software Engineer',
  'Software Developer',
  'Frontend Developer',
  'Backend Developer',
  'Full Stack Developer',
  'React Developer',
  'Flutter Developer',
  'Android Developer',
  'iOS Developer',
  'DevOps Engineer',
  'Cloud Engineer',
  'Data Analyst',
  'Data Scientist',
  'Data Engineer',
  'Machine Learning Engineer',
  'AI Engineer',
  'Database Administrator',
  'Cybersecurity Analyst',
  'Network Administrator',
  'IT Support Specialist',
  'UI/UX Designer',
  'QA Engineer',

  // --- Management, Operations & Project Leadership ---
  'Project Manager',
  'Program Manager',
  'Product Manager',
  'Operations Manager',
  'Shift Incharge',
  'Shift Supervisor',
  'Site Supervisor',
  'General Manager',
  'Assistant Manager',
  'Branch Manager',
  'Scrum Master',
  'Team Lead',
  'Technical Lead',
  'Process Manager',
  'Facility Manager',

  // --- Manufacturing, Factory & Industrial Operations ---
  'Factory Manager',
  'Plant Manager',
  'Production Supervisor',
  'Production Engineer',
  'Quality Control (QC) Inspector',
  'Quality Assurance (QA) Manager',
  'Maintenance Supervisor',
  'Maintenance Engineer',
  'Assembly Line Worker',
  'CNC Operator',
  'Machine Operator',
  'Tool and Die Maker',
  'Industrial Engineer',
  'Safety Officer',
  'EHS (Environmental Health & Safety) Manager',

  // --- Construction, Civil & Real Estate ---
  'Civil Engineer',
  'Site Engineer',
  'Construction Manager',
  'Project Engineer',
  'Quantity Surveyor',
  'Structural Engineer',
  'Architect',
  'Draftsman / CAD Operator',
  'Safety Supervisor',
  'HVAC Engineer',
  'Real Estate Agent',
  'Property Manager',

  // --- Supply Chain, Logistics & Warehouse ---
  'Logistics Manager',
  'Supply Chain Manager',
  'Warehouse Manager',
  'Warehouse Supervisor',
  'Inventory Control Manager',
  'Procurement Manager',
  'Purchase Officer',
  'Dispatch Executive',
  'Fleet Manager',
  'Forklift Operator',
  'Logistics Coordinator',

  // --- Sales, Marketing & Business Development ---
  'Sales Executive',
  'Sales Manager',
  'Business Development Executive (BDE)',
  'Business Development Manager (BDM)',
  'Account Executive',
  'Marketing Executive',
  'Marketing Manager',
  'Digital Marketing Specialist',
  'SEO Specialist',
  'Content Writer',
  'Brand Manager',
  'Public Relations (PR) Specialist',

  // --- Finance, Accounting & Banking ---
  'Accountant',
  'Senior Accountant',
  'Financial Analyst',
  'Finance Manager',
  'Chartered Accountant (CA)',
  'Auditor',
  'Tax Consultant',
  'Payroll Specialist',
  'Bank Teller',
  'Loan Officer',
  'Investment Banker',
  'Credit Analyst',

  // --- Human Resources, Administration & Support ---
  'HR Executive',
  'HR Generalist',
  'HR Manager',
  'Talent Acquisition Specialist / Recruiter',
  'Training and Development Manager',
  'Office Administrator',
  'Administrative Assistant',
  'Executive Assistant',
  'Receptionist',
  'Front Desk Officer',
  'Data Entry Operator',

  // --- Healthcare, Pharma & Life Sciences ---
  'General Physician / Doctor',
  'Registered Nurse (RN)',
  'Pharmacist',
  'Medical Lab Technician',
  'Radiology Technician',
  'Physical Therapist',
  'Clinical Research Associate (CRA)',
  'Medical Representative (MR)',
  'Healthcare Administrator',
  'Dentist',

  // --- Hospitality, Retail, Customer Service & Food Industry ---
  'Customer Support Executive',
  'Call Center Agent',
  'Client Relations Manager',
  'Retail Store Manager',
  'Store Supervisor',
  'Sales Associate',
  'Hotel General Manager',
  'Front Office Manager',
  'Restaurant Manager',
  'Chef / Head Chef',
  'Sous Chef',
  'Barista',
  'Event Manager',
  'Event Coordinator',

  // --- Education, Teaching & Research ---
  'School Teacher',
  'High School Teacher',
  'Assistant Professor',
  'Professor',
  'Academic Counselor',
  'Corporate Trainer',
  'Instructional Designer',
  'Research Associate',
  'Tutor',

  // --- Media, Entertainment & Creative Arts ---
  'Graphic Designer',
  'Video Editor',
  'Animator',
  'Photographer',
  'Videographer',
  'Copywriter',
  'Journalist',
  'Social Media Manager',
  'Sound Engineer',

  // --- Legal, Compliance & Aviation/Transportation ---
  'Legal Associate',
  'Corporate Lawyer',
  'Legal Advisor',
  'Compliance Officer',
  'Flight Attendant / Cabin Crew',
  'Airline Pilot',
  'Air Traffic Controller',
  'Commercial Driver',
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