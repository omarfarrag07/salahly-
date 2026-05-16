import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/offers/user/data/models/accept_offer_response/accept_offer_response.dart';
import 'package:kafa2a/features/offers/user/domain/repository/offers_repository.dart';

@lazySingleton
class AcceptOffer {
  final OffersRepository _offersRepository;
  AcceptOffer(this._offersRepository);

  Future<Either<AcceptOfferResponse, Failure>> call(int offerId) =>
      _offersRepository.acceptOffer(offerId);
}
