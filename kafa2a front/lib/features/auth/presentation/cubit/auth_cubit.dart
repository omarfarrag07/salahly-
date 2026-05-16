import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/core/utils/access_location.dart';
import 'package:kafa2a/core/utils/offer_handler.dart';
import 'package:kafa2a/core/utils/offer_notifier.dart';
import 'package:kafa2a/core/utils/pusher_notification.dart';
import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/data/models/login_request.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/data/models/register_user_request.dart';
import 'package:kafa2a/features/auth/domain/entities/provider.dart';
import 'package:kafa2a/features/auth/domain/entities/user.dart';
import 'package:kafa2a/features/auth/domain/use_cases/log_out.dart';
import 'package:kafa2a/features/auth/domain/use_cases/login_provider.dart';
import 'package:kafa2a/features/auth/domain/use_cases/login_user.dart';
import 'package:kafa2a/features/auth/domain/use_cases/register_provider.dart';
import 'package:kafa2a/features/auth/domain/use_cases/register_user.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_states.dart';
import 'package:location/location.dart';

@singleton
class AuthCubit extends Cubit<AuthStates> {
  AuthCubit(this._loginUser, this._loginProvider, this._registerUser,
      this._registerProvider, this._logOut, this._accessLocation)
      : super(AuthInitialState());

  final LoginUser _loginUser;
  final LoginProvider _loginProvider;
  final RegisterUser _registerUser;
  final RegisterProvider _registerProvider;
  final LogOut _logOut;
  final AccessLocation _accessLocation;
  User? user;
  Provider? provider;
  LocationData? currentLocation;
  File? cameraImage;
  File? image;
  LatLng? pickedLocation;
  final pusherService = getIt<PusherService>();

  Future<void> loginUser(LoginRequest loginRequest) async {
    emit(
      AuthLoadingState(),
    );
    final Either<User, Failure> response = await _loginUser(loginRequest);
    user = response.fold((user) => user, (l) => null);
    response.fold(
      (userSuccess) async {
        OfferHandler().initializeOfferListening();
        await pusherService.init(userId: userSuccess.id);
        emit(
          AuthSuccessState(),
        );
      },
      (failure) => emit(
        AuthErrorState(failure.message),
      ),
    );
  }

  Future<void> loginProvider(LoginRequest loginRequest) async {
    emit(
      AuthLoadingState(),
    );
    final Either<Provider, Failure> response =
        await _loginProvider(loginRequest);
    provider = response.fold((provider) => provider, (l) => null);
    response.fold(
      (_) => emit(
        AuthSuccessState(),
      ),
      (failure) => emit(
        AuthErrorState(failure.message),
      ),
    );
  }

  Future<void> registerUser(RegisterUserRequest registerUserRequest) async {
    emit(
      AuthLoadingState(),
    );
    final Either<User, Failure> response =
        await _registerUser(registerUserRequest);
    user = response.fold((user) => user, (l) => null);

    response.fold(
      (userSuccess) async {
        await pusherService.init(userId: userSuccess.id);
        emit(
          AuthSuccessState(),
        );
      },
      (failure) => emit(
        AuthErrorState(failure.message),
      ),
    );
  }

  Future<void> registerProvider(
      RegisterProviderRequest registerProviderRequest) async {
    emit(
      AuthLoadingState(),
    );
    final Either<Provider, Failure> response =
        await _registerProvider(registerProviderRequest);
    provider = response.fold((provider) => provider, (l) => null);
    response.fold(
      (_) => emit(
        AuthSuccessState(),
      ),
      (failure) => emit(
        AuthErrorState(failure.message),
      ),
    );
  }

  Future<void> logOut() async {
    emit(
      AuthLoadingState(),
    );
    final Either<LogOutResponse, Failure> response = await _logOut();
    response.fold(
      (_) => emit(
        AuthSuccessState(),
      ),
      (failure) => emit(
        AuthErrorState(failure.message),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(
      image.path,
    );
    this.image = imageTemp;
    emit(AuthImagePickedState());
  }

  Future pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image == null) return;
    final imageTemp = File(
      image.path,
    );
    cameraImage = imageTemp;
    emit(AuthSelfiePickedState());
  }

  Future<void> getLocation() async {
    try {
      LocationData location = await _accessLocation.getLocation();
      currentLocation = location;
      emit(AuthLocationSuccessState(location));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  void setPickedLocation(LatLng latLng) async {
    pickedLocation = latLng;

    try {
      final place =
          (await placemarkFromCoordinates(latLng.latitude, latLng.longitude))
              .first;
      final city = place.locality ?? place.administrativeArea ?? '';
      final country = place.country ?? '';
      emit(LocationNameSuccessState('$city, $country'));
    } catch (e) {
      emit(LocationNameSuccessState('${latLng.latitude}, ${latLng.longitude}'));
    }
  }

  Future getNotification() async {
    await OfferNotifier.sendOffer("You received a new offer for: 200 EGP");
  }
}
