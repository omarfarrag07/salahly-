import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';

abstract class UserRequestsStates {}

class UserRequestsInitial extends UserRequestsStates {}

class UserPendingRequestsLoading extends UserRequestsStates {}

class UserPendingRequestsError extends UserRequestsStates {
  final String error;
  UserPendingRequestsError(this.error);
}

class UserPendingRequestsSuccess extends UserRequestsStates {
  final List<AllRequests> pendingRequests;
  UserPendingRequestsSuccess(this.pendingRequests);
}

class AllUserRequestsLoading extends UserRequestsStates {}

class AllUserRequestsError extends UserRequestsStates {
  final String error;
  AllUserRequestsError(this.error);
}

class AllUserRequestsSuccess extends UserRequestsStates {
  final List<PendingRequests> pendingRequests;
  AllUserRequestsSuccess(this.pendingRequests);
}

class UserAcceptedRequestsLoading extends UserRequestsStates {}

class UserAcceptedRequestsError extends UserRequestsStates {
  final String error;
  UserAcceptedRequestsError(this.error);
}

class UserAcceptedRequestsSuccess extends UserRequestsStates {
  final GetAllUserAcceptedOffers getAllUserAcceptedOffers;
  UserAcceptedRequestsSuccess(this.getAllUserAcceptedOffers);
}
