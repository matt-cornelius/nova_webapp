/// Demo data for organizations that can receive donations.
///
/// This file is meant to act like a tiny in‑memory "database" that you can
/// query from your widgets while you are building the app UI.

/// A single nonprofit / organization that can receive donations.
class Organization {
  /// Unique identifier for this organization.
  ///
  /// In a real backend this might come from a database (UUID, auto‑increment id, etc.).
  final String id;

  /// Display name that users will see in the UI.
  final String name;

  /// Short sentence that quickly tells donors what this org does.
  final String tagline;

  /// Longer description / mission statement (can be shown on details page).
  final String description;

  /// High‑level category for filtering and discovery.
  /// Examples: "Health", "Education", "Environment".
  final String category;

  /// City where the organization is primarily based.
  final String city;

  /// Country of the organization.
  final String country;

  /// URL to a logo image (or could be an asset path in a real app).
  final String logoUrl;

  /// Public website where donors can learn more.
  final String website;

  /// Optional tax‑id / EIN (useful if you later want to show tax‑deductible orgs).
  final String? ein;

  /// Total amount received historically (could be used for stats / leaderboards).
  final double totalReceivedUsd;

  /// Number of unique donors that have ever donated to this org.
  final int supportersCount;

  /// Whether the org has been vetted / verified by your platform.
  final bool isVerified;

  /// Tags make it easy to filter / search (e.g. by cause or location).
  final List<String> tags;

  const Organization({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.category,
    required this.city,
    required this.country,
    required this.logoUrl,
    required this.website,
    this.ein,
    required this.totalReceivedUsd,
    required this.supportersCount,
    required this.isVerified,
    required this.tags,
  });
}

