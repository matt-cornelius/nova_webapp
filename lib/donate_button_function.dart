import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import 'demo_data/organizations.dart';

/// DONATION REQUEST DATA MODEL
/// ----------------------------
/// Contains all the information needed to make a donation request
class DonationRequest {
  /// The organization receiving the donation
  final Organization organization;

  /// The amount being donated in USD
  final double amount;

  /// Email address for receipt delivery
  final String email;

  const DonationRequest({
    required this.organization,
    required this.amount,
    required this.email,
  });

  /// Convert the donation request to a JSON map for the API
  /// This formats the data in a way the backend can understand
  Map<String, dynamic> toJson() {
    return {
      'organization_id': organization.id,
      'organization_name': organization.name,
      'amount_usd': amount,
      'email': email,
      // Include additional organization details if needed by the API
      'organization_category': organization.category,
    };
  }
}

/// DONATION RESPONSE MODEL
/// ------------------------
/// Represents the response from the donation API
class DonationResponse {
  /// Whether the donation was successful
  final bool success;

  /// Optional message from the server
  final String? message;

  /// Optional transaction ID or donation ID
  final String? donationId;

  /// Error message if the request failed
  final String? error;

  const DonationResponse({
    required this.success,
    this.message,
    this.donationId,
    this.error,
  });

  /// Create a DonationResponse from JSON
  /// This parses the server's response into our model
  factory DonationResponse.fromJson(Map<String, dynamic> json) {
    return DonationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      donationId: json['donation_id'] as String? ?? json['donationId'] as String?,
      error: json['error'] as String?,
    );
  }
}

/// DONATION API EXCEPTION
/// -----------------------
/// Custom exception for donation API errors
class DonationApiException implements Exception {
  final String message;
  final int? statusCode;

  const DonationApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'DonationApiException: $message (Status: $statusCode)';
}

