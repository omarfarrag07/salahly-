import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kafa2a/core/error/failure.dart';
import 'package:kafa2a/features/payment/data/models/payment_request.dart';
import 'package:kafa2a/features/payment/data/models/payment_response/payment_response.dart';
import 'package:kafa2a/features/payment/domain/use_cases/pay_provider.dart';
import 'package:kafa2a/features/payment/presentation/cubit/payment_states.dart';

@injectable
class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit(this._payProvider) : super(PaymentInitialState());

  final PayProvider _payProvider;

  Future<void> payProvider(PaymentRequest paymentRequest) async {
    emit(PaymentLoadingState());
    final Either<PaymentResponse, Failure> result =
        await _payProvider(paymentRequest);
    result.fold(
      (_) {
        emit(PaymentSuccessState());
      },
      (failure) {
        emit(PaymentErrorState(failure.message));
      },
    );
  }
}
