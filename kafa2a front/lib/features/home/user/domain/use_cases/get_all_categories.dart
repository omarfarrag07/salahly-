import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/user/domain/entities/category.dart';
import 'package:kafa2a/features/home/user/domain/repository/request_service_repository.dart';

@injectable
class GetAllCategories {
  final RequestServiceRepository _requestRepository;
  GetAllCategories(this._requestRepository);

  Future<Either<List<Category>, Failure>> call() =>
      _requestRepository.getAllCategories();
}
