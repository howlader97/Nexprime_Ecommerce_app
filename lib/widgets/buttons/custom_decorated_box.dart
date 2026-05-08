import 'package:flutter/material.dart';

import '../../constant/app_colors.dart';

class CustomDecoratedBox extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const CustomDecoratedBox({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:color ?? AppColors.instance.grayEE,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: child,
        ),
      ),
    );
  }
}