class GetNearbyProvidersRequest {
  final double lat;
  final double lng;

  GetNearbyProvidersRequest({
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lng': lng,
      };
}
