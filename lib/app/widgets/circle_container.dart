import 'package:flutter/material.dart';
import 'package:clean_track/app/helpers/themes.dart';

class CircleContainer extends StatelessWidget {
  CircleContainer({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.height,
    this.width,
    this.color,
    this.alignment,
    this.shadow,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Color? color;
  final Alignment? alignment;
  final bool? shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: color ?? theme(context).colorScheme.surface,
        boxShadow:
            (shadow ?? false)
                ? [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0X1A333333),
                    offset: Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }
}
