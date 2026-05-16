import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';
import 'package:kafa2a/features/requests/user/domain/repository/user_requests_repository.dart';

@lazySingleton
class GetPendingRequests {
  final UserRequestsRepository _userRequestsRepository;
  GetPendingRequests(this._userRequestsRepository);
  Future<Either<List<PendingRequests>, Failure>> call() =>
      _userRequestsRepository.getAllPendingRequests();
}
