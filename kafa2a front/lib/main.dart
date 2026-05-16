import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kafa2a/config/app_theme.dart';
import 'package:kafa2a/config/routes_manager.dart';
import 'package:kafa2a/core/app_bloc_observer.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/utils/notification_service.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/request_service/request_service_cubit.dart';
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_cubit.dart';
import 'package:kafa2a/features/my_profile/presentation/cubit/profile_states.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:flutter_localization/flutter_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await configureDependencies();
  await FlutterLocalization.instance.ensureInitialized();
  await NotificationService.initialize();
  runApp(const Kafa2aApp());
}

class Kafa2aApp extends StatelessWidget {
  const Kafa2aApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt.get<AuthCubit>()),
        BlocProvider(create: (_) => getIt.get<ProfileCubit>()),
        BlocProvider(create: (_) => getIt.get<RequestServiceCubit>()),
      ],
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: Size(375, 812),
            builder: (context, child) => MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale(context.read<ProfileCubit>().getLanguage()),
              initialRoute: RoutesManager.onBoarding,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: RoutesManager.router,
              theme: AppTheme.lightTheme,
            ),
          );
        },
      ),
    );
  }
}
