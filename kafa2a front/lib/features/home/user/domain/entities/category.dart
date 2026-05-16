import 'package:kafa2a/features/home/user/domain/entities/services.dart';

class Category {
  final int id;
  final String name;
  final List<Services> services;
  Category({
    required this.id,
    required this.name,
    required this.services,
  });
}
