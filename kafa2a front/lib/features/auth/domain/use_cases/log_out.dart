import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/log_out_response.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@singleton
class LogOut {
  final AuthRepository _authRepository;

  LogOut(this._authRepository);

  Future<Either<LogOutResponse, Failure>> call() => _authRepository.logOut();
}
