import 'package:flutter/material.dart';

import 'main_nav_bar.dart';

/// EXPLORE / SEARCH PAGE (Spotify‑style)
/// ------------------------------------
/// This page mimics the Spotify "Search" tab layout:
/// - Big title at the top
/// - Search bar
/// - A grid of colorful cards to "browse" trending content
class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  /// A simple list of "trending events" to show in cards.
  /// In a real app these would probably come from an API.
  final List<Map<String, String>> _trendingEvents = <Map<String, String>>[
    <String, String>{
      'title': 'Climate Action Summit',
      'subtitle': 'Global online event · This week',
    },
    <String, String>{
      'title': 'Hack For Good',
      'subtitle': 'Developer fundraiser · Tomorrow',
    },
    <String, String>{
      'title': 'Community Tree Planting',
      'subtitle': 'Local meetup · Saturday',
    },
    <String, String>{
      'title': 'Clean Water Challenge',
      'subtitle': 'Run / Walk · Next month',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar automatically uses theme - clean and modern
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: SingleChildScrollView(
          // `SingleChildScrollView` allows the whole content to scroll together.
          child: Padding(
            padding: const EdgeInsets.all(
              20.0,
            ), // More padding for cleaner look
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// SEARCH BAR
                /// ----------
                /// This is a rounded container that wraps a `TextField`,
                /// similar to the search bar on Spotify.
                /// Uses theme's input decoration for consistent, modern styling.
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: colors.onSurfaceVariant,
                    ),
                    hintText: 'Search organizations',
                    // Theme automatically applies rounded borders and styling
                    // This gives us the clean, modern look inspired by Spotify
                  ),
                  // Right now the search bar is only visual and does not
                  // filter the grid below. You can hook this up later by
                  // storing the text in state and using it to filter cards.
                  onChanged: (String value) {},
                ),
                const SizedBox(
                  height: 28,
                ), // More spacing for cleaner hierarchy
                /// TRENDING CARDS SECTION
                /// ----------------------
                /// This mimics the "Browse all" category grid on Spotify's search page.
                /// We show colorful cards for trending organizations and events.
                Text(
                  'Trending organizations & events',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3, // Tighter spacing for modern look
                  ),
                ),
                const SizedBox(height: 16), // More spacing before grid
                // `GridView.count` is a simple way to create a grid when you
                // know how many columns you want (here: 2).
                // Increased spacing for cleaner, more professional look
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16, // More space between columns
                  mainAxisSpacing: 16, // More space between rows
                  childAspectRatio: 1.3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    // A few hard‑coded cards that highlight certain orgs.
                    _TrendingCard(
                      title: 'Clean Water Now',
                      subtitle: 'Health · Uganda',
                      color: Colors.blue.shade400,
                    ),
                    _TrendingCard(
                      title: 'Code For Kids',
                      subtitle: 'Education · US',
                      color: Colors.purple.shade400,
                    ),
                    _TrendingCard(
                      title: 'Urban Tree Alliance',
                      subtitle: 'Environment · Brazil',
                      color: Colors.green.shade400,
                    ),
                    _TrendingCard(
                      title: 'Rapid Relief Fund',
                      subtitle: 'Emergency · Global',
                      color: Colors.red.shade400,
                    ),
                    // And then cards that represent time‑bound events.
                    for (final Map<String, String> event in _trendingEvents)
                      _TrendingCard(
                        title: event['title'] ?? '',
                        subtitle: event['subtitle'] ?? '',
                        color: Colors.orange.shade400,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Index mapping after adding the Groups tab:
      // 0 = Home, 1 = Groups, 2 = Explore, 3 = Profile.
      bottomNavigationBar: const MainNavBar(currentIndex: 2),
    );
  }
}

/// Simple reusable widget for a colorful "category" style card,
/// similar to the tiles you see on Spotify's search screen.
class _TrendingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _TrendingCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // `InkWell` adds a nice ripple effect when the card is tapped.
      // Modern rounded corners for that Spotify/Venmo feel
      borderRadius: BorderRadius.circular(20), // Match container border radius
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tapped "$title"')));
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          // More rounded corners for modern, friendly look
          borderRadius: BorderRadius.circular(20),
          // Subtle shadow for depth (like Spotify cards)
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // More padding for cleaner, more spacious look
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3, // Tighter spacing for modern feel
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(
                  0.9,
                ), // Slightly more opaque for better readability
              ),
            ),
          ],
        ),
      ),
    );
  }
}
