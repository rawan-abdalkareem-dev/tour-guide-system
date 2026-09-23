import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/admin_config.dart';
import '../storage/preferences_service.dart';
import '../../screens/welcome_screen.dart';
import '../../screens/login_screen.dart';
import '../../screens/signup_screen.dart';
import '../../screens/home_screen.dart';
import '../../screens/explore_screen.dart';
import '../../screens/favorites_screen.dart';
import '../../screens/booking_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/settings_screen.dart';
import '../../screens/support_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/admin_bookings_screen.dart';
import '../../screens/admin/admin_places_screen.dart';
import '../../screens/admin/admin_categories_screen.dart';

/// Central declarative router with role-based admin guard
class AppRouter {
  AppRouter._();

  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String favorites = '/favorites';
  static const String bookings = '/bookings';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String support = '/support';
  static const String admin = '/admin';
  static const String adminBookings = '/admin/bookings';
  static const String adminPlaces = '/admin/places';
  static const String adminCategories = '/admin/categories';

  static final GoRouter router = GoRouter(
    initialLocation: PreferencesService.isLoggedIn
        ? (AdminConfig.isAdmin(PreferencesService.currentUserEmail) ? admin : home)
        : welcome,
    debugLogDiagnostics: false,
    redirect: (BuildContext context, GoRouterState state) {
      final loc = state.matchedLocation;

      // Admin guard: protect any route under /admin
      if (loc.startsWith('/admin')) {
        final email = PreferencesService.currentUserEmail;
        final isAdmin = AdminConfig.isAdmin(email);
        if (!isAdmin) {
          // Non-admin trying to access admin route -> redirect to home
          return home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: explore,
        builder: (context, state) => const ExploreScreen(),
      ),
      GoRoute(
        path: favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: bookings,
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: support,
        builder: (context, state) => const SupportScreen(),
      ),
      // Admin routes
      GoRoute(
        path: admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: adminBookings,
        builder: (context, state) => const AdminBookingsScreen(),
      ),
      GoRoute(
        path: adminPlaces,
        builder: (context, state) => const AdminPlacesScreen(),
      ),
      GoRoute(
        path: adminCategories,
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
    ],
  );
}
