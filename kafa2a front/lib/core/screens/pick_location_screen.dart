import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kafa2a/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';
import 'package:location/location.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  GoogleMapController? _mapController;
  @override
  Widget build(BuildContext context) {
    LocationData? currentLocation = context.read<AuthCubit>().currentLocation;
    LatLng center =
        LatLng(currentLocation!.latitude!, currentLocation.longitude!);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: center,
              zoom: 15,
            ),
            onCameraMove: (position) {
              center = position.target;
            },
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Center(
            child: Icon(Icons.location_pin, size: 40, color: Colors.red),
          ),
          Positioned(
            bottom: 20,
            left: 40,
            right: 40,
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().setPickedLocation(center);
                Navigator.pop(context, center);
              },
              child: Text(AppLocalizations.of(context).pickYourLocation),
            ),
          ),
        ],
      ),
    );
  }
}
