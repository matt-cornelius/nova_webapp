import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main_nav_bar.dart';

/// GROUPS PAGE
/// -----------
/// This page is a **demo screen** that shows how a future "Groups" feature
/// could look.
///
/// Conceptually, "groups" are communities or teams of donors that organize
/// around a shared cause (e.g. "Local climate meetup", "Company giving circle").
///
/// For now this page:
/// - shows a header with a short description
/// - lists a few hard‑coded example groups
/// - uses the shared `MainNavBar` so it behaves like the other main tabs
class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Example data for demo groups. In a real app this would come
    // from your backend / API instead of being hard‑coded.
    final List<_DemoGroup> groups = <_DemoGroup>[
      const _DemoGroup(
        name: 'Hack For Good Squad',
        membersLabel: '24 members · Online',
        description:
            'Developers running mini‑fundraisers during hackathons and meetups.',
      ),
      const _DemoGroup(
        name: 'Local Climate Crew',
        membersLabel: '12 members · In‑person',
        description:
            'Neighbors organizing recurring donations for climate projects.',
      ),
      const _DemoGroup(
        name: 'Company Giving Circle',
        membersLabel: '58 members · Hybrid',
        description:
            'Coworkers pooling monthly contributions to vote on causes.',
      ),
    ];

    return Scaffold(
      // Venmo/Spotify style with colorful background
      backgroundColor: colors.surfaceVariant, // More colorful background, less white
      appBar: AppBar(
        title: const Text('Groups'),
        centerTitle: true, // Center the title in the AppBar
        elevation: 0, // Flat design
      ),
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
        child: SafeArea(
          // For desktop apps, we center the content and constrain its width
          child: Center(
            child: ConstrainedBox(
              // Max width prevents content from stretching too wide on large desktop screens
              // 800px is a good max width for desktop readability
              constraints: const BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(
                  24.0,
                ), // More padding for cleaner look
              child: Column(
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Center all content horizontally
                children: <Widget>[
                  // Header - bold, modern typography - centered
                  Center(
                    child: Text(
                      'Join people who care about the same causes.',
                      textAlign: TextAlign.center, // Center the text
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing:
                                -0.3, // Tighter spacing for modern feel
                          ),
                    ),
                  ),
                  const SizedBox(height: 12), // More spacing
                  // Subtitle - secondary text color for hierarchy - centered
                  Center(
                    child: Text(
                      'Groups make it easier to coordinate donations, set shared goals, '
                      'and see your combined impact over time.',
                      textAlign: TextAlign.center, // Center the text
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            colors.onSurfaceVariant, // Use theme secondary text
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // More spacing before list
                  Expanded(
                    // ListView.builder efficiently renders only the visible cards.
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (BuildContext context, int index) {
                        final _DemoGroup group = groups[index];
                        return _GroupCard(group: group);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
      // Index 1 because Groups sits between Home (0) and Explore (2) in the nav.
      bottomNavigationBar: const MainNavBar(currentIndex: 1),
    );
  }
}

/// Small data class used just on this demo page to describe a group.
class _DemoGroup {
  final String name;
  final String membersLabel;
  final String description;

  const _DemoGroup({
    required this.name,
    required this.membersLabel,
    required this.description,
  });
}

/// Simple presentation widget that shows one group as a card.
class _GroupCard extends StatelessWidget {
  final _DemoGroup group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      // Venmo/Spotify style colorful card
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
        child: ListTile(
        // Leading circle avatar with the first letter of the group name.
        // Uses primary color for modern, professional look
        leading: CircleAvatar(
          radius: 26, // Slightly larger for better visual weight
          backgroundColor: colors.primaryContainer,
          child: Text(
            group.name.substring(0, 1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colors.onPrimaryContainer, // Contrast color for text
              fontSize: 16,
            ),
          ),
        ),
        // Group name - bold, primary text
        title: Text(
          group.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        // Subtitle section with members label and description
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Members label - secondary text
              Text(
                group.membersLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant, // Theme secondary text
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6), // More spacing
              // Description - secondary text, regular weight
              Text(
                group.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant, // Theme secondary text
                ),
              ),
            ],
          ),
        ),
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ), // More padding for cleaner look
        // Trailing chevron in primary color for more vibrancy
        trailing: Icon(Icons.chevron_right, color: colors.primary),
        onTap: () {
          // When the user taps a group, navigate to the **group chat** page
          // using GoRouter. We pass the group name through `extra` so the
          // chat screen knows which group to display.
          //
          // NOTE: We use `context.push` instead of `context.go` here because
          // chat is a *sub-page* on top of Groups. This means the bottom
          // navigation bar state stays correct when you go back.
          context.push(
            '/groups/chat',
            extra: <String, String>{'name': group.name},
          );
        },
        ),
      ),
    );
  }
}
