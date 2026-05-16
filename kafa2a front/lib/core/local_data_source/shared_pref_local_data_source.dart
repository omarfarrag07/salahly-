import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/local_data_source/local_data_source.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: LocalDataSource)
class SharedPrefLocalDataSource implements LocalDataSource {
  final SharedPreferences _sharedPref;
  SharedPrefLocalDataSource(this._sharedPref);
  @override
  Future<void> removeLocation() {
    _sharedPref.remove(CacheConstants.latitude);
    _sharedPref.remove(CacheConstants.longitude);
    throw UnimplementedError();
  }

  @override
  void saveLocation(LocationData location) {
    _sharedPref.setDouble(CacheConstants.latitude, location.latitude!);
    _sharedPref.setDouble(CacheConstants.longitude, location.longitude!);
  }

  @override
  Future<LocationData?> getLocation() async {
    final double? lat = _sharedPref.getDouble(CacheConstants.latitude);
    final double? lng = _sharedPref.getDouble(CacheConstants.longitude);
    if (lat != null && lng != null) {
      return LocationData.fromMap({
        'latitude': lat,
        'longitude': lng,
      });
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await _sharedPref.setString(CacheConstants.token, token);
  }

  @override
  Future<String?> getToken() async {
    return _sharedPref.getString(CacheConstants.token);
  }

  @override
  Future<void> removeToken() async {
    await _sharedPref.remove(CacheConstants.token);
  }
}
