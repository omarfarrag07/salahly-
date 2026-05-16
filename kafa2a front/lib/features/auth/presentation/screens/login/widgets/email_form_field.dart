import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/core/utils/validators.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    super.key,
    required this.controller,
    this.fontSize = 18, // Default bigger font size
  });

  final TextEditingController controller;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => Validators.validateEmail(value, context),
      style: TextStyle(fontSize: fontSize),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).enterYourEmail,
        hintStyle: TextStyle(fontSize: fontSize),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black54),
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
        suffixIcon: Icon(
          Icons.email_outlined,
          color: ColorsManager.blue,
        ),
      ),
    );
  }
}
