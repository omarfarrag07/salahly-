import 'package:kafa2a/core/models/service_model.dart';
import 'package:kafa2a/core/models/user_model.dart';

class PendingRequests {
  final int id;
  final int userId;
  final int serviceId;
  final dynamic title;
  final String description;
  final String location;
  final String price;
  final String scheduledAt;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ServiceModel service;
  final UserModel user;

  PendingRequests({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.description,
    required this.location,
    required this.price,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    required this.user,
  });

  factory PendingRequests.fromJson(Map<String, dynamic> json) =>
      PendingRequests(
        id: json['id'] as int,
        userId: json['user_id'] as int,
        serviceId: json['service_id'] as int,
        title: json['title'] as dynamic,
        description: json['description'] as String,
        location: json['location'] as String,
        price: json['price'] as String,
        scheduledAt: json['scheduled_at'] as String,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        service: ServiceModel.fromJson(json['service'] as Map<String, dynamic>),
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}
