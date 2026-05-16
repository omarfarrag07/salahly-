import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/core/utils/access_location.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_response.dart';
import 'package:kafa2a/features/home/user/domain/use_cases/get_nearby_categories.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/map/map_states.dart';
import 'package:location/location.dart';

@injectable
class MapCubit extends Cubit<MapStates> {
  MapCubit(this._accessLocation, this._getNearbyCategories)
      : super(MapInitialState());
  final AccessLocation _accessLocation;
  final GetNearbyCategories _getNearbyCategories;
  Set<Marker> markers = {};
  LocationData? currentLocation;
  bool hasFetchedProviders = false;
  Future<void> getLocation() async {
    emit(MapLoadingState());
    try {
      final location = await _accessLocation.getLocation();
      currentLocation = location;
      emit(MapSuccessState(location));
    } catch (e) {
      if (!isClosed) {
        emit(MapErrorState());
      }
    }
  }

  Future<void> getNearbyProviders(GetNearbyProvidersRequest request) async {
    if (!isClosed) {
      emit(MapLoadingState());
    }
    hasFetchedProviders = true;
    Either<List<GetNearbyProvidersResponse>, Failure> response =
        await _getNearbyCategories(request);
    response.fold((providerList) {
      markers = providerList.map((provider) {
        return Marker(
          markerId: MarkerId(provider.id.toString()),
          position: LatLng(provider.lat!, provider.lng!),
          infoWindow: InfoWindow(title: provider.name),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            emit(ProviderMarkerTappedState(provider));
          },
        );
      }).toSet();
      if (!isClosed) {
        emit(NearbyProvidersSuccessState());
      }
    }, (failure) {
      if (!isClosed) {
        emit(NearbyProvidersErrorState());
      }
    });
  }
}