/// SUBMIT DONATION FUNCTION
/// -------------------------
/// Makes an HTTP POST request to submit a donation to the server.
///
/// This function:
/// - Takes donation data (organization, amount, email)
/// - Converts it to JSON format
/// - Sends a POST request to the specified URL
/// - Handles errors and returns a response
///
/// Parameters:
/// - [url]: The API endpoint URL to send the donation request to
/// - [donationRequest]: The donation data (organization, amount, email)
/// - [headers]: Optional custom headers (defaults to JSON content-type)
///
/// Returns:
/// - [DonationResponse]: Contains success status, message, and any error info
///
/// Throws:
/// - [DonationApiException]: If the request fails or returns an error status
///
/// Example usage:
/// ```dart
/// final request = DonationRequest(
///   organization: myOrganization,
///   amount: 25.00,
///   email: 'user@example.com',
/// );
///
/// try {
///   final response = await submitDonation(
///     url: 'https://api.example.com/donations',
///     donationRequest: request,
///   );
///   if (response.success) {
///     print('Donation successful! ID: ${response.donationId}');
///   }
/// } catch (e) {
///   print('Error: $e');
/// }
/// ```
Future<DonationResponse> submitDonation({
  required String url,
  required DonationRequest donationRequest,
  Map<String, String>? headers,
}) async {
  try {
    // Prepare the request body by converting donation data to JSON
    // JSON encoding converts Dart objects to a string format the API can read
    final String requestBody = jsonEncode(donationRequest.toJson());

    // Set up default headers for JSON content
    // Content-Type tells the server we're sending JSON data
    // Accept tells the server we want JSON back
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Merge any custom headers provided (allows adding auth tokens, etc.)
      ...?headers,
    };

    // Debug logging: Log request details
    developer.log(
      '=== HTTP POST REQUEST ===',
      name: 'submitDonation',
    );
    developer.log(
      'URL: $url',
      name: 'submitDonation',
    );
    developer.log(
      'Headers: $requestHeaders',
      name: 'submitDonation',
    );
    developer.log(
      'Request Body: $requestBody',
      name: 'submitDonation',
    );
    developer.log(
      'Sending POST request...',
      name: 'submitDonation',
    );

    // Make the HTTP POST request
    // POST is used because we're sending data to create a new donation
    // Uri.parse converts the string URL into a Uri object
    final DateTime requestStartTime = DateTime.now();
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: requestHeaders,
      body: requestBody,
    );
    final Duration requestDuration = DateTime.now().difference(requestStartTime);

    // Debug logging: Log response details
    developer.log(
      '=== HTTP POST RESPONSE ===',
      name: 'submitDonation',
    );
    developer.log(
      'Status Code: ${response.statusCode}',
      name: 'submitDonation',
    );
    developer.log(
      'Response Headers: ${response.headers}',
      name: 'submitDonation',
    );
    developer.log(
      'Response Body: ${response.body}',
      name: 'submitDonation',
    );
    developer.log(
      'Request Duration: ${requestDuration.inMilliseconds}ms',
      name: 'submitDonation',
    );

    // Check if the request was successful (status codes 200-299)
    // HTTP status codes indicate the result of the request:
    // - 200-299: Success
    // - 400-499: Client error (bad request, unauthorized, etc.)
    // - 500-599: Server error
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Success! Parse the response JSON
      // jsonDecode converts the JSON string back into Dart objects
      developer.log(
        'Request successful! Parsing response...',
        name: 'submitDonation',
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Create and return a DonationResponse from the parsed data
      final DonationResponse donationResponse = DonationResponse.fromJson(responseData);
      developer.log(
        'Parsed Response: success=${donationResponse.success}, message=${donationResponse.message}, donationId=${donationResponse.donationId}',
        name: 'submitDonation',
      );
      return donationResponse;
    } else {
      // Request failed - server returned an error status code
      // Try to parse error message from response, or use default message
      developer.log(
        'Request failed with status ${response.statusCode}',
        name: 'submitDonation',
      );
      String errorMessage = 'Donation request failed';
      try {
        final Map<String, dynamic> errorData = jsonDecode(response.body) as Map<String, dynamic>;
        errorMessage = errorData['error'] as String? ??
            errorData['message'] as String? ??
            'Server returned status ${response.statusCode}';
        developer.log(
          'Parsed error message: $errorMessage',
          name: 'submitDonation',
        );
      } catch (e) {
        // If response body isn't valid JSON, use the status code message
        errorMessage = 'Server returned status ${response.statusCode}';
        developer.log(
          'Could not parse error response as JSON: $e',
          name: 'submitDonation',
        );
      }

      // Throw an exception with the error details
      throw DonationApiException(errorMessage, response.statusCode);
    }
  } on http.ClientException catch (e) {
    // Network error - couldn't reach the server
    // This happens when there's no internet, wrong URL, or server is down
    developer.log(
      '=== NETWORK ERROR ===',
      name: 'submitDonation',
      error: e,
    );
    developer.log(
      'Network error details: ${e.message}',
      name: 'submitDonation',
    );
    throw DonationApiException(
      'Network error: ${e.message}',
    );
  } on FormatException catch (e) {
    // JSON parsing error - response wasn't valid JSON
    developer.log(
      '=== JSON PARSING ERROR ===',
      name: 'submitDonation',
      error: e,
    );
    developer.log(
      'JSON parsing error: ${e.message}',
      name: 'submitDonation',
    );
    throw DonationApiException(
      'Invalid response format: ${e.message}',
    );
  } catch (e, stackTrace) {
    // Catch any other unexpected errors
    developer.log(
      '=== UNEXPECTED ERROR ===',
      name: 'submitDonation',
      error: e,
      stackTrace: stackTrace,
    );
    developer.log(
      'Unexpected error type: ${e.runtimeType}',
      name: 'submitDonation',
    );
    developer.log(
      'Unexpected error details: $e',
      name: 'submitDonation',
    );
    throw DonationApiException(
      'Unexpected error: ${e.toString()}',
    );
  }
}

