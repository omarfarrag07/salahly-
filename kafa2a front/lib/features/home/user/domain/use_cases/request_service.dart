import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_request.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_response.dart';
import 'package:kafa2a/features/home/user/domain/repository/request_service_repository.dart';

@singleton
class RequestService {
  final RequestServiceRepository _requestRepository;
  RequestService(this._requestRepository);

  Future<Either<RequestServiceResponse, Failure>> call(
          RequestServiceRequest requestService) =>
      _requestRepository.requestService(requestService);
}
