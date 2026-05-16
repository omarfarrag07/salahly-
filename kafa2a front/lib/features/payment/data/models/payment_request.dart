class PaymentRequest {
  PaymentRequest({
    required this.amount,
    required this.gateway,
    required this.serviceRequestId,
    required this.userId,
  });

  final int amount;
  final String gateway;
  final int serviceRequestId;
  final int userId;

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'gateway': gateway,
        'service_request_id': serviceRequestId,
        'user_id': userId
      };
}
