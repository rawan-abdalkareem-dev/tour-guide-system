import 'package:equatable/equatable.dart';

/// Place domain model representing a tourist attraction or restaurant
class Place extends Equatable {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String image;
  final double rating;
  final String category;
  final String categoryEn;
  final String location;
  final double latitude;
  final double longitude;
  final String openingHours;
  final String phone;
  final String website;
  final String price;
  final int reviews;
  final List<String> images;

  const Place({
    required this.id,
    required this.name,
    this.nameEn = '',
    this.description = '',
    required this.image,
    this.rating = 0.0,
    required this.category,
    this.categoryEn = '',
    required this.location,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.openingHours = '',
    this.phone = '',
    this.website = '',
    this.price = '',
    this.reviews = 0,
    this.images = const [],
  });

  /// Alias for image
  String get imageUrl => image;

  /// Backward-compatibility accessor for existing Map subscript usage
  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'nameEn':
        return nameEn;
      case 'description':
        return description;
      case 'image':
      case 'imageUrl':
        return image;
      case 'rating':
        return rating;
      case 'category':
        return category;
      case 'categoryEn':
        return categoryEn;
      case 'location':
        return location;
      case 'latitude':
        return latitude;
      case 'longitude':
        return longitude;
      case 'openingHours':
        return openingHours;
      case 'phone':
        return phone;
      case 'website':
        return website;
      case 'price':
        return price;
      case 'reviews':
        return reviews;
      case 'images':
        return images;
      default:
        return null;
    }
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nameEn: map['nameEn']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      image: map['image']?.toString() ?? map['imageUrl']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      category: map['category']?.toString() ?? '',
      categoryEn: map['categoryEn']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      openingHours: map['openingHours']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      website: map['website']?.toString() ?? '',
      price: map['price']?.toString() ?? '',
      reviews: (map['reviews'] as num?)?.toInt() ?? 0,
      images: (map['images'] is List)
          ? List<String>.from(map['images'] as List)
          : const [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'description': description,
      'image': image,
      'imageUrl': image,
      'rating': rating,
      'category': category,
      'categoryEn': categoryEn,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'openingHours': openingHours,
      'phone': phone,
      'website': website,
      'price': price,
      'reviews': reviews,
      'images': images,
    };
  }

  Place copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? description,
    String? image,
    double? rating,
    String? category,
    String? categoryEn,
    String? location,
    double? latitude,
    double? longitude,
    String? openingHours,
    String? phone,
    String? website,
    String? price,
    int? reviews,
    List<String>? images,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      categoryEn: categoryEn ?? this.categoryEn,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      price: price ?? this.price,
      reviews: reviews ?? this.reviews,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        rating,
        category,
        location,
        latitude,
        longitude,
        price,
        reviews,
      ];
}
