import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';

abstract class UserRequestsRemoteDataSource {
  Future<List<PendingRequests>> getAllPendingRequests(String token);
  Future<GetAllUserAcceptedOffers> getAllAcceptedOffers(String token);
  Future<List<AllRequests>> getAllRequests(String token, {String status = ""});
}
