import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/reviews/data/data_source/review_provider_remote_data_source.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_response.dart';

@Injectable(as: ReviewProviderRemoteDataSource)
class ReviewProviderApiDataSource implements ReviewProviderRemoteDataSource {
  final Dio _dio;
  ReviewProviderApiDataSource(this._dio);
  @override
  Future<ReviewProviderResponse> reviewProvider(
      ReviewProviderRequest reviewProvider, String token) async {
    try {
      final Response response =
          await _dio.post(ApiConstants.reviewProviderEndPoint,
              data: reviewProvider.toJson(),
              options: Options(
                contentType: Headers.formUrlEncodedContentType,
                headers: {'Authorization': 'Bearer $token'},
              ));
      return ReviewProviderResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.somethingWentWrong;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }
}
