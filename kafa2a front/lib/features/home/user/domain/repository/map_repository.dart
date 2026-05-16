import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_response.dart';

abstract class MapRepository {
  Future<Either<List<GetNearbyProvidersResponse>, Failure>> getNearbyProviders(
      GetNearbyProvidersRequest getNearbyprovidersRequest);
}
