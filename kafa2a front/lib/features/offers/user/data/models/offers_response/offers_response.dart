import 'package:kafa2a/core/models/user_model.dart';
import 'package:kafa2a/features/offers/user/data/models/user_offers_response/offers.dart';
import 'service.dart';

class OffersResponse {
  int? id;
  int? userId;
  int? serviceId;
  String? title;
  String? description;
  String? lat;
  String? lng;
  dynamic address;
  String? price;
  String? scheduledAt;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  Service? service;
  List<Offers>? offers;

  OffersResponse({
    this.id,
    this.userId,
    this.serviceId,
    this.title,
    this.description,
    this.lat,
    this.lng,
    this.address,
    this.price,
    this.scheduledAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.service,
    this.offers,
  });

  factory OffersResponse.fromJson(Map<String, dynamic> json) {
    return OffersResponse(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      serviceId: json['service_id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      address: json['address'] as dynamic,
      price: json['price'] as String?,
      scheduledAt: json['scheduled_at'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
      offers: json['offers'] == null
          ? null
          : (json['offers'] as List<dynamic>)
              .map((e) => Offers.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
