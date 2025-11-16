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
    logoUrl:
        'https://images.pexels.com/photos/4618245/pexels-photo-4618245.jpeg',
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
    logoUrl:
        'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
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
    logoUrl:
        'https://images.pexels.com/photos/1131407/pexels-photo-1131407.jpeg',
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
    logoUrl:
        'https://images.pexels.com/photos/6646912/pexels-photo-6646912.jpeg',
    website: 'https://example.org/rapid-relief',
    ein: '55-0011223',
    totalReceivedUsd: 512_340.10,
    supportersCount: 8023,
    isVerified: true,
    tags: <String>['disaster response', 'food', 'cash assistance', 'global'],
  ),
];
