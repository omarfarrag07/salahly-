import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/local_data_source/local_data_source.dart';
import 'package:location/location.dart';

@lazySingleton
class AccessLocation {
  Location location = Location();
  final LocalDataSource _sharedPref;
  AccessLocation(this._sharedPref);

  Future<LocationData> getLocation() async {
    await getPrmission();
    LocationData locationData;
    locationData = await location.getLocation();
    _sharedPref.saveLocation(locationData);
    return locationData;
  }

  Future<void> getPrmission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled. Please enable them.');
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied. Please grant them.');
      }
    }
  }
}
