import '../core/storage/sqlite_service.dart';
import '../models/category.dart';
import '../models/place.dart';
import 'app_initial_data.dart';

export 'app_initial_data.dart';

/// Facade for Places data access, delegating initial seed data to [AppInitialData]
/// and runtime queries to [SQLiteService].
class PlacesData {
  PlacesData._();

  /// Retrieve initial raw place maps from the central initial data repository
  static List<Map<String, dynamic>> getInitialRawPlaces() =>
      AppInitialData.getInitialRawPlaces();

  /// Retrieve initial category entities from the central initial data repository
  static List<Category> getInitialRawCategories() =>
      AppInitialData.getInitialCategories();

  /// Retrieve all dynamic places from SQLite storage
  static List<Map<String, dynamic>> getAllPlaces() =>
      SQLiteService.getAllPlaces();

  /// Find a specific place map by ID
  static Map<String, dynamic> getPlaceById(String id) {
    final list = getAllPlaces();
    try {
      return list.firstWhere((place) => place['id'] == id);
    } catch (_) {
      return list.isNotEmpty ? list.first : {};
    }
  }

  /// Filter place maps by category name
  static List<Map<String, dynamic>> getPlacesByCategory(String category) {
    return getAllPlaces()
        .where((place) => place['category'] == category)
        .toList();
  }

  /// Get place count for a given category
  static int getCategoryCount(String category) {
    return getPlacesByCategory(category).length;
  }

  /// Retrieve all typed [Place] models from SQLite storage
  static List<Place> getPlaces() => SQLiteService.getPlaces();

  /// Find typed [Place] model by ID
  static Place? findPlaceById(String id) => SQLiteService.getPlaceById(id);

  /// Filter typed [Place] models by category name
  static List<Place> getTypedPlacesByCategory(String category) {
    return getPlaces().where((p) => p.category == category).toList();
  }

  /// Retrieve all categories from SQLite storage
  static List<Category> getCategories() => SQLiteService.getCategories();
}
