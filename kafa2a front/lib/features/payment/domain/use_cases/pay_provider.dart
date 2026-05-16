import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';
import 'package:kafa2a/features/payment/domain/repository/payment_repository.dart';

@injectable
class PayProvider {
  final PaymentRepository _paymentRepository;

  PayProvider(this._paymentRepository);

  Future<Either<PaymentResponse, Failure>> call(
          PaymentRequest paymentRequest) =>
      _paymentRepository.payProvider(paymentRequest);
}
