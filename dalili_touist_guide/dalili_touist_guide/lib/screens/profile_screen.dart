// lib/screens/profile_screen.dart
import 'package:dalili_tourist_guide/providres/booking_provider.dart';
import 'package:dalili_tourist_guide/providres/fanorites_providre.dart';
import 'package:dalili_tourist_guide/providres/user_provider.dart';
import 'package:dalili_tourist_guide/screens/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import 'booking_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final userData = userProvider.userData;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient(context),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============= عنوان الصفحة =============
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        context.go('/home');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '👤 ${context.tr.myAccount}',
                    style: GoogleFonts.cairo(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        const Icon(Icons.settings_rounded, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr.manageAccountAndSettings,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 30),

              // ============= صورة المستخدم =============
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userData?['name'] ?? context.tr.guest,
                      style: GoogleFonts.cairo(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userData?['email'] ?? 'guest@example.com',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.green.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.tr.activeStatus,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.green[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ============= إحصائيات =============
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
                child: Builder(builder: (context) {
                      final currentUid = userData?['uid'] ?? '';
                      final currentEmail = userProvider.userEmail;
                      final userBookingsCount = userProvider.isAdmin
                          ? bookingProvider.totalBookings
                          : bookingProvider.getUserBookingsCount(currentUid,
                              email: currentEmail);
                      final userTotalSpent = userProvider.isAdmin
                          ? bookingProvider.totalSpent
                          : bookingProvider.getUserTotalSpent(currentUid,
                              email: currentEmail);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                              '🏛️', context.tr.trips, '$userBookingsCount'),
                          _buildStatItem(
                              '❤️', context.tr.favorite, '${favoritesProvider.favoritesCount}'),
                          _buildStatItem('💰', context.tr.spending,
                              '${(userTotalSpent / 1000).toStringAsFixed(0)}K'),
                        ],
                      );
                    }),
              ),

              const SizedBox(height: 30),

              // ============= خيارات الحساب =============
              if (userProvider.isAdmin)
                _buildOption(
                  icon: Icons.admin_panel_settings_rounded,
                  title: context.tr.adminPanelTitle,
                  subtitle: context.tr.adminPanelSubtitle,
                  color: Colors.amber[700]!,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      context.tr.manageBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminDashboardScreen(),
                      ),
                    );
                  },
                ),
              _buildOption(
                icon: Icons.favorite_rounded,
                title: context.tr.favorites,
                subtitle: context.tr.addFavoritesSubtitle,
                color: Colors.red[400]!,
                trailing: favoritesProvider.favoritesCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${favoritesProvider.favoritesCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              ),
              _buildOption(
                icon: Icons.event_note_rounded,
                title: context.tr.myBookings,
                subtitle: context.tr.manageAccountAndSettings,
                color: Colors.blue[400]!,
                trailing: bookingProvider.pendingCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${bookingProvider.pendingCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingScreen()),
                  );
                },
              ),
              _buildOption(
                icon: Icons.history_rounded,
                title: context.tr.myTrips,
                subtitle: context.tr.viewTripsHistory,
                color: Colors.teal[400]!,
                onTap: () {
                  _showComingSoon(context, context.tr.myTrips);
                },
              ),
              _buildOption(
                icon: Icons.settings_rounded,
                title: context.tr.settings,
                subtitle: context.tr.customizeApp,
                color: Colors.purple[400]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              _buildOption(
                icon: Icons.help_rounded,
                title: context.tr.support,
                subtitle: context.tr.supportSettingsSubtitle,
                color: Colors.green[400]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportScreen()),
                  );
                },
              ),
              _buildOption(
                icon: Icons.info_rounded,
                title: context.tr.aboutAppTitle,
                subtitle: context.tr.aboutAppSubtitle,
                color: Colors.orange[400]!,
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildOption(
                icon: Icons.share_rounded,
                title: context.tr.shareApp,
                subtitle: context.tr.shareAppSubtitle,
                color: Colors.indigo[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.sharingAppProgress);
                },
              ),
              _buildOption(
                icon: Icons.star_rounded,
                title: context.tr.rateApp,
                subtitle: context.tr.rateAppSubtitle,
                color: Colors.amber[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.thanksRatingToast);
                },
              ),
              _buildOption(
                icon: Icons.privacy_tip_rounded,
                title: context.tr.privacyPolicy,
                subtitle: context.tr.privacyPolicySubtitle,
                color: Colors.teal[400]!,
                onTap: () {
                  _showPrivacyDialog(context);
                },
              ),
              _buildOption(
                icon: Icons.description_rounded,
                title: context.tr.termsOfService,
                subtitle: context.tr.termsOfServiceSubtitle,
                color: Colors.red[400]!,
                onTap: () {
                  _showTermsDialog(context);
                },
              ),

              const SizedBox(height: 20),

              // ============= زر تسجيل الخروج =============
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(
                    context.tr.logout,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withValues(alpha: 0.15),
                    foregroundColor: Colors.red[400],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                      color: Colors.red.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ============= معلومات التطبيق =============
              Center(
                child: Column(
                  children: [
                    Text(
                      'دليلي السياحي v1.0.0',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🇸🇾 اكتشف سوريا',
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // ============= Widgets مساعدة =============

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // ============= دوال الحوارات =============

  void _showSnackBar(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor:
            isDark ? const Color(0xFF1E293B) : const Color(0xFF0D47A1),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'قريباً: $feature',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF1E293B) : const Color(0xFF0D47A1),
          title: Text(
            context.tr.aboutAppTitle,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flight_takeoff_rounded,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                context.tr.appName,
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.tr.aboutAppShort,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _buildAboutInfo('📱', context.tr.version, '1.0.0'),
                    _buildAboutInfo('👨‍💻', context.tr.developer, context.tr.teamDalili),
                    _buildAboutInfo('📅', context.tr.releaseDate, '2024'),
                    _buildAboutInfo('🇸🇾', context.tr.country, context.tr.syria),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.close,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutInfo(String emoji, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.getAppBarColor(context),
          title: Text(
            context.tr.privacyPolicy,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr.privacyIntro,
                style: GoogleFonts.cairo(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              _buildPrivacyItem(
                  '📍', context.tr.privacyItem1),
              _buildPrivacyItem(
                  '📱', context.tr.privacyItem2),
              _buildPrivacyItem('🔒', context.tr.privacyItem3),
              _buildPrivacyItem(
                  '🗑️', context.tr.privacyItem4),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.close,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrivacyItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF1E293B) : const Color(0xFF0D47A1),
          title: Text(
            context.tr.termsOfService,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr.termsIntro,
                style: GoogleFonts.cairo(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              _buildTermsItem('1', context.tr.termsItem1),
              _buildTermsItem('2', context.tr.termsItem2),
              _buildTermsItem('3', context.tr.termsItem3),
              _buildTermsItem('4', context.tr.termsItem4),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.close,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTermsItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.cairo(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? const Color(0xFF1E293B) : const Color(0xFF0D47A1),
          title: Text(
            context.tr.logoutConfirmTitle,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            context.tr.logoutConfirmMessage,
            style: GoogleFonts.cairo(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                context.tr.cancel,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<UserProvider>(context, listen: false)
                    .signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Text(
                context.tr.logout,
                style: GoogleFonts.cairo(
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
