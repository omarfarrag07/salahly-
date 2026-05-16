import 'package:kafa2a/core/utils/notification_service.dart';
import 'package:kafa2a/core/utils/offer_notifier.dart';

class OfferHandler {
  void initializeOfferListening() {
    OfferNotifier.startCheckingForOffers((offer) {
      NotificationService.showNotification(
        title: 'New Offer Received',
        body: offer,
      );
      // Additional business logic when offer is received
    });
  }
}
