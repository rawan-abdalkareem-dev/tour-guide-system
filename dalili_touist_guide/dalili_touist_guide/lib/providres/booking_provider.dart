import 'package:flutter/material.dart';
import '../data/repositories/bookings_repository.dart';
import '../models/booking_model.dart';

export '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final BookingsRepository _repository;
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;
  int get totalBookings => _bookings.length;

  List<Booking> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending').toList();
  List<Booking> get confirmedBookings =>
      _bookings.where((b) => b.status == 'confirmed').toList();
  List<Booking> get completedBookings =>
      _bookings.where((b) => b.status == 'completed').toList();
  List<Booking> get cancelledBookings =>
      _bookings.where((b) => b.status == 'cancelled').toList();
  int get pendingCount => pendingBookings.length;

  BookingProvider({BookingsRepository? repository})
      : _repository = repository ?? const BookingsRepository() {
    _loadFromRepository();
  }

  void _loadFromRepository() {
    try {
      _bookings = List<Booking>.from(_repository.getAllBookings());
    } catch (_) {
      _bookings = [];
    }
  }

  void reloadFromStorage() {
    _loadFromRepository();
    notifyListeners();
  }

  /// Get bookings filtered for a specific user (by UID or Email)
  List<Booking> getBookingsForUser(String userId, {String? email}) {
    final trimmedUid = userId.trim();
    final trimmedEmail = email?.trim().toLowerCase();

    return _bookings.where((b) {
      if (trimmedUid.isNotEmpty && b.userId.trim() == trimmedUid) {
        return true;
      }
      if (trimmedEmail != null &&
          trimmedEmail.isNotEmpty &&
          b.email.trim().toLowerCase() == trimmedEmail) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Get total count of bookings for a specific user
  int getUserBookingsCount(String userId, {String? email}) {
    return getBookingsForUser(userId, email: email).length;
  }

  /// Get total amount spent on confirmed/completed bookings by a specific user
  double getUserTotalSpent(String userId, {String? email}) {
    final userList = getBookingsForUser(userId, email: email);
    double total = 0;
    for (var booking in userList) {
      if (booking.status == 'confirmed' || booking.status == 'completed') {
        total += booking.totalPrice;
      }
    }
    return total;
  }

  /// Only bookings with 'pending' status can be cancelled by a customer
  bool canUserCancel(Booking booking) {
    return booking.status == 'pending';
  }

  /// Customer cancellation action (guarded)
  Future<bool> cancelBookingByUser(String bookingId) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1 && canUserCancel(_bookings[index])) {
      final updated = _bookings[index].copyWith(status: 'cancelled');
      _bookings[index] = updated;
      notifyListeners();
      await _repository.updateBookingStatus(bookingId, 'cancelled');
      return true;
    }
    return false;
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.insert(0, booking);
    notifyListeners();
    await _repository.saveBooking(booking);
  }

  /// Admin action: update status to confirmed, completed, or cancelled
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      final updated = _bookings[index].copyWith(status: newStatus);
      _bookings[index] = updated;
      notifyListeners();
      await _repository.updateBookingStatus(bookingId, newStatus);
    }
  }

  /// Admin action: delete booking completely
  Future<void> deleteBooking(String bookingId) async {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
    await _repository.deleteBooking(bookingId);
  }

  Future<void> clearAllBookings() async {
    _bookings.clear();
    notifyListeners();
    await _repository.clearAllBookings();
  }

  double get totalSpent {
    double total = 0;
    for (var booking in _bookings) {
      if (booking.status == 'confirmed' || booking.status == 'completed') {
        total += booking.totalPrice;
      }
    }
    return total;
  }
}
