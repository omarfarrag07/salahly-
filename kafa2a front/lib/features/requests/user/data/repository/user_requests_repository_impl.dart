import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/exceptions.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/data_sources/local/auth_local_data_source.dart';
import 'package:kafa2a/features/requests/user/data/data_sources/user_requests_remote_data_source.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_requests/all_requests.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_accepted_offers/get_all_user_accepted_offers.dart';
import 'package:kafa2a/features/requests/user/data/models/get_all_user_pending_requests_response/pending_requests.dart';
import 'package:kafa2a/features/requests/user/domain/repository/user_requests_repository.dart';

@Injectable(as: UserRequestsRepository)
class UserRequestsRepositoryImpl implements UserRequestsRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final UserRequestsRemoteDataSource _userRequestsRemoteDataSource;
  const UserRequestsRepositoryImpl(
      this._authLocalDataSource, this._userRequestsRemoteDataSource);
  @override
  Future<Either<GetAllUserAcceptedOffers, Failure>>
      getAllAcceptedOffers() async {
    try {
      final GetAllUserAcceptedOffers response =
          await _userRequestsRemoteDataSource
              .getAllAcceptedOffers(_authLocalDataSource.getToken());
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<List<PendingRequests>, Failure>> getAllPendingRequests() async {
    try {
      final List<PendingRequests> response = await _userRequestsRemoteDataSource
          .getAllPendingRequests(_authLocalDataSource.getToken());
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }

  @override
  Future<Either<List<AllRequests>, Failure>> getAllRequests(
      {String status = ""}) async {
    try {
      final List<AllRequests> response = await _userRequestsRemoteDataSource
          .getAllRequests(_authLocalDataSource.getToken(), status: status);
      return Left(response);
    } on AppException catch (exception) {
      return Right(Failure(exception.message));
    }
  }
}
