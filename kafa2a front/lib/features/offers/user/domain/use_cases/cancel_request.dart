import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/offers/user/data/models/cancel_request_response.dart';
import 'package:kafa2a/features/offers/user/domain/repository/offers_repository.dart';

@lazySingleton
class CancelRequest {
  final OffersRepository _offersRepository;
  CancelRequest(this._offersRepository);

  Future<Either<CancelRequestResponse, Failure>> call(int serviceId) =>
      _offersRepository.cancelRequest(serviceId);
}
