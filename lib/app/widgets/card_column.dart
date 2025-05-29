import 'package:clean_track/app/helpers/themes.dart';
import 'package:flutter/material.dart';

class CardColumn extends StatelessWidget {
  CardColumn({
    this.children = const [],
    this.padding = 16,
    this.margin,
    this.height,
    this.width,
    this.radius,
    this.elevation,
    this.color,
    this.crossAxis,
    this.mainAxis,
    this.onPressed,
  });
  final List<Widget> children;
  final double padding;
  final double? height;
  final double? width;
  final double? radius;
  final double? elevation;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment? mainAxis;
  final CrossAxisAlignment? crossAxis;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      color: color ?? colorScheme(context).surface,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius ?? 16),
        onTap: onPressed,
        child: Container(
          height: height,
          alignment: Alignment.centerLeft,
          width: width,
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: crossAxis ?? CrossAxisAlignment.start,
            mainAxisAlignment: mainAxis ?? MainAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
