import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/custom_navigation_bar.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_cubit.dart';
import 'package:kafa2a/features/home/provider/presentation/screens/provider_home_tab.dart';
import 'package:kafa2a/features/my_profile/presentation/screens/provider/provider_profile_screen.dart';
import 'package:kafa2a/features/home/provider/presentation/screens/scheduled_jobs_screen.dart';

class ProviderMainScreen extends StatefulWidget {
  const ProviderMainScreen({super.key});

  @override
  State<ProviderMainScreen> createState() => _ProviderMainScreenState();
}

class _ProviderMainScreenState extends State<ProviderMainScreen> {
  int selectedTab = 0;

  final List<Widget> tabs = [
    ProviderHomeTab(),
    BlocProvider(
      create: (context) => getIt.get<ProviderOffersCubit>(),
      child: ScheduledJobsScreen(),
    ),
    ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      extendBody: true,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Container(
            key: ValueKey<int>(selectedTab),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: tabs[selectedTab],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: CustomNavigationBar(
          selectedIndex: selectedTab,
          onTap: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          isProvider: true,
        ),
      ),
    );
  }
}
