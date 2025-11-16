import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'demo_data/organizations.dart';
import 'donate_button_function.dart';
import 'n8n_service.dart';
import 'widgets/organization_image.dart';

/// DONATION DIALOG WIDGET
/// -----------------------
/// A clean, Venmo-style pop-up dialog for making donations.
///
/// Features:
/// - Review section showing organization details
/// - Quick amount selector buttons (similar to Venmo)
/// - Custom amount input option
/// - Email text field for receipt
/// - Confirm button that shows a confirmation dialog
///
/// This widget is designed to look modern and clean, similar to Venmo's
/// payment interface with rounded corners, good spacing, and clear hierarchy.
class DonationDialog extends StatefulWidget {
  /// The organization the user is donating to
  final Organization organization;

  const DonationDialog({
    super.key,
    required this.organization,
  });

  @override
  State<DonationDialog> createState() => _DonationDialogState();
}

class _DonationDialogState extends State<DonationDialog> {
  /// Currently selected donation amount
  /// If null, user is entering a custom amount
  double? selectedAmount;

  /// Custom amount entered by user (when selectedAmount is null)
  final TextEditingController customAmountController = TextEditingController();

  /// Email address for receipt
  final TextEditingController emailController = TextEditingController();

  /// Whether user is entering a custom amount
  bool get isCustomAmount => selectedAmount == null;

  /// Get the final donation amount (either selected or custom)
  double? get donationAmount {
    if (selectedAmount != null) {
      return selectedAmount;
    }
    // Try to parse custom amount
    final String customText = customAmountController.text.trim();
    if (customText.isEmpty) {
      return null;
    }
    final double? parsed = double.tryParse(customText);
    return parsed != null && parsed > 0 ? parsed : null;
  }

  /// Quick amount options similar to Venmo's interface
  /// These are common donation amounts users might choose
  static const List<double> quickAmounts = <double>[5, 10, 25, 50, 100];

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    customAmountController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Dialog(
      // Venmo/Spotify style with colorful design
      backgroundColor: colors.surface, // Dialog background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // More rounded for Venmo/Spotify feel
        side: BorderSide(
          color: colors.primary.withOpacity(0.3), // Colored border accent
          width: 1.5,
        ),
      ),
      // Remove default padding so we can control spacing ourselves
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        // Add subtle gradient overlay for more color depth
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
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
        // Constrain width for better desktop/mobile experience
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Only take up needed space
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /// HEADER SECTION
                /// ---------------
                /// Shows organization logo, name, and tagline for review
                Row(
                  children: <Widget>[
                    // Organization logo - circular for clean look
                    // Uses OrganizationImage helper widget which handles
                    // both asset images and network images automatically
                    OrganizationImage(
                      imageUrl: widget.organization.logoUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(16), // Match container border radius
                    ),
                    const SizedBox(width: 16),
                    // Organization name and tagline
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Organization name with verification badge
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  widget.organization.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.organization.isVerified) ...[
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.verified,
                                  color: colors.primary,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Tagline - shows what the organization does
                          Text(
                            widget.organization.tagline,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                /// AMOUNT SELECTOR SECTION
                /// -----------------------
                /// Quick amount buttons (like Venmo) plus custom amount option
                Text(
                  'Select Amount',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                // Quick amount buttons in a grid (2 rows, 3 columns)
                Wrap(
                  spacing: 12, // Horizontal spacing between buttons
                  runSpacing: 12, // Vertical spacing between rows
                  children: <Widget>[
                    // Quick amount buttons
                    ...quickAmounts.map((double amount) {
                      final bool isSelected = selectedAmount == amount;
                      return _AmountButton(
                        amount: amount,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            selectedAmount = amount;
                            // Clear custom amount when selecting quick amount
                            customAmountController.clear();
                          });
                        },
                      );
                    }),
                    // Custom amount button
                    _CustomAmountButton(
                      isSelected: isCustomAmount,
                      onTap: () {
                        setState(() {
                          selectedAmount = null; // Switch to custom mode
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Custom amount input field (shown when custom is selected)
                if (isCustomAmount)
                  TextField(
                    controller: customAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // Only allow numbers and decimal point
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Custom Amount',
                      hintText: '0.00',
                      prefixText: '\$',
                      // Show error if invalid amount entered
                      errorText: donationAmount == null &&
                              customAmountController.text.isNotEmpty
                          ? 'Enter a valid amount'
                          : null,
                    ),
                    onChanged: (String value) {
                      // Trigger rebuild to update validation
                      setState(() {});
                    },
                  ),
                const SizedBox(height: 32),

                /// EMAIL INPUT SECTION
                /// -------------------
                /// Email field for receipt delivery
                Text(
                  'Email for Receipt',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    hintText: 'you@example.com',
                    // Show error if invalid email format
                    errorText: emailController.text.isNotEmpty &&
                            !_isValidEmail(emailController.text)
                        ? 'Enter a valid email'
                        : null,
                  ),
                  onChanged: (String value) {
                    // Trigger rebuild to update validation
                    setState(() {});
                  },
                ),
                const SizedBox(height: 32),

                /// CONFIRM BUTTON
                /// --------------
                /// Primary action button to confirm donation
                SizedBox(
                  height: 56, // Tall button for better touch target
                  child: ElevatedButton(
                    onPressed: _canConfirm() ? _handleConfirm : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16), // Match container border radius
                      ),
                      // Disabled state styling
                      disabledBackgroundColor: colors.surfaceVariant,
                      disabledForegroundColor: colors.onSurfaceVariant,
                    ),
                    child: Text(
                      'Confirm Donation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onPrimary,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Check if all required fields are valid for confirmation
  bool _canConfirm() {
    // Must have a valid donation amount
    if (donationAmount == null || donationAmount! <= 0) {
      return false;
    }
    // Must have a valid email address
    if (emailController.text.trim().isEmpty ||
        !_isValidEmail(emailController.text.trim())) {
      return false;
    }
    return true;
  }

  /// Validate email format using a simple regex
  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }

  /// Handle the confirm button tap
  /// Directly processes the donation by calling the submitDonation function
  void _handleConfirm() async {
    final double amount = donationAmount!;
    final String email = emailController.text.trim();

    // Show loading indicator while processing
    // This gives user feedback that something is happening
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent closing while processing
      builder: (BuildContext loadingContext) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Create donation request with the user's input
      final DonationRequest donationRequest = DonationRequest(
        organization: widget.organization,
        amount: amount,
        email: email,
      );

      // Build the n8n webhook URL
      // This is the full webhook URL for the donation endpoint
      // Format: https://matt-cornelius.app.n8n.cloud/webhook-test/01f63d59-ebc8-4886-9770-6924e17002be
      final String n8nUrl = '${N8nService.baseUrl}/webhook-test/01f63d59-ebc8-4886-9770-6924e17002be';

      // Call the submitDonation function from donate_button_function.dart
      // This makes an HTTP POST request to the n8n webhook with the donation data
      final DonationResponse response = await submitDonation(
        url: n8nUrl,
        donationRequest: donationRequest,
      );

      // Close loading dialog
      Navigator.of(context).pop(); // Close loading
      Navigator.of(context).pop(); // Close donation dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Donation received',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } on DonationApiException catch (e) {
      // Close loading dialog
      Navigator.of(context).pop(); // Close loading

      // Show error message
      // Note: We don't close the donation dialog on error so user can try again
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error processing donation: ${e.message}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 5), // Show longer for errors
        ),
      );
    } catch (e, stackTrace) {
      // Close loading dialog
      Navigator.of(context).pop(); // Close loading

      // Show generic error message for unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error processing donation: ${e.toString()}',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 5), // Show longer for errors
        ),
      );
    }
  }
}

