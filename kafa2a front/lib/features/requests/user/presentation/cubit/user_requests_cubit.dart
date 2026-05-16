import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/domain/use_cases/get_accepted_requests.dart';
import 'package:kafa2a/features/requests/user/domain/use_cases/get_all_user_requests.dart';
import 'package:kafa2a/features/requests/user/presentation/cubit/user_requests_states.dart';

@injectable
class UserRequestsCubit extends Cubit<UserRequestsStates> {
  UserRequestsCubit(this._getAcceptedRequests, this._getAllUserRequests)
      : super(UserRequestsInitial()) {
    getAllRequests();
  }
  final GetAllUserRequests _getAllUserRequests;
  final GetAcceptedRequests _getAcceptedRequests;

  Future<void> getAllRequests({String status = ""}) async {
    if (!isClosed) {
      emit(UserPendingRequestsLoading());
    }
    final Either<List<AllRequests>, Failure> result =
        await _getAllUserRequests(status: status);
    result.fold((success) {
      if (!isClosed) {
        emit(UserPendingRequestsSuccess(success));
      }
    }, (error) {
      if (!isClosed) {
        emit(UserPendingRequestsError(error.message));
      }
    });
  }

  Future<void> getAcceptedRequests() async {
    emit(UserPendingRequestsLoading());
    final Either<GetAllUserAcceptedOffers, Failure> result =
        await _getAcceptedRequests();
    result.fold((success) => emit(UserAcceptedRequestsSuccess(success)),
        (error) => emit(UserAcceptedRequestsError(error.message)));
  }
}
