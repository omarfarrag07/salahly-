import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/assets_manager.dart';
import 'package:kafa2a/config/colors_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/widgets/ui_utils.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:kafa2a/features/my_profile/presentation/screens/widgets/change_language_drop_down.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().user!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).myProfile,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          GestureDetector(
            child: Container(
              width: 100,
              height: 50,
              color: Colors.transparent, // Makes it tappable but invisible
            ),
            onTap: () => context.read<AuthCubit>().getNotification(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage: AssetImage(AssetsManager.appLogo),
                ),
                SizedBox(height: 20.h),

                // Info Card
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: ColorsManager.blue, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, AppLocalizations.of(context).name,
                          user.name),
                      Divider(height: 20.h),
                      _buildInfoRow(context, AppLocalizations.of(context).email,
                          user.email),
                      Divider(height: 20.h),
                      _buildInfoRow(context,
                          AppLocalizations.of(context).phoneNumber, user.phone),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),

                // Language Dropdown
                const ChangeLanguageDropDown(),
                SizedBox(height: 30.h),

                // Logout Button
                BlocListener<AuthCubit, AuthStates>(
                  listener: (context, state) {
                    if (state is AuthLoadingState) {
                      UIUtils.showLoading(context);
                    } else if (state is AuthErrorState) {
                      UIUtils.hideLoading(context);
                      UIUtils.showMessage(state.error);
                    } else if (state is AuthSuccessState) {
                      UIUtils.hideLoading(context);
                      Navigator.of(context)
                          .pushReplacementNamed(RoutesManager.onBoarding);
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().logOut();
                      },
                      icon: Icon(Icons.logout, size: 22, color: Colors.white),
                      label: Text(
                        AppLocalizations.of(context).logOut,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
