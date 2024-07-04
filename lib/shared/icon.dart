import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.icon,
    this.iconColor,
  });

  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: iconColor ?? Theme.of(context).primaryColorLight,
    );
  }
}
