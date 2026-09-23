import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Booking model representing a customer reservation
class Booking extends Equatable {
  final String id;
  final String userId;
  final String placeId;
  final String placeName;
  final String placeImage;
  final String placeLocation;
  final DateTime bookingDate;
  final DateTime visitDate;
  final int numberOfPeople;
  final double totalPrice;
  final String status; // pending, confirmed, completed, cancelled
  final String notes;
  final String phoneNumber;
  final String email;

  const Booking({
    required this.id,
    this.userId = '',
    this.placeId = '',
    required this.placeName,
    required this.placeImage,
    required this.placeLocation,
    required this.bookingDate,
    required this.visitDate,
    required this.numberOfPeople,
    required this.totalPrice,
    required this.status,
    this.notes = '',
    this.phoneNumber = '',
    this.email = '',
  });

  Booking copyWith({
    String? id,
    String? userId,
    String? placeId,
    String? placeName,
    String? placeImage,
    String? placeLocation,
    DateTime? bookingDate,
    DateTime? visitDate,
    int? numberOfPeople,
    double? totalPrice,
    String? status,
    String? notes,
    String? phoneNumber,
    String? email,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      placeImage: placeImage ?? this.placeImage,
      placeLocation: placeLocation ?? this.placeLocation,
      bookingDate: bookingDate ?? this.bookingDate,
      visitDate: visitDate ?? this.visitDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'placeId': placeId,
      'placeName': placeName,
      'placeImage': placeImage,
      'placeLocation': placeLocation,
      'bookingDate': bookingDate.toIso8601String(),
      'visitDate': visitDate.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'totalPrice': totalPrice,
      'status': status,
      'notes': notes,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: json['userId']?.toString() ?? '',
      placeId: json['placeId'] ?? '',
      placeName: json['placeName'] ?? '',
      placeImage: json['placeImage'] ?? '',
      placeLocation: json['placeLocation'] ?? '',
      bookingDate: DateTime.parse(
          json['bookingDate'] ?? DateTime.now().toIso8601String()),
      visitDate:
          DateTime.parse(json['visitDate'] ?? DateTime.now().toIso8601String()),
      numberOfPeople: json['numberOfPeople'] ?? 1,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      notes: json['notes'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Getter لترجمة الحالة
  String get statusText {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        placeId,
        placeName,
        bookingDate,
        visitDate,
        numberOfPeople,
        totalPrice,
        status,
        phoneNumber,
        email,
      ];
}
