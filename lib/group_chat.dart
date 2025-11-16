import 'package:flutter/material.dart';

/// GROUP CHAT PAGE (iMessage-style)
/// --------------------------------
/// This screen shows a simple **group chat** UI inspired by iMessage:
/// - messages are shown as bubbles in a scrollable list
/// - "my" messages are blue and right-aligned
/// - "other" messages are light gray and left-aligned
/// - a text field and send button sit at the bottom
///
/// In a real app you would fetch messages from an API and send them to a
/// backend. For this demo we keep a small list of messages in memory and
/// simply append to it when you hit "Send".
class GroupChatPage extends StatefulWidget {
  /// `groupName` tells the page which group we are chatting in.
  ///
  /// We pass this from the Groups list via `GoRouter`.
  final String groupName;

  const GroupChatPage({super.key, required this.groupName});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

/// Small data class representing a single chat message.
class _ChatMessage {
  /// The display name of the sender (e.g. "You", "Alex").
  final String sender;

  /// The text content of the message.
  final String text;

  /// Whether this message was sent by *the current user*.
  ///
  /// We use this to decide the bubble color and alignment (right vs left).
  final bool isMe;

  /// Whether this message represents a donation.
  /// If true, the message will be displayed as a green donation card.
  final bool isDonation;

  /// The donation amount (only used if isDonation is true).
  final double? donationAmount;

  /// The organization name that received the donation (only used if isDonation is true).
  final String? organizationName;

  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.isMe,
    this.isDonation = false,
    this.donationAmount,
    this.organizationName,
  });
}

class _GroupChatPageState extends State<GroupChatPage> {
  /// Text controller for the input field at the bottom.
  final TextEditingController _textController = TextEditingController();

  /// Focus node so we can programmatically focus the text field after sending.
  final FocusNode _inputFocusNode = FocusNode();

  /// Simple in-memory list of chat messages for the demo.
  final List<_ChatMessage> _messages = <_ChatMessage>[
    const _ChatMessage(
      sender: 'Alex',
      text: 'Hey team, how much should we donate this month?',
      isMe: false,
    ),
    const _ChatMessage(sender: 'Jordan', text: 'Maybe \$20 each?', isMe: false),
    const _ChatMessage(sender: 'You', text: 'I\'m in for \$25 🙌', isMe: true),
    const _ChatMessage(
      sender: 'Taylor',
      text: 'Love it. Let\'s send to Clean Water Now again.',
      isMe: false,
    ),
    // Example donation messages - these will be displayed as green cards
    const _ChatMessage(
      sender: 'Alex',
      text: 'Donated \$20',
      isMe: false,
      isDonation: true,
      donationAmount: 20.0,
      organizationName: 'Clean Water Now',
    ),
    const _ChatMessage(
      sender: 'You',
      text: 'Donated \$25',
      isMe: true,
      isDonation: true,
      donationAmount: 25.0,
      organizationName: 'Clean Water Now',
    ),
  ];

  /// Scroll controller so we can jump to the bottom when a new message is sent.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // Always dispose controllers / focus nodes in a StatefulWidget to avoid
    // memory leaks when the widget is removed from the tree.
    _textController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Helper method to add a new "outgoing" message when the user taps send.
  void _handleSend() {
    final String trimmed = _textController.text.trim();

    // Do nothing if the user just typed spaces or left it empty.
    if (trimmed.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(_ChatMessage(sender: 'You', text: trimmed, isMe: true));
    });

    // Clear the text field after sending.
    _textController.clear();

    // Re-focus the input so the keyboard stays open (mobile UX).
    _inputFocusNode.requestFocus();

