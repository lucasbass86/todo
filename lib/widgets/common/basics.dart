import 'package:flutter/material.dart';
import 'package:todo/themes/themes.dart';

class BasicContainer extends StatelessWidget {
  final Widget child;
  final Color? backColor;
  final double? width;
  final double? height;
  const BasicContainer({super.key, required this.child, this.backColor, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: child,
    );
  }
}
