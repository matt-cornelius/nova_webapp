import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_data/donations_demo.dart';
import 'donations_provider.dart';
import 'main_nav_bar.dart';
import 'widgets/organization_image.dart';

/// HOME PAGE
/// ---------
/// Shows a feed of recent donations as cards.
///
/// - The data comes from `DonationsProvider` (which wraps `demoDonations`).
/// - Each card shows: donor, amount, and the organization they supported.
/// - Users can tap the heart icon to "like" a donation.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Short alias so we do not have to repeatedly type
  /// `DonationsProvider.instance` everywhere.
  final DonationsProvider _provider = DonationsProvider.instance;

  @override
  Widget build(BuildContext context) {
    // We read the current donation list from the provider on every build. This
    // is cheap because the list is small and in memory.
    final List<Donation> donations = _provider.donations;

    // Get the theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // Venmo/Spotify style with colorful background
      backgroundColor: colors.surfaceVariant, // More colorful background, less white
      body: Container(
        // Add gradient background for more color (Venmo/Spotify style)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colors.primaryContainer.withOpacity(0.4),
              colors.secondaryContainer.withOpacity(0.3),
              colors.tertiaryContainer.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            // Max width prevents content from stretching too wide on large desktop screens
            // 800px is good for desktop readability with cards
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Proper desktop padding
              child: ListView.builder(
              // `ListView.builder` lazily builds only the visible cards,
              // which is good practice even for small lists.
              itemCount: donations.length,
              itemBuilder: (BuildContext context, int index) {
                final Donation donation = donations[index];
                return _DonationCard(
                  donation: donation,
                  isLiked: _provider.isLiked(donation.id),
                  onToggleLike: () {
                    // We tell the provider to toggle the like state, then
                    // call `setState` to trigger a rebuild so the UI updates.
                    _provider.toggleLike(donation.id);
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ),
        ),
      ),
      // Our custom bottom navigation bar shared across main pages.
      //
      // Index mapping after adding the Groups tab:
      // 0 = Home, 1 = Groups, 2 = Explore, 3 = Profile.
      bottomNavigationBar: const MainNavBar(currentIndex: 0),
    );
  }
}

/// Presentation widget that renders a single donation "post" card.
///
/// The layout is intentionally similar to a Venmo / social‑feed style post:
/// - header      → avatar, name + handle, relative time
/// - body        → donation message text + optional emoji
/// - footer      → "Paid $X to Organization" summary
/// - trailing UI → heart icon for likes
class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.donation,
    required this.isLiked,
    required this.onToggleLike,
  });

  /// The donation to display.
  final Donation donation;

  /// Whether this donation is currently liked by the user.
  final bool isLiked;

  /// Callback invoked when the user taps the heart icon.
  final VoidCallback onToggleLike;

  @override
  Widget build(BuildContext context) {
    // We use the helper extension defined in `donations_demo.dart` to look up
    // the related user and organization for this donation.
    final fromIndividual = donation.fromIndividual;
    final organization = donation.toOrganization;

    final String donorName = fromIndividual?.fullName ?? 'Unknown donor';
    // Social apps often show a short handle right under the name.
    final String donorHandle = fromIndividual?.handle ?? '@unknown';

    // Get theme colors for consistent styling throughout the card
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Venmo/Spotify style colorful cards
    return Card(
      // Card with colorful background, no shadow
      elevation: 0, // No shadow
      color: colors.surface, // Card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // More rounded for Venmo/Spotify feel
        side: BorderSide(
          color: colors.primary.withOpacity(0.3), // Colored border accent
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 16), // Spacing between cards
      child: Container(
        // Add subtle gradient overlay for more color depth
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colors.surface,
              colors.surface.withOpacity(0.95),
              colors.primaryContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Comfortable desktop padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Middle: main content column (header + body + footer).
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // HEADER ROW: name + handle on the left, time on the right.
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Donor name - bold, primary text color
                            Text(
                              donorName,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colors
                                        .onSurface, // Use theme text color
                                  ),
                            ),
                            const SizedBox(height: 4), // More spacing
                            // Handle - secondary text color for hierarchy
                            Text(
                              donorHandle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors
                                        .onSurfaceVariant, // Theme secondary text
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // More spacing after header
                  // BODY: the "story" text, similar to a Venmo message.
                  if (donation.message.isNotEmpty)
                    Text(
                      donation.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface, // Primary text color
                        height: 1.5, // Line height for readability
                      ),
                    ),
                  if (donation.message.isNotEmpty) const SizedBox(height: 8),
                  // Optional emoji reaction, displayed a bit larger for emphasis.
                  if (donation.emoji != null)
                    Text(
                      donation.emoji!,
                      style: const TextStyle(
                        fontSize: 24,
                      ), // Slightly larger for better visibility
                    ),
                  const SizedBox(height: 12),
                  // FOOTER: Organization recipient section - Venmo/Spotify colorful style
                  // Shows organization logo, amount, and organization name
                  // This makes it very clear who the donation went to
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      // Colorful gradient background (Venmo/Spotify style)
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          colors.primaryContainer.withOpacity(0.5),
                          colors.secondaryContainer.withOpacity(0.4),
                          colors.tertiaryContainer.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: InkWell(
                      // Make the entire organization section clickable
                      onTap: organization != null
                          ? () {
                              // Navigate to the organization profile page using GoRouter
                              context.push(
                                '/organization/${organization.id}',
                              );
                            }
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: <Widget>[
                          // Organization logo/icon - shows who received the donation
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: OrganizationImage(
                              imageUrl: organization?.logoUrl ?? '',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Organization info and amount
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // "Donated to" label for clarity
                                Text(
                                  'Donated to',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 11,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                // Organization name - bold and prominent
                                Text(
                                  organization?.name ?? 'Unknown organization',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Amount displayed prominently on the right
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '\$${donation.amountUsd.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              // Verification badge if organization is verified
                              if (organization?.isVerified ?? false) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.verified,
                                      size: 14,
                                      color: colors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      'Verified',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colors.primary,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right side: like button (heart icon), in its own column so it
            // stays aligned at the top like in many social apps.
            Column(
              children: <Widget>[
                IconButton(
                  // The filled heart means "liked", the border means "not liked".
                  // Use primary color when liked, secondary when not
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked
                        ? colors
                              .primary // Primary color when liked
                        : colors.onSurfaceVariant.withOpacity(
                            0.6,
                          ), // Subtle when not liked
                  ),
                  onPressed: onToggleLike,
                  tooltip: isLiked ? 'Unlike' : 'Like',
                  padding: EdgeInsets.zero, // Tighter padding for cleaner look
                  constraints:
                      const BoxConstraints(), // Remove default constraints
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

