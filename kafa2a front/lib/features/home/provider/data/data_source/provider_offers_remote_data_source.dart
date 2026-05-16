import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';

abstract class ProviderOffersRemoteDataSource {
  Future<List<AllProviderRequests>> getAllRequests(String token);
  Future<SendOfferResponse> sendOffer(
      String token, SendOfferRequest sendOfferRequest);
  Future<void> completeRequest(String token, int requestId);
}
