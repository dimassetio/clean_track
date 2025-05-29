import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.radius,
    this.icon,
  });

  final String title;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? radius;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? SizedBox(),
          if (icon is Widget) 12.width,
          Text(title),
        ],
      ),
    );
  }
}
