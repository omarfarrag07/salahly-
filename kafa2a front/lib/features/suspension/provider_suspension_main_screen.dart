import 'package:flutter/material.dart';
import 'package:kafa2a/core/widgets/custom_navigation_bar.dart';
import 'package:kafa2a/features/my_profile/presentation/screens/provider/provider_profile_screen.dart';
import 'package:kafa2a/features/suspension/provider_suspension_home_tab.dart';
import 'package:kafa2a/features/suspension/update_document_screen.dart';

class ProviderSuspensionMainScreen extends StatefulWidget {
  const ProviderSuspensionMainScreen({super.key});

  @override
  State<ProviderSuspensionMainScreen> createState() =>
      _ProviderSuspensionMainScreenState();
}

class _ProviderSuspensionMainScreenState
    extends State<ProviderSuspensionMainScreen> {
  int selectedTab = 0;
  List<Widget> tabs = [
    ProviderSuspensionHomeTab(),
    UpdateDocumentScreen(),
    ProviderProfileScreen(),
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
        isProvider: true,
        isSuspension: true,
      ),
    );
  }
}
