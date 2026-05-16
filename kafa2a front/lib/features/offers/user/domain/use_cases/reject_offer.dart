import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/offers/user/data/models/reject_offer_response/reject_offer_response.dart';
import 'package:kafa2a/features/offers/user/domain/repository/offers_repository.dart';

@singleton
class RejectOffer {
  final OffersRepository _offersRepository;
  RejectOffer(this._offersRepository);
  Future<Either<RejectOfferResponse, Failure>> call(int offerId) async =>
      await _offersRepository.rejectOffer(offerId);
}
