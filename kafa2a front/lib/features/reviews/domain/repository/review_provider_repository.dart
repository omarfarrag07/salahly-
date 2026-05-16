import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_response.dart';

abstract class ReviewProviderRepository {
  Future<Either<ReviewProviderResponse, Failure>> reviewProvider(
      ReviewProviderRequest reviewProvider);
}
