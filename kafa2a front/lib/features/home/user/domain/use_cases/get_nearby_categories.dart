import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_response.dart';
import 'package:kafa2a/features/home/user/domain/repository/map_repository.dart';

@injectable
class GetNearbyCategories {
  final MapRepository _mapRepository;
  GetNearbyCategories(this._mapRepository);
  Future<Either<List<GetNearbyProvidersResponse>, Failure>> call(
          GetNearbyProvidersRequest getNearbyprovidersRequest) =>
      _mapRepository.getNearbyProviders(getNearbyprovidersRequest);
}
