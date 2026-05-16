import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/di/service_locator.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
Future<void> configureDependencies() => getIt.init();
