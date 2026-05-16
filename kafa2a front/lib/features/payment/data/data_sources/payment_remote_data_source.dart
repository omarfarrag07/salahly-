import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentResponse> payProvider(
      PaymentRequest paymentRequest, String token);
}
