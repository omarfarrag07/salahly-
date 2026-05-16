class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.phone,
  });

  final int id;
  final String email;
  final String name;
  final String phone;
  final String type;
}
