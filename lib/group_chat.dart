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

  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.isMe,
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
      // Using a slightly different background than the other screens so the
      // chat feels more like iMessage / Messages.
      // Using theme surface variant for consistency with modern feel
      backgroundColor: colors.surfaceVariant.withOpacity(
        0.5,
      ), // Light chat background
      appBar: AppBar(
        elevation: 0, // Flat design for modern look
        // Use theme surface color for consistency
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        titleSpacing: 0,
        title: Row(
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
      body: SafeArea(
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: SafeArea(
                top: false,
                child: Row(
                  children: <Widget>[
                    // Optional: small circular "plus" button (like iMessage)
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      color:
                          colors.onSurfaceVariant, // Use theme secondary color
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

    // Choose bubble color:
    // - primary color for my messages (modern, professional)
    // - surface color for incoming messages (clean, subtle)
    final Color bubbleColor = isMe
        ? colors
              .primary // Use theme primary color for sent messages
        : colors.surface; // Use theme surface for received messages

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
