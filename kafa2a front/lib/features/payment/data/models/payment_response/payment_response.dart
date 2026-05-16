import 'payment.dart';

class PaymentResponse {
  String? message;
  Payment? payment;

  PaymentResponse({this.message, this.payment});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      message: json['message'] as String?,
      payment: json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    );
  }
}
