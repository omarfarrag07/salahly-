import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/service_requests_response.dart';

abstract class ServiceRequestsRepository {
  Future<Either<Failure, ServiceRequestsResponse>> getAllServiceRequests();
  Future<Either<Failure, ServiceRequestsResponse>> getServiceRequestById(
      int id);
}
