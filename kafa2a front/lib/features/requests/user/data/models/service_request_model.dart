import 'package:kafa2a/features/requests/user/data/models/service_model.dart';
import 'package:kafa2a/features/requests/user/data/models/user_model.dart';

class ServiceRequestModel {
  final int id;
  final int userId;
  final int serviceId;
  final String title;
  final String description;
  final double? lat;
  final double? lng;
  final String? address;
  final String price;
  final String scheduledAt;
  final String status;
  final String createdAt;
  final String updatedAt;
  final ServiceModel service;
  final UserModel user;
  final List<Map<String, dynamic>>? offers;

  ServiceRequestModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.description,
    this.lat,
    this.lng,
    this.address,
    required this.price,
    required this.scheduledAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.service,
    required this.user,
    this.offers,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) {
    return ServiceRequestModel(
      id: json['id'],
      userId: json['user_id'],
      serviceId: json['service_id'],
      title: json['title'],
      description: json['description'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      address: json['address'],
      price: json['price'],
      scheduledAt: json['scheduled_at'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      service: ServiceModel.fromJson(json['service']),
      user: UserModel.fromJson(json['user']),
      offers: json['offers'] != null
          ? List<Map<String, dynamic>>.from(json['offers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'title': title,
      'description': description,
      'lat': lat,
      'lng': lng,
      'address': address,
      'price': price,
      'scheduled_at': scheduledAt,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'service': service.toJson(),
      'user': user.toJson(),
      'offers': offers,
    };
  }
}
