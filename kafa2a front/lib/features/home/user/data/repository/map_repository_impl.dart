import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/home/user/data/data_sources/map/map_remote_data_source.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_request.dart';
import 'package:kafa2a/features/home/user/data/models/get_nearby_providers_response.dart';
import 'package:kafa2a/features/home/user/domain/repository/map_repository.dart';

@Injectable(as: MapRepository)
class MapRepositoryImpl implements MapRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final MapRemoteDataSource _mapRemoteDataSource;
  MapRepositoryImpl(this._authLocalDataSource, this._mapRemoteDataSource);
  @override
  Future<Either<List<GetNearbyProvidersResponse>, Failure>> getNearbyProviders(
      GetNearbyProvidersRequest getNearbyprovidersRequest) async {
    try {
      final List<GetNearbyProvidersResponse> providers =
          await _mapRemoteDataSource.getNearbyProviders(
              _authLocalDataSource.getToken(), getNearbyprovidersRequest);
      return Left(providers);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
