import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'router.dart';

/// Entry point of the Flutter app.
///
/// `runApp` takes the root widget of your app and attaches it to the screen.
/// This is the first function that runs when the app starts.
void main() {
  runApp(const MyApp());
}

/// Root widget of the application.
///
/// We use `MaterialApp.router` so that `GoRouter` (defined in `router.dart`)
/// can control which page is shown for each route.
///
/// The theme is set globally here using our custom `AppTheme` class,
/// which applies a unified, professional color scheme inspired by
/// Stripe, Venmo, and Spotify throughout the entire app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Hide the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,
      title: 'Donation Platform',
      // Apply our unified theme - this makes all widgets in the app
      // use consistent colors, typography, and styling
      theme: AppTheme.lightTheme,
      // Connect the app to our global router from `router.dart`.
      // This handles navigation between different screens/pages.
      routerConfig: appRouter,
    );
  }
}
