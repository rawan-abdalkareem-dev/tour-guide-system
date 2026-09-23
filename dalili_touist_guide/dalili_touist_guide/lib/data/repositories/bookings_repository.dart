import '../../core/storage/sqlite_service.dart';
import '../../models/booking_model.dart';

/// Repository managing user and admin bookings with SQLite relational storage
class BookingsRepository {
  const BookingsRepository();

  /// Retrieve all bookings stored in SQLite
  List<Booking> getAllBookings() {
    return SQLiteService.getBookings();
  }

  /// Retrieve bookings belonging to a specific customer
  List<Booking> getUserBookings(String userId, {String? email}) {
    return SQLiteService.getUserBookings(userId, email: email);
  }

  /// Retrieve bookings filtered by status ('pending', 'confirmed', 'completed', 'cancelled')
  List<Booking> getBookingsByStatus(String status) {
    return getAllBookings().where((b) => b.status == status).toList();
  }

  /// Save a new booking to SQLite
  Future<void> saveBooking(Booking booking) async {
    await SQLiteService.saveBooking(booking);
  }

  /// Update the status of an existing booking
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final all = getAllBookings();
    final index = all.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final updated = all[index].copyWith(status: newStatus);
      await SQLiteService.updateBooking(updated);
    }
  }

  /// Delete a booking by its ID
  Future<void> deleteBooking(String bookingId) async {
    await SQLiteService.deleteBooking(bookingId);
  }

  /// Clear all stored bookings
  Future<void> clearAllBookings() async {
    await SQLiteService.clearBookings();
  }
}
