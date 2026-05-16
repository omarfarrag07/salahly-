import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';

class OfferTextFormField extends StatelessWidget {
  const OfferTextFormField(
      {super.key,
      required this.controller,
      required this.validator,
      required this.hintText,
      this.textStyle});
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String hintText;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.number,
        style: textStyle,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsManager.blue),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorsManager.blue),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: Colors.red.shade900),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorsManager.blue),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ));
  }
}
