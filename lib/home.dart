import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_data/donations_demo.dart';
import 'donations_provider.dart';
import 'main_nav_bar.dart';

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
      // AppBar automatically uses our theme settings for clean, modern look
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true, // Center the title in the AppBar
      ),
      // `body` is the main content area of the screen.
      // For desktop apps, we center the content and constrain its width
      body: Center(
        child: ConstrainedBox(
          // Max width prevents content from stretching too wide on large desktop screens
          // 800px is a good max width for desktop readability
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.all(
              20.0,
            ), // Slightly more padding for cleaner spacing
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center all content horizontally
              children: <Widget>[
                // Welcome header with modern typography - centered
                Center(
                  child: Text(
                    'Welcome back 👋',
                    textAlign: TextAlign.center, // Center the text
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5, // Tighter spacing for modern feel
                    ),
                  ),
                ),
                const SizedBox(height: 12), // More space for cleaner look
                // Subtitle with secondary text color for hierarchy - centered
                Center(
                  child: Text(
                    'Here are the latest donations happening on the platform.',
                    textAlign: TextAlign.center, // Center the text
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors
                          .onSurfaceVariant, // Use theme color for secondary text
                    ),
                  ),
                ),
                const SizedBox(height: 24), // More space before cards
                Expanded(
                  // `ListView.builder` lazily builds only the visible cards,
                  // which is good practice even for small lists.
                  child: ListView.builder(
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
              ],
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

    return Card(
      // Card automatically uses theme settings - clean, modern look
      // No elevation needed - we use border instead for flat design
      margin: const EdgeInsets.symmetric(vertical: 8),
      // Theme already sets rounded corners and border, but we keep it explicit
      child: Padding(
        padding: const EdgeInsets.all(18.0), // More padding for cleaner look
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Left side: circular avatar with the first letter of the donor.
            // Using primary color with opacity for modern, professional look
            CircleAvatar(
              radius: 24, // Slightly larger for better visual weight
              backgroundColor: colors.primaryContainer,
              child: Text(
                donorName.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer, // Contrast color for text
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16), // More space between avatar and content
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
                      const SizedBox(width: 12),
                      // Time - tertiary text color, right-aligned
                      Text(
                        _formatRelativeTime(donation.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant.withOpacity(
                            0.7,
                          ), // Subtle tertiary
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
                  const SizedBox(height: 10),
                  // FOOTER: summary line like "Paid $25.00 to Clean Water Now".
                  // Highlight amount with primary color for emphasis
                  // Organization name is clickable and navigates to the organization profile
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'Paid '),
                        TextSpan(
                          text: '\$${donation.amountUsd.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: colors
                                .primary, // Highlight amount with primary color
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' to '),
                        // Make organization name clickable - wrap in GestureRecognizer
                        // This allows the text to be tappable while keeping it inline
                        TextSpan(
                          text: organization?.name ?? 'Unknown organization',
                          style: TextStyle(
                            color: colors
                                .primary, // Use primary color to indicate it's clickable
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: colors.primary,
                          ),
                          recognizer: organization != null
                              ? (TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to the organization profile page using GoRouter
                                    // The route expects the organization ID as a path parameter
                                    context.push(
                                      '/organization/${organization.id}',
                                    );
                                  })
                              : null,
                        ),
                      ],
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
    );
  }
}

/// Formats a `DateTime` into a simple relative time string such as "2h ago".
///
/// This is intentionally very lightweight – it is *not* a full i18n solution,
/// but it is good enough to make the demo feel more realistic.
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
