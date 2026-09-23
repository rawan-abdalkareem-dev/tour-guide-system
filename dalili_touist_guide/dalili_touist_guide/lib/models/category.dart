import 'package:equatable/equatable.dart';

/// Category domain model representing a classification of tourist places
class Category extends Equatable {
  final String id;
  final String name;
  final String nameEn;
  final String emoji;
  final int count;

  const Category({
    required this.id,
    required this.name,
    this.nameEn = '',
    this.emoji = '',
    this.count = 0,
  });

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'nameEn':
        return nameEn;
      case 'emoji':
        return emoji;
      case 'count':
        return count;
      default:
        return null;
    }
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toString() ?? map['name']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      nameEn: map['nameEn']?.toString() ?? '',
      emoji: map['emoji']?.toString() ?? '📍',
      count: (map['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameEn': nameEn,
      'emoji': emoji,
      'count': count,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? emoji,
    int? count,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [id, name, emoji, count];
}
