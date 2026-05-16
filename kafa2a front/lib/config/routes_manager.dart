import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/features/auth/presentation/screens/login/login_screen.dart';
import 'package:kafa2a/features/auth/presentation/screens/register/provider_register_screen.dart';
import 'package:kafa2a/features/auth/presentation/screens/register/user_register_screen.dart';
import 'package:kafa2a/features/home/provider/presentation/provider_main_screen.dart';
import 'package:kafa2a/features/home/user/presentation/screens/request_service_screen.dart';
import 'package:kafa2a/features/home/user/presentation/screens/user_main_screen.dart';
import 'package:kafa2a/features/offers/user/presentation/screens/user_offers_screen.dart';
import 'package:kafa2a/features/onboarding/onboarding_screen.dart';
import 'package:kafa2a/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:kafa2a/features/payment/presentation/screens/payment_screen.dart';
import 'package:kafa2a/features/reviews/presentation/cubit/review_provider_cubit.dart';
import 'package:kafa2a/features/reviews/presentation/screens/review_provider_screen.dart';
import 'package:kafa2a/features/suspension/provider_suspension_main_screen.dart';

class RoutesManager {
  static const String onBoarding = '/onboarding';
  static const String login = "/login";
  static const String registerUser = "/registerUser";
  static const String registerProvider = "/registerProvider";
  static const String homeSuspendedProvider = "/homeSuspendedProvider";
  static const String homeUser = "/homeUser";
  static const String homeProvider = "/homeProvider";
  static const String offerUser = "/offerUser";
  static const String providerProfileDetails = "/providerProfileDetails";
  static const String requestAService = "/requestAService";
  static const String requestDetails = "/requestDetails";
  static const String allOffers = "/allOffers";
  static const String payment = "/payment";
  static const String reviewProvider = "/reviewProvider";

  static Route? router(RouteSettings settings) {
    switch (settings.name) {
      case onBoarding:
        return MaterialPageRoute(
          builder: (context) => OnboardingScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings,
        );
      case registerUser:
        return MaterialPageRoute(
          builder: (context) => UserRegisterScreen(),
        );
      case registerProvider:
        return MaterialPageRoute(
          builder: (context) => ProviderRegisterScreen(),
        );
      case homeUser:
        return MaterialPageRoute(
          builder: (context) => UserMainScreen(),
        );
      case homeProvider:
        return MaterialPageRoute(
          builder: (context) => ProviderMainScreen(),
        );
      case offerUser:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => UserOffersScreen(),
        );
      case requestAService:
        return MaterialPageRoute(
          builder: (context) => RequestServiceScreen(),
        );
      case homeSuspendedProvider:
        return MaterialPageRoute(
          builder: (context) => ProviderSuspensionMainScreen(),
        );
      case payment:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) => getIt.get<PaymentCubit>(),
            child: PaymentScreen(),
          ),
        );
      case reviewProvider:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => getIt.get<ReviewProviderCubit>(),
                  child: ProviderRatingScreen(),
                ),
            settings: settings);
    }
    return null;
  }
}
