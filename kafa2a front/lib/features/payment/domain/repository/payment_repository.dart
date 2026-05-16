import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';

abstract class PaymentRepository {
  Future<Either<PaymentResponse, Failure>> payProvider(
      PaymentRequest paymentRequest);
}
