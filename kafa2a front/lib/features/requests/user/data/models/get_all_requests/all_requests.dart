import 'package:kafa2a/core/models/user_model.dart';
import 'service_details.dart';

class AllRequests {
  int id;
  int userId;
  int serviceId;
  String title;
  String description;
  String lat;
  String lng;
  dynamic address;
  String price;
  String scheduledAt;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  ServiceDetails service;
  UserModel user;

  AllRequests({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.address,
    required this.price,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    required this.user,
  });

  factory AllRequests.fromJson(Map<String, dynamic> json) => AllRequests(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        serviceId: json['service_id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        lat: json['lat'] as String,
        lng: json['lng'] as String,
        address: json['address'] as dynamic,
        price: json['price'] as String,
        scheduledAt: json['scheduled_at'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        service:
            ServiceDetails.fromJson(json['service'] as Map<String, dynamic>),
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}
