import 'package:kafa2a/core/models/user_model.dart';
import 'service_request.dart';

class Offers {
  int id;
  int serviceRequestId;
  int providerId;
  String price;
  dynamic message;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel provider;
  ServiceRequest serviceRequest;

  Offers({
    required this.id,
    required this.serviceRequestId,
    required this.providerId,
    required this.price,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.provider,
    required this.serviceRequest,
  });

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        id: json['id'] as int,
        serviceRequestId: json['service_request_id'] as int,
        providerId: json['provider_id'] as int,
        price: json['price'] as String,
        message: json['message'] as dynamic,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        provider: UserModel.fromJson(json['provider'] as Map<String, dynamic>),
        serviceRequest: ServiceRequest.fromJson(
            json['service_request'] as Map<String, dynamic>),
      );
}
