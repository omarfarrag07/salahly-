import 'package:kafa2a/features/offers/user/data/models/accept_offer_response/accept_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/cancel_request_response.dart';
import 'package:kafa2a/features/offers/user/data/models/reject_offer_response/reject_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';

abstract class OffersUserRemoteDataSource {
  Future<List<Offers>> getOffers(String token, int id);
  Future<AcceptOfferResponse> acceptOffer(String token, int offerId);
  Future<RejectOfferResponse> rejectOffer(String token, int offerId);
  Future<CancelRequestResponse> cancelRequest(String token, int serviceId);
}
