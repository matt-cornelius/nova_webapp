import 'package:flutter/material.dart';

import 'main_nav_bar.dart';

/// PROFILE PAGE
/// ------------
/// This page shows a *basic but professional* profile layout with
/// placeholder content and buttons that you can later hook up to
/// real logic (API calls, navigation, etc.).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar automatically uses theme - clean and modern
      appBar: AppBar(
        title: const Text('Profile'),
        // Centering the title gives a slightly more "polished" feel.
        centerTitle: true,
      ),
      // Using theme background color for consistency
      backgroundColor: colors.background,
      body: SafeArea(
        // SingleChildScrollView allows the whole page to scroll on small screens.
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
              20.0,
            ), // More padding for cleaner look
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeaderSection(context),
                const SizedBox(
                  height: 28,
                ), // More spacing for cleaner hierarchy
                _buildStatsRow(context),
                const SizedBox(height: 28),
                _buildPrimaryActions(context),
                const SizedBox(height: 28),
                _buildSectionCard(
                  context,
                  title: 'Account',
                  subtitle:
                      'Manage personal information, security and connected accounts.',
                  children: [
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Personal information',
                      subtitle: 'Name, email, phone',
                      onTap: () {
                        // TODO: Hook this up to a real screen or dialog.
                      },
                    ),
                    _ProfileTile(
                      icon: Icons.lock_outline,
                      title: 'Security',
                      subtitle: 'Password, 2‑factor authentication',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.link,
                      title: 'Connected accounts',
                      subtitle: 'Google, Apple, social logins',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20), // More spacing between sections
                _buildSectionCard(
                  context,
                  title: 'Preferences',
                  subtitle:
                      'Control how the app behaves and how we talk to you.',
                  children: [
                    _ProfileTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Email, push & SMS alerts',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: 'Theme, density',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.language_outlined,
                      title: 'Language & region',
                      subtitle: 'Localization settings',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  context,
                  title: 'Support',
                  subtitle: 'We are here to help whenever you need us.',
                  children: [
                    _ProfileTile(
                      icon: Icons.help_outline,
                      title: 'Help center',
                      subtitle: 'FAQ and how‑to guides',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.mail_outline,
                      title: 'Contact support',
                      subtitle: 'Email our friendly team',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.description_outlined,
                      title: 'Terms & privacy',
                      subtitle: 'Legal information',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'Demo profile • Connect real data here later',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 24), // More bottom padding
              ],
            ),
          ),
        ),
      ),
      // Index mapping after adding the Groups tab:
      // 0 = Home, 1 = Groups, 2 = Explore, 3 = Profile.
      bottomNavigationBar: const MainNavBar(currentIndex: 3),
    );
  }

  /// Builds the top header with avatar, name and email.
  ///
  /// Extracting it into a separate method keeps `build()` easier to read.
  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Avatar with a subtle background to make it stand out.
        CircleAvatar(
          radius: 36,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            size: 36,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // User name - bold, primary text
              Text(
                'Demo User',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3, // Tighter spacing for modern feel
                ),
              ),
              const SizedBox(height: 6), // More spacing
              // Email - secondary text color
              Text(
                'demo.user@email.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        // Small "Edit" icon button for quick access to profile editing.
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: 'Edit profile',
          onPressed: () {
            // TODO: Implement navigation to edit profile screen.
          },
        ),
      ],
    );
  }

  /// Shows some high‑level stats for the user (e.g. donations, favorites).
  ///
  /// All numbers are placeholders for now – you can wire them up to real data.
  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ProfileStatCard(
            label: 'Donations',
            value: '24',
            icon: Icons.volunteer_activism_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProfileStatCard(
            label: 'Organizations',
            value: '6',
            icon: Icons.apartment_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ProfileStatCard(
            label: 'Impact score',
            value: '82',
            icon: Icons.auto_graph_outlined,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  /// Primary action buttons for common tasks on a profile screen.
  Widget _buildPrimaryActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // ElevatedButton is good for the "main" action.
        // Theme automatically applies modern, rounded button styling
        SizedBox(
          height: 52, // Slightly taller for better touch target
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Hook this up to your edit profile flow.
            },
            icon: const Icon(Icons.edit, size: 20),
            label: const Text('Edit profile'),
          ),
        ),
        const SizedBox(height: 12),
        // OutlinedButton feels secondary, so it is nice for less-frequent actions.
        // Theme automatically applies consistent styling
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Hook this up to password/security settings.
            },
            icon: const Icon(Icons.lock_reset_outlined, size: 20),
            label: const Text('Change password'),
          ),
        ),
        const SizedBox(height: 12),
        // Error-styled button for destructive actions
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.5, // Slightly thicker border for emphasis
              ),
            ),
            onPressed: () {
              // TODO: Hook this up to your sign‑out flow.
            },
            icon: const Icon(Icons.logout, size: 20),
            label: const Text('Log out'),
          ),
        ),
      ],
    );
  }

  /// A reusable method to build a "card" section with a title, subtitle,
  /// and a list of tiles below it.
  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      // Card automatically uses theme - modern rounded corners with border
      // Theme sets elevation to 0 and uses border instead for flat design
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ), // More padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Section title - bold, primary text
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2, // Tighter spacing for modern feel
              ),
            ),
            const SizedBox(height: 6), // More spacing
            // Section subtitle - secondary text color
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color:
                    colors.onSurfaceVariant, // Use theme secondary text color
              ),
            ),
            const SizedBox(height: 16), // More spacing before children
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Small card widget to show a single stat in the profile header area.
/// Uses theme colors for a professional, modern look.
class _ProfileStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      // Modern, rounded container with subtle background color
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Subtle background tint
        borderRadius: BorderRadius.circular(16), // More rounded for modern look
        // Subtle border for definition
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ), // More padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(10), // More padding around icon
            child: Icon(icon, size: 22, color: color), // Slightly larger icon
          ),
          const SizedBox(width: 12), // More spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Stat value - bold, large
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4), // More spacing
                // Stat label - secondary text color
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant, // Use theme secondary text
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple reusable tile used in the different profile sections.
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 8,
          ), // More vertical padding
          // Leading icon uses primary color for emphasis
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.primaryContainer, // Subtle background
              borderRadius: BorderRadius.circular(10), // Rounded background
            ),
            child: Icon(
              icon,
              color: colors.onPrimaryContainer, // Contrast color for icon
              size: 20,
            ),
          ),
          // Title uses primary text color
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500, // Medium weight for hierarchy
            ),
          ),
          // Subtitle uses secondary text color
          subtitle: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant, // Secondary text color
            ),
          ),
          // Trailing chevron in secondary color
          trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
          onTap: onTap,
        ),
        // Divider visually separates this tile from the next one.
        // Theme automatically applies subtle divider styling
        Divider(
          height: 0,
          thickness: 1,
          indent: 56, // Indent to align with text (not icon)
        ),
      ],
    );
  }
}
