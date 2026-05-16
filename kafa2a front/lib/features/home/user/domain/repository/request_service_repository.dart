import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_request.dart';
import 'package:kafa2a/features/home/user/data/models/request_service_response.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';

abstract class RequestServiceRepository {
  Future<Either<RequestServiceResponse, Failure>> requestService(
      RequestServiceRequest requestService);
  Future<Either<List<Category>, Failure>> getAllCategories();
}
