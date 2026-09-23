// lib/providers/navigation_provider.dart
import 'package:dalili_tourist_guide/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/booking_screen.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int get currentIndex => _currentIndex;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  List<Widget> get pages => _pages;

  void setIndex(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void goToHome() {
    _currentIndex = 0;
    notifyListeners();
  }

  void goToFavorites() {
    _currentIndex = 1;
    notifyListeners();
  }

  void goToBookings() {
    _currentIndex = 2;
    notifyListeners();
  }

  void goToProfile() {
    _currentIndex = 3;
    notifyListeners();
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }
}
