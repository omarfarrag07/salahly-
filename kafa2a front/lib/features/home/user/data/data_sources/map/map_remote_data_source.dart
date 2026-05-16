import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_response.dart';

abstract class MapRemoteDataSource {
  Future<List<GetNearbyProvidersResponse>> getNearbyProviders(
      String token, GetNearbyProvidersRequest getNearbyProvidersRequest);
}
