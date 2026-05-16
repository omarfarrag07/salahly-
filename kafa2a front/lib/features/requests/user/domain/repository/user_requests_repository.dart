import 'package:dartz/dartz.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';

abstract class UserRequestsRepository {
  Future<Either<List<PendingRequests>, Failure>> getAllPendingRequests();
  Future<Either<GetAllUserAcceptedOffers, Failure>> getAllAcceptedOffers();
  Future<Either<List<AllRequests>, Failure>> getAllRequests(
      {String status = ""});
}
