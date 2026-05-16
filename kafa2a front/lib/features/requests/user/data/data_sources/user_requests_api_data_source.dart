import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/requests/user/data/data_sources/user_requests_remote_data_source.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/get_all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/get_all_user_pending_requests_response.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';

@LazySingleton(as: UserRequestsRemoteDataSource)
class UserRequestsApiDataSource implements UserRequestsRemoteDataSource {
  const UserRequestsApiDataSource(this._dio);
  final Dio _dio;
  @override
  Future<GetAllUserAcceptedOffers> getAllAcceptedOffers(String token) async {
    try {
      final Response response = await _dio.get(
          ApiConstants.getAcceptedUserOffers,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      return GetAllUserAcceptedOffers.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.failedToGetAcceptedOffers;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }

  @override
  Future<List<PendingRequests>> getAllPendingRequests(String token) async {
    try {
      final Response response = await _dio.get(
          ApiConstants.getAllPendingUserRequests,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      GetAllUserPendingRequestsResponse pendingResponse =
          GetAllUserPendingRequestsResponse.fromJson(response.data);
      if (pendingResponse.data == null) {
        throw RemoteException(Messages.noPendingRequetsAtTheMoment);
      }
      List<PendingRequests> pendingRequests = pendingResponse.data!;
      return pendingRequests;
    } catch (exception) {
      String errorMessage = Messages.failedToGetPendingRequests;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }

  @override
  Future<List<AllRequests>> getAllRequests(String token,
      {String status = ""}) async {
    try {
      final Response response = await _dio.get(ApiConstants.getAllUserRequests,
          queryParameters: {
            if (status.isNotEmpty) 'status': status,
          },
          options: Options(headers: {"Authorization": "Bearer $token"}));
      GetAllRequests allRequests = GetAllRequests.fromJson(response.data);
      if (allRequests.data == null) {
        throw RemoteException(Messages.noPendingRequetsAtTheMoment);
      }
      List<AllRequests> pendingRequests = allRequests.data!;
      return pendingRequests;
    } catch (exception) {
      String errorMessage = Messages.failedToGetPendingRequests;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw RemoteException(errorMessage);
    }
  }
}
