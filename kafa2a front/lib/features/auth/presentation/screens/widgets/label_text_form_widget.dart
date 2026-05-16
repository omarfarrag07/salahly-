import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelTextFormWidget extends StatelessWidget {
  const LabelTextFormWidget({
    super.key,
    required this.label,
    this.fontSize,
  });
  final String label;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize ?? 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
