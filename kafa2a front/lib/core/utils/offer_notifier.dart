import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class OfferNotifier {
  static Future<void> sendOffer(String offerDetails) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_offer', offerDetails);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/new_offer.trigger');
    await file.writeAsString(DateTime.now().toString());
  }

  static void startCheckingForOffers(void Function(String) onNewOffer) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/new_offer.trigger');

      if (await file.exists()) {
        final prefs = await SharedPreferences.getInstance();
        final offer = prefs.getString('last_offer');

        if (offer != null) {
          onNewOffer(offer);
          await file.delete();
        }
      }
    });
  }
}
