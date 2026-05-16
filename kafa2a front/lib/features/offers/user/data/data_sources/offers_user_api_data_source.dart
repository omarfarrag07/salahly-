import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/offers/user/data/data_sources/offers_user_remote_data_source.dart';
import 'package:kafa2a/features/offers/user/data/models/accept_offer_response/accept_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/cancel_request_response.dart';
import 'package:kafa2a/features/offers/user/data/models/offers_response/offers_response.dart';
import 'package:kafa2a/features/offers/user/data/models/reject_offer_response/reject_offer_response.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';

@Injectable(as: OffersUserRemoteDataSource)
class OffersUserApiDataSource implements OffersUserRemoteDataSource {
  final Dio _dio;
  OffersUserApiDataSource(this._dio);
  @override
  Future<AcceptOfferResponse> acceptOffer(String token, int offerId) async {
    try {
      final Response response =
          await _dio.post(ApiConstants.acceptOffer(offerId),
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ));
      return AcceptOfferResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.somethingWentWrong;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<CancelRequestResponse> cancelRequest(
      String token, int serviceId) async {
    try {
      final Response response =
          await _dio.delete(ApiConstants.getOffers(serviceId),
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ));
      return CancelRequestResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.somethingWentWrong;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<List<Offers>> getOffers(String token, int serviceId) async {
    try {
      final Response response =
          await _dio.get(ApiConstants.getOffers(serviceId),
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ));
      OffersResponse userOffersResponse =
          OffersResponse.fromJson(response.data);
      if (userOffersResponse.offers != null) {
        List<Offers> offers = userOffersResponse.offers!;
        return offers;
      }
      throw (RemoteException(Messages.noOffersAtTheMoment));
    } catch (exception) {
      String errorMessage = Messages.noOffersAtTheMoment;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }

  @override
  Future<RejectOfferResponse> rejectOffer(String token, int offerId) async {
    try {
      final Response response =
          await _dio.post(ApiConstants.rejectOffer(offerId),
              options: Options(
                headers: {'Authorization': 'Bearer $token'},
              ));
      return RejectOfferResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.somethingWentWrong;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }
}
