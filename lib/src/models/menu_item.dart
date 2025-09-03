import 'package:flutter/widgets.dart';

class MenuItem {
  final String label;
  final String icon;
  final bool isDestructive;

  // contsructor
  const MenuItem({
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });
}
