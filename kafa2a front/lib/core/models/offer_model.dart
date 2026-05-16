import 'package:kafa2a/core/models/user_model.dart';

class OfferModel {
  int id;
  int serviceRequestId;
  int providerId;
  int price;
  dynamic message;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? provider;

  OfferModel({
    required this.id,
    required this.serviceRequestId,
    required this.providerId,
    required this.price,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.provider,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as int,
        serviceRequestId: json['service_request_id'] as int,
        providerId: json['provider_id'] as int,
        price: json['price'] as int,
        message: json['message'] as dynamic,
        status: json['status'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        provider: json['provider'] == null
            ? null
            : UserModel.fromJson(json['provider'] as Map<String, dynamic>),
      );
}
