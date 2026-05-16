import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';

abstract class ProviderOffersRepository {
  Future<Either<List<AllProviderRequests>, Failure>> getAllRequests();
  Future<Either<SendOfferResponse, Failure>> sendOffer(
      SendOfferRequest request);
  Future<Either<void, Failure>> completeRequest(int requestId);
}
