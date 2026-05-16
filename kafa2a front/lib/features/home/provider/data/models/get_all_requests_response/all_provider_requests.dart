import 'package:kafa2a/core/models/user_model.dart';
import 'package:kafa2a/features/requests/user/data/models/service_model.dart';

class AllProviderRequests {
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
  bool hasOffered;
  DateTime createdAt;
  DateTime updatedAt;
  UserModel user;
  ServiceModel? service;

  AllProviderRequests({
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
    required this.hasOffered,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.service,
  });

  factory AllProviderRequests.fromJson(Map<String, dynamic> json) {
    return AllProviderRequests(
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
      hasOffered: json["has_offered"] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      service: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }
}
