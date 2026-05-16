import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isProvider;
  final bool isSuspension;

  const CustomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
    this.isProvider = false,
    this.isSuspension = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: ColorsManager.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: isSuspension
            ? _buildSuspensionItems(context)
            : _buildMainItems(context),
      ),
    );
  }

  List<Widget> _buildMainItems(BuildContext context) {
    if (isProvider) {
      // Provider: Home, Scheduled Jobs, My Profile
      return [
        _buildNavItem(
          context,
          index: 0,
          icon: Icons.home_rounded,
          label: AppLocalizations.of(context).home,
          isSelected: selectedIndex == 0,
        ),
        _buildNavItem(
          context,
          index: 1,
          icon: Icons.schedule_rounded,
          label: AppLocalizations.of(context).scheduledJobs,
          isSelected: selectedIndex == 1,
        ),
        _buildNavItem(
          context,
          index: 2,
          icon: Icons.person_rounded,
          label: AppLocalizations.of(context).myProfile,
          isSelected: selectedIndex == 2,
        ),
      ];
    } else {
      // User: Home, My Requests, My Profile
      return [
        _buildNavItem(
          context,
          index: 0,
          icon: Icons.home_rounded,
          label: AppLocalizations.of(context).home,
          isSelected: selectedIndex == 0,
        ),
        _buildNavItem(
          context,
          index: 1,
          icon: Icons.assignment_rounded,
          label: AppLocalizations.of(context).myRequests,
          isSelected: selectedIndex == 1,
        ),
        _buildNavItem(
          context,
          index: 2,
          icon: Icons.person_rounded,
          label: AppLocalizations.of(context).myProfile,
          isSelected: selectedIndex == 2,
        ),
      ];
    }
  }

  List<Widget> _buildSuspensionItems(BuildContext context) {
    return [
      _buildNavItem(
        context,
        index: 0,
        icon: Icons.home_rounded,
        label: AppLocalizations.of(context).home,
        isSelected: selectedIndex == 0,
      ),
      _buildNavItem(
        context,
        index: 1,
        icon: Icons.document_scanner_rounded,
        label: AppLocalizations.of(context).updateDocument,
        isSelected: selectedIndex == 1,
      ),
      _buildNavItem(
        context,
        index: 2,
        icon: Icons.person_rounded,
        label: AppLocalizations.of(context).myProfile,
        isSelected: selectedIndex == 2,
      ),
    ];
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSuspension ? 120.w : 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border:
              isSelected ? Border.all(color: Colors.white, width: 2.w) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: isSelected ? 26.sp : 24.sp,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 10.sp : 9.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : Colors.grey[400],
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
