import 'organizations.dart';

/// Demo data for individual user accounts and donations.
///
/// Think of this file as a tiny in‑memory "database" for a Venmo‑style
/// donation app. Widgets can import these lists to render feeds, profiles,
/// organization pages, etc.

/// An individual user account in your app.
///
/// In a real app this data would likely come from your auth system
/// and a backend service. Here we just hard‑code a few example users.
class IndividualAccount {
  /// Unique id for the user (used as a foreign key in other records).
  final String id;

  /// Human‑readable name shown in the UI.
  final String fullName;

  /// Short handle / username, like `@sam_donates`.
  final String handle;

  /// Optional avatar image URL (or could be an asset path).
  final String avatarUrl;

  /// Email associated with the account.
  final String email;

  /// When the user created their account.
  final DateTime joinedAt;

  /// Short bio text for the profile page.
  final String bio;

  /// Preferred funding source for "one‑tap" donating.
  /// Examples: "card_visa", "bank_ach", "apple_pay".
  final String defaultFundingSource;

  /// Current in‑app wallet balance (if your product uses stored value).
  final double walletBalanceUsd;

  /// How much this user has donated in total (all‑time).
  final double totalDonatedUsd;

  IndividualAccount({
    required this.id,
    required this.fullName,
    required this.handle,
    required this.avatarUrl,
    required this.email,
    required this.joinedAt,
    required this.bio,
    required this.defaultFundingSource,
    required this.walletBalanceUsd,
    required this.totalDonatedUsd,
  });
}

/// A single donation from an individual to an organization.
///
/// This is the core "transaction" for your app.
class Donation {
  /// Unique id for this donation transaction.
  final String id;

  /// Which user sent the donation (references `IndividualAccount.id`).
  final String fromIndividualId;

  /// Which organization received the donation (references `Organization.id`).
  final String toOrganizationId;

  /// Amount in USD.
  final double amountUsd;

  /// When the donation was created.
  final DateTime createdAt;

  /// Note / message attached by the donor (optional, but nice for the feed).
  final String message;

  /// Optional emoji "reaction" that you can show in the social feed UI.
  final String? emoji;

  /// If true, this donation can be shown publicly in activity feeds.
  final bool isPublic;

  /// If true, this represents a recurring monthly donation.
  final bool isRecurringMonthly;

  /// Status of the payment (for example, useful if you later integrate
  /// with a real payment processor).
  /// Common values: "pending", "completed", "failed", "refunded".
  final String status;

  /// Which payment method was used for this specific donation.
  final String fundingSource;

  /// Optional campaign / appeal name if the donation belongs
  /// to a specific fundraising campaign.
  final String? campaignName;

  Donation({
    required this.id,
    required this.fromIndividualId,
    required this.toOrganizationId,
    required this.amountUsd,
    required this.createdAt,
    required this.message,
    this.emoji,
    required this.isPublic,
    required this.isRecurringMonthly,
    required this.status,
    required this.fundingSource,
    this.campaignName,
  });
}

/// Mock individuals that can appear in a "friends" list or activity feed.
final List<IndividualAccount> demoIndividuals = <IndividualAccount>[
  IndividualAccount(
    id: 'user_sam',
    fullName: 'Sam Patel',
    handle: '@sam_donates',
    avatarUrl:
        'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg',
    email: 'sam.patel@example.com',
    joinedAt: DateTime(2024, 3, 12),
    bio: 'Trying to give a little every month ✨',
    defaultFundingSource: 'card_visa_4242',
    walletBalanceUsd: 35.75,
    totalDonatedUsd: 420.00,
  ),
  IndividualAccount(
    id: 'user_amy',
    fullName: 'Amy Chen',
    handle: '@amy_helps',
    avatarUrl:
        'https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg',
    email: 'amy.chen@example.com',
    joinedAt: DateTime(2023, 11, 5),
    bio: 'Big fan of education + climate projects.',
    defaultFundingSource: 'bank_ach_ending_0011',
    walletBalanceUsd: 120.00,
    totalDonatedUsd: 980.50,
  ),
  IndividualAccount(
    id: 'user_luis',
    fullName: 'Luis García',
    handle: '@luis_gives',
    avatarUrl:
        'https://images.pexels.com/photos/1704488/pexels-photo-1704488.jpeg',
    email: 'luis.garcia@example.com',
    joinedAt: DateTime(2024, 6, 21),
    bio: 'Monthly donor to water + disaster relief orgs.',
    defaultFundingSource: 'apple_pay',
    walletBalanceUsd: 0.0,
    totalDonatedUsd: 220.25,
  ),
];

