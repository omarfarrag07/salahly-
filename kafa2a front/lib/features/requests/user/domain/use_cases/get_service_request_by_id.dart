import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/service_requests_response.dart';
import 'package:kafa2a/features/requests/user/domain/repository/service_requests_repository.dart';

@injectable
class GetServiceRequestById {
  final ServiceRequestsRepository _repository;

  GetServiceRequestById(this._repository);

  Future<Either<Failure, ServiceRequestsResponse>> call(int id) async {
    return await _repository.getServiceRequestById(id);
  }
}
