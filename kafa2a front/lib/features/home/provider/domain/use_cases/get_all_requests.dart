import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/domain/repository/provider_offers_repository.dart';

@singleton
class GetAllRequests {
  final ProviderOffersRepository _providerOffersRepository;

  GetAllRequests(this._providerOffersRepository);

  Future<Either<List<AllProviderRequests>, Failure>> call() async {
    return await _providerOffersRepository.getAllRequests();
  }
}
