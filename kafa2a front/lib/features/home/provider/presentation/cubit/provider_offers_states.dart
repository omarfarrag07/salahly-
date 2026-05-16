import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';

abstract class ProviderOffersStates {}

class ProviderOffersInitialState extends ProviderOffersStates {}

class GetAllRequestsLoadingState extends ProviderOffersStates {}

class GetAllRequestsErrorState extends ProviderOffersStates {
  final String error;
  GetAllRequestsErrorState(this.error);
}

class GetAllRequestsSuccessState extends ProviderOffersStates {
  final List<AllProviderRequests> requests;
  GetAllRequestsSuccessState(this.requests);
}

class SendOfferLoadingState extends ProviderOffersStates {}

class SendOfferErrorState extends ProviderOffersStates {
  final String error;
  SendOfferErrorState(this.error);
}

class SendOfferSuccessState extends ProviderOffersStates {
  final String message;
  SendOfferSuccessState(this.message);
}
