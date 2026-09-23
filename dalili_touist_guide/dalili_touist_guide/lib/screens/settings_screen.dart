// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/storage/preferences_service.dart';
import '../core/storage/sqlite_service.dart';
import '../providres/fanorites_providre.dart';
import '../providres/font_size_provider.dart';
import '../providres/locale_provider.dart';
import '../providres/theme_provider.dart';
import '../providres/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<String, dynamic> settings;
  bool _isLoading = true;
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  bool _isLocationEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isAutoSaveEnabled = true;
  String _selectedLanguage = 'ar';
  String _selectedMapType = 'عادي';
  double _fontSize = 16.0;

  // قوائم خيارات منتقاة ومحسنة
  final List<DropdownMenuItem<String>> _languageItems = [
    const DropdownMenuItem(value: 'ar', child: Text('العربية 🇸🇾')),
    const DropdownMenuItem(value: 'en', child: Text('English 🇬🇧')),
  ];

  final List<DropdownMenuItem<String>> _mapTypeItems = [
    const DropdownMenuItem(value: 'عادي', child: Text('عادي (شوارع ومدن) 🗺️')),
    const DropdownMenuItem(
        value: 'قمر صناعي', child: Text('قمر صناعي (طبيعة) 🛰️')),
    const DropdownMenuItem(
        value: 'تضاريس', child: Text('تضاريس (جبال وسهول) ⛰️')),
    const DropdownMenuItem(
        value: 'مختلط', child: Text('مختلط (قمر + شوارع) 🌐')),
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final fontSizeProvider =
        Provider.of<FontSizeProvider>(context, listen: false);
    settings = userProvider.getSettings();

    setState(() {
      _isDarkMode = themeProvider.isDarkMode;
      _isNotificationsEnabled =
          settings['notifications'] ?? PreferencesService.notifications;
      _isLocationEnabled = settings['location'] ?? PreferencesService.location;
      _isVibrationEnabled =
          settings['vibration'] ?? PreferencesService.vibration;
      _isAutoSaveEnabled = settings['autoSave'] ?? PreferencesService.autoSave;
      _selectedLanguage = settings['language'] ?? PreferencesService.language;
      _selectedMapType = settings['mapType'] ?? PreferencesService.mapType;
      _fontSize = fontSizeProvider.fontSize;
      _isLoading = false;
    });
  }

  void _vibrate() {
    if (_isVibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    _vibrate();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    settings[key] = value;
    await userProvider.saveSettings(settings);

    if (!mounted) return;
    setState(() {});
  }

  void _showSnackBar(String message, {Color? color}) {
    if (!mounted) return;
    final effectiveColor = color ?? AppColors.getAppBarColor(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: effectiveColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    _isDarkMode = themeProvider.isDarkMode;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.getAppBarColor(context),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.getAppBarColor(context),
      appBar: AppBar(
        title: Text(
          context.tr.settingsTitle,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.getAppBarColor(context),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            _vibrate();
            Navigator.of(context).maybePop();
          },
        ),
        actions: [
          IconButton(
            tooltip: context.tr.saveSettingsTooltip,
            icon: const Icon(Icons.check_circle_outline_rounded,
                color: Colors.white),
            onPressed: () {
              _vibrate();
              _showSnackBar(context.tr.settingsSaved,
                  color: const Color(0xFF10B981));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundGradient(context),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ============= تفضيلات التطبيق =============
            _buildSectionHeader(context.tr.appPreferencesSection),

            _buildSwitchCard(
              icon: Icons.dark_mode_rounded,
              title: context.tr.darkMode,
              subtitle: context.tr.darkModeSubtitle,
              value: _isDarkMode,
              onChanged: (value) async {
                _vibrate();
                setState(() => _isDarkMode = value);
                await context.read<ThemeProvider>().setDarkMode(value);
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            _buildSwitchCard(
              icon: Icons.notifications_active_rounded,
              title: context.tr.notificationsTitle,
              subtitle: context.tr.notificationsSubtitle,
              value: _isNotificationsEnabled,
              onChanged: (value) async {
                setState(() => _isNotificationsEnabled = value);
                await _saveSetting('notifications', value);
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            _buildSwitchCard(
              icon: Icons.location_on_rounded,
              title: context.tr.locationPermissionTitle,
              subtitle: context.tr.locationPermissionSubtitle,
              value: _isLocationEnabled,
              onChanged: (value) async {
                setState(() => _isLocationEnabled = value);
                await _saveSetting('location', value);
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            _buildSwitchCard(
              icon: Icons.vibration_rounded,
              title: context.tr.vibration,
              subtitle: context.tr.vibrationSubtitle,
              value: _isVibrationEnabled,
              onChanged: (value) async {
                setState(() => _isVibrationEnabled = value);
                await _saveSetting('vibration', value);
                if (value) HapticFeedback.mediumImpact();
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            const SizedBox(height: 18),

            // ============= اللغة =============
            _buildSectionHeader(context.tr.appLanguage),

            _buildDropdownCard(
              icon: Icons.translate_rounded,
              title: context.tr.language,
              subtitle: context.tr.languageSubtitle,
              value: _selectedLanguage,
              items: _languageItems,
              onChanged: (value) async {
                if (value == null) return;
                final localeProvider = context.read<LocaleProvider>();
                final savedMessage = context.tr.settingsSaved;
                setState(() => _selectedLanguage = value);
                await localeProvider.setLanguageCode(value);
                await _saveSetting('language', _selectedLanguage);
                if (mounted) {
                  _showSnackBar(savedMessage);
                }
              },
            ),

            const SizedBox(height: 18),

            // ============= الخريطة =============
            _buildSectionHeader(context.tr.mapTypeSection),

            _buildDropdownCard(
              icon: Icons.map_rounded,
              title: context.tr.mapTypeTitle,
              subtitle: context.tr.mapTypeSubtitle,
              value: _selectedMapType,
              items: _mapTypeItems,
              onChanged: (value) async {
                if (value == null) return;
                setState(() => _selectedMapType = value);
                await _saveSetting('mapType', _selectedMapType);
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            const SizedBox(height: 18),

            // ============= حجم الخط =============
            _buildSectionHeader(context.tr.fontSizeSection),
            _buildFontSizeCard(),

            const SizedBox(height: 18),

            // ============= إدارة البيانات والمزامنة =============
            _buildSectionHeader(context.tr.dataManagementSection),

            _buildSwitchCard(
              icon: Icons.cloud_sync_rounded,
              title: context.tr.autoSaveTitle,
              subtitle: context.tr.autoSaveSubtitle,
              value: _isAutoSaveEnabled,
              onChanged: (value) async {
                setState(() => _isAutoSaveEnabled = value);
                await _saveSetting('autoSave', value);
                _showSnackBar(context.tr.settingsSaved);
              },
            ),

            _buildActionCard(
              icon: Icons.favorite_border_rounded,
              title: context.tr.clearFavoritesTitle,
              subtitle: context.tr.clearFavoritesSubtitle,
              badgeText: context.tr.clearBadge,
              color: const Color(0xFFEF4444),
              onTap: () {
                _vibrate();
                _showClearFavoritesDialog(context);
              },
            ),

            _buildActionCard(
              icon: Icons.storage_rounded,
              title: context.tr.offlineDataTitle,
              subtitle: context.tr.offlineDataSubtitle,
              badgeText: context.tr.checkBadge,
              color: const Color(0xFF3B82F6),
              onTap: () {
                _vibrate();
                _showOfflineDataDialog(context);
              },
            ),

            _buildActionCard(
              icon: Icons.cleaning_services_rounded,
              title: context.tr.cleanCacheTitle,
              subtitle: context.tr.cleanCacheSubtitle,
              badgeText: context.tr.cleanBadge,
              color: const Color(0xFFF59E0B),
              onTap: () {
                _vibrate();
                _showClearCacheDialog(context);
              },
            ),

            const SizedBox(height: 18),

            // ============= معلومات التطبيق والدعم =============
            _buildSectionHeader(context.tr.aboutAndSupportSection),

            _buildInfoCard(
              icon: Icons.verified_rounded,
              title: context.tr.version,
              subtitle: context.tr.appVersionSubtitle,
            ),
            _buildInfoCard(
              icon: Icons.group_rounded,
              title: context.tr.devTeam,
              subtitle: context.tr.devTeamSubtitle,
            ),
            _buildInfoCard(
              icon: Icons.privacy_tip_rounded,
              title: context.tr.privacyTermsTitle,
              subtitle: context.tr.readPrivacySubtitle,
              onTap: () {
                _vibrate();
                _showPrivacyDialog(context);
              },
            ),
            _buildInfoCard(
              icon: Icons.gavel_rounded,
              title: context.tr.termsOfService,
              subtitle: context.tr.readTermsSubtitle,
              onTap: () {
                _vibrate();
                _showTermsDialog(context);
              },
            ),
            _buildInfoCard(
              icon: Icons.star_rate_rounded,
              title: context.tr.rateApp,
              subtitle: context.tr.rateAppDescription,
              onTap: () {
                _vibrate();
                _showRateAppDialog(context);
              },
            ),
            _buildInfoCard(
              icon: Icons.share_rounded,
              title: context.tr.shareApp,
              subtitle: context.tr.shareAppDescription,
              onTap: () {
                _vibrate();
                _showShareAppDialog(context);
              },
            ),

            const SizedBox(height: 24),

            // ============= زر استعادة الإعدادات الافتراضية =============
            Center(
              child: TextButton.icon(
                icon: Icon(
                  Icons.restore_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                onPressed: () {
                  _vibrate();
                  _showResetDialog(context);
                },
                label: Text(
                  context.tr.restoreDefaults,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.6),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ============= Widgets المساعدة والتصميم =============

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getCardBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF10B981),
            inactiveThumbColor: Colors.white.withValues(alpha: 0.7),
            inactiveTrackColor: Colors.black.withValues(alpha: 0.25),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getCardBorderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF08275A).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF1A237E),
                borderRadius: BorderRadius.circular(14),
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                icon: const Icon(
                  Icons.arrow_drop_down_circle_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
                onChanged: onChanged,
                items: items,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSizeCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getCardBorderColor(context),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.format_size_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr.fontSizeCardTitle,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      context.tr.fontSizeCardSubtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              // Stepper controls
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF08275A).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded,
                          color: Colors.white, size: 18),
                      onPressed: () async {
                        if (_fontSize > 12) {
                          _vibrate();
                          setState(() => _fontSize -= 1.0);
                          await context
                              .read<FontSizeProvider>()
                              .decreaseFontSize();
                        }
                      },
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        _fontSize.toStringAsFixed(0),
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 18),
                      onPressed: () async {
                        if (_fontSize < 24) {
                          _vibrate();
                          setState(() => _fontSize += 1.0);
                          await context
                              .read<FontSizeProvider>()
                              .increaseFontSize();
                        }
                      },
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Live preview box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.visibility_rounded,
                    size: 16, color: Colors.amberAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr.livePreviewText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.cairo(
                      fontSize: _fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getCardBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
            ),
            child: Text(
              badgeText,
              style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final isClickable = onTap != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.getCardBorderColor(context),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isClickable)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 15,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============= دوال الحوارات =============

  void _showClearFavoritesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border_rounded,
                    color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                context.tr.clearFavoritesConfirmTitle,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            context.tr.clearFavoritesConfirmMessage,
            style: GoogleFonts.cairo(
              color: const Color(0xFF475569),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                context.tr.cancel,
                style: GoogleFonts.cairo(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogCtx);
                final favProvider =
                    Provider.of<FavoritesProvider>(context, listen: false);
                await favProvider.clearFavorites();
                if (!mounted) return;
                _showSnackBar(context.tr.favoritesClearedSuccess,
                    color: Colors.red);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                context.tr.clearAll,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOfflineDataDialog(BuildContext context) {
    final placesCount = SQLiteService.getPlaces().length;
    final categoriesCount = SQLiteService.getCategories().length;
    final bookingsCount = SQLiteService.getBookings().length;
    final favCount =
        Provider.of<FavoritesProvider>(context, listen: false).favorites.length;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.2) : const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_done_rounded,
                    color: Color(0xFF3B82F6), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'البيانات المحلية دون اتصال',
                style: GoogleFonts.cairo(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'جميع بيانات التطبيق مخزنة محلياً وجاهزة للاستخدام بالكامل دون الحاجة لأي اتصال بالإنترنت 🇸🇾',
                style: GoogleFonts.cairo(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildDataStatRow(Icons.place_rounded, 'الأماكن السياحية المسجلة',
                  '$placesCount معلماً', isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D47A1)),
              _buildDataStatRow(Icons.category_rounded, 'التصنيفات المتاحة',
                  '$categoriesCount تصنيفات', const Color(0xFF10B981)),
              _buildDataStatRow(
                  Icons.calendar_month_rounded,
                  'الحجوزات المحفوظة',
                  '$bookingsCount حجز',
                  const Color(0xFFF59E0B)),
              _buildDataStatRow(Icons.favorite_rounded, 'الأماكن المفضلة',
                  '$favCount معلم', Colors.red),
            ],
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2563EB) : const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'حسناً',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataStatRow(
      IconData icon, String title, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cleaning_services_rounded,
                    color: Color(0xFFF59E0B), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'تنظيف الذاكرة المؤقتة',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          content: Text(
            'سيتم تفريغ كاش الصور المحفوظة والذاكرة المؤقتة لتحرير مساحة على جهازك وتسريع الأداء. لن تفقد بياناتك الشخصية أو حجوزاتك.',
            style: GoogleFonts.cairo(
              color: const Color(0xFF475569),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                PaintingBinding.instance.imageCache.clear();
                PaintingBinding.instance.imageCache.clearLiveImages();
                Navigator.pop(dialogCtx);
                _showSnackBar('تم تنظيف كاش الصور والذاكرة المؤقتة بنجاح ⚡',
                    color: Colors.green);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'تنظيف الآن',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.restore_rounded,
                    color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'إعادة ضبط الإعدادات',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'سيتم إعادة ضبط جميع التفضيلات والإعدادات إلى حالتها الافتراضية. هل تود الاستمرار؟',
            style: GoogleFonts.cairo(
              color: const Color(0xFF475569),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final defaultSettings = {
                  'darkMode': false,
                  'notifications': true,
                  'location': true,
                  'vibration': true,
                  'autoSave': true,
                  'language': 'ar',
                  'currency': 'ل.س',
                  'themeColor': 'أزرق',
                  'mapType': 'عادي',
                  'fontSize': 16.0,
                };
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                final fontSizeProvider =
                    Provider.of<FontSizeProvider>(context, listen: false);
                await userProvider.saveSettings(defaultSettings);

                await themeProvider.reset();
                await fontSizeProvider.reset();

                await PreferencesService.setNotifications(true);
                await PreferencesService.setLocation(true);
                await PreferencesService.setVibration(true);
                await PreferencesService.setAutoSave(true);
                await PreferencesService.setLanguage('ar');
                await PreferencesService.setCurrency('ل.س');
                await PreferencesService.setMapType('عادي');

                if (!mounted) return;

                setState(() {
                  _isDarkMode = false;
                  _isNotificationsEnabled = true;
                  _isLocationEnabled = true;
                  _isVibrationEnabled = true;
                  _isAutoSaveEnabled = true;
                  _selectedLanguage = 'ar';
                  _selectedMapType = 'عادي';
                  _fontSize = 16.0;
                });

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
                _showSnackBar('تمت استعادة الإعدادات الافتراضية بنجاح ✅',
                    color: Colors.green);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'إعادة ضبط',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRateAppDialog(BuildContext context) {
    int rating = PreferencesService.appRating;
    if (rating < 1 || rating > 5) rating = 5;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final ratingLabels = {
              1: 'يحتاج لتحسين 😕',
              2: 'مقبول 🙂',
              3: 'جيد 👍',
              4: 'جيد جداً! 🌟',
              5: 'ممتاز ورائع جداً! 🇸🇾❤️',
            };

            final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 36),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ما رأيك في دليلي السياحي؟',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تقييمك يسهم في تحسين جودة الدليل وتوفير أدق المعلومات حول معالم سوريا الجميلة:',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starNum = index + 1;
                      return IconButton(
                        iconSize: 34,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          starNum <= rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: starNum <= rating
                              ? Colors.amber
                              : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                        ),
                        onPressed: () {
                          _vibrate();
                          setDialogState(() => rating = starNum);
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ratingLabels[rating] ?? '',
                    style: GoogleFonts.cairo(
                      color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(
                    'لاحقاً',
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await PreferencesService.setAppRating(rating);
                    if (!dialogCtx.mounted) return;
                    Navigator.pop(dialogCtx);
                    _showSnackBar('شكراً لمشاركتنا تقييمك ($rating نجوم) ❤️',
                        color: Colors.green);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF2563EB) : const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'إرسال التقييم',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showShareAppDialog(BuildContext context) {
    const shareText = 'اكتشف جمال وسحر سوريا مع تطبيق "دليلي السياحي" 🇸🇾✨\n\n'
        'دليلك الشامل والموثوق لأجمل المعالم الأثرية، المطاعم السورية الأصيلة، '
        'الفنادق والأنشطة السياحية مع إمكانية الحجز وتصفح الخرائط أوفلاين دون إنترنت!\n\n'
        'حمّل التطبيق الآن واستمتع برحلة سياحية فريدة في ربوع الشام.';

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share_rounded,
                    color: Color(0xFF10B981), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'مشاركة التطبيق',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'شارك دليل السياحة السورية مع أصدقائك عبر مختلف تطبيقات التواصل:',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF475569),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  shareText,
                  style: GoogleFonts.cairo(
                    fontSize: 11.5,
                    color: const Color(0xFF334155),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: Text(
                'إغلاق',
                style: GoogleFonts.cairo(
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: Text(
                'نسخ النص',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await Clipboard.setData(const ClipboardData(text: shareText));
                if (!dialogCtx.mounted) return;
                Navigator.pop(dialogCtx);
                _showSnackBar('تم نسخ نص المشاركة إلى الحافظة بنجاح 📋',
                    color: Colors.green);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                      : const Color(0xFF0D47A1).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.privacy_tip_rounded,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D47A1), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'سياسة الخصوصية',
                style: GoogleFonts.cairo(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'في تطبيق "دليلي السياحي"، نضع خصوصية وأمان مستخدمينا على رأس أولوياتنا:',
                  style: GoogleFonts.cairo(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildModalBullet(dialogCtx, '💾', 'تخزين محلي آمن',
                    'جميع بياناتك (الحجوزات، المفضلة، الإعدادات) مخزنة محلياً على جهازك حصراً.'),
                _buildModalBullet(dialogCtx, '🔒', 'تشفير كلمات المرور',
                    'كلمات المرور مشفرة بخوارزمية SHA-256 المقاومة للتعديل ولا تحفظ بنص صريح.'),
                _buildModalBullet(dialogCtx, '📍', 'صلاحية الموقع',
                    'تستخدم صلاحية الموقع فقط لحساب المسافات وعرض الأماكن الأقرب إليك بموافقتك.'),
                _buildModalBullet(dialogCtx, '🚫', 'لا تتبع أو إعلانات',
                    'التطبيق لا يحتوي على أي مكتبات تتبع خارجية أو إعلانات تجارية.'),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2563EB) : const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'فهمت ذلك',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(dialogCtx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                      : const Color(0xFF0D47A1).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.gavel_rounded,
                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF0D47A1), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'الشروط والأحكام',
                style: GoogleFonts.cairo(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بك في "دليلي السياحي". استخدامك للتطبيق يعني موافقتك على البنود التالية:',
                  style: GoogleFonts.cairo(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildModalBullet(dialogCtx, '🏛️', 'غايات استرشادية',
                    'البيانات والصور والمعلومات الجغرافية مقدمة لأغراض استرشادية وسياحية.'),
                _buildModalBullet(dialogCtx, '📅', 'طبيعة الحجوزات',
                    'الحجوزات داخل التطبيق هي تنظيمية للمستخدم والمسؤول ولا تشتمل على دفع إلكتروني مالي.'),
                _buildModalBullet(dialogCtx, '🌿', 'حماية التراث',
                    'يُهيب التطبيق بزوار المعالم التاريخية السورية الحفاظ على نظافتها وسلامتها.'),
                _buildModalBullet(dialogCtx, '⚖️', 'الامتثال للقوانين',
                    'يلتزم المستخدم بالقوانين والأنظمة المرعية في الجمهورية العربية السورية.'),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogCtx),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF2563EB) : const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'موافق',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModalBullet(BuildContext context, String emoji, String title, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
