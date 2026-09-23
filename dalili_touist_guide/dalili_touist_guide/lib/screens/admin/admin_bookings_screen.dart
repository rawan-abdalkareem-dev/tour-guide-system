import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_cached_image.dart';
import '../../core/widgets/app_snack_bar.dart';
import '../../providres/booking_provider.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  String _selectedFilter = 'all'; // all, pending, confirmed, completed, cancelled

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final allBookings = bookingProvider.bookings;

    final filteredBookings = allBookings.where((b) {
      if (_selectedFilter == 'all') return true;
      return b.status == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.tr.adminBookings),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: context.tr.retry,
            onPressed: () {
              bookingProvider.reloadFromStorage();
              AppSnackBar.showInfo(context, context.tr.bookingSuccess);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ============= Filter Chips =============
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('${context.tr.all} (${allBookings.length})', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '${context.tr.statusPending} (${bookingProvider.pendingCount})',
                  'pending',
                  badgeColor: AppColors.warning,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '${context.tr.statusConfirmed} (${bookingProvider.confirmedBookings.length})',
                  'confirmed',
                  badgeColor: AppColors.success,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '${context.tr.statusCompleted} (${bookingProvider.completedBookings.length})',
                  'completed',
                  badgeColor: AppColors.info,
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  '${context.tr.statusCancelled} (${bookingProvider.cancelledBookings.length})',
                  'cancelled',
                  badgeColor: AppColors.error,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // ============= Bookings List =============
          Expanded(
            child: filteredBookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 64,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.tr.noBookingsFound,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return _buildBookingCard(context, booking, bookingProvider);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, {Color? badgeColor}) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : AppColors.textPrimary,
        ),
      ),
      selected: isSelected,
      selectedColor: badgeColor ?? AppColors.primary,
      backgroundColor: Colors.grey.shade100,
      showCheckmark: false,
      onSelected: (_) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    Booking booking,
    BookingProvider provider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCachedImage(
                  imageUrl: booking.placeImage,
                  width: 70,
                  height: 70,
                  borderRadius: BorderRadius.circular(12),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              booking.placeName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: booking.statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.statusText,
                              style: TextStyle(
                                color: booking.statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${context.tr.location}: ${booking.placeLocation}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${context.tr.bookingDate}: ${_formatDate(booking.visitDate)} • ${booking.numberOfPeople} ${context.tr.visitors}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (booking.email.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${context.tr.email}: ${booking.email}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ] else if (booking.userId.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          'ID: ${booking.userId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (booking.phoneNumber.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${context.tr.phone}: ${booking.phoneNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (booking.notes.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${context.tr.notes}: ${booking.notes}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${context.tr.total}: ${booking.totalPrice.toInt()} SYP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Action Buttons Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Change status dropdown or buttons
                if (booking.status != 'confirmed')
                  _buildQuickAction(
                    icon: Icons.check_circle_outline_rounded,
                    label: context.tr.confirm,
                    color: AppColors.success,
                    onTap: () {
                      provider.updateBookingStatus(booking.id, 'confirmed');
                      AppSnackBar.showSuccess(context, context.tr.statusConfirmed);
                    },
                  ),
                if (booking.status != 'completed')
                  _buildQuickAction(
                    icon: Icons.done_all_rounded,
                    label: context.tr.statusCompleted,
                    color: AppColors.info,
                    onTap: () {
                      provider.updateBookingStatus(booking.id, 'completed');
                      AppSnackBar.showInfo(context, context.tr.statusCompleted);
                    },
                  ),
                if (booking.status != 'cancelled')
                  _buildQuickAction(
                    icon: Icons.cancel_outlined,
                    label: context.tr.cancel,
                    color: AppColors.warning,
                    onTap: () {
                      provider.updateBookingStatus(booking.id, 'cancelled');
                      AppSnackBar.showInfo(context, context.tr.bookingCancelled);
                    },
                  ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 20,
                  ),
                  tooltip: context.tr.delete,
                  onPressed: () => _confirmDelete(context, booking, provider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          visualDensity: VisualDensity.compact,
        ),
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    Booking booking,
    BookingProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(context.tr.delete),
          content: Text(
            '${context.tr.cancelBookingConfirm} (${booking.placeName})',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(context.tr.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                provider.deleteBooking(booking.id);
                AppSnackBar.showSuccess(context, context.tr.delete);
              },
              child: Text(context.tr.delete),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }
}
