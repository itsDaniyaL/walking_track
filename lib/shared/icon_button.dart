import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final Color buttonColor;
  final Color iconColor;
  final double? size;
  final BorderRadius? borderRadius;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.buttonColor = Colors.blue,
    this.iconColor = Colors.white,
    this.size,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: borderRadius ?? BorderRadius.circular(20.0),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: iconColor,
        iconSize: size != null ? size! * 0.5 : 24.0,
      ),
    );
  }
}
