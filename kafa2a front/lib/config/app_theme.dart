import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kafa2a/config/app_styles.dart';
import 'package:kafa2a/config/colors_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: ColorsManager.blue,
    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        )),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppStyles.title),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.blue,
      brightness: Brightness.light,
      primary: ColorsManager.blue,
      onPrimary: Colors.white,
      secondary: Colors.white,
      onSecondary: ColorsManager.blue,
      onSurface: Colors.black,
      surface: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.blue,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontSize: 10.sp),
      unselectedLabelStyle: TextStyle(fontSize: 10.sp),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.inter(
            fontSize: 16.sp,
            textStyle: TextStyle(overflow: TextOverflow.ellipsis)),
        menuStyle: MenuStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(color: ColorsManager.blue, width: 1.2.w))))),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          textStyle: GoogleFonts.inter(
              fontSize: 16.sp,
              textStyle: TextStyle(overflow: TextOverflow.ellipsis)),
          elevation: 2,
          fixedSize: Size.fromHeight(45.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(color: ColorsManager.blue, width: 1.2.w))),
    ),
  );
}
