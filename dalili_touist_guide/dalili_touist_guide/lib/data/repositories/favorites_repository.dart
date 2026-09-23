import '../../core/storage/sqlite_service.dart';
import '../../models/place.dart';
import 'places_repository.dart';

/// Repository managing user favorite places with SQLite relational storage
class FavoritesRepository {
  final PlacesRepository _placesRepository;

  const FavoritesRepository({PlacesRepository? placesRepository})
      : _placesRepository = placesRepository ?? const PlacesRepository();

  /// Retrieve all favorite place IDs for a user (or guest)
  List<String> getFavoriteIds({String userId = 'guest'}) {
    return SQLiteService.getUserFavoriteIds(userId);
  }

  /// Retrieve the list of all favorited places as [Place] domain models for a user
  List<Place> getFavoritePlaces({String userId = 'guest'}) {
    final ids = getFavoriteIds(userId: userId);
    final allPlaces = _placesRepository.getAllPlaces();
    final idSet = ids.toSet();
    return allPlaces.where((place) => idSet.contains(place.id)).toList();
  }

  /// Check whether a place is marked as favorite for a user
  bool isFavorite(String placeId, {String userId = 'guest'}) {
    return SQLiteService.isUserFavorite(userId, placeId);
  }

  /// Add a place to favorites for a user
  Future<void> addFavorite(String placeId, {String userId = 'guest'}) async {
    await SQLiteService.addUserFavorite(userId, placeId);
  }

  /// Remove a place from favorites for a user
  Future<void> removeFavorite(String placeId, {String userId = 'guest'}) async {
    await SQLiteService.removeUserFavorite(userId, placeId);
  }

  /// Toggle favorite status for a place. Returns true if now favorite, false if removed.
  Future<bool> toggleFavorite(String placeId, {String userId = 'guest'}) async {
    if (isFavorite(placeId, userId: userId)) {
      await removeFavorite(placeId, userId: userId);
      return false;
    } else {
      await addFavorite(placeId, userId: userId);
      return true;
    }
  }

  /// Clear all saved favorites for a user
  Future<void> clearFavorites({String userId = 'guest'}) async {
    await SQLiteService.clearUserFavorites(userId);
  }
}
