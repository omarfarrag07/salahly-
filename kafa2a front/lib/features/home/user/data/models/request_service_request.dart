class RequestServiceRequest {
  int serviceId;
  String? description;
  String scheduledAt;
  int price;
  String title;
  String lat;
  String lng;

  RequestServiceRequest(
      {required this.serviceId,
      required this.description,
      required this.scheduledAt,
      required this.price,
      required this.title,
      required this.lat,
      required this.lng});

  Map<String, dynamic> toJson() => {
        'service_id': serviceId,
        'description': description,
        'lat': lat,
        'lng': lng,
        'scheduled_at': scheduledAt,
        'price': price,
        'title': title,
      };
}
