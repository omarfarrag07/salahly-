import 'package:kafa2a/core/models/offer_model.dart';
import 'request.dart';

class AcceptedOffer {
  int? id;
  int? offerId;
  int? serviceRequestId;
  DateTime? createdAt;
  DateTime? updatedAt;
  OfferModel? offer;
  Request? request;

  AcceptedOffer({
    this.id,
    this.offerId,
    this.serviceRequestId,
    this.createdAt,
    this.updatedAt,
    this.offer,
    this.request,
  });

  factory AcceptedOffer.fromJson(Map<String, dynamic> json) => AcceptedOffer(
        id: json['id'] as int?,
        offerId: json['offer_id'] as int?,
        serviceRequestId: json['service_request_id'] as int?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        offer: json['offer'] == null
            ? null
            : OfferModel.fromJson(json['offer'] as Map<String, dynamic>),
        request: json['request'] == null
            ? null
            : Request.fromJson(json['request'] as Map<String, dynamic>),
      );
}
