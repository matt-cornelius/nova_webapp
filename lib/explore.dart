import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'demo_data/organizations.dart';
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
  /// Search query text entered by the user.
  /// When this changes, we filter the organizations list.
  String _searchQuery = '';

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

  /// Filters organizations based on the search query.
  /// Searches in name, tagline, description, category, city, country, and tags.
  List<Organization> _getFilteredOrganizations() {
    if (_searchQuery.isEmpty) {
      return <Organization>[]; // Don't show results when search is empty
    }

    final String query = _searchQuery.toLowerCase();
    return demoOrganizations.where((Organization org) {
      // Search in multiple fields for comprehensive results
      return org.name.toLowerCase().contains(query) ||
          org.tagline.toLowerCase().contains(query) ||
          org.description.toLowerCase().contains(query) ||
          org.category.toLowerCase().contains(query) ||
          org.city.toLowerCase().contains(query) ||
          org.country.toLowerCase().contains(query) ||
          org.tags.any((String tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar automatically uses theme - clean and modern
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true, // Center the title in the AppBar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // `SingleChildScrollView` allows the whole content to scroll together.
          // For desktop apps, we center the content and constrain its width
          child: Center(
            child: ConstrainedBox(
              // Max width prevents content from stretching too wide on large desktop screens
              // 900px is good for explore page with grid layout
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ), // More padding for cleaner look
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center all content horizontally
                  children: <Widget>[
                    /// SEARCH BAR
                    /// ----------
                    /// This is a rounded container that wraps a `TextField`,
                    /// similar to the search bar on Spotify.
                    /// Uses theme's input decoration for consistent, modern styling.
                    /// Now functional - filters organizations as you type.
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: colors.onSurfaceVariant,
                        ),
                        hintText: 'Search organizations',
                        // Add clear button when there's text
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        // Theme automatically applies rounded borders and styling
                        // This gives us the clean, modern look inspired by Spotify
                      ),
                      // Update search query state as user types
                      // This triggers a rebuild and shows filtered results
                      onChanged: (String value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 28,
                    ), // More spacing for cleaner hierarchy
                    /// SEARCH RESULTS SECTION
                    /// ----------------------
                    /// Shows filtered organizations when user is searching.
                    /// Each result is clickable and navigates to the organization profile.
                    if (_searchQuery.isNotEmpty) ...<Widget>[
                      // Show search results header
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Search Results',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Display filtered organizations as a list
                      if (_getFilteredOrganizations().isEmpty)
                        // Show message when no results found
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: colors.onSurfaceVariant,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No organizations found',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        // Show list of matching organizations
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _getFilteredOrganizations().length,
                          itemBuilder: (BuildContext context, int index) {
                            final Organization org =
                                _getFilteredOrganizations()[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                // Organization logo/icon
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    org.logoUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (
                                          BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace,
                                        ) {
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: colors.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.business,
                                              color: colors.onPrimaryContainer,
                                            ),
                                          );
                                        },
                                  ),
                                ),
                                // Organization name
                                title: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        org.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    if (org.isVerified)
                                      Icon(
                                        Icons.verified,
                                        color: colors.primary,
                                        size: 18,
                                      ),
                                  ],
                                ),
                                // Tagline and location
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 4),
                                    Text(
                                      org.tagline,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${org.city}, ${org.country} · ${org.category}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colors.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                                // Navigate to organization profile when tapped
                                onTap: () {
                                  context.push('/organization/${org.id}');
                                },
                                // Trailing arrow to indicate it's clickable
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(height: 24),
                    ],

                    /// TRENDING CARDS SECTION
                    /// ----------------------
                    /// This mimics the "Browse all" category grid on Spotify's search page.
                    /// We show colorful cards for trending organizations and events.
                    /// Only show when not searching (when search query is empty).
                    if (_searchQuery.isEmpty) ...<Widget>[
                      Center(
                        child: Text(
                          'Trending organizations & events',
                          textAlign: TextAlign.center, // Center the text
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing:
                                    -0.3, // Tighter spacing for modern look
                              ),
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
                          // Organization cards - now clickable and navigate to profiles
                          // Map organization names to their IDs for navigation
                          _TrendingCard(
                            title: 'Clean Water Now',
                            subtitle: 'Health · Uganda',
                            color: Colors.blue.shade400,
                            organizationId:
                                'org_clean_water', // Link to actual organization
                          ),
                          _TrendingCard(
                            title: 'Code For Kids',
                            subtitle: 'Education · US',
                            color: Colors.purple.shade400,
                            organizationId: 'org_coding_kids',
                          ),
                          _TrendingCard(
                            title: 'Urban Tree Alliance',
                            subtitle: 'Environment · Brazil',
                            color: Colors.green.shade400,
                            organizationId: 'org_tree_alliance',
                          ),
                          _TrendingCard(
                            title: 'Rapid Relief Fund',
                            subtitle: 'Emergency · Global',
                            color: Colors.red.shade400,
                            organizationId: 'org_emergency_relief',
                          ),
                          // And then cards that represent time‑bound events.
                          // These don't link to organizations (they're events)
                          for (final Map<String, String> event
                              in _trendingEvents)
                            _TrendingCard(
                              title: event['title'] ?? '',
                              subtitle: event['subtitle'] ?? '',
                              color: Colors.orange.shade400,
                              organizationId:
                                  null, // Events don't have organization IDs
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
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
/// Now supports navigation to organization profiles when an organizationId is provided.
class _TrendingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String?
  organizationId; // Optional: if provided, card navigates to org profile

  const _TrendingCard({
    required this.title,
    required this.subtitle,
    required this.color,
    this.organizationId, // Can be null for events that aren't organizations
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // `InkWell` adds a nice ripple effect when the card is tapped.
      // Modern rounded corners for that Spotify/Venmo feel
      borderRadius: BorderRadius.circular(20), // Match container border radius
      onTap: () {
        // If this card represents an organization, navigate to its profile
        // Otherwise, navigate to explore or do nothing (for events)
        if (organizationId != null) {
          context.push('/organization/$organizationId');
        }
        // Events can be tapped but no action needed for now
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
