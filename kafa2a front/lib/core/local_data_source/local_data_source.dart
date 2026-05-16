import 'package:location/location.dart';

abstract class LocalDataSource {
  void saveLocation(LocationData location);
  Future<void> removeLocation();
  Future<LocationData?> getLocation();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
}
