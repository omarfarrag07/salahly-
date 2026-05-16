import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/data_sources/remote/service_requests_remote_data_source.dart';
import 'package:kafa2a/features/requests/user/data/models/service_requests_response.dart';
import 'package:kafa2a/features/requests/user/domain/repository/service_requests_repository.dart';

@Injectable(as: ServiceRequestsRepository)
class ServiceRequestsRepositoryImpl implements ServiceRequestsRepository {
  final ServiceRequestsRemoteDataSource _remoteDataSource;

  ServiceRequestsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ServiceRequestsResponse>>
      getAllServiceRequests() async {
    try {
      final response = await _remoteDataSource.getAllServiceRequests();
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceRequestsResponse>> getServiceRequestById(
      int id) async {
    try {
      final response = await _remoteDataSource.getServiceRequestById(id);
      return Right(response);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
