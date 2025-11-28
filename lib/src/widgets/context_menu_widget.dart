import 'dart:ui';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
              FutureBuilder<List<String>>(
                future: controller.getRecentEmojis(defaultEmojis: config.availableReactions),
                builder: (context, snapshot) {
                  // Show default reactions while loading or if there's an error
                  final reactions = snapshot.data ?? config.availableReactions;

                  return ReactionsRow(
                    reactionAddIcon: config.reactionAddIcon,
                    dialogBackgroundColor: config.dialogBackgroundColor ?? const Color(0xFFFFFFFF),
                    reactions: reactions,
                    alignment: alignment,
                    onReactionTap: (reaction, _) => _handleReactionTap(context, reaction),
                  );
                },
              ),
              const SizedBox(height: 10),

              MessageBubble(
                id: messageId,
                messageWidget: messageWidget,
                alignment: alignment,
                maxHeight: config.heightMessageBox, // Customizable max height
                maxWidth: config.widthMessageBox,
                borderRadius: 12.0, // Customizable border radius
                backgroundColor: Colors.transparent, // Customizable background
              ),

              if (config.showContextMenu) ...[
                const SizedBox(height: 10),
                ContextMenuWidget(
                  dialogBackgroundColor: config.dialogBackgroundColor?? const Color(0xFFFFFFFF),
                  itemTextColor: config.itemTextColor?? Colors.grey,
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
     try{
       final pickerKey = GlobalKey<EmojiPickerState>();
       Navigator.of(context).pop();
       if(reaction != "➕"){
         EmojiPickerUtils().addEmojiToRecentlyUsed(
           key: pickerKey, // Storage key (default is 'recent')
           emoji: Emoji(reaction,'' ),
           config: Config(), // Use your config here
         );
       }
       onReactionTap(reaction);
     }
         catch(e){}
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
  final Color dialogBackgroundColor;
  final Color itemTextColor;
  final Function(MenuItem, int) onMenuItemTap;

  const ContextMenuWidget({
    super.key,
    required this.menuItems,
    required this.onMenuItemTap,
    required this.dialogBackgroundColor,
    required this.itemTextColor,
    this.alignment = Alignment.centerRight,
    this.menuWidth = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
         width: calculateMenuWidth(menuItems),
        decoration: BoxDecoration(
          color: dialogBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark?
            Color(0xFF3D3D3D)
                :Color(0xFFD9D9D9),
            width: 0.3,
          ),
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
                                  : itemTextColor,
                              fontSize: 16,
                            ),
                          ),
                          Image.asset(
                            item.icon,
                            width: 20,
                            height: 20,
                            color: item.isDestructive
                                ? Colors.red
                                : itemTextColor
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast) Divider(height: 1, thickness: 0.3,
                  color: Theme.of(context).brightness == Brightness.dark? Color(0xFF3D3D3D):Color(0xFFD9D9D9),
                ), // Divider between buttons
              ],
            );
          }).toList(),
        )
      ),
    );
  }


  double calculateMenuWidth(List<MenuItem> items) {
    double maxWidth = 0;
    for (var item in items) {
      final tp = TextPainter(
        text: TextSpan(text: item.label, style: TextStyle(fontSize: 16)),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      if (tp.width > maxWidth) maxWidth = tp.width;
    }
    return maxWidth + 80;
  }

}
