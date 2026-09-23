import 'package:dalili_tourist_guide/providres/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../core/extensions/context_extensions.dart';
import '../core/storage/preferences_service.dart';
import '../core/widgets/app_cached_image.dart';
import '../providres/user_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedFilter = 'الكل';

  final List<String> filters = [
    'الكل',
    'قيد الانتظار',
    'مؤكد',
    'مكتمل',
    'ملغي',
  ];

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final currentUid = userProvider.userData?['uid'] ??
        PreferencesService.currentUserUid ??
        '';
    final currentEmail = userProvider.userEmail;

    final userBookings = userProvider.isAdmin
        ? bookingProvider.bookings
        : bookingProvider.getBookingsForUser(currentUid, email: currentEmail);

    final bookings = _getFilteredBookings(userBookings);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient(context),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============= عنوان الصفحة =============
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                    children: [
                      Text(
                        '📅 ${context.tr.myBookings}',
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
                      if (userBookings.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${userBookings.length} ${context.tr.bookingsCountSuffix}',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ============= فلتر الحجوزات =============
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final isSelected = filter == selectedFilter;
                      final displayFilterName = filter == 'الكل'
                          ? context.tr.all
                          : (filter == 'قيد الانتظار'
                              ? context.tr.statusPending
                              : (filter == 'مؤكد'
                                  ? context.tr.statusConfirmed
                                  : (filter == 'مكتمل'
                                      ? context.tr.statusCompleted
                                      : (filter == 'ملغي'
                                          ? context.tr.statusCancelled
                                          : filter))));
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color(0xFFFFB300)
                                    : Colors.white)
                                : AppColors.getCardColor(context,
                                    lightAlpha: 0.1, darkAlpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFFFFB300)
                                      : Colors.white)
                                  : AppColors.getCardBorderColor(context),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            displayFilterName,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF0F172A)
                                      : const Color(0xFF0D47A1))
                                  : Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ============= عدد النتائج =============
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${bookings.length} ${context.tr.bookingsCountSuffix}',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      if (selectedFilter != 'الكل')
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'الكل';
                            });
                          },
                          child: Text(
                            context.tr.resetFilter,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ============= قائمة الحجوزات =============
                Expanded(
                  child: userBookings.isEmpty
                      ? _buildEmptyState()
                      : bookings.isEmpty
                          ? _buildEmptyFilterState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                final booking = bookings[index];
                                return _buildBookingCard(
                                  context,
                                  booking,
                                  bookingProvider,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
  }

  // ============= الحصول على الحجوزات المفلترة =============
  List<Booking> _getFilteredBookings(List<Booking> userBookings) {
    switch (selectedFilter) {
      case 'قيد الانتظار':
        return userBookings.where((b) => b.status == 'pending').toList();
      case 'مؤكد':
        return userBookings.where((b) => b.status == 'confirmed').toList();
      case 'مكتمل':
        return userBookings.where((b) => b.status == 'completed').toList();
      case 'ملغي':
        return userBookings.where((b) => b.status == 'cancelled').toList();
      default:
        return userBookings;
    }
  }

  // ============= شاشة فارغة =============
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_note_rounded,
            size: 80,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            context.tr.noBookingsFound,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr.noBookingsSubtitle,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/home');
            },
            icon: const Icon(Icons.explore_rounded),
            label: Text(
              context.tr.explorePlaces,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============= لا توجد نتائج للفلتر =============
  Widget _buildEmptyFilterState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_alt_rounded,
            size: 60,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            context.tr.noBookingsInFilter,
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = 'الكل';
              });
            },
            child: Text(
              context.tr.showAll,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.4),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============= بطاقة الحجز =============
  Widget _buildBookingCard(
    BuildContext context,
    Booking booking,
    BookingProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ============= صورة ومعلومات =============
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المكان
              AppCachedImage(
                imageUrl: booking.placeImage,
                width: 100,
                height: 130,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              // معلومات الحجز
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم المكان
                      Text(
                        booking.placeName,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // الموقع
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.placeLocation,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // تاريخ الزيارة وعدد الأشخاص
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(booking.visitDate),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.people_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking.numberOfPeople} ${context.tr.peopleSuffix}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // المبلغ والحالة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.amber.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${booking.totalPrice.toStringAsFixed(0)} ${context.tr.currency}',
                              style: TextStyle(
                                color: Colors.amber[400],
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: booking.statusColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: booking.statusColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getStatusIcon(booking.status),
                                  color: booking.statusColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booking.statusText,
                                  style: TextStyle(
                                    color: booking.statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ============= أزرار الإجراءات =============
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر التفاصيل
                _buildActionButton(
                  icon: Icons.info_rounded,
                  label: context.tr.details,
                  color: Colors.white,
                  onTap: () {
                    _showBookingDetails(context, booking);
                  },
                ),
                // زر إلغاء الحجز (فقط إذا كان قيد الانتظار)
                if (provider.canUserCancel(booking)) ...[
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.cancel_rounded,
                    label: context.tr.cancelBooking,
                    color: Colors.red[400]!,
                    onTap: () {
                      _showCancelDialog(context, booking, provider);
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= زر إجراء =============
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============= دوال مساعدة =============

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'confirmed':
        return Icons.check_circle_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  // ============= عرض تفاصيل الحجز =============
  void _showBookingDetails(BuildContext context, Booking booking) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : const Color(0xFF0D47A1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.tr.bookingDetails,
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              _buildDetailRow(context.tr.place, booking.placeName),
              _buildDetailRow(context.tr.location, booking.placeLocation),
              _buildDetailRow(context.tr.visitDate, _formatDate(booking.visitDate)),
              _buildDetailRow(context.tr.numberOfVisitors, '${booking.numberOfPeople} ${context.tr.peopleSuffix}'),
              _buildDetailRow(context.tr.totalPrice,
                  '${booking.totalPrice.toStringAsFixed(0)} ${context.tr.currency}'),
              _buildDetailRow(context.tr.status, booking.statusText),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.tr.close,
                    style: GoogleFonts.cairo(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============= حوارات التأكيد =============

  void _showCancelDialog(
      BuildContext context, Booking booking, BookingProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E293B)
              : const Color(0xFF0D47A1),
          title: Text(
            context.tr.cancelBooking,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            context.tr.cancelBookingConfirm,
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
                final success = await provider.cancelBookingByUser(booking.id);
                if (!context.mounted) return;
                Navigator.pop(context);
                if (success) {
                  _showSnackBar(context, context.tr.bookingCancelled);
                } else {
                  _showSnackBar(context, context.tr.cannotCancelBooking);
                }
              },
              child: Text(
                context.tr.confirmCancel,
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
}
