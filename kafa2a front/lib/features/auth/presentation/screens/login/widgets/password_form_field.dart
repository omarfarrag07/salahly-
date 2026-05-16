import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    super.key,
    required this.controller,
    required this.validator,
    this.fontSize = 18, // Default bigger font size
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final double fontSize;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool isVisible = true;
  Icon visibilityIcon =
      Icon(Icons.visibility_off_outlined, color: ColorsManager.blue);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      obscureText: isVisible,
      style: TextStyle(fontSize: widget.fontSize),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).enterYourPassword,
        hintStyle: TextStyle(fontSize: widget.fontSize),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.black54),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.red.shade900),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorsManager.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.blue),
          borderRadius: BorderRadius.circular(12.r),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isVisible = !isVisible;
              visibilityIcon = isVisible
                  ? Icon(Icons.visibility_off_outlined,
                      color: ColorsManager.blue)
                  : Icon(Icons.visibility_outlined, color: ColorsManager.blue);
            });
          },
          icon: visibilityIcon,
        ),
      ),
    );
  }
}
