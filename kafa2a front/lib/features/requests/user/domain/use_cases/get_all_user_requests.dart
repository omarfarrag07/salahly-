import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/domain/repository/user_requests_repository.dart';

@injectable
class GetAllUserRequests {
  final UserRequestsRepository _userRequestsRepository;
  GetAllUserRequests(this._userRequestsRepository);
  Future<Either<List<AllRequests>, Failure>> call({String status = ""}) =>
      _userRequestsRepository.getAllRequests(status: status);
}
