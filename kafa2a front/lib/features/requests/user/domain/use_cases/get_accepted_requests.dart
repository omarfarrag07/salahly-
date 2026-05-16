import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/domain/repository/user_requests_repository.dart';

@lazySingleton
class GetAcceptedRequests {
  final UserRequestsRepository _userRequestsRepository;
  GetAcceptedRequests(this._userRequestsRepository);
  Future<Either<GetAllUserAcceptedOffers, Failure>> call() =>
      _userRequestsRepository.getAllAcceptedOffers();
}
