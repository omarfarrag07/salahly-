import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/features/my_profile/data/models/language.dart';
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_cubit.dart';

class ChangeLanguageDropDown extends StatefulWidget {
  const ChangeLanguageDropDown({super.key});

  @override
  State<ChangeLanguageDropDown> createState() => _ChangeLanguageDropDownState();
}

class _ChangeLanguageDropDownState extends State<ChangeLanguageDropDown> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ProfileCubit>();
    final currentLangCode = cubit.selectedLanguageCode;
    final nextLangCode = currentLangCode == 'ar' ? 'en' : 'ar';
    final nextLangLabel = currentLangCode == 'ar' ? 'ENG' : 'عربي';

    return InkWell(
      onTap: () {
        final nextLang =
            languages.firstWhere((lang) => lang.code == nextLangCode);
        cubit.changeLanguage(nextLang); // This is your existing logic!
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsManager.blue),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nextLangLabel,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.language,
              size: 20,
              color: ColorsManager.blue,
            ),
          ],
        ),
      ),
    );
  }
}
