import 'package:flutter/material.dart';

/// Widget that displays the original message with Hero animation
/// Automatically handles scrolling for long messages and applies border radius
class MessageBubble extends StatelessWidget {
  /// Creates a message widget.
  const MessageBubble({
    super.key,
    required this.id,
    required this.messageWidget,
    required this.alignment,
    required this.maxHeight,
    required this.maxWidth,
    this.borderRadius = 12.0,
    this.backgroundColor,
  });

  final String id;
  final Widget messageWidget;
  final Alignment alignment;
  final double maxHeight;
  final double maxWidth;
  final double borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth
        ),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Hero(
          tag: id,
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehavior(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: messageWidget,
            ),
          ),
        ),
      ),
    );
  }
}


class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child; // No glow effect
  }
}