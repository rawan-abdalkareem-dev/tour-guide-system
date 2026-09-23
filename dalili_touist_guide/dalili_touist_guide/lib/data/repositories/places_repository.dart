import '../../core/storage/sqlite_service.dart';
import '../../models/category.dart';
import '../../models/place.dart';

/// Repository handling persistent access and CMS operations for places and categories
/// Powered 100% by SQLite Relational Database Engine
class PlacesRepository {
  const PlacesRepository();

  /// Retrieve all places as strongly typed [Place] models
  List<Place> getAllPlaces() {
    return SQLiteService.getPlaces();
  }

  /// Find a specific place by its unique ID
  Place? getPlaceById(String id) {
    return SQLiteService.getPlaceById(id);
  }

  /// Filter places by their Arabic category name
  List<Place> getPlacesByCategory(String category) {
    return getAllPlaces().where((p) => p.category == category).toList();
  }

  /// Search places by Arabic or English name, location, or category
  List<Place> searchPlaces(String query) {
    if (query.trim().isEmpty) return getAllPlaces();
    final lower = query.toLowerCase().trim();
    return getAllPlaces().where((place) {
      return place.name.toLowerCase().contains(lower) ||
          place.nameEn.toLowerCase().contains(lower) ||
          place.location.toLowerCase().contains(lower) ||
          place.category.toLowerCase().contains(lower);
    }).toList();
  }

  /// Save or update a place (CMS action)
  Future<void> savePlace(Place place) async {
    await SQLiteService.savePlace(place);
  }

  /// Delete a place by its ID (CMS action)
  Future<void> deletePlace(String id) async {
    await SQLiteService.deletePlace(id);
  }

  // ==========================================
  // Categories
  // ==========================================

  /// Retrieve all available categories with current place counts
  List<Category> getCategories() {
    final categories = SQLiteService.getCategories();
    final allPlaces = getAllPlaces();

    // Recompute live count for each category
    return categories.map((cat) {
      final count = allPlaces.where((p) => p.category == cat.name).length;
      return cat.copyWith(count: count);
    }).toList();
  }

  /// Retrieve the number of places in a given category
  int getCategoryCount(String category) {
    return getAllPlaces().where((p) => p.category == category).length;
  }

  /// Save or update a category (CMS action)
  Future<void> saveCategory(Category category) async {
    await SQLiteService.saveCategory(category);
  }

  /// Delete a category by its ID (CMS action)
  Future<void> deleteCategory(String id) async {
    await SQLiteService.deleteCategory(id);
  }
}
