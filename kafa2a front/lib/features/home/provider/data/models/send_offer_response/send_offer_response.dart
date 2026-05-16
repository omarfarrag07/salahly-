import '../../../../../../core/models/offer_model.dart';

class SendOfferResponse {
  String? message;
  OfferModel? offer;

  SendOfferResponse({this.message, this.offer});

  factory SendOfferResponse.fromJson(Map<String, dynamic> json) {
    return SendOfferResponse(
      message: json['message'] as String?,
      offer: json['offer'] == null
          ? null
          : OfferModel.fromJson(json['offer'] as Map<String, dynamic>),
    );
  }
}
