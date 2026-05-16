import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';
import 'package:kafa2a/features/home/provider/domain/repository/provider_offers_repository.dart';

@singleton
class SendOffer {
  SendOffer(this._providerOffersRepository);

  final ProviderOffersRepository _providerOffersRepository;

  Future<Either<SendOfferResponse, Failure>> call(
          SendOfferRequest sendOfferRequest) =>
      _providerOffersRepository.sendOffer(sendOfferRequest);
}
