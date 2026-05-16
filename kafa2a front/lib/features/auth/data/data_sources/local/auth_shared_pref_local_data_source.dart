import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: AuthLocalDataSource)
class AuthSharedPrefLocalDataSource extends AuthLocalDataSource {
  AuthSharedPrefLocalDataSource(this._sharedPref);

  final SharedPreferences _sharedPref;

  @override
  String getToken() {
    try {
      final String token = _sharedPref.getString(CacheConstants.token)!;
      return token;
    } catch (exception) {
      throw (LocalException(Messages.failedToSaveToken));
    }
  }

  @override
  void removeToken() {
    try {
      _sharedPref.remove(CacheConstants.token);
    } catch (exception) {
      throw (LocalException(Messages.failedToDeleteToken));
    }
  }

  @override
  void saveToken(String token) {
    try {
      _sharedPref.setString(CacheConstants.token, token);
    } catch (exception) {
      throw (LocalException(Messages.failedToSaveToken));
    }
  }
}
