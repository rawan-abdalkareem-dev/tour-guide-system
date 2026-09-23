import 'package:equatable/equatable.dart';

/// User domain model representing an authenticated user
class UserModel extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String createdAt;
  final List<String> favorites;
  final List<Map<String, dynamic>> bookings;
  final Map<String, dynamic> settings;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.favorites = const [],
    this.bookings = const [],
    this.settings = const {},
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'uid':
        return uid;
      case 'name':
        return name;
      case 'email':
        return email;
      case 'createdAt':
        return createdAt;
      case 'favorites':
        return favorites;
      case 'bookings':
        return bookings;
      case 'settings':
        return settings;
      default:
        return null;
    }
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      createdAt: map['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      favorites: (map['favorites'] is List)
          ? List<String>.from(map['favorites'] as List)
          : const [],
      bookings: (map['bookings'] is List)
          ? (map['bookings'] as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList()
          : const [],
      settings: (map['settings'] is Map)
          ? Map<String, dynamic>.from(map['settings'] as Map)
          : const {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'favorites': favorites,
      'bookings': bookings,
      'settings': settings,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? createdAt,
    List<String>? favorites,
    List<Map<String, dynamic>>? bookings,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      favorites: favorites ?? this.favorites,
      bookings: bookings ?? this.bookings,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [uid, email, name, createdAt];
}
