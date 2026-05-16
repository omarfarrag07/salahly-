import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/messages.dart';
import 'package:kafa2a/features/payment/data/data_sources/payment_remote_data_source.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';

@Injectable(as: PaymentRemoteDataSource)
class PaymentApiDataSource implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentApiDataSource(this._dio);

  @override
  Future<PaymentResponse> payProvider(
      PaymentRequest paymentRequest, String token) async {
    try {
      final Response response = await _dio.post(ApiConstants.paymentEndPoint,
          data: paymentRequest.toJson(),
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: {'Authorization': 'Bearer $token'},
          ));

      return PaymentResponse.fromJson(response.data);
    } catch (exception) {
      String errorMessage = Messages.somethingWentWrong;
      if (exception is DioException) {
        errorMessage = exception.response?.data['message'] ?? errorMessage;
      }
      throw (RemoteException(errorMessage));
    }
  }
}
