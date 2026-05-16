import 'accepted_offer.dart';

class AcceptOfferResponse {
  String? message;
  AcceptedOffer? acceptedOffer;

  AcceptOfferResponse({this.message, this.acceptedOffer});

  factory AcceptOfferResponse.fromJson(Map<String, dynamic> json) {
    return AcceptOfferResponse(
      message: json['message'] as String?,
      acceptedOffer: json['accepted_offer'] == null
          ? null
          : AcceptedOffer.fromJson(
              json['accepted_offer'] as Map<String, dynamic>),
    );
  }
}
