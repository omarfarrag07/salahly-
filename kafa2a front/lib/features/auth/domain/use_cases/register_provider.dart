import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/auth/data/models/register_provider_request.dart';
import 'package:kafa2a/features/auth/domain/entities/provider.dart';
import 'package:kafa2a/features/auth/domain/repository/auth_repository.dart';

@singleton
class RegisterProvider {
  RegisterProvider(this._authRepository);

  final AuthRepository _authRepository;

  Future<Either<Provider, Failure>> call(
          RegisterProviderRequest registerProviderRequest) =>
      _authRepository.registerProvider(registerProviderRequest);
}
