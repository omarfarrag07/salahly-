import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/app_styles.dart';
import 'package:kafa2a/config/assets_manager.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/widgets/default_submit_button.dart';
import 'package:kafa2a/features/my_profile/presentation/screens/widgets/change_language_drop_down.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;

  bool showSlogan = false;
  bool showButtons = false;
  bool showLangIcon = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        showSlogan = true;
      });
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        showButtons = true;
        showLangIcon = true;
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Language icon with fade-in
          if (showLangIcon)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              top: 60, // moved down
              right: 24,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: showLangIcon ? 1 : 0,
                child: const ChangeLanguageDropDown(),
              ),
            ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: FadeTransition(
                      opacity: _scaleAnimation,
                      child: Image.asset(
                        AssetsManager.appLogo,
                        height: 300.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Slogan
                  Visibility(
                    visible: showSlogan,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: showSlogan ? 1 : 0,
                      child: AnimatedTextKit(
                        key: ValueKey(
                            Localizations.localeOf(context).languageCode),
                        isRepeatingAnimation: false,
                        totalRepeatCount: 1,
                        animatedTexts: [
                          TyperAnimatedText(
                            AppLocalizations.of(context).slogan,
                            textStyle: AppStyles.onBoarding.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.sp,
                            ),
                            speed: const Duration(milliseconds: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Buttons
                  Visibility(
                    visible: showButtons,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 800),
                      opacity: showButtons ? 1 : 0,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: DefaultSubmitButton(
                              label: AppLocalizations.of(context).user,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                RoutesManager.login,
                                arguments: UserType.user,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: DefaultSubmitButton(
                              label:
                                  AppLocalizations.of(context).serviceProvider,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                RoutesManager.login,
                                arguments: UserType.provider,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
