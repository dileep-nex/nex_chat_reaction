import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

/// Single reaction button with animation
class ReactionButton extends StatelessWidget {
  /// Creates a reaction button widget.
  const ReactionButton({
    super.key,
    required this.reaction,
    required this.index,
    required this.onTap,
  });

  final String reaction;
  final int index;
  final Function(String, int) onTap;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      from: (index * 20).toDouble(),
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () => onTap(reaction, index),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
          child: Text(
            reaction,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 22),
          ),
        ),
      ),
    );
  }
}


class ReactionImageButton extends StatelessWidget {
  /// Creates a reaction button widget.
  const ReactionImageButton({
    super.key,
    required this.reaction,
    required this.index,
    required this.onTap,
  });

  final String reaction;
  final int index;
  final Function(String, int) onTap;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      from: (index * 20).toDouble(),
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: () => onTap(reaction, index),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 6.0, 4.0),
          child: Center(
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark?
              'assets/reaction_chat/plus_icon_dark.png'
              :"assets/reaction_chat/plus_icon.png",// path to your asset
              width: 30,             // you can set custom size
              height: 30,
              fit: BoxFit.contain,
            )
          ),
        ),
      ),
    );
  }
}
