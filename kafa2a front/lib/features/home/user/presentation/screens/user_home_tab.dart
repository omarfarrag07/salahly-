import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/widgets/default_elevated_button.dart';
import 'package:kafa2a/features/home/user/presentation/screens/map_tab.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class UserHomeTab extends StatefulWidget {
  const UserHomeTab({super.key});

  @override
  State<UserHomeTab> createState() => _UserHomeTabState();
}

class _UserHomeTabState extends State<UserHomeTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        MapTab(),
        Padding(
          padding: EdgeInsets.only(bottom: 120.h, left: 20.w, right: 20.w),
          child: DefaultElevatedButton(
            label: AppLocalizations.of(context).requestService,
            onPressed: () => Navigator.pushNamed(
              context,
              RoutesManager.requestAService,
            ),
          ),
        ),
      ],
    );
  }
}
