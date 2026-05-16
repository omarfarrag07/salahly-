import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/reviews/data/data_source/review_provider_remote_data_source.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_response.dart';
import 'package:kafa2a/features/reviews/domain/repository/review_provider_repository.dart';

@Injectable(as: ReviewProviderRepository)
class ReviewProviderRepostioryImpl implements ReviewProviderRepository {
  final ReviewProviderRemoteDataSource _reviewProviderRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  ReviewProviderRepostioryImpl(
      this._reviewProviderRemoteDataSource, this._authLocalDataSource);
  @override
  Future<Either<ReviewProviderResponse, Failure>> reviewProvider(
      ReviewProviderRequest reviewProvider) async {
    try {
      final response = await _reviewProviderRemoteDataSource.reviewProvider(
          reviewProvider, _authLocalDataSource.getToken());
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