/// Mock donations between `demoIndividuals` and `demoOrganizations`.
///
/// You can use these to drive:
/// - a "recent activity" feed
/// - organization detail pages (showing recent donors)
/// - user profile pages (showing where they donated)
final List<Donation> demoDonations = <Donation>[
  Donation(
    id: 'don_001',
    fromIndividualId: 'user_sam',
    toOrganizationId: 'org_clean_water',
    amountUsd: 25.00,
    createdAt: DateTime(2024, 10, 5, 14, 30),
    message: 'For new wells in rural villages 💧',
    emoji: '💧',
    isPublic: true,
    isRecurringMonthly: true,
    status: 'completed',
    fundingSource: 'card_visa_4242',
    campaignName: 'October Clean Water Drive',
  ),
  Donation(
    id: 'don_002',
    fromIndividualId: 'user_amy',
    toOrganizationId: 'org_coding_kids',
    amountUsd: 50.00,
    createdAt: DateTime(2024, 10, 6, 9, 15),
    message: 'For more laptops in Oakland schools 💻',
    emoji: '💻',
    isPublic: true,
    isRecurringMonthly: false,
    status: 'completed',
    fundingSource: 'bank_ach_ending_0011',
    campaignName: 'Back‑To‑School Kits',
  ),
  Donation(
    id: 'don_003',
    fromIndividualId: 'user_luis',
    toOrganizationId: 'org_emergency_relief',
    amountUsd: 75.50,
    createdAt: DateTime(2024, 10, 7, 18, 45),
    message: 'Sending support after the recent floods.',
    emoji: '🤝',
    isPublic: true,
    isRecurringMonthly: false,
    status: 'completed',
    fundingSource: 'apple_pay',
    campaignName: 'Flood Relief 2024',
  ),
  Donation(
    id: 'don_004',
    fromIndividualId: 'user_amy',
    toOrganizationId: 'org_tree_alliance',
    amountUsd: 10.00,
    createdAt: DateTime(2024, 10, 8, 8, 5),
    message: 'A little something for more trees in the city 🌳',
    emoji: '🌳',
    isPublic: false, // private donation (only org + donor can see it).
    isRecurringMonthly: true,
    status: 'pending',
    fundingSource: 'bank_ach_ending_0011',
    campaignName: null,
  ),
  Donation(
    id: 'don_005',
    fromIndividualId: 'user_sam',
    toOrganizationId: 'org_coding_kids',
    amountUsd: 5.00,
    createdAt: DateTime(2024, 10, 8, 20, 10),
    message: 'Keep inspiring the next generation!',
    emoji: '🚀',
    isPublic: true,
    isRecurringMonthly: false,
    status: 'completed',
    fundingSource: 'card_visa_4242',
    campaignName: null,
  ),
];

/// Helper methods to "join" donation rows with user + organization data.
///
/// These are convenience getters so you can easily access related records
/// without writing the lookup logic everywhere in your widgets.
extension DonationLookups on Donation {
  /// The `IndividualAccount` that sent this donation, or `null` if
  /// something is mis‑configured in the demo data.
  IndividualAccount? get fromIndividual {
    try {
      return demoIndividuals.firstWhere(
        (IndividualAccount user) => user.id == fromIndividualId,
      );
    } on StateError {
      return null;
    }
  }

  /// The `Organization` that received this donation, or `null` if
  /// the id does not exist in `demoOrganizations`.
  Organization? get toOrganization {
    try {
      return demoOrganizations.firstWhere(
        (Organization org) => org.id == toOrganizationId,
      );
    } on StateError {
      return null;
    }
  }
}
