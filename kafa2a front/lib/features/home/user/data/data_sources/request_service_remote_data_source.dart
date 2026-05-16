import 'package:kafa2a/features/home/user/data/models/request_service_request.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_response.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';

abstract class RequestServiceRemoteDataSource {
  Future<List<Category>> getAllCategories();

  void getAllServices(String token, String category);

  Future<RequestServiceResponse> requestService(
      String token, RequestServiceRequest requestService);
}
