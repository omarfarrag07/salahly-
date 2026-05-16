import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/constants.dart';
import 'package:kafa2a/core/local_data_source/local_data_source.dart';
import 'package:kafa2a/features/requests/user/data/models/service_requests_response.dart';

abstract class ServiceRequestsRemoteDataSource {
  Future<ServiceRequestsResponse> getAllServiceRequests();
  Future<ServiceRequestsResponse> getServiceRequestById(int id);
}

@Injectable(as: ServiceRequestsRemoteDataSource)
class ServiceRequestsRemoteDataSourceImpl
    implements ServiceRequestsRemoteDataSource {
  final Dio _dio;
  final LocalDataSource _localDataSource;

  ServiceRequestsRemoteDataSourceImpl(this._dio, this._localDataSource);

  @override
  Future<ServiceRequestsResponse> getAllServiceRequests() async {
    try {
      final token = await _localDataSource.getToken();
      final response = await _dio.get(
        ApiConstants.getAllUserRequests,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return ServiceRequestsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get service requests: $e');
    }
  }

  @override
  Future<ServiceRequestsResponse> getServiceRequestById(int id) async {
    try {
      final token = await _localDataSource.getToken();
      final response = await _dio.get(
        '${ApiConstants.getAllUserRequests}/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return ServiceRequestsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get service request by id: $e');
    }
  }
}
