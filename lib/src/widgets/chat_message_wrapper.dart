
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nex_chat_reaction/src/controllers/reactions_controller.dart';
import 'package:nex_chat_reaction/src/models/chat_reactions_config.dart';
import 'package:nex_chat_reaction/src/models/menu_item.dart';
import 'package:nex_chat_reaction/src/utilities/hero_dialog_route.dart';
import 'package:nex_chat_reaction/src/widgets/context_menu_widget.dart';

class ChatMessageWrapper extends StatelessWidget {
  final String messageId;
  final Widget child;
  final ReactionsController controller;
  final ChatReactionsConfig config;
  final Function(String)? onReactionAdded;
  final Function(String)? onReactionRemoved;
  final Function(MenuItem)? onMenuItemTapped;
  final VoidCallback? onPopupOpened;
  final VoidCallback? onPopupClosed;
  final VoidCallback? onPopupBeforeCallback;
  final Alignment alignment;

  const ChatMessageWrapper({
    super.key,
    required this.messageId,
    required this.child,
    required this.controller,
    this.config = const ChatReactionsConfig(),
    this.onReactionAdded,
    this.onReactionRemoved,
    this.onMenuItemTapped,
    this.alignment = Alignment.centerRight,
    this.onPopupOpened,
    this.onPopupClosed,
    this.onPopupBeforeCallback

  });

  void _handleReactionTap(BuildContext context, String reaction) {
    if (config.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }

    if (reaction == '➕') {
      showModalBottomSheet(
        context: context,
        builder: (context) => config.emojiPickerBuilder!(
          context,
          (emoji) {
            Navigator.pop(context);
            _addReaction(emoji);
          },
        ),
      );
    } else {
      _toggleReaction(reaction);
    }
  }

  void _addReaction(String reaction) {
    controller.addReaction(messageId, reaction);
    onReactionAdded?.call(reaction);
  }

  void _toggleReaction(String reaction) {
    final wasReacted = controller.hasUserReacted(messageId, reaction);
    controller.toggleReaction(messageId, reaction);

    if (wasReacted) {
      onReactionRemoved?.call(reaction);
    } else {
      onReactionAdded?.call(reaction);
    }
  }

  void _handleMenuItemTap(MenuItem item) {
    if (config.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    onMenuItemTapped?.call(item);
  }

  void _showReactionsDialog(BuildContext context) {
    onPopupOpened?.call(); // 🔥 notify popup opened
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => ReactionsDialogWidget(
          messageId: messageId,
          messageWidget: child,
          controller: controller,
          config: config,
          onReactionTap: (reaction) => _handleReactionTap(context, reaction),
          onMenuItemTap: _handleMenuItemTap,
          alignment: alignment,
        ),
      ),
    ).then((value) =>  onPopupClosed?.call(),);// 🔥 notify popup closed
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onPopupBeforeCallback?.call();
        if (config.enableLongPress) {
          _showReactionsDialog(context);
        }
      },
      onDoubleTap: () {
        onPopupBeforeCallback?.call();
        if (config.enableDoubleTap) {
          _showReactionsDialog(context);
        }
      },
      child: Hero(
        tag: messageId,
        child: child,
      ),
    );
  }
}
