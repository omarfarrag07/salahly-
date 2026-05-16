import 'package:kafa2a/core/models/offer_model.dart';
import 'package:kafa2a/features/home/provider/domain/entities/offer.dart';

extension OfferMapper on OfferModel {
  Offer get toOfferEntity => Offer(
      id: id,
      providerId: providerId,
      price: price,
      serviceRequestId: serviceRequestId);
}
