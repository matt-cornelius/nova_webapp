import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_theme.dart';
import 'router.dart';

/// Entry point of the Flutter app.
///
/// `runApp` takes the root widget of your app and attaches it to the screen.
/// This is the first function that runs when the app starts.
///
/// We load environment variables from the .env file before starting the app.
/// This allows us to securely store API keys and other configuration.
Future<void> main() async {
  // Load environment variables from .env file
  // This must be done before runApp() is called
  // The .env file should be in the root of your project
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // If .env file doesn't exist, the app will still run
    // but API keys won't be available
    debugPrint('Warning: Could not load .env file: $e');
    debugPrint('Make sure you have a .env file in the root directory with N8N_API_KEY');
  }

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
