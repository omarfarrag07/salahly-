import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/home/provider/data/data_source/provider_offers_remote_data_source.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';
import 'package:kafa2a/features/home/provider/domain/repository/provider_offers_repository.dart';

@LazySingleton(as: ProviderOffersRepository)
class ProviderOffersRepositoryImpl implements ProviderOffersRepository {
  final ProviderOffersRemoteDataSource _providerOffersRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  ProviderOffersRepositoryImpl(
      this._providerOffersRemoteDataSource, this._authLocalDataSource);

  @override
  Future<Either<List<AllProviderRequests>, Failure>> getAllRequests() async {
    try {
      final List<AllProviderRequests> result =
          await _providerOffersRemoteDataSource
              .getAllRequests(_authLocalDataSource.getToken());
      return Left(result);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<SendOfferResponse, Failure>> sendOffer(
      SendOfferRequest sendOfferRequest) async {
    try {
      final SendOfferResponse result = await _providerOffersRemoteDataSource
          .sendOffer(_authLocalDataSource.getToken(), sendOfferRequest);
      return Left(result);
    } on AppException catch (exception) {
      return Right(
        Failure(exception.message),
      );
    }
  }

  @override
  Future<Either<void, Failure>> completeRequest(int requestId) async {
    try {
      await _providerOffersRemoteDataSource.completeRequest(
        _authLocalDataSource.getToken(),
        requestId,
      );
      return const Left(null);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
