import 'package:kafa2a/features/offers/user/data/models/accept_offer_response/accept_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/reject_offer_response/reject_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';

abstract class OffersStates {}

class OffersInitialState extends OffersStates {}

class OffersLoadingState extends OffersStates {}

class OffersSuccessState extends OffersStates {
  List<Offers> offers;
  OffersSuccessState(this.offers);
}

class OffersErrorState extends OffersStates {
  String error;
  OffersErrorState(this.error);
}

class AcceptOfferSuccessState extends OffersStates {
  AcceptOfferResponse acceptOfferResponse;
  AcceptOfferSuccessState(this.acceptOfferResponse);
}

class RejectOfferSuccessState extends OffersStates {
  RejectOfferResponse rejectOfferResponse;
  RejectOfferSuccessState(this.rejectOfferResponse);
}

class ManageOfferLoadingState extends OffersStates {}

class ManageOfferErrorState extends OffersStates {
  String error;
  ManageOfferErrorState(this.error);
}

class CancelRequestSuccessState extends OffersStates {}
