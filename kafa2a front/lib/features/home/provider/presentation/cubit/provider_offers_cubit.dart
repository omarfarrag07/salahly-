import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/home/provider/data/models/get_all_requests_response/all_provider_requests.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_request.dart';
import 'package:kafa2a/features/home/provider/data/models/send_offer_response/send_offer_response.dart';
import 'package:kafa2a/features/home/provider/domain/use_cases/get_all_requests.dart';
import 'package:kafa2a/features/home/provider/domain/use_cases/send_offer.dart';
import 'package:kafa2a/features/home/provider/presentation/cubit/provider_offers_states.dart';
import 'package:kafa2a/features/home/provider/domain/repository/provider_offers_repository.dart';

@injectable
class ProviderOffersCubit extends Cubit<ProviderOffersStates> {
  ProviderOffersCubit(
      this._getAllRequests, this._sendOffer, this._providerOffersRepository)
      : super(ProviderOffersInitialState()) {
    getAllRequests();
  }

  final GetAllRequests _getAllRequests;
  final SendOffer _sendOffer;
  final ProviderOffersRepository _providerOffersRepository;

  Future<void> getAllRequests() async {
    emit(
      GetAllRequestsLoadingState(),
    );
    final Either<List<AllProviderRequests>, Failure> result =
        await _getAllRequests();
    result.fold(
      (requests) => emit(
        GetAllRequestsSuccessState(
          requests,
        ),
      ),
      (failure) => emit(
        GetAllRequestsErrorState(
          failure.message,
        ),
      ),
    );
  }

  Future<void> sendOffer(SendOfferRequest sendOfferRequest) async {
    emit(
      SendOfferLoadingState(),
    );
    final Either<SendOfferResponse, Failure> result = await _sendOffer(
      sendOfferRequest,
    );
    result.fold(
      (response) async {
        emit(
          SendOfferSuccessState(response.message!),
        );
      },
      (failure) => emit(
        SendOfferErrorState(failure.message),
      ),
    );
  }

  Future<void> completeRequest(int requestId) async {
    emit(SendOfferLoadingState());
    final result = await _providerOffersRepository.completeRequest(requestId);
    result.fold((_) async {
      await getAllRequests();
      emit(SendOfferSuccessState('Request marked as completed.'));
    }, (failure) {
      emit(SendOfferErrorState(failure.message));
    });
  }
}
