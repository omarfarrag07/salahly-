import 'package:location/location.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthSuccessState extends AuthStates {}

class AuthErrorState extends AuthStates {
  AuthErrorState(this.error);

  final String error;
}

class AuthLoadingState extends AuthStates {}

class AuthSelfiePickedState extends AuthStates {}

class AuthImagePickedState extends AuthStates {}

class AuthLocationSuccessState extends AuthStates {
  final LocationData location;

  AuthLocationSuccessState(this.location);
}

class LocationNameSuccessState extends AuthStates {
  final String locationName;
  LocationNameSuccessState(this.locationName);
}
