import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_response.dart';
import 'package:kafa2a/features/reviews/domain/repository/review_provider_repository.dart';

@injectable
class ReviewProvider {
  final ReviewProviderRepository _reviewProviderRepository;

  ReviewProvider(this._reviewProviderRepository);

  Future<Either<ReviewProviderResponse, Failure>> call(
          ReviewProviderRequest reviewProvider) =>
      _reviewProviderRepository.reviewProvider(reviewProvider);
}
