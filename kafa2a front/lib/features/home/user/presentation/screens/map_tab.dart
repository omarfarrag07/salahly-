import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kafa2a/core/di/service_locator.dart';
import 'package:kafa2a/core/widgets/loading_indicator.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/map/map_cubit.dart';
import 'package:kafa2a/features/home/user/presentation/cubit/map/map_states.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt.get<MapCubit>()..getLocation(),
        child: BlocConsumer<MapCubit, MapStates>(
          listener: (context, state) {
            if (state is ProviderMarkerTappedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    final provider = state.provider;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                provider.name ?? 'Unnamed',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.home_repair_service_rounded,
                                  color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                  "${AppLocalizations.of(context).service}: ${provider.serviceId}"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 8),
                              Text(
                                  "${AppLocalizations.of(context).rating}: ${provider.rating ?? 'N/A'}"),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_pin, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(
                                      "${AppLocalizations.of(context).address}: ${provider.address}")),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              });
            }
          },
          builder: (context, state) {
            final cubit = context.read<MapCubit>();
            if (state is MapSuccessState ||
                state is NearbyProvidersSuccessState ||
                state is ProviderMarkerTappedState) {
              final LatLng currentLatLng = LatLng(
                cubit.currentLocation!.latitude!,
                cubit.currentLocation!.longitude!,
              );
              return GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  if (!cubit.hasFetchedProviders) {
                    cubit.getNearbyProviders(GetNearbyProvidersRequest(
                      lat: currentLatLng.latitude,
                      lng: currentLatLng.longitude,
                    ));
                  }
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                markers: cubit.markers,
                initialCameraPosition: CameraPosition(
                  zoom: 15.15,
                  target: currentLatLng,
                ),
              );
            } else if (state is MapLoadingState) {
              return LoadingIndicator();
            } else if (state is MapErrorState) {
              return Center(child: Text("ERROR"));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
