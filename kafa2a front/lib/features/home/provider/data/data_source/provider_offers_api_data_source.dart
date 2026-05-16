import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/home/provider/data/data_source/provider_offers_remote_data_source.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';

@LazySingleton(as: ProviderOffersRemoteDataSource)
class ProviderOffersApiDataSource extends ProviderOffersRemoteDataSource {
  final Dio _dio;
  ProviderOffersApiDataSource(this._dio);
  @override
  Future<List<AllProviderRequests>> getAllRequests(String token) async {
    try {
      final Response response = await _dio.get(ApiConstants.getAllRequests,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ));
      List<AllProviderRequests> providerRequests = (response.data as List)
          .map((requests) => AllProviderRequests.fromJson(requests))
          .toList();
      return providerRequests;
    } catch (exception) {
      String errorMessage = Messages.failedToGetRequests;
      if (exception is DioException) {
        errorMessage = exception.response?.data['error'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }

  @override
  Future<SendOfferResponse> sendOffer(
      String token, SendOfferRequest sendOfferRequest) async {
    try {
      final Response response = await _dio.post(
        ApiConstants.sendOffer(sendOfferRequest.offerId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: sendOfferRequest.toJson(),
      );
      return SendOfferResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToSendOffer;
      if (exception is DioException) {
        errorMessage = exception.response?.data['error'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }

  @override
  Future<void> completeRequest(String token, int requestId) async {
    try {
      await _dio.post(
        'service-requests/$requestId/complete',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } catch (exception) {
      String errorMessage = 'Failed to complete request';
      if (exception is DioException) {
        errorMessage = exception.response?.data['error'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }
}
