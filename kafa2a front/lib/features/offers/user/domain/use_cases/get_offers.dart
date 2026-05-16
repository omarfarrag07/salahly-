import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';
import 'package:kafa2a/features/offers/user/domain/repository/offers_repository.dart';

@lazySingleton
class GetOffers {
  final OffersRepository _offersRepository;
  GetOffers(this._offersRepository);

  Future<Either<List<Offers>, Failure>> call(int serviceId) =>
      _offersRepository.getOffers(serviceId);
}
