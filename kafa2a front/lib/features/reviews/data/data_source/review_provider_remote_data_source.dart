import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_response.dart';

abstract class ReviewProviderRemoteDataSource {
  Future<ReviewProviderResponse> reviewProvider(
      ReviewProviderRequest paymentRequest, String token);
}