/// QUICK AMOUNT BUTTON
/// -------------------
/// A button for selecting a preset donation amount (like Venmo)
class _AmountButton extends StatelessWidget {
  final double amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountButton({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Match container border radius
      child: Container(
        width: 100, // Fixed width for consistent grid
        height: 56, // Tall enough for easy tapping
        decoration: BoxDecoration(
          // Colorful gradient for selected, subtle gradient for unselected (Venmo/Spotify style)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? <Color>[
                    colors.primary,
                    colors.primary.withOpacity(0.9),
                    colors.secondaryContainer.withOpacity(0.3),
                  ]
                : <Color>[
                    colors.surfaceVariant.withOpacity(0.6),
                    colors.surfaceVariant.withOpacity(0.4),
                    colors.primaryContainer.withOpacity(0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(16), // More rounded for Venmo/Spotify feel
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.primary.withOpacity(0.4), // Colored border even when not selected
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            '\$${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}

/// CUSTOM AMOUNT BUTTON
/// --------------------
/// Button to switch to custom amount input mode
class _CustomAmountButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CustomAmountButton({
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Match container border radius
      child: Container(
        width: 100,
        height: 56,
        decoration: BoxDecoration(
          // Colorful gradient for selected, subtle gradient for unselected (Venmo/Spotify style)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? <Color>[
                    colors.primary,
                    colors.primary.withOpacity(0.9),
                    colors.secondaryContainer.withOpacity(0.3),
                  ]
                : <Color>[
                    colors.surfaceVariant.withOpacity(0.6),
                    colors.surfaceVariant.withOpacity(0.4),
                    colors.primaryContainer.withOpacity(0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(16), // More rounded for Venmo/Spotify feel
          border: Border.all(
            color: isSelected
                ? colors.primary
                : colors.primary.withOpacity(0.4), // Colored border even when not selected
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            'Custom',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onSurfaceVariant,
                ),
          ),
        ),
      ),
    );
  }
}


