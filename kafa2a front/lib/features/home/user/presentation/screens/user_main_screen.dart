import 'package:flutter/material.dart';
import 'package:kafa2a/core/widgets/custom_navigation_bar.dart';
import 'package:kafa2a/features/home/user/presentation/screens/user_home_tab.dart';
import 'package:kafa2a/features/my_profile/presentation/screens/user/user_profile_screen.dart';
import 'package:kafa2a/features/requests/user/presentation/screens/user_requests_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int selectedTab = 0;
  List<Widget> tabs = [
    UserHomeTab(),
    UserRequestsScreen(),
    UserProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: tabs[selectedTab],
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        isProvider: false,
      ),
    );
  }
}
