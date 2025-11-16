import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// N8N SERVICE
/// -----------
/// Service for triggering n8n workflows from Flutter user events.
///
/// This service sends HTTP POST requests to n8n webhook endpoints when
/// specific user events occur (button clicks, form submissions, donations, etc.).
///
/// How it works:
/// 1. User performs an action in the Flutter app (e.g., clicks donate button)
/// 2. This service sends an HTTP POST to your n8n webhook URL
/// 3. n8n receives the request and triggers a workflow
/// 4. The workflow can then process the data, send emails, update databases, etc.
class N8nService {
  /// Base URL for your n8n instance
  /// This is the base domain for your n8n cloud instance
  static const String baseUrl = 'https://matt-cornelius.app.n8n.cloud';

  /// Get the API key from environment variables
  /// This reads the N8N_API_KEY from the .env file
  /// The .env file should be in the root directory of your project
  ///
  /// To set up:
  /// 1. Create a .env file in the root directory (copy from .env.example)
  /// 2. Add your n8n API key: N8N_API_KEY=your_actual_api_key_here
  /// 3. Make sure .env is in .gitignore (don't commit it to version control)
  ///
  /// To add authentication in n8n:
  /// 1. In the Webhook node settings, enable "Authentication"
  /// 2. Choose "Header Auth" or "Query Auth"
  /// 3. Set the header name (e.g., "X-API-Key")
  /// 4. Set the value in your .env file to match
  static String get _apiKey {
    // Get the API key from environment variables
    // Returns empty string if not found (allows app to work without auth)
    return dotenv.env['N8N_API_KEY'] ?? '';
  }

