import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/reviews/data/models/review_provider_request.dart';
import 'package:kafa2a/features/reviews/domain/use_cases/review_provider.dart';
import 'package:kafa2a/features/reviews/presentation/cubit/review_provider_states.dart';

@injectable
class ReviewProviderCubit extends Cubit<ReviewProviderStates> {
  ReviewProviderCubit(this._reviewProvider)
      : super(ReviewProviderInitialState());

  final ReviewProvider _reviewProvider;

  Future<void> reviewProvider(
      ReviewProviderRequest reviewProviderRequest) async {
    emit(ReviewProviderLoadingState());
    final Either<void, Failure> result =
        await _reviewProvider(reviewProviderRequest);
    result.fold(
      (_) {
        emit(ReviewProviderSuccessState());
      },
      (failure) {
        emit(ReviewProviderErrorState(failure.message));
      },
    );
  }
}
