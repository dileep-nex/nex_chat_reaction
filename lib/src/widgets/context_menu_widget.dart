import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nex_chat_reaction/src/controllers/reactions_controller.dart';
import 'package:nex_chat_reaction/src/models/chat_reactions_config.dart';
import 'package:nex_chat_reaction/src/models/menu_item.dart';
import 'package:nex_chat_reaction/src/widgets/message_bubble.dart';
import 'package:nex_chat_reaction/src/widgets/rections_row.dart';

/// A dialog widget that displays reactions and context menu options for a message.
///
/// This widget creates a modal dialog with three main sections:
/// - A row of reaction emojis that can be tapped
/// - The original message (displayed using a Hero animation)
/// - A context menu with customizable options
class ReactionsDialogWidget extends StatelessWidget {
  /// Unique identifier for the hero animation.
  final String messageId;

  /// The widget displaying the message content.
  final Widget messageWidget;

  /// Controller to manage reaction state.
  final ReactionsController controller;

  /// Configuration for the reactions dialog.
  final ChatReactionsConfig config;

  /// Callback triggered when a reaction is selected.
  final Function(String) onReactionTap;

  /// Callback triggered when a context menu item is selected.
  final Function(MenuItem) onMenuItemTap;

  /// Alignment of the dialog components.
  final Alignment alignment;

  /// Creates a reactions dialog widget.
  const ReactionsDialogWidget({
    super.key,
    required this.messageId,
    required this.messageWidget,
    required this.controller,
    required this.config,
    required this.onReactionTap,
    required this.onMenuItemTap,
    this.alignment = Alignment.centerRight,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
          sigmaX: config.dialogBlurSigma, sigmaY: config.dialogBlurSigma),
      child: Center(
        child: Padding(
          padding: config.dialogPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactionsRow(
                reactions: config.availableReactions,
                alignment: alignment,
                onReactionTap: (reaction, _) =>
                    _handleReactionTap(context, reaction),
              ),
              const SizedBox(height: 10),
              MessageBubble(
                id: messageId,
                messageWidget: messageWidget,
                alignment: alignment,
              ),
              if (config.showContextMenu) ...[
                const SizedBox(height: 10),
                ContextMenuWidget(
                  menuItems: config.menuItems,
                  alignment: alignment,
                  onMenuItemTap: (item, _) => _handleMenuItemTap(context, item),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleReactionTap(BuildContext context, String reaction) {
    Navigator.of(context).pop();
    onReactionTap(reaction);
  }

  void _handleMenuItemTap(BuildContext context, MenuItem item) {
    Navigator.of(context).pop();
    onMenuItemTap(item);
  }
}

class ContextMenuWidget extends StatelessWidget {
  final List<MenuItem> menuItems;
  final Alignment alignment;
  final double menuWidth;
  final Function(MenuItem, int) onMenuItemTap;

  const ContextMenuWidget({
    super.key,
    required this.menuItems,
    required this.onMenuItemTap,
    this.alignment = Alignment.centerRight,
    this.menuWidth = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: MediaQuery.of(context).size.width * menuWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF000000)
              : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: menuItems.map((item) {
            final isLast = menuItems.indexOf(item) == menuItems.length - 1;
            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onMenuItemTap(item, menuItems.indexOf(item)),
                    borderRadius: BorderRadius.circular(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              color: item.isDestructive
                                  ? Colors.red
                                  : Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            item.icon,
                            color: item.isDestructive
                                ? Colors.red
                                : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast) const Divider(height: 1, thickness: 1), // Divider between buttons
              ],
            );
          }).toList(),
        )
      ),
    );
  }
}