    // Jump to the bottom of the list so the new message is visible.
    // We add a small delay to ensure the list has finished animating/layout.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      // Venmo/Spotify style with colorful background
      backgroundColor: colors.surfaceVariant, // More colorful background, less white
      appBar: AppBar(
        elevation: 0, // Flat design for modern look
        // Use theme surface color for consistency
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        titleSpacing: 0,
        centerTitle: true, // Center the title in the AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the row content
          children: <Widget>[
            // Small circular avatar with the first letter of the group name.
            // Uses primary color for modern, professional look
            CircleAvatar(
              radius: 20, // Slightly larger for better visibility
              backgroundColor: colors.primaryContainer,
              child: Text(
                widget.groupName.isNotEmpty
                    ? widget.groupName.substring(0, 1)
                    : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer, // Contrast color
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Group name - bold, primary text
                Text(
                  widget.groupName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface, // Use theme text color
                  ),
                ),
                const SizedBox(height: 4),
                // Small "subtitle" similar to iMessage showing something like
                // "3 people • Giving circle". Here we just hard-code a label.
                Text(
                  'Group chat • Giving circle',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant, // Use theme secondary text
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        // Add gradient background for more color (Venmo/Spotify style)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              colors.primaryContainer.withOpacity(0.3),
              colors.secondaryContainer.withOpacity(0.2),
              colors.tertiaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: SafeArea(
          // For desktop apps, we center the chat content and constrain its width
          child: Center(
            child: ConstrainedBox(
              // Max width prevents chat from stretching too wide on large desktop screens
              // 800px is a good max width for chat readability
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
              children: <Widget>[
                // Expanded message list takes up all available vertical space above
                // the input bar at the bottom.
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _ChatMessage message = _messages[index];
                      // If this is a donation message, show the donation card instead of a regular bubble
                      if (message.isDonation) {
                        return _DonationCard(message: message);
                      }
                      // Otherwise, show the regular message bubble
                      return _MessageBubble(message: message);
                    },
                  ),
                ),

                // Thin divider above the input bar for a subtle separation.
                // Theme automatically applies subtle divider styling
                Divider(height: 1, thickness: 1),

                // Input bar that sits at the bottom (similar to iMessage).
                // Uses theme surface color for consistency
                Container(
                  color: colors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: <Widget>[
                        // Optional: small circular "plus" button (like iMessage)
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          color: colors
                              .onSurfaceVariant, // Use theme secondary color
                          onPressed: () {
                            // In a full app, you might open media / payments here.
                          },
                        ),
                        // Expanded text field so it takes as much space as possible.
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors
                                  .surfaceVariant, // Use theme surface variant
                              borderRadius: BorderRadius.circular(
                                24,
                              ), // More rounded for modern feel
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: TextField(
                              controller: _textController,
                              focusNode: _inputFocusNode,
                              minLines: 1,
                              maxLines: 4,
                              style: TextStyle(
                                color: colors.onSurface, // Use theme text color
                              ),
                              decoration: InputDecoration(
                                hintText: 'Message',
                                hintStyle: TextStyle(
                                  color: colors.onSurfaceVariant.withOpacity(
                                    0.6,
                                  ), // Subtle hint
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.zero, // Remove default padding
                              ),
                              // Optionally send on "enter" if you want desktop chat
                              // behavior. For now we only send when tapping the icon.
                              onSubmitted: (_) => _handleSend(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Send button using a filled icon for a Venmo/iMessage feel.
                        // Uses primary color for modern, professional look
                        IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: colors.primary, // Use theme primary color
                          onPressed: _handleSend,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

/// Renders a donation message as a compact green card integrated into the chat flow.
/// The card is styled like a message bubble but with green color to indicate a donation.
class _DonationCard extends StatelessWidget {
  final _ChatMessage message;

  const _DonationCard({required this.message});

  @override
  Widget build(BuildContext context) {
    // Determine if this is from the current user (affects alignment)
    final bool isMe = message.isMe;

    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Use green color for donation cards - vibrant but not too bright
    // Colors.green[500] or [600] provides a nice balance
    final Color donationColor = Colors.green[600] ?? Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4), // Same padding as regular messages
      child: Row(
        // Align like regular messages: right for "me", left for others
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          // Show avatar for other participants (same as regular messages)
          if (!isMe) ...<Widget>[
            CircleAvatar(
              radius: 16,
              backgroundColor: colors.surfaceVariant,
              child: Text(
                message.sender.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          // Compact donation card styled like a message bubble
          Flexible(
            // Flexible allows the card to wrap nicely and not overflow
            child: Container(
              // Compact padding - smaller than before for seamless integration
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: donationColor, // Green background for donations
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  // Asymmetric bottom corners like message bubbles (tail effect)
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Show sender name for others (like regular messages)
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        message.sender,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  // Compact donation info in a single row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    // Align icon and text based on sender
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      // Small heart icon to indicate donation
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 14, // Smaller icon for compact design
                      ),
                      const SizedBox(width: 6),
                      // Donation amount in compact format
                      Text(
                        '\$${message.donationAmount?.toStringAsFixed(0) ?? '0'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15, // Same size as regular message text
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  // Organization name on a separate line (if provided)
                  if (message.organizationName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      message.organizationName!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Small spacing for "me" messages (matches regular message layout)
          if (isMe) const SizedBox(width: 6),
        ],
      ),
    );
  }
}

/// Renders a single chat message as an iMessage-style bubble.
class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    // If this is "my" message, align it to the right. Otherwise align left.
    final bool isMe = message.isMe;

    // Get theme colors for consistent styling
    final ColorScheme colors = Theme.of(context).colorScheme;

    // Choose bubble color with gradients for more color (Venmo/Spotify style):
    // - primary color gradient for my messages (vibrant, modern)
    // - colorful surface variant for incoming messages (less white)
    final Color bubbleColor = isMe
        ? colors
              .primary // Use theme primary color for sent messages
        : colors.surfaceVariant.withOpacity(0.6); // More colorful for received messages

    // Choose text color to keep contrast good.
    // Theme provides proper contrast colors automatically
    final Color textColor = isMe
        ? colors
              .onPrimary // White/light text on primary background
        : colors.onSurface; // Dark text on light surface

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          if (!isMe) ...<Widget>[
            // Small avatar for other participants to give some personality.
            // Uses theme colors for consistency
            CircleAvatar(
              radius: 16, // Slightly larger for better visibility
              backgroundColor: colors.surfaceVariant,
              child: Text(
                message.sender.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: colors.onSurfaceVariant, // Contrast color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8), // More spacing
          ],
          Flexible(
            // `Flexible` allows the bubble to wrap nicely instead of overflowing.
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  // Use asymmetric bottom corners to mimic the "tail" feeling.
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        message.sender,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isMe
                              ? textColor.withOpacity(
                                  0.8,
                                ) // Slightly transparent for hierarchy
                              : colors
                                    .onSurfaceVariant, // Use theme secondary text
                        ),
                      ),
                    ),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15, // Slightly larger for better readability
                      height: 1.4, // Line height for readability
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 6),
        ],
      ),
    );
  }
}
