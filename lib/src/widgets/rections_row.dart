import 'package:flutter/material.dart';
import 'package:nex_chat_reaction/src/widgets/reactions_button.dart';

class ReactionsRow extends StatelessWidget {
  /// Creates a reactions row widget.
  const ReactionsRow({
    super.key,
    required this.reactions,
    required this.alignment,
    required this.onReactionTap,
    required this.dialogBackgroundColor,
    this.reactionAddIcon
  });

  final List<String> reactions;
  final Alignment alignment;
  final Color dialogBackgroundColor;
  final String? reactionAddIcon;
  final Function(String, int) onReactionTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Material(
         color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          decoration: BoxDecoration(
             color: dialogBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark?
              Color(0xFF3D3D3D)
                  :Color(0xFFD9D9D9),
              width: 0.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < reactions.length; i++)
                i == reactions.length-1 ? ReactionImageButton(
                  imagePath: reactionAddIcon,
                  reaction: reactions[i],
                  index: i,
                  onTap: onReactionTap,
                ):
                ReactionButton(
                  reaction: reactions[i],
                  index: i,
                  onTap: onReactionTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
