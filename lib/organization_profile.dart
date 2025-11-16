import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_data/organizations.dart';
import 'demo_data/donations_demo.dart';
import 'donation_dialog.dart';

/// ORGANIZATION PROFILE PAGE
/// -------------------------
/// Displays detailed information about an organization including:
/// - Name, location, and description
/// - Donation button
/// - Leaderboard of largest recent donations
///
/// This page can be accessed by clicking on organization names throughout
/// the app or by searching for organizations.
class OrganizationProfilePage extends StatelessWidget {
  /// The unique identifier of the organization to display.
  final String organizationId;

  const OrganizationProfilePage({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context) {
    // Look up the organization by its ID from the demo data
    // In a real app, this would come from an API or database
    Organization? organization;
    try {
      organization = demoOrganizations.firstWhere(
        (Organization org) => org.id == organizationId,
      );
    } on StateError {
      // If organization not found, show error message
      organization = null;
    }

    // If organization doesn't exist, show error screen
    if (organization == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Organization Not Found'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Organization not found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Get all donations for this organization, sorted by amount (largest first)
    // Only show public donations that are completed
    final List<Donation> organizationDonations =
        demoDonations
            .where(
              (Donation donation) =>
                  donation.toOrganizationId == organizationId &&
                  donation.isPublic &&
                  donation.status == 'completed',
            )
            .toList()
          ..sort(
            (Donation a, Donation b) => b.amountUsd.compareTo(a.amountUsd),
          );

    // Take top 5 largest donations for the leaderboard
    final List<Donation> topDonations = organizationDonations.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: Text(organization.name), centerTitle: true),
      body: SingleChildScrollView(
        // For desktop apps, we center the content and constrain its width
        child: Center(
          child: ConstrainedBox(
            // Max width prevents content from stretching too wide on large desktop screens
            // 800px is a good max width for organization profile readability
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Center all content horizontally
                children: <Widget>[
                  /// ORGANIZATION HEADER SECTION
                  /// ---------------------------
                  /// Shows the organization logo, name, tagline, and verification badge
                  // Centered header with logo and info stacked vertically for cleaner look
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Organization logo - centered
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          organization.logoUrl,
                          width:
                              120, // Slightly larger for better visual impact
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) {
                                // Fallback if image fails to load
                                return Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.business,
                                    size: 60,
                                    color: colors.onPrimaryContainer,
                                  ),
                                );
                              },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // More spacing for cleaner look
                      // Organization name with verification badge - centered
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            organization.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (organization.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              color: colors.primary,
                              size: 24, // Slightly larger for better visibility
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Tagline - short description, centered
                      Text(
                        organization.tagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ), // More spacing for cleaner separation
                  /// LOCATION INFORMATION
                  /// ---------------------
                  /// Displays city and country where the organization is based
                  // Centered location info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.location_on, color: colors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${organization.city}, ${organization.country}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ), // More spacing for cleaner separation
                  /// DESCRIPTION SECTION
                  /// -------------------
                  /// Shows the full mission statement/description
                  // Centered "About" title
                  Center(
                    child: Text(
                      'About',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // More spacing
                  // Centered description text
                  Text(
                    organization.description,
                    textAlign: TextAlign.center, // Center the description text
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height:
                          1.6, // Slightly increased line height for better readability
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ), // More spacing for cleaner separation
                  /// STATISTICS SECTION
                  /// ------------------
                  /// Shows total received, supporters count, and category
                  // Statistics container with centered content
                  Container(
                    padding: const EdgeInsets.all(
                      20,
                    ), // More padding for cleaner look
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // More rounded for modern look
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Total received
                        Column(
                          children: <Widget>[
                            Text(
                              '\$${organization.totalReceivedUsd.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total Raised',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        // Supporters count
                        Column(
                          children: <Widget>[
                            Text(
                              organization.supportersCount.toString(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Supporters',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        // Category
                        Column(
                          children: <Widget>[
                            Text(
                              organization.category,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colors.primary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Category',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ), // More spacing for cleaner separation
                  /// DONATION BUTTON
                  /// ----------------
                  /// Primary call-to-action button to donate to this organization
                  // Constrained width button for better desktop UX
                  SizedBox(
                    width: double.infinity, // Full width within constraints
                    height: 56, // Taller button for better touch target
                    child: ElevatedButton(
                      onPressed: () {
                        // Show the donation dialog when user taps "Donate Now"
                        // This opens a clean, Venmo-style pop-up for making donations
                        // We use ! because we know organization is not null at this point
                        // (there's an early return if it's null earlier in the build method)
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return DonationDialog(
                              organization: organization!,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Use primary color for the button
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.favorite),
                          const SizedBox(width: 8),
                          Text(
                            'Donate Now',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ), // More spacing for cleaner separation
                  /// DONATION LEADERBOARD SECTION
                  /// -----------------------------
                  /// Shows the top 5 largest recent donations to this organization
                  if (topDonations.isNotEmpty) ...<Widget>[
                    // Centered "Recent Top Donations" title
                    Center(
                      child: Text(
                        'Recent Top Donations',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // More spacing before list
                    // List of top donations - centered with constrained width
                    ...topDonations.asMap().entries.map((
                      MapEntry<int, Donation> entry,
                    ) {
                      final int index = entry.key;
                      final Donation donation = entry.value;
                      final IndividualAccount? donor = donation.fromIndividual;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: <Widget>[
                              // Rank indicator (1st, 2nd, 3rd, etc.)
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: index < 3
                                      ? colors.primaryContainer
                                      : colors.surfaceVariant,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: index < 3
                                          ? colors.onPrimaryContainer
                                          : colors.onSurfaceVariant,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Donor avatar
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: colors.primaryContainer,
                                child: Text(
                                  donor?.fullName
                                          .substring(0, 1)
                                          .toUpperCase() ??
                                      '?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colors.onPrimaryContainer,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Donor name and amount
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      donor?.fullName ?? 'Anonymous',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatRelativeTime(donation.createdAt),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // Donation amount - highlighted
                              Text(
                                '\$${donation.amountUsd.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ] else ...<Widget>[
                    // Show message if no donations yet - centered
                    Container(
                      padding: const EdgeInsets.all(
                        32,
                      ), // More padding for cleaner look
                      decoration: BoxDecoration(
                        color: colors.surfaceVariant,
                        borderRadius: BorderRadius.circular(
                          16,
                        ), // More rounded for modern look
                      ),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.volunteer_activism,
                              size:
                                  56, // Slightly larger for better visual impact
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: 20), // More spacing
                            Text(
                              'Be the first to donate!',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Formats a `DateTime` into a simple relative time string such as "2h ago".
  ///
  /// This helper function converts donation timestamps into human-readable
  /// relative time for better UX.
  String _formatRelativeTime(DateTime time) {
    final Duration diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} min ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} h ago';
    } else {
      return '${diff.inDays} d ago';
    }
  }
}