  /// TRIGGER WORKFLOW
  /// ----------------
  /// Sends a POST request to an n8n webhook to trigger a workflow.
  ///
  /// This is the main function you'll call when a user event happens.
  /// It packages the event data into JSON and sends it to n8n.
  ///
  /// Parameters:
  /// - [webhookPath]: The webhook path configured in n8n (e.g., 'flutter-event', 'donation')
  ///   This is the path you set in the n8n Webhook node settings
  /// - [eventName]: A descriptive name for the event (e.g., 'user_donated', 'button_clicked')
  /// - [userId]: Optional user identifier (can be null if user is not logged in)
  /// - [extraData]: Optional map of additional data to send with the event
  ///
  /// Returns:
  /// - Future<void> that completes when the request is sent
  ///
  /// Throws:
  /// - Exception if the request fails (network error, invalid response, etc.)
  ///
  /// Example usage:
  /// ```dart
  /// await N8nService.triggerWorkflow(
  ///   webhookPath: 'donation',
  ///   eventName: 'user_donated',
  ///   userId: 'user123',
  ///   extraData: {
  ///     'amount': 25.00,
  ///     'organization': 'Clean Water Now',
  ///   },
  /// );
  /// ```
  static Future<void> triggerWorkflow({
    required String webhookPath,
    required String eventName,
    String? userId,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      // Build the full webhook URL
      // Format: https://your-n8n-instance.com/webhook/webhookPath
      final String webhookUrl = '$baseUrl/webhook/$webhookPath';

      // Prepare the payload (data to send to n8n)
      // This structure makes it easy for n8n workflows to access the data
      final Map<String, dynamic> payload = {
        'event': eventName, // What happened (e.g., 'user_donated')
        'userId': userId, // Who did it (null if anonymous)
        'timestamp': DateTime.now().toUtc().toIso8601String(), // When it happened (ISO format)
        'data': extraData ?? {}, // Additional event-specific data
      };

      // Prepare headers for the HTTP request
      // Content-Type tells n8n we're sending JSON
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add API key to headers if configured (for authentication)
      // This helps secure your webhook so only your app can trigger it
      if (_apiKey.isNotEmpty) {
        headers['X-API-Key'] = _apiKey;
        // Alternative: you could use Authorization header instead
        // headers['Authorization'] = 'Bearer $_apiKey';
      }

      // Send the HTTP POST request to n8n
      // POST is used because we're sending data to trigger an action
      final http.Response response = await http.post(
        Uri.parse(webhookUrl),
        headers: headers,
        body: jsonEncode(payload), // Convert Dart map to JSON string
      );

      // Check if the request was successful
      // Status codes 200-299 indicate success
      // Status codes 400+ indicate an error
      if (response.statusCode < 200 || response.statusCode >= 300) {
        // Request failed - throw an exception with details
        throw Exception(
          'Failed to trigger n8n workflow: ${response.statusCode} ${response.body}',
        );
      }

      // Success! The workflow has been triggered
      // n8n will now process the workflow with the data we sent
    } on http.ClientException catch (e) {
      // Network error - couldn't reach n8n server
      // This happens when there's no internet, wrong URL, or server is down
      throw Exception('Network error connecting to n8n: ${e.message}');
    } on FormatException catch (e) {
      // JSON encoding error (shouldn't happen, but handle it just in case)
      throw Exception('Error encoding data for n8n: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception('Unexpected error triggering n8n workflow: $e');
    }
  }

  /// TRIGGER DONATION WORKFLOW
  /// --------------------------
  /// Convenience method specifically for donation events.
  ///
  /// This is a specialized version of triggerWorkflow that formats
  /// donation data in a way that's easy for n8n workflows to process.
  ///
  /// Parameters:
  /// - [webhookPath]: The webhook path for donations (e.g., 'donation', 'donate')
  /// - [organizationId]: ID of the organization receiving the donation
  /// - [organizationName]: Name of the organization
  /// - [amount]: Donation amount in USD
  /// - [email]: Email address for receipt
  /// - [userId]: Optional user identifier
  ///
  /// Example usage:
  /// ```dart
  /// await N8nService.triggerDonationWorkflow(
  ///   webhookPath: 'donation',
  ///   organizationId: 'org_123',
  ///   organizationName: 'Clean Water Now',
  ///   amount: 25.00,
  ///   email: 'user@example.com',
  ///   userId: 'user123',
  /// );
  /// ```
  static Future<void> triggerDonationWorkflow({
    required String webhookPath,
    required String organizationId,
    required String organizationName,
    required double amount,
    required String email,
    String? userId,
  }) async {
    // Call the main triggerWorkflow function with donation-specific data
    await triggerWorkflow(
      webhookPath: webhookPath,
      eventName: 'user_donated', // Standard event name for donations
      userId: userId,
      extraData: {
        'organization_id': organizationId,
        'organization_name': organizationName,
        'amount_usd': amount,
        'email': email,
        'currency': 'USD', // Always USD for now
      },
    );
  }

  /// TRIGGER BUTTON CLICK WORKFLOW
  /// ------------------------------
  /// Convenience method for tracking button clicks or other UI interactions.
  ///
  /// Useful for analytics, A/B testing, or triggering workflows based on
  /// user interface interactions.
  ///
  /// Parameters:
  /// - [webhookPath]: The webhook path for UI events (e.g., 'ui-events', 'analytics')
  /// - [buttonName]: Name/identifier of the button that was clicked
  /// - [screenName]: Name of the screen/page where the click happened
  /// - [userId]: Optional user identifier
  /// - [extraData]: Optional additional context
  ///
  /// Example usage:
  /// ```dart
  /// await N8nService.triggerButtonClickWorkflow(
  ///   webhookPath: 'ui-events',
  ///   buttonName: 'donate_now',
  ///   screenName: 'organization_profile',
  ///   userId: 'user123',
  /// );
  /// ```
  static Future<void> triggerButtonClickWorkflow({
    required String webhookPath,
    required String buttonName,
    required String screenName,
    String? userId,
    Map<String, dynamic>? extraData,
  }) async {
    await triggerWorkflow(
      webhookPath: webhookPath,
      eventName: 'button_clicked',
      userId: userId,
      extraData: {
        'button_name': buttonName,
        'screen_name': screenName,
        ...?extraData, // Merge any additional data
      },
    );
  }
}

