// lib/screens/more_screen.dart
import 'package:dalili_tourist_guide/providres/navigation_provider.dart';
import 'package:dalili_tourist_guide/screens/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import 'settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

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
              // عنوان الصفحة
              Row(
                children: [
                  Text(
                    '📋 المزيد',
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
                    icon: const Icon(Icons.home_rounded, color: Colors.white),
                    onPressed: () {
                      navProvider.goToHome();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                context.tr.aboutAppDescription,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 30),

              // خيارات المزيد
              _buildMoreItem(
                icon: Icons.settings_rounded,
                title: context.tr.settings,
                subtitle: context.tr.customizeApp,
                color: Colors.blue[400]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              _buildMoreItem(
                icon: Icons.info_rounded,
                title: context.tr.aboutAppTitle,
                subtitle: context.tr.aboutAppSubtitle,
                color: Colors.purple[400]!,
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildMoreItem(
                icon: Icons.help_rounded,
                title: context.tr.support,
                subtitle: context.tr.helpAndSupport,
                color: Colors.green[400]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportScreen()),
                  );
                },
              ),
              _buildMoreItem(
                icon: Icons.share_rounded,
                title: context.tr.shareApp,
                subtitle: context.tr.shareAppSubtitle,
                color: Colors.orange[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.shareApp);
                },
              ),
              _buildMoreItem(
                icon: Icons.star_rounded,
                title: context.tr.rateApp,
                subtitle: context.tr.rateAppSubtitle,
                color: Colors.amber[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.rateApp);
                },
              ),
              _buildMoreItem(
                icon: Icons.privacy_tip_rounded,
                title: context.tr.privacyPolicy,
                subtitle: context.tr.privacyPolicySubtitle,
                color: Colors.teal[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.privacyPolicy);
                },
              ),
              _buildMoreItem(
                icon: Icons.description_rounded,
                title: context.tr.termsOfService,
                subtitle: context.tr.termsOfServiceSubtitle,
                color: Colors.red[400]!,
                onTap: () {
                  _showSnackBar(context, context.tr.termsOfService);
                },
              ),
              _buildMoreItem(
                icon: Icons.language_rounded,
                title: context.tr.language,
                subtitle: context.tr.changeAppLanguage,
                color: Colors.indigo[400]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),

              const SizedBox(height: 30),

              // إحصائيات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getCardColor(context, lightAlpha: 0.1, darkAlpha: 0.8),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.getCardBorderColor(context),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('📱', context.tr.version, '1.0.0'),
                    _buildStatItem('👨‍💻', context.tr.developer, context.tr.appName),
                    _buildStatItem('📅', context.tr.releaseDate, '2026'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // زر العودة للرئيسية
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    navProvider.goToHome();
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: Text(
                    context.tr.backToHome,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(context, lightAlpha: 0.08, darkAlpha: 0.8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.getCardBorderColor(context),
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
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withValues(alpha: 0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildStatItem(String emoji, String label, String value) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.getAppBarColor(context),
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
                context.tr.welcomeSubtitle,
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
                    _buildAboutInfo('📅', context.tr.releaseDate, '2026'),
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
                  fontWeight: FontWeight.bold,
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
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
