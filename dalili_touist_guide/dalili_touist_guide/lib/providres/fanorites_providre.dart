import 'package:flutter/material.dart';
import '../core/storage/preferences_service.dart';
import '../models/place_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;
  String _currentUserId;
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;
  List<Place> get favoritePlaces =>
      _favorites.map((p) => Place.fromMap(p)).toList();
  int get favoritesCount => _favorites.length;
  String get currentUserId => _currentUserId;

  FavoritesProvider({FavoritesRepository? repository, String? initialUserId})
      : _repository = repository ?? const FavoritesRepository(),
        _currentUserId = initialUserId ?? PreferencesService.currentUserUid ?? 'guest' {
    _loadFavoritesFromRepository();
  }

  /// Switch user and reload favorites
  void updateUser(String? userId) {
    final newId = (userId == null || userId.trim().isEmpty) ? 'guest' : userId.trim();
    if (_currentUserId != newId) {
      _currentUserId = newId;
      _loadFavoritesFromRepository();
      notifyListeners();
    }
  }

  void _loadFavoritesFromRepository() {
    try {
      final places = _repository.getFavoritePlaces(userId: _currentUserId);
      _favorites.clear();
      for (final place in places) {
        _favorites.add(place.toMap());
      }
    } catch (_) {
      _favorites.clear();
    }
  }

  void reloadFromStorage() {
    _loadFavoritesFromRepository();
    notifyListeners();
  }

  bool _matches(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a['id'] != null && b['id'] != null) {
      return a['id'] == b['id'];
    }
    return a['name'] == b['name'];
  }

  bool isFavorite(Map<String, dynamic> place) {
    return _favorites.any((fav) => _matches(fav, place));
  }

  bool isFavoriteById(String placeId) {
    return _repository.isFavorite(placeId, userId: _currentUserId);
  }

  Future<void> toggleFavorite(Map<String, dynamic> place) async {
    final placeId = place['id']?.toString();
    if (isFavorite(place)) {
      await removeFavorite(place);
    } else {
      _favorites.add(place);
      notifyListeners();
      if (placeId != null) {
        await _repository.addFavorite(placeId, userId: _currentUserId);
      }
    }
  }

  Future<void> removeFavorite(Map<String, dynamic> place) async {
    final placeId = place['id']?.toString();
    _favorites.removeWhere((fav) => _matches(fav, place));
    notifyListeners();
    if (placeId != null) {
      await _repository.removeFavorite(placeId, userId: _currentUserId);
    }
  }

  Future<void> removeFavoriteById(String placeId) async {
    _favorites.removeWhere((fav) => fav['id'] == placeId);
    notifyListeners();
    await _repository.removeFavorite(placeId, userId: _currentUserId);
  }

  Future<void> clearFavorites() async {
    _favorites.clear();
    notifyListeners();
    await _repository.clearFavorites(userId: _currentUserId);
  }
}
