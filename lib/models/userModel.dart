import 'dart:convert';

class ItemsModel {
  String token;
  String tokenType;
  int expiresIn;
  User user;

  ItemsModel({
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });
}

class User {
  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  String position;
  String userClass;
  String role;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.position,
    required this.userClass,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });
}
