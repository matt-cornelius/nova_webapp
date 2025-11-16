import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Simple bottom navigation bar that appears on every main page.
///
/// This widget:
/// - shows 4 tabs (Home, Groups, Explore, Profile)
/// - uses `GoRouter` to navigate when a tab is tapped
/// - highlights the currently selected tab
class MainNavBar extends StatelessWidget {
  /// The index of the currently selected tab.
  ///
  /// We pass this from each page so the correct tab is highlighted.
  final int currentIndex;

  const MainNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    // We pull colors from the app's ColorScheme so the nav bar matches
    // the overall theme defined in `app_theme.dart`.
    // The theme is already applied globally, but we access it here for
    // consistency and to ensure we're using the right colors.
    final ColorScheme colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      // Make the bar use a solid surface color so icons/text stay visible
      // against the page background.
      // Theme automatically applies this, but we keep it explicit for clarity.
      backgroundColor: colors.surface,
      // Primary color = accent color for the active tab.
      // This makes it clear which page the user is currently viewing.
      selectedItemColor: colors.primary,
      // Use a softer / lower‑contrast color for inactive tabs so they are
      // still readable but do not compete with the active one.
      // This creates clear visual hierarchy.
      unselectedItemColor: colors.onSurfaceVariant,
      // Show labels for all items, not just the selected one (helps beginners).
      // This improves accessibility and makes the app easier to navigate.
      showUnselectedLabels: true,
      // `fixed` keeps all items equally spaced and always visible.
      // This is the modern, professional look inspired by Venmo/Stripe/Spotify.
      type: BottomNavigationBarType.fixed,
      // Theme automatically applies elevation and styling, but we can
      // ensure it's optimal for our design.
      elevation: 8, // Subtle elevation for depth
      // Tells Flutter which tab should look "active" / selected.
      currentIndex: currentIndex,
      // Called whenever the user taps one of the items.
      onTap: (int index) {
        // We use `context.go` (from go_router) to change the current route.
        // This ensures smooth navigation between main pages.
        switch (index) {
          case 0:
            context.go('/'); // Navigate to Home
            break;
          case 1:
            context.go('/groups'); // Navigate to Groups
            break;
          case 2:
            context.go('/explore'); // Navigate to Explore
            break;
          case 3:
            context.go('/profile'); // Navigate to Profile
            break;
        }
      },
      // Navigation items - clean, simple icons for each main section
      // Theme automatically applies consistent icon sizing and spacing.
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Groups'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
