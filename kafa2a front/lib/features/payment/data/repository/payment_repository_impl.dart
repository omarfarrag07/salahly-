import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/payment/data/data_sources/payment_remote_data_source.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';
import 'package:kafa2a/features/payment/domain/repository/payment_repository.dart';

@Injectable(as: PaymentRepository)
class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(
      this._paymentRemoteDataSource, this._authLocalDataSource);

  final PaymentRemoteDataSource _paymentRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  @override
  Future<Either<PaymentResponse, Failure>> payProvider(
      PaymentRequest paymentRequest) async {
    try {
      final PaymentResponse response = await _paymentRemoteDataSource
          .payProvider(paymentRequest, _authLocalDataSource.getToken());
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
