import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color buttonColor;
  final Color textColor;
  final Color? disabledColor;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const CustomFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.white,
    this.disabledColor,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          foregroundColor: onPressed != null ? textColor : Colors.grey,
          backgroundColor: onPressed != null
              ? buttonColor
              : (disabledColor ?? Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(20.0),
          ),
        ),
        child: child,
      ),
    );
  }
}
