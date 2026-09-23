import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../data/repositories/places_repository.dart';
import '../../providres/booking_provider.dart';
import '../../providres/user_provider.dart';
import '../home_screen.dart';
import 'admin_bookings_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_places_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    const placesRepo = PlacesRepository();
    final allPlaces = placesRepo.getAllPlaces();
    final allCategories = placesRepo.getCategories();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.tr.adminDashboard),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined),
            tooltip: context.tr.clientPreviewMode,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: context.tr.retry,
            onPressed: () {
              bookingProvider.reloadFromStorage();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: context.tr.logout,
            onPressed: () async {
              await userProvider.logout();
              await SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============= Admin Header Card =============
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userProvider.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                context.tr.adminBadge,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userProvider.userEmail,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ============= Overview Title =============
            Text(
              context.tr.systemOverview,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // ============= Stats Grid =============
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: [
                _buildStatCard(
                  title: context.tr.totalBookings,
                  value: '${bookingProvider.totalBookings}',
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                ),
                _buildStatCard(
                  title: context.tr.pendingBookings,
                  value: '${bookingProvider.pendingCount}',
                  icon: Icons.hourglass_top_rounded,
                  color: AppColors.warning,
                  backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                ),
                _buildStatCard(
                  title: context.tr.placesAndRestaurants,
                  value: '${allPlaces.length}',
                  icon: Icons.place_rounded,
                  color: const Color(0xFF0D9488),
                  backgroundColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
                ),
                _buildStatCard(
                  title: context.tr.guideCategories,
                  value: '${allCategories.length}',
                  icon: Icons.category_rounded,
                  color: const Color(0xFF8B5CF6),
                  backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Total Revenue Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.payments_rounded,
                      color: AppColors.secondaryDark,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr.totalEstimatedRevenue,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${bookingProvider.totalSpent.toInt()} SYP',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ============= Quick Actions =============
            Text(
              context.tr.adminActions,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              title: context.tr.adminBookings,
              subtitle: context.tr.manageBookingsSubtitle,
              icon: Icons.book_online_rounded,
              color: AppColors.primary,
              badge: '${bookingProvider.pendingCount} ${context.tr.statusPending}',
              badgeColor: AppColors.warning,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminBookingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              title: context.tr.adminPlaces,
              subtitle: context.tr.managePlacesSubtitle,
              icon: Icons.map_rounded,
              color: const Color(0xFF0D9488),
              badge: '${allPlaces.length} ${context.tr.placesAndRestaurants}',
              badgeColor: const Color(0xFF0D9488),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminPlacesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              title: context.tr.adminCategories,
              subtitle: context.tr.manageCategoriesSubtitle,
              icon: Icons.category_rounded,
              color: const Color(0xFF8B5CF6),
              badge: '${allCategories.length} ${context.tr.categories}',
              badgeColor: const Color(0xFF8B5CF6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminCategoriesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            _buildActionTile(
              context: context,
              title: context.tr.clientPreviewMode,
              subtitle: context.tr.clientPreviewSubtitle,
              icon: Icons.phone_android_rounded,
              color: const Color(0xFF2563EB),
              badge: context.tr.clientPreviewMode,
              badgeColor: const Color(0xFF2563EB),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // ============= Recent Bookings =============
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr.recentBookings,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminBookingsScreen(),
                      ),
                    );
                  },
                  child: Text(context.tr.seeAll),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (bookingProvider.bookings.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    context.tr.noBookingsRegistered,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
              )
            else
              ...bookingProvider.bookings.take(3).map((booking) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: booking.statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          booking.statusIcon,
                          color: booking.statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.placeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${booking.numberOfPeople} أفراد • ${booking.totalPrice.toInt()} ل.س',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: booking.statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          booking.statusText,
                          style: TextStyle(
                            color: booking.statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: badgeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
