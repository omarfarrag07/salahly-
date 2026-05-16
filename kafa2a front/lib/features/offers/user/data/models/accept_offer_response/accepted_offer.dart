class AcceptedOffer {
  int offerId;
  int serviceRequestId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  AcceptedOffer({
    required this.offerId,
    required this.serviceRequestId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AcceptedOffer.fromJson(Map<String, dynamic> json) => AcceptedOffer(
        offerId: json['offer_id'] as int,
        serviceRequestId: json['service_request_id'] as int,
        updatedAt: DateTime.parse(json['updated_at'] as String),
        createdAt: DateTime.parse(json['created_at'] as String),
        id: json['id'] as int,
      );
}
