import 'dart:ui';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/features/my_profile/data/data_sources/local/profile_local_data_source.dart';
import 'package:kafa2a/features/my_profile/data/models/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ProfileLocalDataSource)
class ProfileSharedPrefLocalDataSource implements ProfileLocalDataSource {
  ProfileSharedPrefLocalDataSource(this._sharedPref);

  final SharedPreferences _sharedPref;

  @override
  Future<void> changeLanguage(Language language) async {
    await _sharedPref.setString(CacheConstants.language, language.code);
  }

  @override
  String getLanguage() {
    try {
      final savedLang = _sharedPref.getString(CacheConstants.language);
      if (savedLang != null) return savedLang;

      final deviceLocale = PlatformDispatcher.instance.locale.languageCode;

      if (deviceLocale == 'en' || deviceLocale == 'ar') {
        return deviceLocale;
      } else {
        return 'ar';
      }
    } catch (e) {
      return 'ar';
    }
  }
}