/// List of mock organizations you can import and show in your UI.
///
/// Example usage in a widget:
/// ```dart
/// import 'demo_data/organizations.dart';
///
/// // Inside a build method:
/// final firstOrg = demoOrganizations.first;
/// Text(firstOrg.name);
/// ```
const List<Organization> demoOrganizations = <Organization>[
  Organization(
    id: 'org_clean_water',
    name: 'Clean Water Now',
    tagline: 'Bringing safe drinking water to every village.',
    description:
        'Clean Water Now builds and maintains community‑owned wells in '
        'rural areas with limited access to safe drinking water. They also '
        'train local teams to maintain the infrastructure long term.',
    category: 'Health',
    city: 'Kampala',
    country: 'Uganda',
    logoUrl: 'assets/clean_water_now_360.png',
    website: 'https://example.org/clean-water',
    ein: '12-3456789',
    totalReceivedUsd: 128_500.00,
    supportersCount: 2143,
    isVerified: true,
    tags: <String>['water', 'sanitation', 'africa', 'health'],
  ),
  Organization(
    id: 'org_coding_kids',
    name: 'Code For Kids',
    tagline: 'Teaching the next generation to code.',
    description:
        'Code For Kids runs after‑school coding clubs in under‑resourced '
        'schools, providing laptops, mentors, and project‑based curricula.',
    category: 'Education',
    city: 'Oakland',
    country: 'United States',
    logoUrl: 'assets/kids_who_code_360.png',
    website: 'https://example.org/code-for-kids',
    ein: '98-7654321',
    totalReceivedUsd: 245_230.50,
    supportersCount: 3891,
    isVerified: true,
    tags: <String>['education', 'youth', 'technology', 'coding'],
  ),
  Organization(
    id: 'org_tree_alliance',
    name: 'Urban Tree Alliance',
    tagline: 'Greening cities one tree at a time.',
    description:
        'Urban Tree Alliance plants and cares for trees in low‑canopy '
        'neighborhoods, helping reduce heat islands and improve air quality.',
    category: 'Environment',
    city: 'São Paulo',
    country: 'Brazil',
    logoUrl: 'assets/urban_tree_alliance_720.png',
    website: 'https://example.org/urban-tree-alliance',
    ein: null, // This org is international and not registered with a US EIN.
    totalReceivedUsd: 76_910.75,
    supportersCount: 1540,
    isVerified: false,
    tags: <String>['trees', 'climate', 'urban', 'latam'],
  ),
  Organization(
    id: 'org_emergency_relief',
    name: 'Rapid Relief Fund',
    tagline: 'Fast support when disasters strike.',
    description:
        'Rapid Relief Fund coordinates emergency food, shelter, and cash '
        'assistance for families affected by natural disasters around the world.',
    category: 'Emergency Relief',
    city: 'Geneva',
    country: 'Switzerland',
    logoUrl: 'assets/rapid_relief_fund_360.png',
    website: 'https://example.org/rapid-relief',
    ein: '55-0011223',
    totalReceivedUsd: 512_340.10,
    supportersCount: 8023,
    isVerified: true,
    tags: <String>['disaster response', 'food', 'cash assistance', 'global'],
  ),
  Organization(
    id: 'org_hunger_fight',
    name: 'Fight Hunger Foundation',
    tagline: 'Ending food insecurity, one meal at a time.',
    description:
        'Fight Hunger Foundation operates food banks and meal programs in '
        'urban centers, providing nutritious meals to families in need. They '
        'also run community gardens to promote food sustainability.',
    category: 'Food Security',
    city: 'New York',
    country: 'United States',
    logoUrl:
        'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg',
    website: 'https://example.org/fight-hunger',
    ein: '11-2233445',
    totalReceivedUsd: 189_420.30,
    supportersCount: 3124,
    isVerified: true,
    tags: <String>['food', 'hunger', 'community', 'nutrition'],
  ),
  Organization(
    id: 'org_women_empower',
    name: 'Women Empowerment Network',
    tagline: 'Building economic independence for women worldwide.',
    description:
        'Women Empowerment Network provides microloans, business training, '
        'and mentorship programs to help women start and grow their own '
        'businesses in developing regions.',
    category: 'Social Justice',
    city: 'Nairobi',
    country: 'Kenya',
    logoUrl:
        'https://images.pexels.com/photos/1181519/pexels-photo-1181519.jpeg',
    website: 'https://example.org/women-empower',
    ein: null,
    totalReceivedUsd: 156_780.90,
    supportersCount: 2456,
    isVerified: true,
    tags: <String>['women', 'empowerment', 'business', 'africa'],
  ),
  Organization(
    id: 'org_ocean_cleanup',
    name: 'Ocean Cleanup Initiative',
    tagline: 'Protecting our oceans for future generations.',
    description:
        'Ocean Cleanup Initiative removes plastic waste from oceans and '
        'coastlines, conducts research on marine pollution, and educates '
        'communities about ocean conservation.',
    category: 'Environment',
    city: 'Sydney',
    country: 'Australia',
    logoUrl:
        'https://images.pexels.com/photos/1007657/pexels-photo-1007657.jpeg',
    website: 'https://example.org/ocean-cleanup',
    ein: '77-8899001',
    totalReceivedUsd: 298_650.20,
    supportersCount: 4567,
    isVerified: true,
    tags: <String>['ocean', 'plastic', 'conservation', 'marine'],
  ),
  Organization(
    id: 'org_elderly_care',
    name: 'Golden Years Support',
    tagline: 'Dignified care and companionship for seniors.',
    description:
        'Golden Years Support provides home care services, social activities, '
        'and medical assistance to elderly individuals living alone or in '
        'under-resourced communities.',
    category: 'Health',
    city: 'London',
    country: 'United Kingdom',
    logoUrl:
        'https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg',
    website: 'https://example.org/golden-years',
    ein: '33-4455667',
    totalReceivedUsd: 94_320.50,
    supportersCount: 1876,
    isVerified: true,
    tags: <String>['elderly', 'care', 'health', 'community'],
  ),
  Organization(
    id: 'org_animal_rescue',
    name: 'Paws & Claws Rescue',
    tagline: 'Saving lives, one animal at a time.',
    description:
        'Paws & Claws Rescue operates animal shelters, provides veterinary '
        'care, and facilitates adoptions for abandoned and abused animals. '
        'They also run spay/neuter programs to control pet populations.',
    category: 'Animal Welfare',
    city: 'Toronto',
    country: 'Canada',
    logoUrl:
        'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
    website: 'https://example.org/paws-claws',
    ein: '44-5566778',
    totalReceivedUsd: 167_890.40,
    supportersCount: 2934,
    isVerified: true,
    tags: <String>['animals', 'rescue', 'pets', 'welfare'],
  ),
  Organization(
    id: 'org_mental_health',
    name: 'Mind Matters Foundation',
    tagline: 'Breaking the stigma around mental health.',
    description:
        'Mind Matters Foundation provides free counseling services, mental '
        'health education, and support groups in underserved communities. '
        'They focus on making mental health care accessible to everyone.',
    category: 'Health',
    city: 'Berlin',
    country: 'Germany',
    logoUrl:
        'https://images.pexels.com/photos/4101143/pexels-photo-4101143.jpeg',
    website: 'https://example.org/mind-matters',
    ein: null,
    totalReceivedUsd: 223_450.60,
    supportersCount: 3678,
    isVerified: true,
    tags: <String>['mental health', 'counseling', 'wellness', 'support'],
  ),
  Organization(
    id: 'org_homeless_shelter',
    name: 'Safe Haven Shelter',
    tagline: 'A place to call home for those without one.',
    description:
        'Safe Haven Shelter provides temporary housing, meals, job training, '
        'and support services to help homeless individuals and families '
        'transition to stable housing and employment.',
    category: 'Social Services',
    city: 'Los Angeles',
    country: 'United States',
    logoUrl:
        'https://images.pexels.com/photos/1571458/pexels-photo-1571458.jpeg',
    website: 'https://example.org/safe-haven',
    ein: '66-7788990',
    totalReceivedUsd: 345_210.80,
    supportersCount: 5234,
    isVerified: true,
    tags: <String>['homeless', 'housing', 'shelter', 'support'],
  ),
  Organization(
    id: 'org_refugee_support',
    name: 'Refugee Welcome Network',
    tagline: 'Supporting refugees on their journey to safety.',
    description:
        'Refugee Welcome Network provides legal assistance, language classes, '
        'job placement, and community integration support for refugees and '
        'asylum seekers in host countries.',
    category: 'Social Services',
    city: 'Amsterdam',
    country: 'Netherlands',
    logoUrl:
        'https://images.pexels.com/photos/3184306/pexels-photo-3184306.jpeg',
    website: 'https://example.org/refugee-welcome',
    ein: null,
    totalReceivedUsd: 278_560.70,
    supportersCount: 4123,
    isVerified: true,
    tags: <String>['refugees', 'immigration', 'integration', 'support'],
  ),
  Organization(
    id: 'org_youth_sports',
    name: 'Youth Sports Foundation',
    tagline: 'Building character through sports and teamwork.',
    description:
        'Youth Sports Foundation provides free sports programs, equipment, '
        'and coaching to children in low-income neighborhoods. They focus on '
        'teaching life skills through athletic participation.',
    category: 'Education',
    city: 'Chicago',
    country: 'United States',
    logoUrl:
        'https://images.pexels.com/photos/46798/the-ball-stadion-football-the-pitch-46798.jpeg',
    website: 'https://example.org/youth-sports',
    ein: '88-9900112',
    totalReceivedUsd: 134_670.25,
    supportersCount: 2567,
    isVerified: false,
    tags: <String>['sports', 'youth', 'teamwork', 'fitness'],
  ),
];
